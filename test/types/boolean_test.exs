defmodule Shapex.Types.BooleanTest do
  use ExUnit.Case, async: true

  alias Shapex.Types, as: S

  describe "validate/2" do
    test "should return success on valid eq" do
      schema = S.boolean(true)

      assert {:ok, :valid} = Shapex.validate(schema, true)
    end

    test "should return error on invalid eq" do
      schema = S.boolean(true)

      assert {:error, %{eq: "Value must be true, got false"}} =
               Shapex.validate(schema, false)
    end

    test "should return error on invalid eq with custom message" do
      schema = S.boolean({true, "Message"})

      assert {:error, %{eq: "Message"}} =
               Shapex.validate(schema, false)
    end
  end
end
