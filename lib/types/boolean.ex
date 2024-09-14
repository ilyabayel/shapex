defmodule Shapex.Types.Boolean do
  @moduledoc """
  This module provides a type for validating booleans.

  It's better to use the Shapex.Types.boolean/1 function to create a schema,
  since it covers implementation details and provides a more user-friendly API.
  """
  @behaviour Shapex.Type

  @type boolean_or_tuple :: boolean() | {boolean(), String.t()}

  @type t :: %__MODULE__{
          eq: boolean_or_tuple()
        }

  defstruct [:eq]

  @impl Shapex.Type
  def validate(%__MODULE__{} = schema, value) when is_boolean(value) do
    case schema.eq do
      nil ->
        :ok

      {expected_value, message} when value != expected_value ->
        {:error, %{eq: message}}

      expected_value when value != expected_value ->
        {:error, %{eq: "Value must be #{schema.eq}, got #{value}"}}

      _ ->
        :ok
    end
  end

  @impl Shapex.Type
  def validate(_, _), do: {:error, %{type: "Value must be a boolean"}}
end
