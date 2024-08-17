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
        {:error, "Something went wrong"}
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

# {:error, %{age: %{gte: "Should be adult"}, role: %{eq: "Should be :admin"}
```

## What is not planned

- Generic Tuple type, since it's not very clear how to validate them the best, so if you need to validate a tuple, please create custom type for it.
