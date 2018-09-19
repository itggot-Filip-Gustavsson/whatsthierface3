defmodule Pluggy.UserController do

	#import Pluggy.Template, only: [render: 2]
	import Plug.Conn, only: [send_resp: 3]

	def login(conn, params) do
		email = params["email"]
		password = params["pwd"]


		result =
		  Postgrex.query!(DB, "SELECT id, hash FROM users WHERE email = $1", [email],
		    pool: DBConnection.Poolboy
			)

		case result.num_rows do
		  0 -> #no user with that username
		    IO.puts("no user with that email") && redirect(conn, "/login")
			_ -> #user with that username exists
		   [[id, password_hash]] = result.rows

		    #make sure password is correct
		    if Bcrypt.verify_pass(password, password_hash) do
		      Plug.Conn.put_session(conn, :user_id, id)
		      |>redirect("/")
		    else
		      redirect(conn, "/login")
		    end
		end
	end

	def register(conn, params) do
		email = params["email"]
		name = params["name"]
		pwd = params["pwd"]

		password = Bcrypt.hash_pwd_salt(pwd)

		Postgrex.query!(DB, "INSERT INTO users (email, name, hash) VALUES ($1, $2, $3)", [email, name, password],
		    pool: DBConnection.Poolboy
			)
			
		redirect(conn, "/")

	end

	def logout(conn) do
		Plug.Conn.configure_session(conn, drop: true)
		|> redirect("/login")
	end

	# def create(conn, params) do
	# 	#pseudocode
	# 	# in db table users with password_hash CHAR(60)
	# 	# hashed_password = Bcrypt.hash_pwd_salt(params["password"])
    #  	# Postgrex.query!(DB, "INSERT INTO users (username, password_hash) VALUES ($1, $2)", [params["username"], hashed_password], [pool: DBConnection.Poolboy])
    #  	# redirect(conn, "/fruits")
	# end

	defp redirect(conn, url), do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
end
