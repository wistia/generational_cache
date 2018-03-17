# GenerationalCache

dead simple generational cache
 
## Installation

```elixir
def deps do
  [{:generational_cache, github: "wistia/generational_cache"}]
end
```

## Usage

```elixir
# Keep the two latest generations
cache = GenerationalCache.new(2)

# Add a new generation
# Generations are expected to be maps
cache = GenerationalCache.add_generation(cache, %{a: 1, b: 2})

# The freshest generation always wins
# Generations are essentially layered on top of each other then flattened
cache = GenerationalCache.add_generation(cache, %{b: 3})
GenerationalCache.entries(cache)
#=> %{a: 1, b: 3}

# Older generations are dropped
cache = GenerationalCache.add_generation(cache, %{c: 4})
GenerationalCache.entries(cache)
#=> %{b: 3, c: 4}
```
