import { supabase } from "../db/supabase.js";
import type { Client, CreateClientInput, Interaction, Milestone, Transaction } from "../types/client.js";

// ── Clients ──

export async function createClient(input: CreateClientInput): Promise<Client> {
  const { data, error } = await supabase
    .from("clients")
    .insert(input)
    .select()
    .single();

  if (error) throw new Error(`Failed to create client: ${error.message}`);
  return data;
}

export async function getClient(id: string): Promise<Client> {
  const { data, error } = await supabase
    .from("clients")
    .select()
    .eq("id", id)
    .single();

  if (error) throw new Error(`Client not found: ${error.message}`);
  return data;
}

export async function searchClients(query: string): Promise<Client[]> {
  const { data, error } = await supabase
    .from("clients")
    .select()
    .or(`first_name.ilike.%${query}%,last_name.ilike.%${query}%,email.ilike.%${query}%`)
    .order("last_name");

  if (error) throw new Error(`Search failed: ${error.message}`);
  return data;
}

export async function updateClient(id: string, updates: Partial<CreateClientInput>): Promise<Client> {
  const { data, error } = await supabase
    .from("clients")
    .update(updates)
    .eq("id", id)
    .select()
    .single();

  if (error) throw new Error(`Failed to update client: ${error.message}`);
  return data;
}

export async function getClientsNeedingFollowup(): Promise<Client[]> {
  const { data, error } = await supabase
    .from("clients")
    .select()
    .lte("next_followup_date", new Date().toISOString())
    .eq("is_active", true)
    .order("next_followup_date");

  if (error) throw new Error(`Followup query failed: ${error.message}`);
  return data;
}

export async function getDormantClients(daysSinceContact: number): Promise<Client[]> {
  const cutoff = new Date();
  cutoff.setDate(cutoff.getDate() - daysSinceContact);

  const { data, error } = await supabase
    .from("clients")
    .select()
    .lt("last_contact_date", cutoff.toISOString())
    .eq("is_active", true)
    .order("last_contact_date");

  if (error) throw new Error(`Dormant query failed: ${error.message}`);
  return data;
}

// ── Interactions ──

export async function logInteraction(input: Omit<Interaction, "id" | "created_at">): Promise<Interaction> {
  const { data, error } = await supabase
    .from("interactions")
    .insert(input)
    .select()
    .single();

  if (error) throw new Error(`Failed to log interaction: ${error.message}`);

  // Update client's last_contact_date
  await supabase
    .from("clients")
    .update({ last_contact_date: new Date().toISOString() })
    .eq("id", input.client_id);

  return data;
}

export async function getClientInteractions(clientId: string, limit = 20): Promise<Interaction[]> {
  const { data, error } = await supabase
    .from("interactions")
    .select()
    .eq("client_id", clientId)
    .order("created_at", { ascending: false })
    .limit(limit);

  if (error) throw new Error(`Failed to get interactions: ${error.message}`);
  return data;
}

// ── Milestones ──

export async function addMilestone(input: Omit<Milestone, "id" | "created_at">): Promise<Milestone> {
  const { data, error } = await supabase
    .from("milestones")
    .insert(input)
    .select()
    .single();

  if (error) throw new Error(`Failed to add milestone: ${error.message}`);
  return data;
}

export async function getUpcomingMilestones(daysAhead: number): Promise<(Milestone & { client: Client })[]> {
  const now = new Date();
  const future = new Date();
  future.setDate(future.getDate() + daysAhead);

  const { data, error } = await supabase
    .from("milestones")
    .select("*, client:clients(*)")
    .gte("milestone_date", now.toISOString().split("T")[0])
    .lte("milestone_date", future.toISOString().split("T")[0])
    .order("milestone_date");

  if (error) throw new Error(`Milestone query failed: ${error.message}`);
  return data as (Milestone & { client: Client })[];
}

// ── Transactions ──

export async function createTransaction(input: Omit<Transaction, "id" | "created_at" | "updated_at">): Promise<Transaction> {
  const { data, error } = await supabase
    .from("transactions")
    .insert(input)
    .select()
    .single();

  if (error) throw new Error(`Failed to create transaction: ${error.message}`);
  return data;
}

export async function getClientTransactions(clientId: string): Promise<Transaction[]> {
  const { data, error } = await supabase
    .from("transactions")
    .select()
    .eq("client_id", clientId)
    .order("created_at", { ascending: false });

  if (error) throw new Error(`Failed to get transactions: ${error.message}`);
  return data;
}

// ── Full Client Profile (everything in one call) ──

export async function getFullClientProfile(clientId: string) {
  const [client, interactions, milestones, transactions] = await Promise.all([
    getClient(clientId),
    getClientInteractions(clientId),
    supabase.from("milestones").select().eq("client_id", clientId).order("milestone_date"),
    getClientTransactions(clientId),
  ]);

  return {
    client,
    interactions,
    milestones: milestones.data || [],
    transactions,
  };
}
