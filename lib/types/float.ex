defmodule Shapex.Types.Float do
  @behaviour Shapex.Type

  @type float_or_tuple :: float() | {float(), String.t()}
  @type float_list_or_tuple :: list(float()) | {list(float()), String.t()}

  @type validations ::
          {:min, float_or_tuple()}
          | {:max, float_or_tuple()}
          | {:lt, float_or_tuple()}
          | {:lte, float_or_tuple()}
          | {:gt, float_or_tuple()}
          | {:gte, float_or_tuple()}
          | {:eq, float_or_tuple()}
          | {:neq, float_or_tuple()}
          | {:in, float_list_or_tuple()}
          | {:not_in, float_list_or_tuple()}

  @type t :: %__MODULE__{
          validations: [validations()]
        }

  defstruct [:validations]

  @spec validate(t(), float()) :: {:ok, :valid} | {:error, map()}
  def validate(schema, value) do
    validation_results =
      Enum.reduce(schema.validations, %{}, fn
        {rule, {target, message}}, acc ->
          case do_validate(rule, value, target, message) do
            nil -> acc
            message -> Map.put(acc, rule, message)
          end

        {rule, target}, acc ->
          case do_validate(rule, value, target, nil) do
            nil -> acc
            message -> Map.put(acc, rule, message)
          end
      end)

    if validation_results == %{} do
      {:ok, :valid}
    else
      {:error, validation_results}
    end
  end

  defp do_validate(:gt, value, target, message) when value <= target do
    message || "Value must be greater than #{target}"
  end

  defp do_validate(:gte, value, target, message) when value < target do
    message || "Value must be greater than or equal to #{target}"
  end

  defp do_validate(:lt, value, target, message) when value >= target do
    message || "Value must be less than #{target}"
  end

  defp do_validate(:lte, value, target, message) when value > target do
    message || "Value must be less than or equal to #{target}"
  end

  defp do_validate(:eq, value, target, message) when value != target do
    message || "Value must be equal to #{target}"
  end

  defp do_validate(:neq, value, target, message) when value == target do
    message || "Value must not be equal to #{target}"
  end

  defp do_validate(:in, value, target, message) do
    unless Enum.member?(target, value) do
      message || "Value must be one of #{inspect(target)}"
    end
  end

  defp do_validate(:not_in, value, target, message) do
    if Enum.member?(target, value) do
      message || "Value must not be one of #{inspect(target)}"
    end
  end

  defp do_validate(_, _, _, _), do: nil
end
