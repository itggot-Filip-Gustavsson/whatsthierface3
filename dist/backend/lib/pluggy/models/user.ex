defmodule Pluggy.User do

	defstruct(id: nil, email: "", name: "")

	alias Pluggy.User


	def get(id) do
		Postgrex.query!(DB, "SELECT id, email, name FROM users WHERE id = $1 LIMIT 1", [id],
        pool: DBConnection.Poolboy
      ).rows |> to_struct
	end

	def to_struct([[id, email, name]]) do
		%User{id: id, email: email, name: name}
	end


end