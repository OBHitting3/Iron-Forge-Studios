import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { translateToPrompt } from "./translate.js";
import path from "path";
import { fileURLToPath } from "url";

dotenv.config();

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const app = express();
const port = parseInt(process.env.PORT || "3001");

app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, "../public")));

// Health check
app.get("/api/health", (_req, res) => {
  res.json({ ok: true, service: "prompt-forge" });
});

// The main endpoint — translate raw speech to actionable prompt
app.post("/api/translate", async (req, res) => {
  const { input } = req.body;

  if (!input || typeof input !== "string" || input.trim().length === 0) {
    return res.status(400).json({ error: "Give me something to work with." });
  }

  try {
    const prompt = await translateToPrompt(input.trim());
    res.json({ prompt });
  } catch (err: any) {
    if (err.message?.includes("api_key")) {
      return res.status(500).json({ error: "API key not set. Add ANTHROPIC_API_KEY to your .env file." });
    }
    res.status(500).json({ error: `Translation failed: ${err.message}` });
  }
});

// Serve the frontend
app.get("/", (_req, res) => {
  res.sendFile(path.join(__dirname, "../public/index.html"));
});

app.listen(port, () => {
  console.log(`Prompt Forge running at http://localhost:${port}`);
});
