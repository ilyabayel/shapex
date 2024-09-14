defmodule Shapex.Types.Any do
  @behaviour Shapex.Type

  @type t :: %__MODULE__{}

  defstruct []

  @impl Shapex.Type
  def validate(_, _), do: :ok
end
