class AddNextNumberTrigger < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE OR REPLACE FUNCTION set_next_number() RETURNS trigger AS $$
      DECLARE
        last_number integer;
      BEGIN
        SELECT MAX(number) INTO last_number FROM builds WHERE repository_id = NEW.repository_id;

        IF last_number IS NULL THEN
          last_number := 0;
        END IF;

        NEW.number := last_number + 1;
        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;

      DROP TRIGGER IF EXISTS set_next_number_before_build_create ON builds;
      CREATE TRIGGER set_next_number_before_build_create BEFORE INSERT ON builds
        FOR EACH ROW EXECUTE PROCEDURE set_next_number();
    SQL
  end

  def down
    execute <<-SQL
      DROP TRIGGER IF EXISTS set_next_number_before_build_create ON builds;
      DROP FUNCTION IF EXISTS set_next_number();
    SQL
  end
end
