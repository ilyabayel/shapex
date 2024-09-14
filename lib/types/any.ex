defmodule Shapex.Types.Any do
  @moduledoc """
  This module provides a type for validating any value.
  """
  @behaviour Shapex.Type

  @type t :: %__MODULE__{}

  defstruct []

  @impl Shapex.Type
  def validate(_, _), do: :ok
end
