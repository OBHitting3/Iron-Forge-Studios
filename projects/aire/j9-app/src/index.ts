import express from "express";
import { env } from "./config/env.js";
import { clientRouter } from "./api/clients.js";

const app = express();

app.use(express.json());

// Health check
app.get("/api/health", (_req, res) => {
  res.json({ ok: true, service: "j9-aire", module: "memory-vault" });
});

// Memory Vault API
app.use("/api/clients", clientRouter);

app.listen(env.port, () => {
  console.log(`J9-AiRE running on port ${env.port}`);
});
