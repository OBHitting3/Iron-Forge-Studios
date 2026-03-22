import { Request, Response, NextFunction } from "express";
import { supabase } from "../db/supabase.js";

// Extend Express Request to include authenticated user
declare global {
  namespace Express {
    interface Request {
      agentId?: string;
    }
  }
}

/**
 * Verifies the Supabase JWT from the Authorization header.
 * Attaches `req.agentId` (the user's Supabase auth ID) to the request.
 */
export async function requireAuth(req: Request, res: Response, next: NextFunction) {
  const authHeader = req.headers.authorization;
  if (!authHeader?.startsWith("Bearer ")) {
    return res.status(401).json({ error: "Missing or invalid authorization header" });
  }

  const token = authHeader.slice(7);

  const { data, error } = await supabase.auth.getUser(token);
  if (error || !data.user) {
    return res.status(401).json({ error: "Invalid or expired token" });
  }

  req.agentId = data.user.id;
  next();
}
