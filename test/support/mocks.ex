for mod <- [
  Johan.Notifications.SMS
] do
Mox.defmock(:"#{mod}Mock", for: mod)
end
