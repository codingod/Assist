defmodule Slackproject.CustomAlertHose do
  require Logger
  import Ecto.Query
  #alias Slackproject.User
  alias Slackproject.IdentificationUser
  alias Slackproject.PayloadUser
  alias Slackproject.Repo
  alias Slackproject.Changeset
  #alias Slackproject.SlackMessenger
  import Ecto.Changeset

  use GenServer
  use AMQP

  @type opts :: [...] | []

  @spec start_link :: {:ok, pid}
  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  @queue       "query_sub_q"
  @queue_error "#{@queue}_error"
  @exchange "query_sub_exchange"
  @spec init([...]) :: tuple
  def init(_opts), do: rabbitmq_connect()

  def rabbitmq_connect do
        {:ok, conn} = Connection.open("amqp://guest:guest@localhost") # opens connection from our app to rabbit server
        {:ok, chan} = Channel.open(conn)  #opens up a channel on that connection

        Basic.qos(chan, prefetch_count: 1)
        Queue.declare(chan, @queue_error, durable: true)  #declare queue inside channel
        Queue.declare(chan, @queue, durable: true,
                                    arguments: [{"x-dead-letter-exchange", :longstr, ""},
                                                {"x-dead-letter-routing-key", :longstr, @queue_error}]) #direct errors to error q

        Exchange.declare(chan, @exchange)       #calling exchange, direct messag
        AMQP.Basic.publish(chan, "", "hello", "Hello World!")
        Queue.bind(chan, @queue, @exchange, routing_key: @queue)  #Connecting queue to the exchange

        {:ok, _consumer_tag} = Basic.consume(chan, @queue)
        {:ok, chan}
  end

  # Confirmation sent by the broker after registering this proccess
  @spec handle_info(tuple(), tuple()) :: tuple()
  def handle_info({:basic_consume_ok, %{consumer_tag: _consumer_tag}}, chan) do
    {:noreply, chan}
  end
  def handle_info({:basic_cancel, %{consumer_tag: _consumer_tag}}, chan) do
    {:stop, :normal, chan}
  end
  def handle_info({:basic_cancel_ok, %{consumer_tag: _consumer_tag}}, chan) do
    {:noreply, chan}
  end
  def handle_info({:basic_deliver, payload, %{delivery_tag: tag, redelivered: redelivered}}, chan) do
    Task.start(fn() -> consume(chan, tag, redelivered, payload) end)
    {:noreply, chan}
  end

  def handle_info({:DOWN, _, :process, _pid, _reason}, _) do
    IO.inspect "Received :DOWN signal. Reconnecting..."
    {:ok, chan} = rabbitmq_connect()
    {:noreply, chan}
  end

  @spec consume(any(), any(), any(), map()) :: :ok
  def consume(channel, tag, _redelivered, alerts) do
    alerts = :jiffy.decode(alerts, [:return_maps])
    a = %{}

    message = alerts["message"]
    map = %{"message" => alerts["message"], "tag" => alerts["tag"]}

    IO.inspect("Inspecting:    " <> alerts["message"])

    #IO.inspect("Before Print Changeset: + + + + + + + ++ + + +")
    #map = %{"message" => message, "tag" => alerts["tag"], "userid" => alerts["userid"], "teamid" => alerts["teamid"]}
    changeset = PayloadUser.changeset(%PayloadUser{}, map)

    # look in slack api for options with webhook to specify workspace
    #1.    query = for all the users that have the tag == to notifications tag
    #2.
    #read from static file
    IO.inspect("Before sending function: ")
    #SlackprojectWeb.SlackMessenger.send(alerts["message"])
    SlackprojectWeb.SlackMessenger.send(alerts["message"])
    IO.inspect("After sending function: ")
    #call function inside Slack Messenger

    result = Repo.insert(changeset) #successfully inserted into payload

    #add status with payload database
    #unsent notification
    #don't do hard delete use status columns
    # Unique identifier column(auto increment)
      # (Service Fields) - special
      # Add 4 fields:
        #user added
        # date added
        # user changed
        # date change
        # status
    #insert worked for: { "message":"Carmelo", "tag":"nba", "userid":"yhailu", "teamid":"BR" }


    ####{ "message":"Austin hits game winner in game 7 of NBA finals!", "tag":"nba"}
    #hardening
    #formatting
    # BR Logo

    case result do
      {:ok, _} ->
        "Hello"
      {:error, _} ->
        Enum.into(changeset.errors, %{})
        IO.inspect("IN ERROR: _________")
    end
    Basic.ack(channel, tag)
  rescue
    exception ->
      IO.inspect "Error when consuming from custom alert hose"
      IO.inspect alerts
      IO.inspect :erlang.get_stacktrace
      IO.inspect exception
  end
end
