defmodule Shapex do
  @moduledoc """
  Shapex is a tool to help you validate your maps.

  You'll need to define a schema for a map and then you can use Shapex to validate it.

  ## Built-in types

  There are some built-in types that you can use to define your schema:
    - atom
    - boolean
    - enum
    - float
    - integer
    - list
    - map
    - record
    - string
    - dict

  ## Schema DSL

  This DSL is used to simplify the creation of the contract that will be used for data validation.

  ### Key differences

  The differences between schema DSL and default function composition style are:

  ```
  1 -> integer(eq: 1)
  1.0 -> float(eq: 1.0)
  true -> boolean(true)
  :atom -> atom(eq: :atom)
  "string" -> string(eq: "string")
  [1, 2, 3] -> enum([integer(eq: 1), integer(eq: 2), integer(eq: 3)])
  %{name: "John Doe"} -> map(key: string(eq: "John Doe"))
  ```

  The schema DSL is more readable and easier to understand. This is difference for the big schema:

  #### Function composition
  ```
  alias Shapex.Types, as: S

  animal_schema = S.enum([
    S.map(%{
      name: S.string(),
      family: S.atom(eq: :dog),
      breed: S.enum([S.string(eq: "Akita"), S.string(eq: "Husky"), S.string(eq: "Poodle")])
    }),
    S.map(%{
      name: S.string(),
      family: S.atom(eq: :cat),
      breed: S.enum([S.string(eq: "Siamese"), S.string(eq: "Persian"), S.string(eq: "Maine Coon")])
    }),
    S.map(%{
      name: S.string(),
      family: S.atom(eq: :owl),
      genus: S.enum([S.string(eq: "Athene"), S.string(eq: "Bubo"), S.string(eq: "Strix")])
    })
  ])

  ```

  #### Schema DSL

  ```

  require Shapex

  animal_schema = Shapex.schema([
    %{
      name: string(),
      family: :dog,
      breed: ["Akita", "Husky", "Poodle"]
    },
    %{
      name: string(),
      family: :cat,
      breed: ["Siamese", "Persian", "Maine Coon"]
    },
    %{
      name: string(),
      family: :owl,
      genus: ["Athene", "Bubo", "Strix"]
    },
  ])
  ```
  """

  @doc """
    Validate data depending on the schema

    Examples:

      iex> some_schema = Shapex.Types.string()
      iex> Shapex.validate(some_schema, "string")
      :ok
  """
  @spec validate(Shapex.Type.t(), term()) :: :ok | {:error, term()}
  def validate(schema, value) do
    schema.__struct__.validate(schema, value)
  end

  @doc """
    Macro to create a schema using a DSL.
  """
  defmacro schema(expression) do
    Shapex.Services.SchemaBuilder.call(expression)
  end
end
