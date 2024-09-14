defmodule Shapex.Types.Enum do
  @moduledoc """
  This module provides a type for validating enums.

  Enums are a list of possible values that a value can be.

  It's better to use the Shapex.Types.enum/1 function to create a schema,
  since it covers implementation details and provides a more user-friendly API.
  """

  @behaviour Shapex.Type

  defstruct [:items]

  @type t :: %__MODULE__{
          items: list(Shapex.Type.t())
        }

  def validate(%__MODULE__{} = schema, value) do
    case Enum.find(schema.items, fn item -> Shapex.validate(item, value) == :ok end) do
      nil -> {:error, {"Value must be one of", schema.items}}
      _ -> :ok
    end
  end
end
