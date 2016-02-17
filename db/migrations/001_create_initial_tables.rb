Sequel.migration do
  change do
    create_table(:matches) do
      primary_key :id

      DateTime :created_at
      DateTime :updated_at
    end

    create_table(:teams) do
      primary_key :id

      DateTime :created_at
      DateTime :updated_at
    end

    create_table(:players) do
      primary_key :id

      String :name, null: false, unique: true

      DateTime :created_at
      DateTime :updated_at
    end

    create_join_table(match_id: :matches, team_id: teams)
    create_join_table(player_id: :players, team_id: teams)
  end
end
