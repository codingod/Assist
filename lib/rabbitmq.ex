defmodule Slackproject.Rabbitmq do
  use AMQP

  @moduledoc """
  Get RabbitMQ Connection and Channel based on application configuration.
  """

  def get_connection do
    host = Application.get_env(:slackproject, :rabbitmq)[:host]
    vhost = Application.get_env(:slackproject, :rabbitmq)[:vhost]
    user = Application.get_env(:slackproject, :rabbitmq)[:user]
    password = Application.get_env(:slackproject, :rabbitmq)[:password]
    port = Application.get_env(:slackproject, :rabbitmq)[:port] || 5672
    
    Connection.open(host: host, port: port, username: user, password: password, virtual_host: vhost)
  end
end
