defmodule Shapex.Types.List do
  @moduledoc """
  Module that contains List type for Shapex.

  It's better to use the Shapex.Types.list/1 function to create a schema,
  since it covers implementation details and provides a more user-friendly API.
  """
  @behaviour Shapex.Type

  @type t :: %__MODULE__{
          item: Shapex.Type.t()
        }

  defstruct [:item]

  @spec validate(__MODULE__.t(), list()) :: :ok | {:error, term()}
  def validate(%__MODULE__{} = schema, list) when is_list(list) do
    errors =
      list
      |> Enum.with_index()
      |> Enum.reduce(
        %{},
        fn
          {item, idx}, errors ->
            case Shapex.validate(schema.item, item) do
              :ok -> errors
              {:error, item_errors} -> Map.put(errors, idx, item_errors)
            end
        end
      )

    if errors == %{} do
      :ok
    else
      {:error, errors}
    end
  end

  def validate(_, _) do
    {:error, %{type: "Value must be a list"}}
  end
end
