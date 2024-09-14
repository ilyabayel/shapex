defmodule Shapex.Types.String do
  @behaviour Shapex.Type

  @type type_or_tuple(t) :: t | {t, error_message :: String.t()}
  @type t :: %__MODULE__{}

  @type validation_rule ::
          {:min_length, type_or_tuple(integer())}
          | {:max_length, type_or_tuple(integer())}
          | {:length, type_or_tuple(integer())}
          | {:eq, type_or_tuple(String.t())}
          | {:neq, type_or_tuple(String.t())}
          | {:regex, type_or_tuple(String.t())}

  @enforce_keys [:validations]
  defstruct [:validations]

  @spec validate(Shapex.Types.String.t(), String.t()) :: :ok | {:error, term()}

  def validate(%__MODULE__{} = schema, value) when is_binary(value) do
    errors =
      schema.validations
      |> Enum.reduce(%{}, fn
        {rule_name, {rule_value, error_message}}, errors ->
          case do_validate(rule_name, rule_value, value, error_message) do
            nil -> errors
            error -> Map.put(errors, rule_name, error)
          end

        {rule_name, rule_value}, errors ->
          case do_validate(rule_name, rule_value, value) do
            nil -> errors
            error -> Map.put(errors, rule_name, error)
          end
      end)

    if errors == %{} do
      :ok
    else
      {:error, errors}
    end
  end

  def validate(_, _value),
    do: {:error, %{type: "Value must be a string"}}

  defp do_validate(rule_name, expected_value, value, message \\ nil)

  defp do_validate(:min_length, min_length, value, message) do
    if String.length(value) < min_length do
      message || "String length must be at least #{min_length}"
    end
  end

  defp do_validate(:max_length, max_length, value, message) do
    if String.length(value) > max_length do
      message || "String length must be no more than #{max_length}"
    end
  end

  defp do_validate(:length, expected_length, value, message) do
    if String.length(value) != expected_length do
      message || "String length must be equal to #{expected_length}"
    end
  end

  defp do_validate(:eq, expected_value, value, message) do
    if value != expected_value do
      message || "String must be equal to #{expected_value}"
    end
  end

  defp do_validate(:neq, not_expected_value, value, message) do
    if value == not_expected_value do
      message || "String must not be equal to #{not_expected_value}"
    end
  end

  defp do_validate(:regex, regex, value, message) do
    if not Regex.match?(regex, value) do
      message || "String must match the regex #{inspect(regex)}"
    end
  end
end
