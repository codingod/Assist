defmodule Slackproject.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Slackproject.Repo, []),
      #supervisor(Slackproject.RepoReadOnly, []),  #added
      #supervisor(Slackproject.Payload, []),
      #worker(Slackproject.CustomAlertHose, [[name: Slackproject.CustomAlertHose]]),
      # Start the endpoint when the application starts
      supervisor(SlackprojectWeb.Endpoint, []),

      supervisor(Slackproject.CustomAlertHose, [])
      #worker(Slackproject.CustomAlertHose, [], restart: :transient)
      # Start your own worker by calling: Slackproject.Worker.start_link(arg1, arg2, arg3)
      # worker(Slackproject.Worker, [arg1, arg2, arg3]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Slackproject.Supervisor]
    Supervisor.start_link(children, opts)
    #Slack.Bot.start_link(SlackRtm, [], "xoxp-385208367875-385084588596-390830011590-970c7c4eb61ea268ca29e4149340e40c")

  end

  # defimpl Poison.Encoder, for: BSON.ObjectId do
  #   def encode(id, options) do
  #     BSON.ObjectId.encode!(id) |> Poison.Encoder.encode(options)
  #   end
  # end
  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SlackprojectWeb.Endpoint.config_change(changed, removed)
    :ok
  end

end
