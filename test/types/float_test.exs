defmodule Shapex.Types.IntegerTest do
  use ExUnit.Case, async: true

  alias Shapex.Types, as: S

  describe "validate/2 integer" do
    test "should return :ok if valid" do
      schema = S.float(gt: 4.0, lt: 6.0)
      assert :ok = Shapex.validate(schema, 5.0)
    end

    test "should return error for gt" do
      schema = S.float(gt: 4.0)
      assert {:error, %{gt: "Value must be greater than 4.0"}} = Shapex.validate(schema, 4.0)
    end

    test "should return error for gte" do
      schema = S.float(gte: 4.0)

      assert {:error, %{gte: "Value must be greater than or equal to 4.0"}} =
               Shapex.validate(schema, 3.0)
    end

    test "should return error for lt" do
      schema = S.float(lt: 4.0)
      assert {:error, %{lt: "Value must be less than 4.0"}} = Shapex.validate(schema, 4.0)
    end

    test "should return error for lte" do
      schema = S.float(lte: 4.0)

      assert {:error, %{lte: "Value must be less than or equal to 4.0"}} =
               Shapex.validate(schema, 5.0)
    end

    test "should return error for eq" do
      schema = S.float(eq: 4.0)
      assert {:error, %{eq: "Value must be equal to 4.0"}} = Shapex.validate(schema, 5.0)
    end

    test "should return error for neq" do
      schema = S.float(neq: 4.0)
      assert {:error, %{neq: "Value must not be equal to 4.0"}} = Shapex.validate(schema, 4.0)
    end

    test "should return error for in" do
      schema = S.float(in: [1.0, 2.0, 3.0])

      assert {:error, %{in: "Value must be one of [1.0, 2.0, 3.0]"}} =
               Shapex.validate(schema, 4.0)
    end

    test "should return error for not_in" do
      schema = S.float(not_in: [1.0, 2.0, 3.0])

      assert {:error, %{not_in: "Value must not be one of [1.0, 2.0, 3.0]"}} =
               Shapex.validate(schema, 2.0)
    end
  end
end
