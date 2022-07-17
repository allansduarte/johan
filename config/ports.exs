import Config

setup_port = fn app, conf ->
  {port, default, opts} =
    case conf do
      {port, impl} -> {port, impl, []}
      conf -> conf
    end

  impl =
    case Mix.env() do
      :test -> Keyword.get(opts, :test, :"#{port}Mock")
      env -> Keyword.get(opts, env, default)
    end

  config app, port, impl
end

ports_by_app = %{
  johan: [
    {
      Johan.Notifications.SMS,
      Johan.Notifications.SMS.Dispatcher
    }
  ]
}

ports_by_app
|> Enum.flat_map(fn {app, ports} ->
  Enum.map(ports, &{app, &1})
end)
|> Enum.each(fn {app, port} ->
  setup_port.(app, port)
end)
