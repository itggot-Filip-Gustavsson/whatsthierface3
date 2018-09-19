defmodule Pluggy.Wtf do
	
	defstruct(id: nil, name: "", company: "")

	alias Pluggy.Wtf

	def all do
		Postgrex.query!(DB, "SELECT * FROM workspaces", [], [pool: DBConnection.Poolboy]).rows
		|> to_struct_list
	end
	
	def get(id) do
		Postgrex.query!(DB, "SELECT id, name, company FROM workspaces WHERE id = $1", [id], [pool: DBConnection.Poolboy]).rows
		|> to_struct_list
	end

	def get_i(id) do
		Postgrex.query!(DB, "SELECT id, name, company FROM workspaces WHERE id = $1", [String.to_integer(id)], [pool: DBConnection.Poolboy]).rows
		|> to_struct
	end

	def update(id, params) do
		name = params["name"]
		company = String.to_integer(params["company"])
		id = String.to_integer(id)
		Postgrex.query!(DB, "UPDATE wtf SET name = $1, company = $2 WHERE id = $3", [name, company, id], [pool: DBConnection.Poolboy])
	end

	def create(params) do
		name = params["name"]
		company = String.to_integer(params["company"])
		Postgrex.query!(DB, "INSERT INTO wtf (name, company) VALUES ($1, $2)", [name, company], [pool: DBConnection.Poolboy])	
	end

	def delete(id) do
		Postgrex.query!(DB, "DELETE FROM wtf WHERE id = $1", [String.to_integer(id)], [pool: DBConnection.Poolboy])	
	end

	def to_struct([[id, name, company]]) do
		%Wtf{id: id, name: name, company: company}
	end

	def to_struct_list(rows) do
		for [id, name, company] <- rows, do: %Wtf{id: id, name: name, company: company}
	end



end