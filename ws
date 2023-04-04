
import { serve } from "https://deno.land/std@0.177.0/http/server.ts";

const targetWSHost = "xx.xxx.xxxx";
async function handler(req: Request): Promise<Response> {
  const url = new URL(req.url);
  const upgrade = req.headers.get("upgrade") || "";
  if (upgrade.toLowerCase() != "websocket") {
    url.host = targetWSHost;
    return await fetch(url, req);
  }

  const socketPromse = [];
  const { socket: downstream, response } = Deno.upgradeWebSocket(req);
  downstream.addEventListener("open", ()=>{
    console.log('open----downstream-------');
  })
  url.host = targetWSHost
  url.protocol = 'wss';
  url.port = '443'
  const upstream = new WebSocket(url);
  socketPromse.push(new Promise((resolve) => upstream.addEventListener("open", resolve)));
  await Promise.all(socketPromse);
  console.log("Both WebSocket connections are open");
  downstream.addEventListener("message", (message: any) => {
    upstream.send(message.data);
  });
  downstream.addEventListener("error", (error: any) => {
    console.log("error", error);
  });
  
  // Proxy messages from the upstream WebSocket connection to the downstream connection
  upstream.addEventListener("message", (message: any) => {
    downstream.send(message.data);
  });
  upstream.addEventListener('error', (e: any) => {
    console.log("error", e);
  });
  return response;
}

serve(handler);
