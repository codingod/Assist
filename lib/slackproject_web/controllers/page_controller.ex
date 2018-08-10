defmodule SlackprojectWeb.PageController do
  use SlackprojectWeb, :controller

  plug :scrub_params, "user" when action in [:create] #added

  # rabbit_settings = Application.get_env :my_app, :rabbitmq
  # {:ok, connection} = AMQP.Connection.open(rabbit_settings)

  def index(conn, _params) do
    render conn, "index.html"
  end
end
