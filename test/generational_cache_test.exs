defmodule GenerationalCacheTest do
  use ExUnit.Case
  doctest GenerationalCache

  test "empty cache has no entries" do
    cache = GenerationalCache.new(3)
    assert %{} == GenerationalCache.entries(cache)
  end

  test "returns all entries" do
    cache = GenerationalCache.new(3)
    cache = GenerationalCache.add_generation(cache, %{a: 3})
    cache = GenerationalCache.add_generation(cache, %{b: 4})
    assert %{a: 3, b: 4} == GenerationalCache.entries(cache)
  end

  test "last write wins" do
    cache = GenerationalCache.new(3)
    cache = GenerationalCache.add_generation(cache, %{a: 3})
    cache = GenerationalCache.add_generation(cache, %{a: 4})
    assert %{a: 4} == GenerationalCache.entries(cache)
  end

  test "partial overlaps" do
    cache = GenerationalCache.new(3)
    cache = GenerationalCache.add_generation(cache, %{a: 3, b: 4})
    cache = GenerationalCache.add_generation(cache, %{b: 5, c: 6})
    assert %{a: 3, b: 5, c: 6} == GenerationalCache.entries(cache)
  end

  test "old generations are purged" do
    cache = GenerationalCache.new(2)
    cache = GenerationalCache.add_generation(cache, %{a: 3})
    cache = GenerationalCache.add_generation(cache, %{b: 4})
    cache = GenerationalCache.add_generation(cache, %{c: 5})
    assert %{b: 4, c: 5} == GenerationalCache.entries(cache)
  end
end
