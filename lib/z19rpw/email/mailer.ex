defmodule Z19rpw.Mailer do
  @moduledoc """
  Module that initializes and sends email
  """
  use Bamboo.Mailer, otp_app: :z19rpw
  use Pow.Phoenix.Mailer

  import Bamboo.Email

  @impl true
  def cast(%{user: user, subject: subject, text: text, html: html}) do
    new_email(
      to: user.email,
      from: "noreply@z19r.pw",
      subject: subject,
      html_body: html,
      text_body: text
    )
  end

  @impl true
  def process(email) do
    # An asynchronous process should be used here to prevent enumeration
    # attacks. Synchronous e-mail delivery can reveal whether a user already
    # exists in the system or not.
    require Logger
    Logger.info(email)
    deliver_later(email)
  end
end
