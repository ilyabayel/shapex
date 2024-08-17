defmodule Shapex.Types do
  alias Shapex.Types.Integer
  alias Shapex.Types.Float
  alias Shapex.Types.String
  alias Shapex.Types.Map
  alias Shapex.Types.List
  alias Shapex.Types.Enum
  alias Shapex.Types.Record
  alias Shapex.Types.Atom

  @doc """
    Integer type for Shapex.
    Validation rules:
      - :gt - greater than
      - :gte - greater than or equal
      - :lt - less than
      - :lte - less than or equal
      - :eq - equal
      - :neq - not equal
      - :in - in list
      - :not_in - not in list
      - :custom - custom validation function

    ## Example

      integer(
        gt: 10,
        gte: 10,
        lt: 20,
        lte: 20,
        eq: 15,
        neq: 10,
        in: [1, 2, 3],
        not_in: [4, 5, 6],
        custom: fn value ->
          if value > 10 do
            "Value must be less than 10"
          end
        end
      )
  """
  def integer(validations \\ []) do
    %Integer{
      validations: validations
    }
  end

  def float(validations \\ []) do
    %Float{
      validations: validations
    }
  end

  @doc """
  String type for Shapex.

  Validation rules:
    - :min_length - minimum length
    - :max_length - maximum length
    - :length - exact length
    - :in - in list
    - :not_in - not in list
    - :custom - custom validation function
  """
  def string(validations \\ []) do
    %String{
      validations: validations
    }
  end

  @doc """
    Map type for Shapex.
    Fields required by default, if you want make them optional use &optional/1

    ## Example

      map(%{
        :name => string(),
        optional(:age) => integer()
      })
  """
  def map(fields) do
    %Map{
      fields: fields
    }
  end

  @doc """
    Support function to make map field optional

    ## Example

      map(%{
        :name => string(),
        optional(:age) => integer()
      })
  """
  def optional(key) do
    {:optional, key}
  end

  def list(item) do
    %List{
      item: item
    }
  end

  def enum(items) do
    %Enum{
      items: items
    }
  end

  def record(key_type, value_type) do
    %Record{
      key_type: key_type,
      value_type: value_type
    }
  end

  def atom(validations) do
    %Atom{
      validations: validations
    }
  end
end
