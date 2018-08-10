defmodule SlackprojectWeb.SlackMessenger do
  use Slack

  def send(a) do
    url = "https://hooks.slack.com/services/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"
    SlackWebhook.send(a, url)
  end
end
