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

    create_table(:matches_teams) do
      foreign_key :match_id, :matches
      foreign_key :team_id, :teams
      index [:match_id, :team_id], unique: true

      Integer :rank, null: false
    end

    create_table(:players_teams) do
      foreign_key :player_id, :players
      foreign_key :team_id, :teams
      index [:player_id, :team_id], unique: true
    end
  end
end
