defmodule Services.Builder do
  def build(expression) do
    build_schema(expression)
  end

  defp build_schema(expression) do
    case expression do
      value when is_integer(value) ->
        build_integer([[eq: value]])

      value when is_float(value) ->
        build_float([[eq: value]])

      value when is_boolean(value) ->
        build_boolean([value])

      value when is_atom(value) ->
        build_atom([[eq: value]])

      value when is_binary(value) ->
        build_string([[eq: value]])

      enum when is_list(enum) ->
        build_enum(enum)

      {:%{}, _, kw} ->
        build_map(kw)

      {:atom, _, args} ->
        build_atom(args)

      {:integer, _, args} ->
        build_integer(args)

      {:float, _, args} ->
        build_float(args)

      {:string, _, args} ->
        build_string(args)

      {:boolean, _, args} ->
        build_boolean(args)

      {:dict, _, args} ->
        build_dict(args)

      {:list, _, args} ->
        build_list(args)

      {:record, _, args} ->
        build_record(args)

      {:^, _, [expr]} ->
        expr
    end
  end

  defp build_map(keyword) do
    build_keyword =
      keyword
      |> Enum.map(fn {key, value} ->
        {key, build_schema(value)}
      end)

    quote do
      Shapex.Types.map(Enum.into(unquote(build_keyword), %{}))
    end
  end

  defp build_atom(args) do
    built_args = build_args(args)

    quote do
      apply(Shapex.Types, :atom, unquote(built_args))
    end
  end

  defp build_integer(args) do
    built_args = build_args(args)

    quote do
      apply(Shapex.Types, :integer, unquote(built_args))
    end
  end

  defp build_float(args) do
    built_args = build_args(args)

    quote do
      apply(Shapex.Types, :float, unquote(built_args))
    end
  end

  defp build_string(args) do
    built_args = build_args(args)

    quote do
      apply(Shapex.Types, :string, unquote(built_args))
    end
  end

  defp build_boolean(args) do
    built_args = build_args(args)

    quote do
      apply(Shapex.Types, :boolean, unquote(built_args))
    end
  end

  defp build_dict([key, value]) do
    quote do
      Shapex.Types.dict(unquote(build_schema(key)), unquote(build_schema(value)))
    end
  end

  defp build_enum(enum) do
    built_enum_list = Enum.map(enum, &build_enum_item/1)

    quote do
      Shapex.Types.enum(unquote(built_enum_list))
    end
  end

  defp build_enum_item(enum_item) do
    case enum_item do
      {:^, _, [expr]} ->
        expr

      value ->
        build_schema(value)
    end
  end

  defp build_list([item]) do
    quote do
      Shapex.Types.list(unquote(build_schema(item)))
    end
  end

  defp build_record(args) do
    built_args = build_args(args)

    quote do
      apply(Shapex.Types, :record, unquote(built_args))
    end
  end

  defp build_args(args) do
    Enum.map(args, fn arg ->
      cond do
        Keyword.keyword?(arg) -> build_keyword_list(arg)
        is_boolean(arg) -> arg
        {:^, _, [expr]} = arg -> expr
      end
    end)
  end

  defp build_keyword_list(kw) do
    Enum.map(kw, fn {key, value} ->
      {:{}, [], [key, build_keyword_value(value)]}
    end)
  end

  defp build_keyword_value(value) do
    case value do
      {:^, _, [expr]} ->
        expr

      value ->
        value
    end
  end
end
