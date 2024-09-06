defmodule Shapex.Types.Atom do
  @moduledoc """
  This module provides a type for validating atoms.

  It's better to use the Shapex.Types.atom/1 function to create a schema,
  since it covers implementation details and provides a more user-friendly API.
  """
  @behaviour Shapex.Type

  @type atom_or_tuple :: atom() | {atom(), String.t()}

  @type validation ::
          {:eq, atom_or_tuple()}
          | {:neq, atom_or_tuple()}

  @type t :: %__MODULE__{
          validations: [validation]
        }

  defstruct [:validations]

  def validate(%__MODULE__{} = schema, value) when is_atom(value) do
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

  def validate(_, _), do: {:error, %{type: "Value must be an atom"}}

  defp do_validate(:eq, value, target, message) when value != target do
    message || "Value must be equal to #{target}"
  end

  defp do_validate(:neq, value, target, message) when value == target do
    message || "Value must not be equal to #{target}"
  end

  defp do_validate(_, _, _, _), do: nil
end
