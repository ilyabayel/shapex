defmodule Shapex.Types.Enum do
  @moduledoc """
  Enum type module for Shapex.
  """

  @behaviour Shapex.Type

  defstruct [:items]

  @type t :: %__MODULE__{
          items: list(Shapex.Type.t())
        }

  def validate(schema, value) do
    case Enum.find(schema.items, fn item -> Shapex.validate(item, value) == {:ok, :valid} end) do
      nil -> {:error, {"Value must be one of", schema.items}}
      _ -> {:ok, :valid}
    end
  end
end
