defmodule SlackprojectWeb.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  use Phoenix.HTML

  @doc """
  Translates an error message using gettext.
  """
  def error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn (error) ->
      content_tag :span, translate_error(error), class: "help-block"
    end)
  end

  #added
  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  #added
  # def render("error.json", %{changeset: changeset}) do
  #   # When encoded, the changeset returns its errors
  #   # as a JSON object. So we just pass it forward.
  #   %{errors: translate_errors(changeset)}
  # end

  def render("409.json", %{changeset: changeset}) do
  %{
   status: "failure",
   #errors: changeset.errors # this line causes the error
   errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  }
end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate "is invalid" in the "errors" domain
    #     dgettext "errors", "is invalid"
    #
    #     # Translate the number of files with plural rules
    #     dngettext "errors", "1 file", "%{count} files", count
    #
    # Because the error messages we show in our forms and APIs
    # are defined inside Ecto, we need to translate them dynamically.
    # This requires us to call the Gettext module passing our gettext
    # backend as first argument.
    #
    # Note we use the "errors" domain, which means translations
    # should be written to the errors.po file. The :count option is
    # set by Ecto and indicates we should also apply plural rules.
    if count = opts[:count] do
      Gettext.dngettext(SlackprojectWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(SlackprojectWeb.Gettext, "errors", msg, opts)
    end
  end

end
