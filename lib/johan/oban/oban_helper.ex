defmodule Johan.ObanHelper do
  @moduledoc """
  Helper to deal with Oban functions and queries.
  """

  require Logger

  @tag_separator " => "

  @doc "Inserts a new `Oban.Job` with the given worker and params"
  @spec insert_job(
          job :: atom(),
          params :: map(),
          opts :: keyword()
        ) :: {:ok, Job.t()} | {:error, Ecto.Changeset.t()}
  def insert_job(job, params, opts \\ [])
      when is_atom(job) and is_map(params) and is_list(opts) do
    # Parsing default tags
    opts = Keyword.put(opts, :tags, parse_tags_from_opts(opts))

    # Enqueuing the new job
    params
    |> job.new(opts)
    |> Oban.insert()
    |> case do
      {:ok, _job} = response ->
        Logger.info("Job #{inspect(job)} enqueued with success")
        response

      {:error, _error} = response ->
        Logger.error("Job #{inspect(job)} enqueue failed")
        response
    end
  end

  defp parse_tags_from_opts(opts) do
    request_id = Logger.metadata()[:request_id] || Ecto.UUID.generate()

    opts
    |> Keyword.get(:tags, [])
    |> Enum.flat_map(fn
      {key, tag} ->
        [{Atom.to_string(key), tag}]

      tag when is_binary(tag) ->
        case String.split(tag, @tag_separator) do
          [key, value] -> [{key, value}]
          _ -> []
        end
    end)
    |> Map.new()
    |> Map.put_new("request_id", request_id)
    |> Enum.map(fn {key, value} -> String.slice("#{key}#{@tag_separator}#{value}", 0, 255) end)
  end
end
