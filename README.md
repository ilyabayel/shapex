# Shapex

Shapex is a small library to define contracts for a maps and validate them easily.
Key features:
- Validate BEAM specific data types like `atom`
- Define custom data types easily with Shapex.Type behaviour. Documentation coming soon.

## Future plans

- [ ] Add macro to make defining schema easier
- [ ] Add more built-in types
  - [ ] Date
  - [ ] Time
  - [ ] DateTime
- [ ] Add fast mode, wich will validate until first error and return it

## Example

```elixir
defmodule UserValidator do
  alias Shapex.Types, as: S
  # or import Shapex.Types
  @user_schema S.map(%{
                 name: S.string(min_length: 3),
                 age: S.integer(gte: {18, "Should be adult"}),
                 email: S.string(regex: ~r/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/),
                 address:
                   S.map(%{
                     street: S.string(),
                     city: S.string(),
                     zip: S.string(min_length: 5)
                   }),
                 role: S.atom(eq: :admin)
               })

  def validate_user(user_params) do
    case Shapex.validate(@user_schema, user_params) do
      {:ok, :valid} -> insert_user(user)
      {:error, errors} ->
        Log.error("Validation failed", %{errors: errors})
        {:error, errors}
    end
  end
end

user = %{
  name: "John Doe",
  age: 17,
  email: "john@google.com",
  address: %{
    street: "123 Main St",
    city: "New York",
    zip: "000504"
  },
  role: :member
}

UserValidator.validate_user(user)

# {:error, %{age: %{gte: "Should be adult"}, role: %{eq: "Should be :admin"}}
```

## Schema DSL

This DSL is used to simplify the creation of the contract that will be used for data validation.
Here is an example of how it simplifies code.

**Function composition:**
```elixir
alias Shapex.Types, as: S

animal_schema = S.enum([
  S.map(%{
    name: S.string(min_length: 2),
    family: S.atom(eq: :dog),
    breed: S.enum([S.string(eq: "Akita"), S.string(eq: "Husky"), S.string(eq: "Poodle")])
  }),
  S.map(%{
    name: S.string(min_length: 2),
    family: S.atom(eq: :cat),
    breed: S.enum([S.string(eq: "Siamese"), S.string(eq: "Persian"), S.string(eq: "Maine Coon")])
  }),
  S.map(%{
    name: S.string(min_length: 2),
    family: S.atom(eq: :owl),
    genus: S.enum([S.string(eq: "Athene"), S.string(eq: "Bubo"), S.string(eq: "Strix")])
  })
])
```

**Schema DSL:**

```elixir
require Shapex

animal_schema = Shapex.schema([
  %{
    name: string(min_length: 2),
    family: :dog,
    breed: ["Akita", "Husky", "Poodle"]
  },
  %{
    name: string(min_length: 2),
    family: :cat,
    breed: ["Siamese", "Persian", "Maine Coon"]
  },
  %{
    name: string(min_length: 2),
    family: :owl,
    genus: ["Athene", "Bubo", "Strix"]
  },
])
```

As you can see you can use built-in function without any import, since they are supported by the DSL. They copy API of `Shapex.Types` module functions.

### DSL Cheatsheet

The differences between schema DSL and default function composition style are:

| Type | DSL expression | Function Composition |
|---|---|---|
| Integer | `1` | `integer(eq: 1)` |
| Float | `1.0` | `float(eq: 1.0)` |
| Boolean | `true` | `boolean(true)` |
| Atom | `:atom` | `atom(eq: :atom)` |
| String | `"name"` | `string(eq: "name")` |
| Enum | `[1, 2, 3]` | `enum([integer(eq: 1), integer(eq: 2), integer(eq: 3)])` |
| Map | `%{name: "John Doe"}` | `map(key: string(eq: "John Doe"))` |


## What is not planned

- Generic Tuple type, since it's not very clear how to validate them the best, so if you need to validate a tuple, please create custom type for it.
