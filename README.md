# MsBenchmarkCache

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ms_benchmark_cache` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ms_benchmark_cache, "~> 0.1.0"}
  ]
end
```

Dynamodb
```
aws dynamodb delete-table --table-name cache --endpoint-url http://localhost:8000


aws dynamodb create-table \
    --table-name cache \
    --attribute-definitions \
        AttributeName=key,AttributeType=S \
    --key-schema \
        AttributeName=key,KeyType=HASH \
--provisioned-throughput \
        ReadCapacityUnits=10,WriteCapacityUnits=10 \
        --endpoint-url http://localhost:8000

aws dynamodb update-time-to-live --table-name cache --time-to-live-specification "Enabled=true, AttributeName=expiration" --endpoint-url http://localhost:8000



aws dynamodb list-tables --endpoint-url http://localhost:8000

aws dynamodb describe-table --table-name cache --endpoint-url http://localhost:8000



EXP=`date -d '+120 seconds' +%s`
aws dynamodb put-item \
    --table-name "cache" \
    --item \
    '{"key": {"S": "1"}, "expiration": {"N": "'$EXP'"}, "Value": {"S": "Hello"}}' \
    --endpoint-url http://localhost:8000


aws dynamodb get-item --consistent-read \
    --table-name cache \
    --key '{ "key": {"S": "1"}}' \
    --endpoint-url http://localhost:8000
```


Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ms_benchmark_cache](https://hexdocs.pm/ms_benchmark_cache).

