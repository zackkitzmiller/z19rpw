defmodule Z19rpw.Email do
  @moduledoc """
  Module to contain all custom outgoing emails
  """
  import Bamboo.Email

  def welcome_email do
    new_email(
      to: "zackkitzmiller@gmail.com",
      from: "noreply@z19r.pw",
      subject: "Email Integration.",
      html_body: "<strong>Thanks for joining!</strong>",
      text_body: "Thanks for joining!"
    )
  end
end
