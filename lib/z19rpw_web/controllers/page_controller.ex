defmodule Z19rpwWeb.PageController do
  use Z19rpwWeb, :controller

  def index(conn, _params) do
    if conn.host == "thetrumphealthcareplan.com" do
      conn
      |> redirect(to: "/thc")
    else
      render(conn, "index.html")
    end
  end

  def thc(conn, _params) do
    HTTPoison.post(
      "https://plausible.io/api/event",
      "{\"n\": \"pageview\", \"u\": \"http://thetrumphealthcareplan.com:4000/thc\",
    \"d\": \"thetrumphealthcareplan.com\",
      \"r\": \"thc\",
      \"w\": 1764
  }",
      [
        {"Content-Type", "plain/text"}
      ]
    )

    conn
    |> redirect(
      external:
        "https://www.google.com/search?client=safari&rls=en&ei=1IOTX9PIKcustQavmZygDw&q=funeral+homes&oq=funeral+homes&gs_lcp=a&sclient=psy-ab&ved=&uact=5"
    )
  end

  def coffee(conn, _params) do
    render(conn, "coffee.html")
  end
end
