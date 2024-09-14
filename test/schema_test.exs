defmodule Shapex.SchemaTest do
  use ExUnit.Case, async: true

  alias Shapex.Types, as: S

  require Shapex

  describe "schema/1" do
    test "should return valid schema for any" do
      schema = Shapex.schema(any())

      assert S.any() == schema
    end

    test "should return valid schema for nil" do
      schema = Shapex.schema(nil)

      assert %S.Nil{} == schema
    end

    test "should return valid schema for integer" do
      schema = Shapex.schema(1)

      assert S.integer(eq: 1) == schema
    end

    test "should return valid schema for float" do
      schema = Shapex.schema(1.0)

      assert S.float(eq: 1.0) == schema
    end

    test "should return valid schema for atom" do
      schema = Shapex.schema(:atom)

      assert S.atom(eq: :atom) == schema
    end

    test "should return valid schema for string" do
      schema = Shapex.schema("string")

      assert S.string(eq: "string") == schema
    end

    test "shoould generate schema for enums" do
      enum = Shapex.schema(1 | 1.0 | "string" | :atom | true | %{:key => "value"})

      expected_enum =
        S.enum([
          S.integer(eq: 1),
          S.float(eq: 1.0),
          S.string(eq: "string"),
          S.atom(eq: :atom),
          S.boolean(true),
          S.map(%{key: S.string(eq: "value")})
        ])

      assert expected_enum == enum
    end

    test "should return valid schema for map" do
      schema =
        Shapex.schema(%{
          int: 1,
          float: 1.0,
          atom: :atom,
          string: "string",
          bool: true
        })

      assert S.map(%{
               int: S.integer(eq: 1),
               float: S.float(eq: 1.0),
               atom: S.atom(eq: :atom),
               string: S.string(eq: "string"),
               bool: S.boolean(true)
             }) == schema
    end

    test "should generate valid schema for map inside map" do
      schema =
        Shapex.schema(%{
          map: %{
            int: 1
          }
        })

      assert S.map(%{
               map:
                 S.map(%{
                   int: S.integer(eq: 1)
                 })
             }) == schema
    end

    test "should generate dict schema" do
      schema = Shapex.schema(dict(string(), integer(gte: 10)))

      assert schema == S.dict(S.string(), S.integer(gte: 10))
    end
  end

  describe "advanced cases" do
    test "should generate maps with interpolated runtime values" do
      user =
        S.map(%{
          name: S.string(min_length: 3),
          age: S.integer(gt: 0)
        })

      enum_int = S.integer(eq: 1)
      enum_float = S.float(eq: 1.0)

      int_value = 10
      float_value = 10
      string_length = 8
      not_atom = :not_atom
      expected_bool = false
      key = S.string(eq: "hello")
      value = S.integer(eq: 10)

      expected_schema =
        S.map(%{
          atom: S.atom(neq: not_atom),
          bool: S.boolean(expected_bool),
          dict: S.dict(key, value),
          enum: S.enum([enum_int, enum_float]),
          float: S.float(gt: float_value),
          int: S.integer(gte: int_value),
          list: S.list(S.integer(gte: 10)),
          map: user,
          string: S.string(min_length: string_length)
        })

      assert Shapex.schema(%{
               atom: atom(neq: ^not_atom),
               bool: boolean(^expected_bool),
               dict: dict(^key, ^value),
               enum: ^enum_int | ^enum_float,
               float: float(gt: ^float_value),
               int: integer(gte: ^int_value),
               list: list(integer(gte: 10)),
               map: ^user,
               string: string(min_length: ^string_length)
             }) == expected_schema
    end
  end
end
