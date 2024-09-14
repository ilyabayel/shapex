defmodule Shapex.Types.Number do
  @moduledoc """
    This module provides a type for validating numbers.

    Existing validations:
    - :gt - greater than
    - :gte - greater than or equal to
    - :lt - less than
    - :lte - less than or equal to
    - :eq - equal
    - :neq - not equal
    - :in - checks if the value is in a list
    - :not_in - checks if the value is not in a list

    It's better to use the Shapex.Types.number/1 function to create a schema,
    since it covers implementation details and provides a more user-friendly API.
  """

  alias Shapex.Types.Float
  alias Shapex.Types.Integer

  @behaviour Shapex.Type

  @type target(a) :: a | {a, String.t()}

  @type validation_rules ::
          {:gt, target(number())}
          | {:gte, target(number())}
          | {:lt, target(number())}
          | {:lte, target(number())}
          | {:eq, target(number())}
          | {:neq, target(number())}
          | {:in, target(list(number()))}
          | {:not_in, target(list(number()))}

  @type t :: %__MODULE__{
          validations: [validation_rules()]
        }

  defstruct [:validations]

  @impl Shapex.Type
  def validate(%__MODULE__{} = schema, value) when is_integer(value) do
    Integer.validate(%Integer{validations: schema.validations}, value)
  end

  @impl Shapex.Type
  def validate(%__MODULE__{} = schema, value) when is_float(value) do
    Shapex.Types.Float.validate(%Float{validations: schema.validations}, value)
  end

  def validate(_, _), do: {:error, %{type: "Value must be a number"}}
end
