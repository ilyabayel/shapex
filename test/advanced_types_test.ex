defmodule Shapex.AdvancedTypesTest do
  use ExUnit.Case, async: true

  alias Shapex.Types, as: S

  describe "validate/2" do
    @user_schema S.map(%{
                   name: S.string(min_length: 3),
                   age: S.integer(gte: {18, "Should be adult"}),
                   email: S.string(regex: ~r/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/),
                   address:
                     S.map(%{
                       street: S.string(),
                       city: S.string(),
                       zip: S.string(min_length: 5)
                     })
                 })

    test "valid user" do
      user = %{
        name: "John Doe",
        age: 18,
        email: "john@google.com",
        address: %{
          street: "123 Main St",
          city: "New York",
          zip: "000504"
        }
      }

      assert {:ok, :valid} = Shapex.validate(@user_schema, user)
    end

    test "invalid user" do
      user = %{
        name: "Jo",
        age: 17,
        email: "john@google",
        address: %{
          street: "123 Main St",
          city: "New York",
          zip: "1001"
        }
      }

      assert {:error,
              %{
                age: %{gte: "Should be adult"},
                email: %{
                  regex:
                    "String must match the regex ~r/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$/"
                },
                name: %{min_length: "String length must be at least 3"},
                address: %{zip: %{min_length: "String length must be at least 5"}}
              }} = Shapex.validate(@user_schema, user)
    end
  end
end
