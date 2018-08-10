defmodule SlackprojectWeb.ErrorView do
  use SlackprojectWeb, :view
  #import TranslateErrors, except: [length: 1]

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  def render("409.json", %{changeset: changeset}) do
  %{
    status: "failure",
    errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  }
  end

  # def translate_errors(changeset) do
  #   #Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  #   Slackproject.Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
