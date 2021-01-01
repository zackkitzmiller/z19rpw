defmodule Z19rpwWeb.PowEmailConfirmation.MailerView do
  use Z19rpwWeb, :mailer_view

  def subject(:email_confirmation, _assigns), do: "Confirm your email address"
end
