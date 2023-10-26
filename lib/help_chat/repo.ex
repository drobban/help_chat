defmodule HelpChat.Repo do
  use Ecto.Repo,
    otp_app: :help_chat,
    adapter: Ecto.Adapters.Postgres
end
