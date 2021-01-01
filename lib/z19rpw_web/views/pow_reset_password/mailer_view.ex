defmodule Z19rpwWeb.PowResetPassword.MailerView do
  use Z19rpwWeb, :mailer_view

  def subject(:reset_password, _assigns), do: "Reset password link"
end
