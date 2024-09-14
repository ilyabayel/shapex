defmodule Shapex.Types.DictTest do
  use ExUnit.Case, async: true

  alias Shapex.Types, as: S

  describe "validate/2" do
    test "should return success on valid data" do
      schema = S.dict(S.string(), S.integer())

      data = %{
        "1" => 1,
        "2" => 2,
        "3" => 3
      }

      assert :ok = Shapex.validate(schema, data)
    end

    test "should return error on valid data" do
      schema = S.dict(S.integer(), S.integer())

      data = %{
        "1" => 1,
        2 => "2",
        3 => 3
      }

      assert {:error,
              %{
                "1" => %{value: :valid, key: %{type: "Value must be an integer"}},
                2 => %{value: %{type: "Value must be an integer"}, key: :valid}
              }} = Shapex.validate(schema, data)
    end
  end
end
