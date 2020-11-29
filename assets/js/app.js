import "../css/app.scss"

import NProgress from 'nprogress'
import "phoenix_html"
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import hljs from "highlight.js"
import "./nav"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

let liveSocket = new LiveSocket("/live", Socket, { params: { _csrf_token: csrfToken }, });

window.addEventListener("phx:page-loading-start", info => NProgress.start());
window.addEventListener("phx:page-loading-stop", info => NProgress.done());

// add syntax hilighting for the code in blog posts
window.addEventListener("phx:page-loading-stop", info => hljs.initHighlighting())
liveSocket.connect()

window.liveSocket = liveSocket
