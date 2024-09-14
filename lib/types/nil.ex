defmodule Shapex.Types.Nil do
  @behaviour Shapex.Type

  defstruct []

  @spec validate(%__MODULE__{}, any()) :: :ok | {:error, map()}

  def validate(%__MODULE__{}, nil), do: :ok
  def validate(_, _), do: {:error, %{type: "Value must be nil"}}
end
