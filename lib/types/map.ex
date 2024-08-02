defmodule Shapex.Types.Map do
  @behaviour Shapex.Type

  @type key :: String.t() | atom() | {:optional, String.t()} | {:optional, atom()}

  @type t :: %__MODULE__{
          fields: %{
            key() => Shapex.Type.t()
          }
        }

  @enforce_keys [:fields]
  defstruct [:fields]

  @spec validate(__MODULE__.t(), map()) :: {:ok, :valid} | {:error, term()}
  def validate(schema, value) do
    keys = Map.keys(schema.fields)

    errors =
      Enum.reduce(
        keys,
        %{},
        fn
          {:optional, key}, errors ->
            if Map.has_key?(value, key) do
              case Shapex.validate(schema.fields[key], Map.get(value, key)) do
                {:ok, :valid} -> errors
                {:error, field_errors} -> Map.put(errors, key, field_errors)
              end
            else
              errors
            end

          key, errors ->
            if not Map.has_key?(value, key) do
              Map.put(errors, key, %{required: "Key #{key} is required"})
            else
              case Shapex.validate(schema.fields[key], Map.get(value, key)) do
                {:ok, :valid} ->
                  errors

                {:error, field_errors} ->
                  Map.merge(errors, %{key => field_errors})
              end
            end
        end
      )

    if errors == %{} do
      {:ok, :valid}
    else
      {:error, errors}
    end
  end
end
