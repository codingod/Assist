defmodule Slackproject do
  @moduledoc """
  Slackproject keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  import Supervisor.Spec

  def start(_type, _args) do
    children = [
        # Start the endpoint when the application starts
        #supervisor(Slackproject.Repo, []),
        supervisor(SlackprojectWeb.Endpoint, []),
        worker(Slackproject.Worker, []),
      ]
  end
end
