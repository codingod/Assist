defmodule SlackprojectWeb.ExternalRequests do

  def func(query) do
    url = "http://push.bleacherreport.com/api/v1/push_notifications?tags=#{query}" #shift(3)
    result = HTTPoison.get(url)

    case result do
      {:ok, %{status_code: 200, body: body}} ->
        Poison.decode!(body)    # reads in json => elixir data structures

      {:ok, %{status_code: 404}} ->
        "ER 404"

      {:error, %{reason: reason}} ->
        "ER error tuple"
      end
  end
end
