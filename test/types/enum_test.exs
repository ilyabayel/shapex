defmodule Shapex.Types.EnumTest do
  use ExUnit.Case, async: true

  alias Shapex.Types, as: S

  describe "validate/2" do
    test "should return success if valid" do
      schema = S.enum([S.integer(eq: 1), S.integer(eq: 2), S.integer(eq: 3)])

      assert :ok = Shapex.validate(schema, 1)
    end

    test "should return error if value is not in enum" do
      enumeration = [S.integer(eq: 1), S.integer(eq: 2), S.integer(eq: 3)]
      schema = S.enum(enumeration)

      assert {:error, {"Value must be one of", ^enumeration}} = Shapex.validate(schema, 4)
    end

    test "should return error if value is not in enum (map enums)" do
      person_schema = S.map(%{name: S.string(), age: S.integer()})
      animal_schema = S.map(%{name: S.string(), breed: S.string()})

      person_or_animal = [person_schema, animal_schema]

      schema = S.enum(person_or_animal)

      assert {:error, {"Value must be one of", person_or_animal}} ==
               Shapex.validate(schema, %{adult?: true})
    end
  end
end
