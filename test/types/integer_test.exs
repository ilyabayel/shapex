defmodule Shapex.Types.FloatTest do
  use ExUnit.Case, async: true

  alias Shapex.Types, as: S

  describe "validate/2 integer" do
    test "should return {:ok, :valid} if valid" do
      schema = S.integer(gt: 4, lt: 6)
      assert {:ok, :valid} = Shapex.validate(schema, 5)
    end

    test "should return error for gt" do
      schema = S.integer(gt: 4)
      assert {:error, %{gt: "Value must be greater than 4"}} = Shapex.validate(schema, 4)
    end

    test "should return error for gte" do
      schema = S.integer(gte: 4)

      assert {:error, %{gte: "Value must be greater than or equal to 4"}} =
               Shapex.validate(schema, 3)
    end

    test "should return error for lt" do
      schema = S.integer(lt: 4)
      assert {:error, %{lt: "Value must be less than 4"}} = Shapex.validate(schema, 4)
    end

    test "should return error for lte" do
      schema = S.integer(lte: 4)

      assert {:error, %{lte: "Value must be less than or equal to 4"}} =
               Shapex.validate(schema, 5)
    end

    test "should return error for eq" do
      schema = S.integer(eq: 4)
      assert {:error, %{eq: "Value must be equal to 4"}} = Shapex.validate(schema, 5)
    end

    test "should return error for neq" do
      schema = S.integer(neq: 4)
      assert {:error, %{neq: "Value must not be equal to 4"}} = Shapex.validate(schema, 4)
    end

    test "should return error for in" do
      schema = S.integer(in: [1, 2, 3])
      assert {:error, %{in: "Value must be one of [1, 2, 3]"}} = Shapex.validate(schema, 4)
    end

    test "should return error for not_in" do
      schema = S.integer(not_in: [1, 2, 3])

      assert {:error, %{not_in: "Value must not be one of [1, 2, 3]"}} =
               Shapex.validate(schema, 2)
    end

    test "should return error for custom" do
      schema =
        S.integer(
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
end
