defmodule SlackprojectWeb.SlackController do
  use SlackprojectWeb, :controller
  alias Slackproject.IdentificationUser
  alias Slackproject.PayloadUser
  alias Slackproject.Repo
  alias Slackproject.Changeset
  import Ecto.Query

  def call(conn, params) do
    [funcname, query] = String.split(conn.params["text"], " ")
      result = case funcname do           #case statement save into result/ in order to render
        "latest" ->       #function names/call function name with query as param
          latest(query)
        "random" ->
          random(query)
        "oldest" ->
          oldest(query)
        "sub" ->
          sub(query, conn.params)
        _ ->
          "ERROR"
          raise "Error: " <> funcname <> " : is not supported!"
      end
      IO.inspect("HELLOOOOO There")
      json(conn, result)
  end
  def sub(tag, params) do
    #don't call one controller from another controller
    user_id = params["user_id"]     #search user_field from result json
    team_id = params["team_id"]
    IO.inspect(params)
    map = %{"userid" => user_id, "teamid" => team_id, "tag" => tag}

    changeset = IdentificationUser.changeset(%IdentificationUser{}, map)
    result = Repo.insert(changeset)

    case result do
        {:ok, _} ->
          IO.inspect("Successfully subscribed to: " <> String.upcase(tag))
        {:error, reason} ->
          IO.inspect(reason)
          Enum.into(changeset.errors, %{})
          IO.inspect("Already subscribed to: " <> String.upcase(tag))
      end
   end

  def latest(params) do   #conn: first param of function in controller is always conn
    result = SlackprojectWeb.ExternalRequests.func(params)    #filename.function to pass the variable query
    |> Enum.take(3)   #check length of push.nba
    |> Enum.map(fn (x) -> x["message"]  end)

    length = Kernel.length(result)    #get the size of the json object so we can pattern match

    if(length == 3) do
      [a, b, c] = result
      up = String.upcase(params)
      #IO.inspect("Line 1'\n'Line 2")
      %{
        "text" => " - - - - -- - - - - -- - -" <> "\n"<> "Latest updates for: " <> up <> "\n" <>
        "1. " <> a <> "\n" <> "2. " <> b <> "\n" <> "3. " <> c
      }
     else if(length == 1) do
        [a] = result
        up = String.upcase(params)

        %{
          "text" => " - - - - -- - - - - -- - -" <> "\n"<> "Latest updates for: " <> up <> "\n" <>
          "1. " <> a
        }
      else if(length == 2) do
          [a,b] = result
          up = String.upcase(params)
          %{
            "text" => " - - - - -- - - - - -- - -" <> "\n"<> "Latest updates for: " <> up <> "\n" <>
            "1. " <> a <> "\n" <> "2. " <> b
          }
      end
    end

  end
end

  def random(params) do   #conn: first param of function in controller is always conn
    result = SlackprojectWeb.ExternalRequests.func(params)    #filename.function to pass the variable query
    |>Enum.take_random(3)
    |> Enum.map(fn (x) -> x["message"]  end)
                            #atom   #=| #map[field]
                            #IO.inspect(result)
  end

  def oldest(params) do   #conn: first param of function in controller is always conn
    result = SlackprojectWeb.ExternalRequests.func(params)    #filename.function to pass the variable query
    |> Enum.take(-3) #|> IO.inspect(charlists: :as_lists)
    |> Enum.map(fn (x) -> x["message"]  end)
  end
end
