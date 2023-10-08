defmodule Utils do
  @doc """
  Returns a list with the result of applying the given function to each element, where the function returns {:ok, new_element}.

  If for any element the function return does not match {:ok, new_element}, the function stops and returns this last value.
  """
  @spec try_map(Enumerable.t(), (any() -> {:ok, any()} | any())) :: {:ok, list()} | any()
  def try_map(enumerable, function) do
    Enum.reduce_while(enumerable, {:ok, []}, fn element, {:ok, acc} ->
      case function.(element) do
        {:ok, new_element} -> {:cont, {:ok, [new_element | acc]}}
        error -> {:halt, error}
      end
    end)
    |> case do
      {:ok, result} -> {:ok, Enum.reverse(result)}
      error -> error
    end
  end
end
