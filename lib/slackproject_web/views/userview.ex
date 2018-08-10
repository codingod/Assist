defmodule Slackproject.UserView do
  use SlackprojectWeb, :view

  def render("show.json", %{user: user}) do
    %{name: user.name, address: user.address}
  end

   def render("error.json", %{error: error}), do: %{error: error}
end
