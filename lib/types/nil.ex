defmodule Shapex.Types.Nil do
  @moduledoc """
  This module provides a type for validating nil values.
  """

  @behaviour Shapex.Type

  defstruct []

  @spec validate(%__MODULE__{}, any()) :: :ok | {:error, map()}

  def validate(%__MODULE__{}, nil), do: :ok
  def validate(_, _), do: {:error, %{type: "Value must be nil"}}
end
