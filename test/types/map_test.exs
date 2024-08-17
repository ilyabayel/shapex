defmodule Shapex.Types.MapTest do
  use ExUnit.Case, async: true

  alias Shapex.Types, as: S

  describe "validate/2 map" do
    test "should return success if valid" do
      schema =
        S.map(%{
          name: S.string(),
          age: S.integer(gt: 0)
        })

      assert {:ok, :valid} = Shapex.validate(schema, %{name: "John", age: 30})
    end

    test "should return error if type doesn't match" do
      schema =
        S.map(%{
          name: S.string(),
          age: S.integer(gt: 0)
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
        S.map(%{
          name: S.string()
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
        S.map(%{
          :age => S.integer(),
          S.optional(:name) => S.string()
        })

      assert {:ok, :valid} = Shapex.validate(schema, %{age: 12})
    end
  end
end
