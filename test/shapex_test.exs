defmodule ShapexTest do
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

  describe "parsed json" do
    @config_schema S.map(%{
                     "type" => S.enum([S.string(eq: "gl"), S.string(eq: "contract")]),
                     "configuration" =>
                       S.map(%{
                         "line" =>
                           S.list(
                             S.map(%{
                               "id" => S.string(),
                               "slug" => S.string()
                             })
                           )
                       })
                   })

    S.map(%{
      "type" =>
        S.enum([
          S.string(eq: "gl"),
          S.string(eq: "contract")
        ]),
      "configuration" =>
        S.map(%{
          "line" =>
            S.list(
              S.map(%{
                "id" => S.string(),
                "slug" => S.string()
              })
            )
        })
    })

    test "valid string key map" do
      data =
        %{
          "type" => "gl",
          "configuration" => %{
            "line" => [
              %{"id" => "1", "slug" => "slug1"},
              %{"id" => "2", "slug" => "slug2"}
            ]
          }
        }

      assert {:ok, :valid} = Shapex.validate(@config_schema, data)
    end

    test "invalid string key map" do
      data = %{
        "type" => "bla-bla",
        "configuration" => %{
          "line" => [
            %{"id" => "1", "slug" => "slug1"},
            %{"id" => "2", "slug" => "slug2"}
          ]
        }
      }

      assert {
               :error,
               %{
                 "type" =>
                   {"Value must be one of",
                    [
                      %Shapex.Types.String{validations: [eq: "gl"]},
                      %Shapex.Types.String{validations: [eq: "contract"]}
                    ]}
               }
             } = Shapex.validate(@config_schema, data)
    end
  end
end
