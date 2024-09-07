defmodule Shapex.SchemaTest do
  use ExUnit.Case, async: true

  require Shapex

  describe "schema/1" do
    test "should return valid schema for integer" do
      schema = Shapex.schema(1)

      assert Shapex.Types.integer(eq: 1) == schema
    end

    test "should return valid schema for float" do
      schema = Shapex.schema(1.0)

      assert Shapex.Types.float(eq: 1.0) == schema
    end

    test "should return valid schema for atom" do
      schema = Shapex.schema(:atom)

      assert Shapex.Types.atom(eq: :atom) == schema
    end

    test "should return valid schema for string" do
      schema = Shapex.schema("string")

      assert Shapex.Types.string(eq: "string") == schema
    end

    test "shoould generate schema for enums" do
      schema = Shapex.schema([1, 1.0, "string", :atom, true, %{key: "value"}])

      assert Shapex.Types.enum([
               Shapex.Types.integer(eq: 1),
               Shapex.Types.float(eq: 1.0),
               Shapex.Types.string(eq: "string"),
               Shapex.Types.atom(eq: :atom),
               Shapex.Types.boolean(true),
               Shapex.Types.map(%{key: Shapex.Types.string(eq: "value")})
             ]) == schema
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

      assert Shapex.Types.map(%{
               int: Shapex.Types.integer(eq: 1),
               float: Shapex.Types.float(eq: 1.0),
               atom: Shapex.Types.atom(eq: :atom),
               string: Shapex.Types.string(eq: "string"),
               bool: Shapex.Types.boolean(true)
             }) == schema
    end

    test "should generate valid schema for map inside map" do
      schema =
        Shapex.schema(%{
          map: %{
            int: 1
          }
        })

      assert Shapex.Types.map(%{
               map:
                 Shapex.Types.map(%{
                   int: Shapex.Types.integer(eq: 1)
                 })
             }) == schema
    end

    test "d" do
      schema = Shapex.schema(dict(string(), integer(gte: 10)))

      schema2 = Shapex.Types.dict(Shapex.Types.string(), Shapex.Types.integer(gte: 10))

      assert schema == schema2
    end
  end
end
