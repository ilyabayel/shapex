defmodule Shapex.Type do
  @type t :: struct()

  @callback validate(schema :: t(), value :: term()) :: {:ok, :valid} | {:error, term()}
end
