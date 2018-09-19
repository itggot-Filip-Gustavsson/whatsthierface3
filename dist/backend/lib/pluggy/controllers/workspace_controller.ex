defmodule Pluggy.WorkspaceController do 
    import Plug.Conn, only: [send_resp: 3]

   # alias Pluggy.Wtf 
    alias Pluggy.Workspace
    
    def create(conn, params) do
		name = params["name"]
        company = params["company"]
        pwd = params["code"]

        code = Bcrypt.hash_pwd_salt(pwd)

        Postgrex.query!(DB, "INSERT INTO workspaces (name, company, code) VALUES ($1, $2, $3)", [name, company, code,],
            pool: DBConnection.Poolboy
            )
        ws_id = (
        Postgrex.query!(DB, "SELECT id FROM workspaces WHERE name = $1 AND company = $2 AND code = $3", [name, company, code,], pool: DBConnection.Poolboy).rows
        |> Workspace.to_struct )

    
        Postgrex.query!(DB, "INSERT INTO user_ws (user_id, workspace_id) VALUES ($1, $2)", [conn.private.plug_session["user_id"], ws_id.id],
		    pool: DBConnection.Poolboy
			)
			
        redirect(conn, "/")
        
    
    end

    def join(conn, params) do 
        name = params["name"]
        code = params["code"]

        result =
		  Postgrex.query!(DB, "SELECT id, code FROM workspaces WHERE name = $1", [name],
		    pool: DBConnection.Poolboy
			)

		case result.num_rows do
		  0 -> #no user with that username
		    IO.puts("no workspace with that name") && redirect(conn, "/join/w")
			_ -> #user with that username exists
		   [[id, password_hash]] = result.rows

		    #make sure password is correct
		    if Bcrypt.verify_pass(code, password_hash) do
                
                Postgrex.query!(DB, "INSERT INTO user_ws (user_id, workspace_id) VALUES ($1, $2)", [conn.private.plug_session["user_id"], id],
                    pool: DBConnection.Poolboy
                    )
                
		      redirect(conn, "/")
            else   
                IO.puts("Password not correct")
		      redirect(conn, "/join/w")
		    end
		end
    
      
    
			
        redirect(conn, "/")
    end

    def create_g(conn, params) do
        name = params["name"]

        
        
    end


    defp redirect(conn, url), do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")

end