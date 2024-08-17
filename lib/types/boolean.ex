defmodule Shapex.Types.Boolean do
  @behaviour Shapex.Type

  @type boolean_or_tuple :: boolean() | {boolean(), String.t()}

  @type t :: %__MODULE__{
          eq: boolean_or_tuple()
        }

  defstruct [:eq]

  @impl Shapex.Type
  def validate(%__MODULE__{} = schema, value) when is_boolean(value) do
    case schema.eq do
      {expected_value, message} when value != expected_value ->
        {:error, %{eq: message}}

      expected_value when value != expected_value ->
        {:error, %{eq: "Value must be #{schema.eq}, got #{value}"}}

      _ ->
        {:ok, :valid}
    end
  end

  @impl Shapex.Type
  def validate(_, _), do: {:error, %{type: "Value must be a boolean"}}
end
