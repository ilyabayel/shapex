defmodule Shapex.Types.StringTest do
  use ExUnit.Case, async: true

  alias Shapex.Types, as: S

  describe "validate/2 string" do
    test "should return {:ok, :valid} if valid" do
      schema = S.string()
      assert {:ok, :valid} = Shapex.validate(schema, "hey")
    end

    test "should return error for min_length" do
      schema = S.string(min_length: 4)

      assert {:error, %{min_length: "String length must be at least 4"}} =
               Shapex.validate(schema, "123")
    end

    test "should return error for max_length" do
      schema = S.string(max_length: 4)

      assert {:error, %{max_length: "String length must be no more than 4"}} =
               Shapex.validate(schema, "12345")
    end

    test "should return error for length" do
      schema = S.string(length: 4)

      assert {:error, %{length: "String length must be equal to 4"}} =
               Shapex.validate(schema, "12345")
    end

    test "should return error for eq" do
      schema = S.string(eq: "hey")

      assert {:error, %{eq: "String must be equal to hey"}} =
               Shapex.validate(schema, "hello")
    end

    test "should return error for neq" do
      schema = S.string(neq: "hello")

      assert {:error, %{neq: "String must not be equal to hello"}} =
               Shapex.validate(schema, "hello")
    end

    test "should return error for regex" do
      schema = S.string(regex: ~r/^(hey|hello)$/)

      assert {:error, %{regex: "String must match the regex ~r/^(hey|hello)$/"}} =
               Shapex.validate(schema, "hi")
    end
  end
end
