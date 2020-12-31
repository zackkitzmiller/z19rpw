vcl 4.0;

import directors;
import std;


backend z19rpw {
  .host = "z19rpw-service";
  .port = "80";
}

backend cdn {
  .host = "minio-1606771947.minio";
  .port = "9000";
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

  if (req.http.Host ~ "contentdeliverynetwork.z19r.pw" && req.url ~ "^/assets/") {
    set req.url = regsuball(req.url, "/assets/", "/public/");
    std.log("setting backend to CDNNN");
    set req.backend_hint = cdn;
  }

  if (req.method != "GET" && req.method != "HEAD") {
    return (pass);
  }

  if (req.url == "/") {
    std.log("attempting to cache home");
    unset req.http.Cookie;
    return (hash);
  }

  if (req.url ~ "\.(png|jpg|gif|jpeg|css|js)") {
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
  if (bereq.url ~ "\.(png|jpg|jpeg|css|js)" || bereq.url == "/") {
    unset beresp.http.set-cookie;
  }

  set beresp.http.Cache-Control = "max-age=3600";
  set beresp.ttl = 1h;

  return (deliver);
}

sub vcl_pipe {
  if (req.http.upgrade) {
    set bereq.http.upgrade = req.http.upgrade;
    set bereq.http.connection = req.http.connection;
  }

  return (pipe);
}
