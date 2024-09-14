defmodule Shapex.Types do
  @moduledoc """
  Module that contains helper functions to define schema.
  """

  alias Shapex.Types.Integer
  alias Shapex.Types.Float
  alias Shapex.Types.String
  alias Shapex.Types.Map
  alias Shapex.Types.List
  alias Shapex.Types.Enum
  alias Shapex.Types.Dict
  alias Shapex.Types.Atom
  alias Shapex.Types.Boolean
  alias Shapex.Types.Any
  alias Shapex.Types.Number

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

  @doc """
    Float type for Shapex.
    Validation rules:
      - :gt - greater than
      - :gte - greater than or equal
      - :lt - less than
      - :lte - less than or equal
      - :eq - equal
      - :neq - not equal
      - :in - in list
      - :not_in - not in list
  """
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
        name: string(),
        age: integer()
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
        optional(:age) => integer()
      })
  """
  def optional(key) do
    {:optional, key}
  end

  @doc """
    List type for Shapex.

    ## Example

      list(integer())
  """
  def list(item) do
    %List{
      item: item
    }
  end

  @doc """
    Enum type for Shapex.

    ## Example

      enum([integer(), string()])
  """
  def enum(items) do
    %Enum{
      items: items
    }
  end

  @doc """
    Record type for Shapex. It's like a map, but fields are not pre-defined, useful for dictionaries.

    ## Example

      schema = dict(string(), string())

      value = %{
        "id1" => "value1",
        "id2" => "value2"
        "id3" => "value3"
      }

      Shapex.validate(schema, value)

      # :ok
  """
  def dict(key_type, value_type) do
    %Dict{
      key_type: key_type,
      value_type: value_type
    }
  end

  @doc """
    Atom type for Shapex.

    Validations:
      - :eq - equality check
      - :neq - not equal check

    ## Example

      atom(eq: :ok)
  """
  def atom(validations) do
    %Atom{
      validations: validations
    }
  end

  @doc """
    Boolean type for Shapex.

    ## Example

      boolean(true)
  """
  def boolean(expected_value \\ nil) do
    %Boolean{
      eq: expected_value
    }
  end

  @doc """
    Any type for Shapex.

    ## Example

      any()
  """
  def any() do
    %Any{}
  end

  @doc """
  Number type for Shapex.
  """
  def number(validations) do
    %Number{validations: validations}
  end
end
