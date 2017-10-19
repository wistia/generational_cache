defmodule GenerationalCache do
  def new(max_generations), do: %{max_generations: max_generations, generations: []}

  def add_generation(cache = %{generations: generations, max_generations: max_generations}, new_gen) when length(generations) == max_generations do
    evict_generation(cache)
    |> add_generation(new_gen)
  end
  def add_generation(cache = %{generations: generations}, new_gen) do
    put_in(cache[:generations], generations ++ [new_gen])
  end

  def evict_generation(cache = %{generations: [_|rest]}) do
    put_in(cache[:generations], rest)
  end

  def entries(%{generations: generations}) do
    Enum.reduce(generations, %{}, fn gen, acc -> Map.merge(acc, gen) end)
  end

  def keys(cache), do: entries(cache) |> Map.keys

  def values(cache), do: entries(cache) |> Map.values

  def delete(cache = %{generations: generations}, k) do
    new_generations = Enum.map(generations, fn generation -> Map.delete(generation, k) end)
    put_in(cache[:generations], new_generations)
  end
end
