defmodule Shapex.Type do
  @moduledoc """
    A behaviour for defining custom types.

    Example:

    ```elixir
    defmodule Email do
      @behaviour Shapex.Type

      @type t :: %__MODULE__{
              allowed_domains: [String.t()]
            }

      defstruct [:allowed_domains]

      def validate(schema, value) do
        results = case String.split(value, "@") do
          [_, domain] when domain in schema.allowed_domains -> {:ok, :valid}
          _ -> {:error, %{type: "Invalid email"}}
        end

        if results == %{} do
          {:ok, :valid}
        else
          {:error, results}
        end
      end
    end

    Shapex.validate(%Email{allowed_domains: ["example.com"]}, "ilya@example.com")

    {:ok, :valid}
    ```
  """

  @type t :: struct()

  @callback validate(schema :: t(), value :: term()) :: {:ok, :valid} | {:error, term()}
end
