defmodule Pluggy.Groups do

    alias Pluggy.Groups
    
defstruct(id: nil, name: "", ws_id: nil)

    
	def get(id) do
		Postgrex.query!(DB, "SELECT * FROM groups WHERE workspace_id = $1", [id], [pool: DBConnection.Poolboy]).rows
		|> to_struct_list
    end
    
    def to_struct([[id, name, ws_id]]) do
		%Groups{id: id, name: name, ws_id: ws_id}
    end
    
    def to_struct_list(rows) do
        for [id, name, ws_id] <- rows, do: %Groups{id: id, name: name, ws_id: ws_id}
    end
end