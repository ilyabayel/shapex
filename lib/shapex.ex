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
  """

  @spec validate(Shapex.Type.t(), term()) :: {:ok, :valid} | {:error, term()}
  def validate(schema, value) do
    schema.__struct__.validate(schema, value)
  end

  defmacro schema(schema) do
    definition = gen_schema(schema)

    quote do
      unquote(Macro.escape(definition))
    end
  end

  defp gen_schema(schema) do
    case schema do
      boolean when is_boolean(boolean) ->
        Shapex.Types.boolean(boolean)

      atom when is_atom(atom) ->
        Shapex.Types.atom(eq: atom)

      enum when is_list(enum) ->
        gen_enum_schema(enum)

      float when is_float(float) ->
        Shapex.Types.float(eq: float)

      int when is_integer(int) ->
        Shapex.Types.integer(eq: int)

      string when is_binary(string) ->
        Shapex.Types.string(eq: string)

      {:%{}, _, keyword} ->
        gen_map_schema(keyword)

      {:atom, _, args} ->
        args
        |> Enum.at(0, [])
        |> Shapex.Types.atom()

      {:boolean, _, [expected_value]} ->
        Shapex.Types.boolean(expected_value)

      {:dict, _, keyword} ->
        gen_dict_schema(keyword)

      {:float, _, args} ->
        args
        |> Enum.at(0, [])
        |> Shapex.Types.float()

      {:integer, _, args} ->
        args
        |> Enum.at(0, [])
        |> Shapex.Types.integer()

      {:list, _, [list_item]} ->
        Shapex.Types.list(list_item)

      {:string, _, args} ->
        args
        |> Enum.at(0, [])
        |> Shapex.Types.string()

      {v, _, _} ->
        raise "Unknown schema type: #{inspect(v)}"
    end
  end

  defp gen_map_schema(keyword) do
    keyword
    |> Enum.map(fn {key, value} -> {key, gen_schema(value)} end)
    |> Enum.into(%{})
    |> Shapex.Types.map()
  end

  defp gen_enum_schema(values) do
    case Enum.find(values, fn value -> is_list(value) end) do
      nil -> Shapex.Types.enum(values |> Enum.map(&gen_schema/1))
      _ -> raise "There should be no nested enumerations"
    end
  end

  defp gen_dict_schema(keyword) do
    [{key, _, key_args}, {value, _, value_args}] = keyword

    Shapex.Types.dict(
      apply(Shapex.Types, key, key_args),
      apply(Shapex.Types, value, value_args)
    )
  end
end
