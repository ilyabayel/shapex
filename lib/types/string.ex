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

  @spec validate(Shapex.Types.String.t(), String.t()) :: {:ok, :valid} | {:error, term()}

  def validate(_, value) when not is_binary(value),
    do: {:error, %{type: "Value must be a string"}}

  def validate(schema, value) do
    errors =
      schema.validations
      |> Enum.reduce(%{}, fn
        {rule_name, {target_value, error_message}}, errors ->
          case do_validate(rule_name, target_value, value, error_message) do
            nil -> errors
            error -> Map.put(errors, rule_name, error)
          end

        {rule_name, target_value}, errors ->
          case do_validate(rule_name, target_value, value) do
            nil -> errors
            error -> Map.put(errors, rule_name, error)
          end
      end)

    if errors == %{} do
      {:ok, :valid}
    else
      {:error, errors}
    end
  end

  defp do_validate(rule_name, target, value, message \\ nil)

  defp do_validate(:min_length, target, value, message) do
    if String.length(value) < target do
      message || "String length must be at least #{target}"
    end
  end

  defp do_validate(:max_length, target, value, message) do
    if String.length(value) > target do
      message || "String length must be no more than #{target}"
    end
  end

  defp do_validate(:length, target, value, message) do
    if String.length(value) != target do
      message || "String length must be equal to #{target}"
    end
  end

  defp do_validate(:eq, target, value, message) do
    if value != target do
      message || "String must be equal to #{target}"
    end
  end

  defp do_validate(:neq, target, value, message) do
    if value == target do
      message || "String must not be equal to #{target}"
    end
  end

  defp do_validate(:regex, target, value, message) do
    if not Regex.match?(target, value) do
      message || "String must match the regex #{inspect(target)}"
    end
  end
end
