defmodule Utils do
  @typep element :: any()
  @typep error :: any()

  @doc """
  Returns a list with the result of applying the given function to each element, where the function returns {:ok, new_element}.

  If for any element the function return does not match {:ok, new_element}, the function stops and returns this last value.
  """
  @spec try_map(Enumerable.t(), (element() -> {:ok, element()} | error())) ::
          {:ok, list()} | error()
  def try_map(enumerable, function) do
    Enum.reduce_while(enumerable, {:ok, []}, fn element, {:ok, tail} ->
      case function.(element) do
        {:ok, head} -> {:cont, {:ok, [head | tail]}}
        error -> {:halt, error}
      end
    end)
    |> case do
      {:ok, list} -> {:ok, Enum.reverse(list)}
      error -> error
    end
  end
end
