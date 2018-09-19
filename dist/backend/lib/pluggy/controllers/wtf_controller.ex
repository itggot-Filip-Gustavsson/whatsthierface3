defmodule Pluggy.WtfController do
  
  require IEx

  alias Pluggy.Wtf
  alias Pluggy.User
  alias Pluggy.Workspace
  alias Pluggy.Groups
  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]

  def index(conn) do

    #get user if logged in
    session_user = conn.private.plug_session["user_id"]
    current_user = case session_user do
      nil -> nil
      _   -> User.get(session_user)
    end

    if current_user == nil do
      send_resp(conn, 200, render("wtf/login", user: current_user))
    else
      
      workspace = 
      Workspace.get(session_user)
      |> Enum.reduce([], fn (head, acc) ->
        acc ++ Wtf.get(head.id)
      end) 
      



      send_resp(conn, 200, render("wtf/index", wss: workspace, user: current_user, workspace_ids: Workspace.get(session_user)))
    end
  end

  def login(conn) do
    #get user if logged in
    session_user = conn.private.plug_session["user_id"]
    current_user = case session_user do
      nil -> nil
      _   -> User.get(session_user)
    end

    send_resp(conn, 200, render("wtf/login", wtf: Wtf.all(), user: current_user))
  end

  def createw(conn),      do: send_resp(conn, 200, render("wtf/new_workspace", []))
  def join(conn),        do: send_resp(conn, 200, render("wtf/new_workspace", []))
  def register(conn),     do: send_resp(conn, 200, render("wtf/register", []))
  def new(conn),          do: send_resp(conn, 200, render("wtf/new", []))
  def show(conn, id) do 
    ws = Wtf.get_i(id)
    send_resp(conn, 200, render("wtf/show", gps: Groups.get(ws.id), ws: ws))
  end
  def edit(conn, id),     do: send_resp(conn, 200, render("wtf/edit", ws: Wtf.get_i(id)))
  
  def create(conn, params) do
    Wtf.create(params)
    #move uploaded file from tmp-folder (might want to first check that a file was uploaded)
    File.rename(params["file"].path, "priv/static/uploads/#{params["file"].filename}")
    redirect(conn, "/wtf")
  end

  def update(conn, id, params) do
    Wtf.update(id, params)
    redirect(conn, "/wtf")
  end

  def destroy(conn, id) do
    Wtf.delete(id)
    redirect(conn, "/wtf")
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end

end
