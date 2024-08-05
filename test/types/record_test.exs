defmodule Shapex.Types.RecordTest do
  use ExUnit.Case, async: true

  alias Shapex.Types, as: S

  describe "validate/2" do
    test "should return success on valid data" do
      schema = S.record(S.string(), S.integer())

      data = %{
        "1" => 1,
        "2" => 2,
        "3" => 3
      }

      assert {:ok, :valid} = Shapex.validate(schema, data)
    end

    test "should return error on valid data" do
      schema = S.record(S.integer(), S.integer())

      data = %{
        "1" => 1,
        2 => "2",
        3 => 3
      }

      assert {:ok, :valid} = Shapex.validate(schema, data)
    end
  end
end
