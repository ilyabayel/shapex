defmodule Shapex.Types.Integer do
  @moduledoc """
  Integer types for Shapex
  """

  @behaviour Shapex.Type

  @enforce_keys [:validations]
  defstruct [:validations]

  @type target(a) :: a | {a, String.t()}

  @type validation_rules ::
          {:gt, target(integer())}
          | {:gte, target(integer())}
          | {:lt, target(integer())}
          | {:lte, target(integer())}
          | {:eq, target(integer())}
          | {:neq, target(integer())}
          | {:in, target(list(integer()))}
          | {:not_in, target(list(integer()))}
          | {:custom, {name :: atom(), function()}}

  @type t :: %__MODULE__{
          validations: [validation_rules()]
        }

  def validate(_, value) when not is_integer(value),
    do: {:error, %{type: "Value must be an integer"}}

  @impl Shapex.Type
  def validate(%__MODULE__{} = schema, value) do
    validation_results =
      Enum.reduce(schema.validations, %{}, fn
        {:custom, {rule_name, callback}}, errors ->
          case callback.(value) do
            nil -> errors
            error -> Map.put(errors, rule_name, error)
          end

        {rule_name, {target, message}}, errors ->
          case do_validate(rule_name, target, value, message) do
            nil -> errors
            error -> Map.put(errors, rule_name, error)
          end

        {rule_name, target}, errors ->
          case do_validate(rule_name, target, value) do
            nil -> errors
            error -> Map.put(errors, rule_name, error)
          end
      end)

    if validation_results == %{} do
      {:ok, :valid}
    else
      {:error, validation_results}
    end
  end

  defp do_validate(rule_name, target, value, message \\ nil)

  defp do_validate(:gt, target, value, message) when not (value > target) do
    message || "Value must be greater than #{target}"
  end

  defp do_validate(:gte, target, value, message) when not (value >= target) do
    message || "Value must be greater than or equal to #{target}"
  end

  defp do_validate(:lt, target, value, message) when not (value < target) do
    message || "Value must be less than #{target}"
  end

  defp do_validate(:lte, target, value, message) when not (value <= target) do
    message || "Value must be less than or equal to #{target}"
  end

  defp do_validate(:eq, target, value, message) when not (value == target) do
    message || "Value must be equal to #{target}"
  end

  defp do_validate(:neq, target, value, message) when not (value != target) do
    message || "Value must not be equal to #{target}"
  end

  defp do_validate(:in, range, value, message) do
    if not Enum.member?(range, value) do
      message || "Value must be one of #{inspect(range)}"
    end
  end

  defp do_validate(:not_in, range, value, message) do
    if Enum.member?(range, value) do
      message || "Value must not be one of #{inspect(range)}"
    end
  end

  defp do_validate(_rule_name, _target, _value, _message) do
    nil
  end
end