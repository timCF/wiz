defmodule Wiz.Type do
  require Wiz.Type.Items, as: Type
  require Uelli

  @doc """
  Infers type from AST

  ## Examples

  ```
  iex> alias Wiz.Type
  Wiz.Type
  iex> Type.infer(10)
  :pos_integer
  iex> Type.infer([])
  :list
  iex> Type.infer([1, 2, 3])
  {:list, :pos_integer}
  iex> Type.infer([[0.2], [], [0.3, 0.5]])
  {:list, {:list, :pos_float}}
  ```
  """

  # primitives
  def infer(ast) when is_atom(ast), do: Type.atom
  def infer(ast) when is_binary(ast), do: Type.binary
  def infer(ast) when is_boolean(ast), do: Type.boolean
  def infer(ast) when is_pid(ast), do: Type.pid
  # integers
  def infer(ast) when Uelli.pos_integer(ast), do: Type.pos_integer
  def infer(ast) when Uelli.non_neg_integer(ast), do: Type.non_neg_integer
  def infer(ast) when is_integer(ast), do: Type.integer
  # floats
  def infer(ast) when Uelli.pos_float(ast), do: Type.pos_float
  def infer(ast) when Uelli.non_neg_float(ast), do: Type.non_neg_float
  def infer(ast) when is_float(ast), do: Type.float
  # lists
  def infer([]), do: Type.list
  def infer(ast = [_ | _]) do
    ast
    |> Enum.reduce(Type.list, fn(element, acc) ->
      element
      |> infer
      |> case do
        ^acc ->
          acc
        Type.list ->
          acc
        subtype when (acc == Type.list) ->
          subtype
        subtype ->
          #
          # TODO : infer type intersection
          #
          raise("got new subtype #{inspect subtype}, but actual type was #{inspect acc}")
      end
    end)
    |> Type.list
  end

end
