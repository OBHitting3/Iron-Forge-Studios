import { z } from "zod";

export const createClientSchema = z.object({
  first_name: z.string().min(1, "First name is required"),
  last_name: z.string().min(1, "Last name is required"),
  email: z.string().email().optional().or(z.literal("")),
  phone: z.string().optional(),
  secondary_phone: z.string().optional(),
  mailing_address: z.string().optional(),
  city: z.string().optional(),
  state: z.string().optional(),
  zip: z.string().optional(),
  relationship_type: z.enum(["client", "prospect", "vendor", "personal", "referral"]).default("client"),
  relationship_tier: z.enum(["vip", "standard", "dormant"]).default("standard"),
  source: z.string().optional(),
  spouse_name: z.string().optional(),
  children: z.string().optional(),
  birthday: z.string().optional(),
  anniversary: z.string().optional(),
  interests: z.string().optional(),
  pet_info: z.string().optional(),
  notes: z.string().optional(),
  preferred_communities: z.array(z.string()).optional(),
  property_preferences: z.string().optional(),
  price_range_low: z.number().positive().optional(),
  price_range_high: z.number().positive().optional(),
  is_buyer: z.boolean().default(false),
  is_seller: z.boolean().default(false),
  current_property_address: z.string().optional(),
});

export const updateClientSchema = createClientSchema.partial();

export const logInteractionSchema = z.object({
  interaction_type: z.enum(["email", "call", "text", "meeting", "open_house", "event", "note"]),
  direction: z.enum(["inbound", "outbound", "internal"]).default("outbound"),
  channel: z.string().optional(),
  subject: z.string().optional(),
  content: z.string().optional(),
  ai_generated: z.boolean().default(false),
  sentiment: z.enum(["positive", "neutral", "negative", "urgent"]).optional(),
  follow_up_needed: z.boolean().default(false),
  follow_up_date: z.string().optional(),
  follow_up_note: z.string().optional(),
});

export const addMilestoneSchema = z.object({
  milestone_type: z.enum(["birthday", "anniversary", "purchase_anniversary", "closing", "listing", "move_in", "life_event"]),
  title: z.string().min(1, "Title is required"),
  milestone_date: z.string().min(1, "Date is required"),
  recurring: z.boolean().default(false),
  notes: z.string().optional(),
});

export const createTransactionSchema = z.object({
  transaction_type: z.enum(["purchase", "sale", "lease", "referral"]),
  status: z.enum(["prospect", "active", "pending", "closed", "cancelled"]).default("active"),
  property_address: z.string().min(1, "Property address is required"),
  community: z.string().optional(),
  list_price: z.number().positive().optional(),
  sale_price: z.number().positive().optional(),
  listing_date: z.string().optional(),
  closing_date: z.string().optional(),
  escrow_number: z.string().optional(),
  representing: z.enum(["buyer", "seller", "dual"]).optional(),
  co_agent_name: z.string().optional(),
  co_agent_brokerage: z.string().optional(),
  commission_rate: z.number().optional(),
  commission_amount: z.number().optional(),
  notes: z.string().optional(),
});
