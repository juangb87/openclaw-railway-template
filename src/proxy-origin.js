// The relay validates the caller's real Origin and authenticates separately.
// Never manufacture an accepted extension Origin for untrusted callers.
export function setWebSocketProxyOrigin(proxyReq, req, proxyOrigin) {
  const pathname = (req.url || "").split("?")[0];
  if (pathname !== "/browser/extension") {
    proxyReq.setHeader("Origin", proxyOrigin);
  }
}
