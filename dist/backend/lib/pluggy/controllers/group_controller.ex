defmodule Pluggy.GroupController do

    import Plug.Conn, only: [send_resp: 3]
    
    def create(conn, params) do
		name = params["name"]
        ws_id = params["ws_id"]

        Postgrex.query!(DB, "INSERT INTO groups (name, workspace_id) VALUES ($1, $2)", [name, String.to_integer(ws_id)],
            pool: DBConnection.Poolboy
            )
			
        redirect(conn, "/w/#{ws_id}")
        
    
    end


    defp redirect(conn, url), do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
end