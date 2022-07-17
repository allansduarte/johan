for mod <- [
  Johan.Notifications.SMS,
  Johan.NotificationDispatcher.Ports.SendNotification
] do
Mox.defmock(:"#{mod}Mock", for: mod)
end
