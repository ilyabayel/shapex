defmodule Shapex.AdvancedTypesTest do
  use ExUnit.Case, async: true

  import Shapex.Types

  describe "validate/2" do
    @xero_line_item_mapping map(%{
                              line_item_identifier: string(),
                              account_slug: string()
                            })

    @xero_matching_invoice_configuration map(%{
                                           line_item_mapping: list(@xero_line_item_mapping)
                                         })

    # @xero_department_configuration map(%{
    #                                  string() => %{
    #                                    department_slug: string(),
    #                                    line_item_mapping: @xero_line_item_mapping
    #                                  }
    #                                })

    @xero_matching_invoice_account_mapping map(%{
                                             type: string(eq: "matching_invoice"),
                                             configuration: @xero_matching_invoice_configuration
                                           })

    test "should return success if xero matching invoice account mapping valid" do
      assert Shapex.validate(@xero_matching_invoice_account_mapping, %{
               type: "matching_invoice",
               configuration: %{
                 line_item_mapping: [
                   %{
                     line_item_identifier: "line_item_identifier",
                     account_slug: "account_slug"
                   }
                 ]
               }
             }) == {:ok, :valid}
    end

    test "should return error if xero matching invoice account mapping invalid" do
      assert Shapex.validate(@xero_matching_invoice_account_mapping, %{
               type: 123,
               configuration: %{
                 line_item_mapping: [
                   %{
                     account_slug: 23
                   }
                 ]
               }
             }) == {
               :error,
               %{
                 configuration: %{
                   line_item_mapping: %{
                     0 => %{
                       line_item_identifier: %{required: "Key line_item_identifier is required"},
                       account_slug: %{type: "Value must be a string"}
                     }
                   }
                 },
                 type: %{type: "Value must be a string"}
               }
             }
    end

    test "should validate xero department account mapping" do
    end
  end
end
