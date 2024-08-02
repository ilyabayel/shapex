defmodule ShapexTest do
  use ExUnit.Case

  import Shapex.Types

  describe "validate/2 integer" do
    test "should return {:ok, :valid} if valid" do
      schema = integer(gt: 4, lt: 6)
      assert {:ok, :valid} = Shapex.validate(schema, 5)
    end

    test "should return error for gt" do
      schema = integer(gt: 4)
      assert {:error, %{gt: "Value must be greater than 4"}} = Shapex.validate(schema, 4)
    end

    test "should return error for gte" do
      schema = integer(gte: 4)

      assert {:error, %{gte: "Value must be greater than or equal to 4"}} =
               Shapex.validate(schema, 3)
    end

    test "should return error for lt" do
      schema = integer(lt: 4)
      assert {:error, %{lt: "Value must be less than 4"}} = Shapex.validate(schema, 4)
    end

    test "should return error for lte" do
      schema = integer(lte: 4)

      assert {:error, %{lte: "Value must be less than or equal to 4"}} =
               Shapex.validate(schema, 5)
    end

    test "should return error for eq" do
      schema = integer(eq: 4)
      assert {:error, %{eq: "Value must be equal to 4"}} = Shapex.validate(schema, 5)
    end

    test "should return error for neq" do
      schema = integer(neq: 4)
      assert {:error, %{neq: "Value must not be equal to 4"}} = Shapex.validate(schema, 4)
    end

    test "should return error for in" do
      schema = integer(in: [1, 2, 3])
      assert {:error, %{in: "Value must be one of [1, 2, 3]"}} = Shapex.validate(schema, 4)
    end

    test "should return error for not_in" do
      schema = integer(not_in: [1, 2, 3])

      assert {:error, %{not_in: "Value must not be one of [1, 2, 3]"}} =
               Shapex.validate(schema, 2)
    end

    test "should return error for custom" do
      schema =
        integer(
          custom:
            {:rule,
             fn value ->
               if value == 4 do
                 "Value must not be 4"
               end
             end}
        )

      assert {:error, %{rule: "Value must not be 4"}} =
               Shapex.validate(schema, 4)
    end
  end

  describe "validate/2 string" do
    test "should return {:ok, :valid} if valid" do
      schema = string()
      assert {:ok, :valid} = Shapex.validate(schema, "hey")
    end

    test "should return error for min_length" do
      schema = string(min_length: 4)

      assert {:error, %{min_length: "String length must be at least 4"}} =
               Shapex.validate(schema, "123")
    end

    test "should return error for max_length" do
      schema = string(max_length: 4)

      assert {:error, %{max_length: "String length must be no more than 4"}} =
               Shapex.validate(schema, "12345")
    end

    test "should return error for length" do
      schema = string(length: 4)

      assert {:error, %{length: "String length must be equal to 4"}} =
               Shapex.validate(schema, "12345")
    end

    test "should return error for eq" do
      schema = string(eq: "hey")

      assert {:error, %{eq: "String must be equal to hey"}} =
               Shapex.validate(schema, "hello")
    end

    test "should return error for neq" do
      schema = string(neq: "hello")

      assert {:error, %{neq: "String must not be equal to hello"}} =
               Shapex.validate(schema, "hello")
    end

    test "should return error for regex" do
      schema = string(regex: ~r/^(hey|hello)$/)

      assert {:error, %{regex: "String must match the regex ~r/^(hey|hello)$/"}} =
               Shapex.validate(schema, "hi")
    end
  end

  describe "validate/2 map" do
    test "should return success if valid" do
      schema =
        map(%{
          name: string(),
          age: integer(gt: 0)
        })

      assert {:ok, :valid} = Shapex.validate(schema, %{name: "John", age: 30})
    end

    test "should return error if type doesn't match" do
      schema =
        map(%{
          name: string(),
          age: integer(gt: 0)
        })

      assert {:error,
              %{
                name: %{
                  type: "Value must be a string"
                },
                age: %{
                  type: "Value must be an integer"
                }
              }} = Shapex.validate(schema, %{name: 123, age: "30"})
    end

    test "should return error if required field is missing" do
      schema =
        map(%{
          name: string()
        })

      assert {:error,
              %{
                name: %{
                  required: "Key name is required"
                }
              }} = Shapex.validate(schema, %{})
    end

    test "should return ok if optional field is missing" do
      schema =
        map(%{
          :age => integer(),
          optional(:name) => string()
        })

      assert {:ok, :valid} = Shapex.validate(schema, %{age: 12})
    end
  end

  describe "validate/2 list" do
    test "should return success if valid" do
      schema = list(integer(gt: 0))

      assert {:ok, :valid} = Shapex.validate(schema, [1, 2, 3])
    end

    test "should return error if type doesn't match" do
      schema = list(integer(gt: 0))

      assert {:error,
              %{
                1 => %{
                  type: "Value must be an integer"
                }
              }} = Shapex.validate(schema, [1, "2", 3])
    end

    test "should return ok for empty list" do
      schema = list(integer(gt: 0))

      assert {:ok, :valid} = Shapex.validate(schema, [])
    end

    test "should return error for if there is an error in a map" do
      schema = list(map(%{name: string(length: 4)}))

      assert {:error,
              %{
                0 => %{
                  name: %{
                    length: "String length must be equal to 4"
                  }
                }
              }} = Shapex.validate(schema, [%{name: "Johny"}, %{name: "Jane"}])
    end
  end

  describe "validate/2 for enum" do
    test "should return success if valid" do
      schema = enum([integer(eq: 1), integer(eq: 2), integer(eq: 3)])

      assert {:ok, :valid} = Shapex.validate(schema, 1)
    end

    test "should return error if value is not in enum" do
      enumeration = [integer(eq: 1), integer(eq: 2), integer(eq: 3)]
      schema = enum(enumeration)

      assert {:error, {"Value must be one of", ^enumeration}} = Shapex.validate(schema, 4)
    end

    test "should return error if value is not in enum (map enums)" do
      person_schema = map(%{name: string(), age: integer()})
      animal_schema = map(%{name: string(), breed: string()})

      person_or_animal = [person_schema, animal_schema]

      schema = enum(person_or_animal)

      assert {:error, {"Value must be one of", person_or_animal}} == Shapex.validate(schema, %{adult?: true})
    end
  end
end
