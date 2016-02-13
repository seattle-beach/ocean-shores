Sequel.migration do
  change do
    create_table(:matches) do
      primary_key :id
      column :created_at, "timestamp without time zone"
      column :updated_at, "timestamp without time zone"
    end

    create_table(:players) do
      primary_key :id
      column :name, "text", :null=>false
      column :created_at, "timestamp without time zone"
      column :updated_at, "timestamp without time zone"

      index [:name], :name=>:players_name_key, :unique=>true
    end

    create_table(:schema_info) do
      column :version, "integer", :default=>0, :null=>false
    end

    create_table(:teams) do
      primary_key :id
      column :created_at, "timestamp without time zone"
      column :updated_at, "timestamp without time zone"
      column :rank, "integer", :null=>false
      foreign_key :match_id, :matches, :key=>[:id]
    end

    create_table(:players_teams) do
      foreign_key :player_id, :players, :key=>[:id]
      foreign_key :team_id, :teams, :key=>[:id]

      index [:player_id, :team_id], :unique=>true
    end
  end
end
