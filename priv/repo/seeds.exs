alias Johan.DatabaseSeeder

[{:ok, health_center_1} | _] = DatabaseSeeder.populate_health_centers!()
[{:ok, patient_1} | _] = DatabaseSeeder.populate_patients!(health_center_1.id)
DatabaseSeeder.populate_associations!(health_center_1.id, patient_1.id)
