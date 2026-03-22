import { Router, Request, Response } from "express";
import { requireAuth } from "../middleware/auth.js";
import {
  createClientSchema,
  updateClientSchema,
  logInteractionSchema,
  addMilestoneSchema,
  createTransactionSchema,
} from "../validation/schemas.js";
import {
  listClients,
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

// All client routes require authentication
clientRouter.use(requireAuth);

// List all clients
clientRouter.get("/", async (req: Request, res: Response) => {
  try {
    const clients = await listClients(req.agentId!);
    res.json(clients);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

// Create a new client
clientRouter.post("/", async (req: Request, res: Response) => {
  try {
    const parsed = createClientSchema.safeParse(req.body);
    if (!parsed.success) {
      return res.status(400).json({ error: parsed.error.issues[0].message });
    }
    const client = await createClient(req.agentId!, parsed.data);
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
    const clients = await searchClients(req.agentId!, query);
    res.json(clients);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

// Get clients needing follow-up
clientRouter.get("/followups", async (req: Request, res: Response) => {
  try {
    const clients = await getClientsNeedingFollowup(req.agentId!);
    res.json(clients);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

// Get dormant clients
clientRouter.get("/dormant", async (req: Request, res: Response) => {
  try {
    const days = parseInt(req.query.days as string) || 60;
    const clients = await getDormantClients(req.agentId!, days);
    res.json(clients);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

// Get upcoming milestones
clientRouter.get("/milestones/upcoming", async (req: Request, res: Response) => {
  try {
    const days = parseInt(req.query.days as string) || 14;
    const milestones = await getUpcomingMilestones(req.agentId!, days);
    res.json(milestones);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

// Get a single client with full profile
clientRouter.get("/:id/full", async (req: Request, res: Response) => {
  try {
    const profile = await getFullClientProfile(req.agentId!, req.params.id as string);
    res.json(profile);
  } catch (err: any) {
    res.status(404).json({ error: err.message });
  }
});

// Get a single client
clientRouter.get("/:id", async (req: Request, res: Response) => {
  try {
    const client = await getClient(req.agentId!, req.params.id as string);
    res.json(client);
  } catch (err: any) {
    res.status(404).json({ error: err.message });
  }
});

// Update a client
clientRouter.patch("/:id", async (req: Request, res: Response) => {
  try {
    const parsed = updateClientSchema.safeParse(req.body);
    if (!parsed.success) {
      return res.status(400).json({ error: parsed.error.issues[0].message });
    }
    const client = await updateClient(req.agentId!, req.params.id as string, parsed.data);
    res.json(client);
  } catch (err: any) {
    res.status(400).json({ error: err.message });
  }
});

// Log an interaction
clientRouter.post("/:id/interactions", async (req: Request, res: Response) => {
  try {
    const parsed = logInteractionSchema.safeParse(req.body);
    if (!parsed.success) {
      return res.status(400).json({ error: parsed.error.issues[0].message });
    }
    const interaction = await logInteraction(req.agentId!, { ...parsed.data, client_id: req.params.id as string });
    res.status(201).json(interaction);
  } catch (err: any) {
    res.status(400).json({ error: err.message });
  }
});

// Get client interactions
clientRouter.get("/:id/interactions", async (req: Request, res: Response) => {
  try {
    const limit = parseInt(req.query.limit as string) || 20;
    const interactions = await getClientInteractions(req.agentId!, req.params.id as string, limit);
    res.json(interactions);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

// Add a milestone
clientRouter.post("/:id/milestones", async (req: Request, res: Response) => {
  try {
    const parsed = addMilestoneSchema.safeParse(req.body);
    if (!parsed.success) {
      return res.status(400).json({ error: parsed.error.issues[0].message });
    }
    const milestone = await addMilestone(req.agentId!, { ...parsed.data, client_id: req.params.id as string });
    res.status(201).json(milestone);
  } catch (err: any) {
    res.status(400).json({ error: err.message });
  }
});

// Create a transaction
clientRouter.post("/:id/transactions", async (req: Request, res: Response) => {
  try {
    const parsed = createTransactionSchema.safeParse(req.body);
    if (!parsed.success) {
      return res.status(400).json({ error: parsed.error.issues[0].message });
    }
    const transaction = await createTransaction(req.agentId!, { ...parsed.data, client_id: req.params.id as string });
    res.status(201).json(transaction);
  } catch (err: any) {
    res.status(400).json({ error: err.message });
  }
});

// Get client transactions
clientRouter.get("/:id/transactions", async (req: Request, res: Response) => {
  try {
    const transactions = await getClientTransactions(req.agentId!, req.params.id as string);
    res.json(transactions);
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});
