defmodule Johan.Alerts.Commands.CreateAlert do
  @moduledoc """
  Create an alert.

  It formats and creates alert content.
  """

  require Logger

  alias Johan.Alerts.Inputs.{
    Alert,
    AlertContent
  }

  alias Johan.ChangesetValidation

  alias Johan.Alerts.Schemas.{
    Alerts,
    Devices
  }

  alias Johan.Repo

  @type possible_errors :: Ecto.Changeset.t() | :invalid_format | :device_not_found

  @spec execute(input :: Alert.t()) :: {:ok, Alerts.t()} | {:error, possible_errors()}
  def execute(%Alert{} = input) do
    Repo.transaction(fn ->
      with {:ok, content} <- format_content(input),
           {:ok, alert_content} <- validate_content(content),
           {:ok, device} <- find_device(input.sim_sid),
           {:ok, alert} <- register_alert(device.patients_id, alert_content, input) do
        alert
      else
        err ->
          Logger.error("""
          Unexpected error processing Alert
          Input: #{inspect(input)}
          error: #{inspect(err)}
          """)

          Repo.rollback(err)
      end
    end)
    |> case do
      {:ok, alert} -> {:ok, alert}
      {:error, err} -> err
    end
  end

  defp find_device(sim_sid) do
    case Repo.get_by(Devices, sim_sid: sim_sid) do
      nil ->
        {:error, :device_not_found}

      device ->
        {:ok, device}
    end
  end

  defp register_alert(patients_id, alert_content, input) do
    payload = Map.from_struct(input)

    attrs =
      alert_content
      |> Map.from_struct()
      |> Map.put(:patients_id, patients_id)
      |> Map.put(:metadata, payload)

    %Alerts{}
    |> Alerts.changeset(attrs)
    |> Repo.insert()
  end

  defp validate_content(content), do: ChangesetValidation.cast_and_apply(AlertContent, content)

  defp format_content(input) do
    try do
      content =
        input.content
        |> String.split(" ", trim: true)
        |> then(fn [_type | content] ->
          content
          |> Enum.map(fn value -> String.split(value, "=") end)
          |> Map.new(fn [k, v] -> {k, v} end)
        end)

      alert_content = %{
        created: NaiveDateTime.from_iso8601!(content["DT"]),
        type: content["T"],
        lat: content["LAT"],
        lon: content["LON"],
        value: content["VAL"]
      }

      {:ok, alert_content}
    rescue
      _ -> {:error, :invalid_format}
    end
  end
end
