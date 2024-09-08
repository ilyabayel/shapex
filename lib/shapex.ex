defmodule Shapex do
  @moduledoc """
  Shapex is a tool to help you validate your maps.

  You'll need to define a schema for a map and then you can use Shapex to validate it.

  There are some built-in types that you can use to define your schema:
    - atom
    - boolean
    - enum
    - float
    - integer
    - list
    - map
    - record
    - string
    - dict
  """

  @spec validate(Shapex.Type.t(), term()) :: {:ok, :valid} | {:error, term()}
  def validate(schema, value) do
    schema.__struct__.validate(schema, value)
  end

  defmacro schema(expression) do
    Services.Builder.build(expression)
  end
end
