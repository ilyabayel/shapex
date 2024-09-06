defmodule Shapex.Types.Map do
  @moduledoc """
  This module provides a type for validating maps.

  Maps have a schema that defines the keys and their respective types.

  It's better to use the Shapex.Types.map/1 function to create a schema,
  since it covers implementation details and provides a more user-friendly API.
  """
  @behaviour Shapex.Type

  @type key :: String.t() | atom() | {:optional, String.t()} | {:optional, atom()}

  @type t :: %__MODULE__{
          fields: %{
            key() => Shapex.Type.t()
          }
        }

  @enforce_keys [:fields]
  defstruct [:fields]

  @spec validate(__MODULE__.t(), map()) :: {:ok, :valid} | {:error, term()}
  def validate(%__MODULE__{} = schema, value) when is_map(value) do
    keys = Map.keys(schema.fields)

    errors =
      Enum.reduce(
        keys,
        %{},
        fn
          {:optional, key}, errors ->
            if Map.has_key?(value, key) do
              case Shapex.validate(schema.fields[key], Map.get(value, key)) do
                {:ok, :valid} -> errors
                {:error, field_errors} -> Map.put(errors, key, field_errors)
              end
            else
              errors
            end

          key, errors ->
            if not Map.has_key?(value, key) do
              Map.put(errors, key, %{required: "Key #{key} is required"})
            else
              case Shapex.validate(schema.fields[key], Map.get(value, key)) do
                {:ok, :valid} ->
                  errors

                {:error, field_errors} ->
                  Map.merge(errors, %{key => field_errors})
              end
            end
        end
      )

    if errors == %{} do
      {:ok, :valid}
    else
      {:error, errors}
    end
  end

  def validate(_, _value), do: {:error, %{type: "Value must be a map"}}
end
