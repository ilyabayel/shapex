defmodule Shapex.Types.List do
  @behaviour Shapex.Type

  @type t :: %__MODULE__{
          item: Shapex.Type.t()
        }

  defstruct [:item]

  @spec validate(__MODULE__.t(), list()) :: {:ok, :valid} | {:error, term()}
  def validate(schema, list) do
    errors =
      list
      |> Enum.with_index()
      |> Enum.reduce(
        %{},
        fn
          {item, idx}, errors ->
            case Shapex.validate(schema.item, item) do
              {:ok, :valid} -> errors
              {:error, item_errors} -> Map.put(errors, idx, item_errors)
            end
        end
      )

    if errors == %{} do
      {:ok, :valid}
    else
      {:error, errors}
    end
  end
end
