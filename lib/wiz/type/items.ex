defmodule Wiz.Type.Items do

  @scalars [
    :atom,
    :binary,
    :boolean,
    :pid,
    # integers
    :pos_integer,
    :non_neg_integer,
    :integer,
    # floats
    :pos_float,
    :non_neg_float,
    :float,
    # numbers
    :pos_number,
    :non_neg_number,
    :number
  ]

  @list :list

  @scalars
  |> Enum.each(fn(type) ->
    defmacro unquote(type)() do
      unquote(type)
    end
  end)

  @doc """
  Represents empty list
  """
  defmacro list do
    @list
  end

  @doc """
  Represents uniform list

  ## Examples

  ```
  iex> alias Wiz.Type.Items, as: Type
  Wiz.Type.Items
  iex> Type.list(Type.integer)
  {:list, :integer}
  iex> Type.list(Type.list(Type.integer))
  {:list, {:list, :integer}}
  ```
  """
  def list(subtype) do
    :ok = check_list_subtype(subtype)
    {@list, subtype}
  end

  #
  # priv
  #

  defp check_list_subtype(subtype) when (subtype in @scalars), do: :ok
  defp check_list_subtype({@list, subtype}), do: check_list_subtype(subtype)
  defp check_list_subtype(subtype), do: raise("invalid list subtype #{inspect subtype}")

end
