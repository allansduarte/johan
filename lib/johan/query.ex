defmodule Johan.Query do
  @moduledoc """
  Global schema querying facility.

  This is meant to ease on the usage of Ecto queries all around.

  It also can be used in order to inject functions as `query/2`, `one/2`,
  `all/2` and `exists?/2` that will provide default query functions to be used
  on database and also includes an overridable function `custom_filter/2` that
  should be used to create custom filters used on queries that does not have a
  valid key on schema (as embedded schemas for filters).
  """

  import Ecto.Query

  alias Johan.Repo

  @behaviour Johan.Queries.Behaviour

  @reserved_keys [
    :limit,
    :sort,
    :distinct,
    :group_by,
    :preload,
    :select,
    :count,
    :lock_for_update
  ]

  defmacro __using__(opts) do
    quote do
      import Ecto.Query

      alias Johan.Query

      @behaviour Johan.Queries.Behaviour

      @repo unquote(opts[:repo]) || Johan.Repo

      @impl true
      def query(queryable \\ __MODULE__, filters) when is_list(filters) or is_map(filters) do
        queryable = Query.query(queryable, filters)

        Enum.reduce(filters, queryable, fn
          {key, nil}, query -> query
          filter, query -> custom_filter(query, filter)
        end)
      end

      @impl true
      def all(queryable \\ __MODULE__, filters) when is_list(filters) or is_map(filters) do
        queryable
        |> query(filters)
        |> @repo.all()
      end

      @impl true
      def one(queryable \\ __MODULE__, filters) when is_list(filters) or is_map(filters) do
        queryable
        |> query(filters)
        |> @repo.one()
      end

      @impl true
      def fetch(queryable \\ __MODULE__, filters) do
        case all(queryable, filters) do
          [] -> {:error, :not_found}
          [result] -> {:ok, result}
          _ -> {:error, :too_many_results}
        end
      end

      @impl true
      def exists?(queryable \\ __MODULE__, filters) when is_list(filters) or is_map(filters) do
        queryable
        |> query(filters)
        |> @repo.exists?()
      end

      defp custom_filter(queryable, {_key, nil}), do: queryable
      defp custom_filter(queryable, {_key, {_, nil}}), do: queryable
      defp custom_filter(queryable, _filter), do: queryable

      defoverridable custom_filter: 2
    end
  end

  defguardp is_relative_datetime(value)
            when is_tuple(value) and
                   elem(value, 0) in [
                     :minutes_ago,
                     :hours_ago,
                     :days_ago,
                     :minutes_after,
                     :hours_after,
                     :days_ago
                   ]

  defguardp is_relative_date(value) when value in [:today, :yesterday, :tomorrow]

  @impl true
  def all(queryable, repo \\ Repo, filters) do
    queryable
    |> query(filters)
    |> repo.all()
  end

  @impl true
  def one(queryable, repo \\ Repo, filters) do
    queryable
    |> query(filters)
    |> repo.one()
  end

  @impl true
  def fetch(queryable, repo \\ Repo, filters) do
    case all(queryable, repo, filters) do
      [] -> {:error, :not_found}
      [result] -> {:ok, result}
      _ -> {:error, :too_many_results}
    end
  end

  @impl true
  def exists?(queryable, repo \\ Repo, filters) do
    queryable
    |> query(filters)
    |> repo.exists?()
  end

  @impl true
  def query(queryable, filters) when is_map(filters) or is_list(filters) do
    Enum.reduce(filters, queryable, &maybe_apply_filter/2)
  end

  # Default filter applicable only for schema fields
  # All custom fields should be declared on `custom_filter/2`
  defp maybe_apply_filter({key, value}, %{from: %{source: {_table, schema}}} = query) do
    if key in schema.__schema__(:fields) or key in @reserved_keys do
      apply_filter({key, value}, query)
    else
      query
    end
  end

  defp maybe_apply_filter({key, value}, query) do
    if key in query.__schema__(:fields) or key in @reserved_keys do
      apply_filter({key, value}, query)
    else
      query
    end
  end

  # Transform module schema into a query
  defp apply_filter(filter, schema) when is_atom(schema),
    do: apply_filter(filter, from(c in schema))

  # Fields to ignore
  defp apply_filter({_field, nil}, query), do: query
  defp apply_filter({_field, {_clause, nil}}, query), do: query
  defp apply_filter({:__struct__, _value}, query), do: query

  defp apply_filter({key, {:>, value}}, query) when is_relative_datetime(value),
    do: where(query, [c], field(c, ^key) > ^relative_datetime(value))

  defp apply_filter({key, {:>=, value}}, query) when is_relative_datetime(value),
    do: where(query, [c], field(c, ^key) >= ^relative_datetime(value))

  defp apply_filter({key, {:<, value}}, query) when is_relative_datetime(value),
    do: where(query, [c], field(c, ^key) < ^relative_datetime(value))

  defp apply_filter({key, {:<=, value}}, query) when is_relative_datetime(value),
    do: where(query, [c], field(c, ^key) <= ^relative_datetime(value))

  defp apply_filter({key, {:==, value}}, query) when is_relative_date(value),
    do: where(query, [c], type(field(c, ^key), :date) == ^relative_date(value))

  defp apply_filter({key, {:!=, value}}, query) when is_relative_date(value),
    do: where(query, [c], type(field(c, ^key), :date) != ^relative_date(value))

  defp apply_filter({key, {:>, value}}, query) when is_relative_date(value),
    do: where(query, [c], type(field(c, ^key), :date) > ^relative_date(value))

  defp apply_filter({key, {:>=, value}}, query) when is_relative_date(value),
    do: where(query, [c], type(field(c, ^key), :date) >= ^relative_date(value))

  defp apply_filter({key, {:<, value}}, query) when is_relative_date(value),
    do: where(query, [c], type(field(c, ^key), :date) < ^relative_date(value))

  defp apply_filter({key, {:<=, value}}, query) when is_relative_date(value),
    do: where(query, [c], type(field(c, ^key), :date) <= ^relative_date(value))

  defp apply_filter({key, {:==, value}}, query),
    do: where(query, [c], field(c, ^key) == ^value)

  defp apply_filter({key, {:!=, value}}, query),
    do: where(query, [c], field(c, ^key) != ^value)

  defp apply_filter({key, {:>, value}}, query),
    do: where(query, [c], field(c, ^key) > ^value)

  defp apply_filter({key, {:>=, value}}, query),
    do: where(query, [c], field(c, ^key) >= ^value)

  defp apply_filter({key, {:<, value}}, query),
    do: where(query, [c], field(c, ^key) < ^value)

  defp apply_filter({key, {:<=, value}}, query),
    do: where(query, [c], field(c, ^key) <= ^value)

  defp apply_filter({key, {:in, value}}, query),
    do: where(query, [c], field(c, ^key) in ^value)

  defp apply_filter({key, {:not_in, value}}, query),
    do: where(query, [c], field(c, ^key) not in ^value)

  defp apply_filter({key, {:is_in_list, value}}, query),
    do: where(query, [c], ^value in field(c, ^key))

  defp apply_filter({key, {:is_not_in_list, value}}, query) do
    where(query, [c], is_nil(field(c, ^key)) or ^value not in field(c, ^key))
  end

  defp apply_filter({key, :is_null}, query),
    do: where(query, [c], is_nil(field(c, ^key)))

  defp apply_filter({key, :is_not_null}, query),
    do: where(query, [c], not is_nil(field(c, ^key)))

  defp apply_filter({key, {:lower, value}}, query) do
    value = String.downcase(value)
    where(query, [c], fragment("lower(?)", field(c, ^key)) == ^value)
  end

  defp apply_filter({key, {:like, value}}, query) do
    sanitized_value = "%#{sanitize_like(value)}%"
    where(query, [c], like(field(c, ^key), ^sanitized_value))
  end

  defp apply_filter({key, {:ilike, value}}, query) do
    sanitized_value = "%#{sanitize_like(value)}%"
    where(query, [c], ilike(field(c, ^key), ^sanitized_value))
  end

  defp apply_filter({key, {:unsanitized_like, value}}, query),
    do: where(query, [c], like(field(c, ^key), ^value))

  defp apply_filter({key, {:unsanitized_ilike, value}}, query),
    do: where(query, [c], ilike(field(c, ^key), ^value))

  defp apply_filter({key, {:object_field, [{object_field, value}]}}, query),
    do: where(query, [c], fragment("?->>? = ?", field(c, ^key), ^to_string(object_field), ^value))

  defp apply_filter({key, {:contains, value}}, query),
    do: where(query, [c], fragment("? @> ?", field(c, ^key), ^value))

  defp apply_filter({key, {:contained_by, value}}, query),
    do: where(query, [c], fragment("? <@ ?", field(c, ^key), ^value))

  defp apply_filter({:limit, number}, query),
    do: limit(query, ^number)

  defp apply_filter({:sort, [field | _] = sort_fields}, query) when is_binary(field) do
    sort =
      sort_fields
      |> Enum.chunk_every(2)
      |> Enum.map(fn [field, order] ->
        {String.to_existing_atom(order), String.to_existing_atom(field)}
      end)

    order_by(query, ^sort)
  end

  defp apply_filter({:sort, sort_fields}, query),
    do: order_by(query, ^sort_fields)

  defp apply_filter({:distinct, fields}, query),
    do: distinct(query, ^fields)

  defp apply_filter({:group_by, fields}, query),
    do: group_by(query, ^fields)

  defp apply_filter({:preload, assocs}, query),
    do: preload(query, ^assocs)

  defp apply_filter({:select, :all}, query), do: query

  defp apply_filter({:select, fields}, query),
    do: select(query, ^fields)

  defp apply_filter({:lock_for_update, true}, query),
    do: lock(query, "FOR UPDATE")

  defp apply_filter({:count, key}, query),
    do: select(query, [c], count(field(c, ^key)))

  defp apply_filter({key, value}, query),
    do: where(query, [c], field(c, ^key) == ^value)

  defp relative_date(:today), do: Date.utc_today()
  defp relative_date(:tomorrow), do: Date.utc_today() |> Date.add(1)
  defp relative_date(:yesterday), do: Date.utc_today() |> Date.add(-1)

  defp relative_datetime({:seconds_after, amount}),
    do: NaiveDateTime.utc_now() |> NaiveDateTime.add(amount)

  defp relative_datetime({:minutes_after, amount}),
    do: relative_datetime({:seconds_after, 60 * amount})

  defp relative_datetime({:hours_after, amount}),
    do: relative_datetime({:minutes_after, 60 * amount})

  defp relative_datetime({:days_after, amount}),
    do: relative_datetime({:hours_after, 24 * amount})

  defp relative_datetime({:seconds_ago, amount}), do: relative_datetime({:seconds_after, -amount})
  defp relative_datetime({:minutes_ago, amount}), do: relative_datetime({:minutes_after, -amount})
  defp relative_datetime({:hours_ago, amount}), do: relative_datetime({:hours_after, -amount})
  defp relative_datetime({:days_ago, amount}), do: relative_datetime({:days_after, -amount})

  # avoiding like injection as mentioned on Ecto docs
  # https://github.blog/2015-11-03-like-injection/
  defp sanitize_like(nil), do: nil

  defp sanitize_like(value) when is_binary(value) do
    Regex.replace(~r/([\\%_])/, value, ~S<\\\1>)
  end

  @doc """
  Converts a database result, usually coming from Ecto.Adapter.SQL.query!, into a stream of maps with atom keys
  """
  def beautify_result(%Postgrex.Result{columns: columns, rows: rows})
      when is_list(columns) and is_list(rows) do
    columns = Enum.map(columns, &String.to_atom/1)

    rows
    |> Stream.map(fn values ->
      columns
      |> Enum.zip(values)
      |> Map.new()
    end)
  end
end
