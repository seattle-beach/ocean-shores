Sequel.migration do
  change do
    alter_table(:teams) do
      add_column :rank, Integer, null: false, default: 0
      add_foreign_key :match_id, :matches
    end

    drop_table(:matches_teams)
  end
end
