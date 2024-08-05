defmodule Shapex.Types.Record do
  @behaviour Shapex.Type

  @type t :: %__MODULE__{
          key_type: Shapex.Types.Type.t(),
          value_type: Shapex.Types.Type.t()
        }

  defstruct [:key_type, :value_type]

  def validate(schema, value) do
    results =
      value
      |> Map.to_list()
      |> Enum.map(fn {k, v} ->
        {k, Shapex.validate(schema.key_type, k), Shapex.validate(schema.value_type, v)}
      end)
      |> Enum.reduce(%{}, fn
        {_key, {:ok, :valid}, {:ok, :valid}}, acc ->
          acc

        {key, key_result, value_result}, acc ->
          Map.put(acc, key, %{key: elem(key_result, 1), value: elem(value_result, 1)})
      end)

    if results == %{} do
      {:ok, :valid}
    else
      {:error, results}
    end
  end
end
