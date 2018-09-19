defmodule Pluggy.Workspace do
	
	defstruct(id: nil)

	alias Pluggy.Workspace


	def get(id) do
		Postgrex.query!(DB, "SELECT workspace_id FROM user_ws WHERE user_id = $1", [id], [pool: DBConnection.Poolboy]).rows
		|> to_struct_list
	end

	 def to_struct([[id]]) do
	 	%Workspace{id: id}
	 end

	def to_struct_list(rows) do
		for [id] <- rows, do: %Workspace{id: id}
	end



end