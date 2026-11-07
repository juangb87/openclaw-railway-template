import { test } from "node:test";
import assert from "node:assert/strict";
import { setWebSocketProxyOrigin } from "../src/proxy-origin.js";

for (const url of ["/browser/extension", "/browser/extension?profile=chrome"]) {
  for (const origin of ["chrome-extension://official-id", "https://evil.example", undefined]) {
    test(`preserves real origin ${origin} on ${url}`, () => {
      const headers = new Map(origin ? [["Origin", origin]] : []);
      setWebSocketProxyOrigin({ setHeader: (k,v) => headers.set(k,v) }, {url}, "https://bot.example");
      assert.equal(headers.get("Origin"), origin);
      assert.equal(headers.has("Origin"), origin !== undefined);
    });
  }
}
for (const url of ["/", "/browser/extension-evil", "/browser/extension/", "/other?next=/browser/extension"]) {
  test(`retains Control UI origin rewrite on ${url}`, () => {
    const headers = new Map();
    setWebSocketProxyOrigin({ setHeader: (k,v) => headers.set(k,v) }, {url}, "https://bot.example");
    assert.equal(headers.get("Origin"), "https://bot.example");
  });
}
