defmodule Pluggy.Router do
  use Plug.Router

  alias Pluggy.WtfController
  alias Pluggy.UserController
  alias Pluggy.WorkspaceController
  alias Pluggy.GroupController
  
  plug Plug.Static, at: "/", from: :pluggy
  plug(:put_secret_key_base)

    plug(Plug.Session,
    store: :cookie,
    key: "_pluggy_session",
    encryption_salt: "cookie store encryption salt",
    signing_salt: "cookie store signing salt",
    key_length: 64,
    log: :debug,
    secret_key_base: "-- LONG STRING WITH AT LEAST 64 BYTES --"
  )

  plug(:fetch_session)
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])
  plug(:match)
  plug(:dispatch)

  get "/",                 do: WtfController.index(conn)
  get "/login",       do: WtfController.login(conn)
  get "/create/u",     do: WtfController.register(conn) 
  get "/w/:id",            do: WtfController.show(conn, id)
  get "/wtf/:id/edit",  do: WtfController.edit(conn, id)
  get "/create/w",      do: WtfController.createw(conn)
  get "/join/w",      do: WtfController.join(conn)
  
  
  post "/wtf",          do: WtfController.create(conn, conn.body_params)
 
  # should be put /wtf/:id, but put/patch/delete are not supported without hidden inputs
  post "/wtf/:id/edit", do: WtfController.update(conn, id, conn.body_params)

  # should be delete /wtf/:id, but put/patch/delete are not supported without hidden inputs
  post "/wtf/:id/destroy", do: WtfController.destroy(conn, id)
  
  post "/create/g",  do: GroupController.create(conn, conn.body_params)
  post "/w/:id",            do: WorkspaceController.create_g(conn, id)
  post "/join/w",   do: WorkspaceController.join(conn, conn.body_params)
  post "/create/w",   do: WorkspaceController.create(conn, conn.body_params)
  post "/create/u",     do: UserController.register(conn, conn.body_params)
  post "/login",     do: UserController.login(conn, conn.body_params)
  post "/logout",    do: UserController.logout(conn)

  match _ do
    send_resp(conn, 404, "oops")
  end

  defp put_secret_key_base(conn, _) do
    put_in(
      conn.secret_key_base,
      "-- LONG STRING WITH AT LEAST 64 BYTES LONG STRING WITH AT LEAST 64 BYTES --"
    )
  end
end
