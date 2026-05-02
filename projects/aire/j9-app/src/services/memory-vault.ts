import { supabase } from "../db/supabase.js";
import type { Client, CreateClientInput, Interaction, Milestone, Transaction } from "../types/client.js";

// ── Clients ──

export async function listClients(agentId: string): Promise<Client[]> {
  const { data, error } = await supabase
    .from("clients")
    .select()
    .eq("agent_id", agentId)
    .eq("is_active", true)
    .order("last_name");

  if (error) throw new Error(`Failed to list clients: ${error.message}`);
  return data;
}

export async function createClient(agentId: string, input: CreateClientInput): Promise<Client> {
  const { data, error } = await supabase
    .from("clients")
    .insert({ ...input, agent_id: agentId })
    .select()
    .single();

  if (error) throw new Error(`Failed to create client: ${error.message}`);
  return data;
}

export async function getClient(agentId: string, id: string): Promise<Client> {
  const { data, error } = await supabase
    .from("clients")
    .select()
    .eq("id", id)
    .eq("agent_id", agentId)
    .single();

  if (error) throw new Error(`Client not found: ${error.message}`);
  return data;
}

export async function searchClients(agentId: string, query: string): Promise<Client[]> {
  // Sanitize query to prevent filter injection — remove characters that could break the Supabase filter syntax
  const sanitized = query.replace(/[%_\\(),."']/g, "");
  if (!sanitized) return [];

  const { data, error } = await supabase
    .from("clients")
    .select()
    .eq("agent_id", agentId)
    .or(`first_name.ilike.%${sanitized}%,last_name.ilike.%${sanitized}%,email.ilike.%${sanitized}%`)
    .order("last_name");

  if (error) throw new Error(`Search failed: ${error.message}`);
  return data;
}

export async function updateClient(agentId: string, id: string, updates: Partial<CreateClientInput>): Promise<Client> {
  const { data, error } = await supabase
    .from("clients")
    .update(updates)
    .eq("id", id)
    .eq("agent_id", agentId)
    .select()
    .single();

  if (error) throw new Error(`Failed to update client: ${error.message}`);
  return data;
}

export async function getClientsNeedingFollowup(agentId: string): Promise<Client[]> {
  const { data, error } = await supabase
    .from("clients")
    .select()
    .eq("agent_id", agentId)
    .lte("next_followup_date", new Date().toISOString())
    .eq("is_active", true)
    .order("next_followup_date");

  if (error) throw new Error(`Followup query failed: ${error.message}`);
  return data;
}

export async function getDormantClients(agentId: string, daysSinceContact: number): Promise<Client[]> {
  const cutoff = new Date();
  cutoff.setDate(cutoff.getDate() - daysSinceContact);

  const { data, error } = await supabase
    .from("clients")
    .select()
    .eq("agent_id", agentId)
    .lt("last_contact_date", cutoff.toISOString())
    .eq("is_active", true)
    .order("last_contact_date");

  if (error) throw new Error(`Dormant query failed: ${error.message}`);
  return data;
}

// ── Interactions ──

export async function logInteraction(agentId: string, input: Record<string, unknown>): Promise<Interaction> {
  const { data, error } = await supabase
    .from("interactions")
    .insert({ ...input, agent_id: agentId })
    .select()
    .single();

  if (error) throw new Error(`Failed to log interaction: ${error.message}`);

  const { error: updateError } = await supabase
    .from("clients")
    .update({ last_contact_date: new Date().toISOString() })
    .eq("id", input.client_id as string)
    .eq("agent_id", agentId);

  if (updateError) throw new Error(`Interaction logged but failed to update client contact date: ${updateError.message}`);

  return data;
}

export async function getClientInteractions(agentId: string, clientId: string, limit = 20): Promise<Interaction[]> {
  const { data, error } = await supabase
    .from("interactions")
    .select()
    .eq("client_id", clientId)
    .eq("agent_id", agentId)
    .order("created_at", { ascending: false })
    .limit(limit);

  if (error) throw new Error(`Failed to get interactions: ${error.message}`);
  return data;
}

// ── Milestones ──

export async function addMilestone(agentId: string, input: Record<string, unknown>): Promise<Milestone> {
  const { data, error } = await supabase
    .from("milestones")
    .insert({ ...input, agent_id: agentId })
    .select()
    .single();

  if (error) throw new Error(`Failed to add milestone: ${error.message}`);
  return data;
}

export async function getUpcomingMilestones(agentId: string, daysAhead: number): Promise<(Milestone & { client: Client })[]> {
  const now = new Date();
  const future = new Date();
  future.setDate(future.getDate() + daysAhead);

  const { data, error } = await supabase
    .from("milestones")
    .select("*, client:clients(*)")
    .eq("agent_id", agentId)
    .gte("milestone_date", now.toISOString().split("T")[0])
    .lte("milestone_date", future.toISOString().split("T")[0])
    .order("milestone_date");

  if (error) throw new Error(`Milestone query failed: ${error.message}`);
  return data as (Milestone & { client: Client })[];
}

// ── Transactions ──

export async function createTransaction(agentId: string, input: Record<string, unknown>): Promise<Transaction> {
  const { data, error } = await supabase
    .from("transactions")
    .insert({ ...input, agent_id: agentId })
    .select()
    .single();

  if (error) throw new Error(`Failed to create transaction: ${error.message}`);
  return data;
}

export async function getClientTransactions(agentId: string, clientId: string): Promise<Transaction[]> {
  const { data, error } = await supabase
    .from("transactions")
    .select()
    .eq("client_id", clientId)
    .eq("agent_id", agentId)
    .order("created_at", { ascending: false });

  if (error) throw new Error(`Failed to get transactions: ${error.message}`);
  return data;
}

// ── Full Client Profile (everything in one call) ──

export async function getFullClientProfile(agentId: string, clientId: string) {
  const [client, interactions, milestones, transactions] = await Promise.all([
    getClient(agentId, clientId),
    getClientInteractions(agentId, clientId),
    getClientMilestones(agentId, clientId),
    getClientTransactions(agentId, clientId),
  ]);

  return { client, interactions, milestones, transactions };
}

async function getClientMilestones(agentId: string, clientId: string): Promise<Milestone[]> {
  const { data, error } = await supabase
    .from("milestones")
    .select()
    .eq("client_id", clientId)
    .eq("agent_id", agentId)
    .order("milestone_date");

  if (error) throw new Error(`Failed to get milestones: ${error.message}`);
  return data;
}
