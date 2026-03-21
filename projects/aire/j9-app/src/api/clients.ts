import { Router, Request, Response } from "express";
import {
  createClient,
  getClient,
  searchClients,
  updateClient,
  getClientsNeedingFollowup,
  getDormantClients,
  getFullClientProfile,
  logInteraction,
  getClientInteractions,
  addMilestone,
  getUpcomingMilestones,
  createTransaction,
  getClientTransactions,
} from "../services/memory-vault.js";

export const clientRouter = Router();

// Create a new client
clientRouter.post("/", async (req: Request, res: Response) => {
  try {
    const client = await createClient(req.body);
    res.status(201).json(client);
  } catch (err: any) {
    res.status(400).json({ error: err.message });
  }
});

// Search clients
clientRouter.get("/search", async (req: Request, res: Response) => {
  try {
    const query = req.query.q as string;
    if (!query) return res.status(400).json({ error: "Query parameter 'q' required" });
    const clients = await searchClients(query);
    res.json(clients);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

// Get clients needing follow-up
clientRouter.get("/followups", async (_req: Request, res: Response) => {
  try {
    const clients = await getClientsNeedingFollowup();
    res.json(clients);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

// Get dormant clients
clientRouter.get("/dormant", async (req: Request, res: Response) => {
  try {
    const days = parseInt(req.query.days as string) || 60;
    const clients = await getDormantClients(days);
    res.json(clients);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

// Get upcoming milestones
clientRouter.get("/milestones/upcoming", async (req: Request, res: Response) => {
  try {
    const days = parseInt(req.query.days as string) || 14;
    const milestones = await getUpcomingMilestones(days);
    res.json(milestones);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

// Get a single client with full profile
clientRouter.get("/:id/full", async (req: Request, res: Response) => {
  try {
    const profile = await getFullClientProfile(req.params.id);
    res.json(profile);
  } catch (err: any) {
    res.status(404).json({ error: err.message });
  }
});

// Get a single client
clientRouter.get("/:id", async (req: Request, res: Response) => {
  try {
    const client = await getClient(req.params.id);
    res.json(client);
  } catch (err: any) {
    res.status(404).json({ error: err.message });
  }
});

// Update a client
clientRouter.patch("/:id", async (req: Request, res: Response) => {
  try {
    const client = await updateClient(req.params.id, req.body);
    res.json(client);
  } catch (err: any) {
    res.status(400).json({ error: err.message });
  }
});

// Log an interaction
clientRouter.post("/:id/interactions", async (req: Request, res: Response) => {
  try {
    const interaction = await logInteraction({ ...req.body, client_id: req.params.id });
    res.status(201).json(interaction);
  } catch (err: any) {
    res.status(400).json({ error: err.message });
  }
});

// Get client interactions
clientRouter.get("/:id/interactions", async (req: Request, res: Response) => {
  try {
    const limit = parseInt(req.query.limit as string) || 20;
    const interactions = await getClientInteractions(req.params.id, limit);
    res.json(interactions);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

// Add a milestone
clientRouter.post("/:id/milestones", async (req: Request, res: Response) => {
  try {
    const milestone = await addMilestone({ ...req.body, client_id: req.params.id });
    res.status(201).json(milestone);
  } catch (err: any) {
    res.status(400).json({ error: err.message });
  }
});

// Create a transaction
clientRouter.post("/:id/transactions", async (req: Request, res: Response) => {
  try {
    const transaction = await createTransaction({ ...req.body, client_id: req.params.id });
    res.status(201).json(transaction);
  } catch (err: any) {
    res.status(400).json({ error: err.message });
  }
});

// Get client transactions
clientRouter.get("/:id/transactions", async (req: Request, res: Response) => {
  try {
    const transactions = await getClientTransactions(req.params.id);
    res.json(transactions);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});
