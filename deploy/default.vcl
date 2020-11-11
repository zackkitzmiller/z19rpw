vcl 4.0;

import directors;
import std;


backend z19rpw {
  .host = "z19rpw-service";
  .port = "80";
}

sub vcl_recv {
  if (req.http.upgrade ~ "(?i)websocket") {
    return (pipe);
  }

  # normalize the port for testing/staging
  set req.http.Host = regsub(req.http.Host, ":[0-9]+", "");
  std.log(req.http.Host);

  # pass on the real IP address here as X-Forwarded-For
  if (req.restarts == 0) {
      if (req.http.X-Forwarded-For) {
          set req.http.X-Forwarded-For = req.http.X-Forwarded-For + ", " + client.ip;
      } else {
      set req.http.X-Forwarded-For = client.ip;
      }
  }

  if (req.http.Host ~ "z19r.pw") {

    std.log("setting backend to z19rpw");
    set req.backend_hint = z19rpw;
  }

  if (req.method != "GET" && req.method != "HEAD") {
    return (pass);
  }

  if (req.url ~ "\.(png|jpg|jpeg|css|js)") {
    std.log("processing for z19r assets");
    unset req.http.Cookie;
    return (hash);
  }

  std.log("not an asset request");
  return (pass);
}

sub vcl_deliver {
  if (obj.hits > 0) {
    set resp.http.X-Cache = "HIT";
  } else {
    set resp.http.X-Cache = "MISS";
  }
  return (deliver);
}

sub vcl_backend_response {
  if (bereq.url ~ "\.(png|jpg|jpeg|css|js)") {
    unset beresp.http.set-cookie;
  }
  return (deliver);
}

sub vcl_pipe {
  if (req.http.upgrade) {
    set bereq.http.upgrade = req.http.upgrade;
    set bereq.http.connection = req.http.connection;
  }

  return (pipe);
}
