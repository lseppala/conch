SELECT run_migration(20, $$

    -- This was an overly optimistic column that hasn't been used at all
    ALTER TABLE device_settings DROP COLUMN resource_id;

$$);
