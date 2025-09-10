import { describe, it, beforeEach, afterEach } from "node:test";
import { expect, config } from "chai";
import quibble from "quibble";
import request from "supertest";

import app from "../../app.mjs";

config.includeStack = true;

describe("Health Routes", () => {
  describe("GET /public/health/v1/ping", () => {
    it("should return pong", async () => {
      const response = await request(app).get("/public/health/v1/ping");

      expect(response.status).to.eq(200);
      expect(response.text).to.eq("pong");
    });
  });

  describe("GET /health/v1/all", () => {
    it("should return OK status", async () => {
      const response = await request(app).get("/health/v1/all");

      expect(response.status).to.eq(200);
      expect(response.body).to.deep.eq({
        summary: "OK",
        remote: {
          summary: "OK",
        },
        local: {
          summary: "OK",
        },
      });
    });
  });

  describe("one dependency is not healthy", async () => {
    let subject;
    beforeEach(async () => {
      await quibble.reset();

      // mock healthManager before importing app
      await quibble.esm("../../lib/health/healthManager.mjs", {
        localHealthResponse: async () => ({ summary: "NOT_OK" }),
        registerLocalHealthCheck: () => {},
        registerRemoteHealthCheck: () => {},
        remoteHealthResponse: async () => ({ summary: "OK" }),
        allHealthResponse: async () => {
          return {
            summary: "NOT_OK",
            local: { summary: "NOT_OK" },
            remote: { summary: "OK" },
          };
        },
      });

      // reload app after mocking
      subject = (await import("../../app.mjs?t=" + Date.now())).default;
    });

    afterEach(async () => {
      await quibble.reset();
    });

    it("should return NOT_OK with 500 status", async () => {
      const response = await request(subject).get("/health/v1/all");
      expect(response.status).to.eq(500);
      expect(response.body).to.deep.eq({
        summary: "NOT_OK",
        local: { summary: "NOT_OK" },
        remote: { summary: "OK" },
      });
    });
  });
});