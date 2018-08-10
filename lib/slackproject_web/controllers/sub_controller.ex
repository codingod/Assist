defmodule SlackprojectWeb.SubController do
  use SlackprojectWeb, :controller

  def subfunc do
    url = "https://slack.com/api/auth.test?token=xoxp-385208367875-385084588596-390830011590-970c7c4eb61ea268ca29e4149340e40c&pretty=1" #shift(3)
    result = HTTPoison.get(url)
    #IO.inspect(result)
    case result do
      {:ok, %{status_code: 200, body: body}} ->
        #IO.inspect("TESTING: + _ + _ + _ + _ + _ + _ +")
        #IO.inspect(body)
        Poison.decode!(body)    # reads in json => elixir data structures
            # failure, but prints anyway
      {:ok, %{status_code: 404}} ->
        "Error: 404"

      {:error, %{reason: reason}} ->
        "Other Error!"
      end
  end
end
