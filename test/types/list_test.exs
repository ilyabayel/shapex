defmodule Shapex.Types.ListTets do
  use ExUnit.Case, async: true

  alias Shapex.Types, as: S

  describe "validate/2" do
    test "should return success if valid" do
      schema = S.list(S.integer(gt: 0))

      assert :ok = Shapex.validate(schema, [1, 2, 3])
    end

    test "should return error if type doesn't match" do
      schema = S.list(S.integer(gt: 0))

      assert {:error,
              %{
                1 => %{
                  type: "Value must be an integer"
                }
              }} = Shapex.validate(schema, [1, "2", 3])
    end

    test "should return ok for empty list" do
      schema = S.list(S.integer(gt: 0))

      assert :ok = Shapex.validate(schema, [])
    end

    test "should return error for if there is an error in a map" do
      schema = S.list(S.map(%{name: S.string(length: 4)}))

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
end
