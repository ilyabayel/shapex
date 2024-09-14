defmodule Shapex.Types.Dict do
  @moduledoc """
  This module provides a type for validating dictionaries.

  Records are a key-value pair where the key is a string and the value is any type.

  Difference between a dict and a map:
  - A dict is a key-value pair where you validate that the key has the type you expect, and the value has the type you expect.
  - A map is like a struct since you define set of keys and their values that you expect.

  It's better to use the Shapex.Types.dict/2 function to create a schema,
  since it covers implementation details and provides a more user-friendly API.
  """

  @behaviour Shapex.Type

  @type t :: %__MODULE__{
          key_type: Shapex.Types.Type.t(),
          value_type: Shapex.Types.Type.t()
        }

  defstruct [:key_type, :value_type]

  @impl Shapex.Type
  def validate(%__MODULE__{} = schema, value) do
    results =
      value
      |> Map.to_list()
      |> Enum.map(fn {k, v} ->
        {k, Shapex.validate(schema.key_type, k), Shapex.validate(schema.value_type, v)}
      end)
      |> Enum.reduce(%{}, fn
        {_key, :ok, :ok}, acc ->
          acc

        {key, key_result, value_result}, acc ->
          key_result =
            case key_result do
              :ok -> :valid
              {:error, key_errors} -> key_errors
            end

          value_result =
            case value_result do
              :ok -> :valid
              {:error, value_errors} -> value_errors
            end

          Map.put(acc, key, %{key: key_result, value: value_result})
      end)

    if results == %{} do
      :ok
    else
      {:error, results}
    end
  end
end
