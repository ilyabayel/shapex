defmodule Shapex.Types.AtomTest do
  use ExUnit.Case, async: true

  alias Shapex.Types, as: S

  describe "validate/2" do
    test "should return success on valid eq" do
      schema = S.atom(eq: :foo)

      assert {:ok, :valid} = Shapex.validate(schema, :foo)
    end

    test "should return error on invalid eq" do
      schema = S.atom(eq: :foo)

      assert {:error, %{eq: "Value must be equal to foo"}} =
               Shapex.validate(schema, :bar)
    end

    test "should return error on valid neq" do
      schema = S.atom(neq: :foo)

      assert {:ok, :valid} = Shapex.validate(schema, :bar)
    end

    test "should return error on invalid neq" do
      schema = S.atom(neq: :foo)

      assert {:error, %{neq: "Value must not be equal to foo"}} =
               Shapex.validate(schema, :foo)
    end

    test "should return error on invalid eq with custom message" do
      schema = S.atom(eq: {:foo, "Message"})

      assert {:error, %{eq: "Message"}} =
               Shapex.validate(schema, :bar)
    end

    test "should return error on invalid neq with custom message" do
      schema = S.atom(neq: {:foo, "Message"})

      assert {:error, %{neq: "Message"}} =
               Shapex.validate(schema, :foo)
    end
  end
end
