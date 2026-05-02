export interface Client {
  id: string;
  first_name: string;
  last_name: string;
  email: string | null;
  phone: string | null;
  secondary_phone: string | null;
  mailing_address: string | null;
  city: string | null;
  state: string | null;
  zip: string | null;
  relationship_type: string;
  relationship_tier: string;
  source: string | null;
  referred_by: string | null;
  spouse_name: string | null;
  children: string | null;
  birthday: string | null;
  anniversary: string | null;
  interests: string | null;
  pet_info: string | null;
  notes: string | null;
  preferred_communities: string[] | null;
  property_preferences: string | null;
  price_range_low: number | null;
  price_range_high: number | null;
  is_buyer: boolean;
  is_seller: boolean;
  current_property_address: string | null;
  last_contact_date: string | null;
  next_followup_date: string | null;
  engagement_score: number;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface CreateClientInput {
  first_name: string;
  last_name: string;
  email?: string;
  phone?: string;
  relationship_type?: string;
  relationship_tier?: string;
  source?: string;
  spouse_name?: string;
  children?: string;
  birthday?: string;
  anniversary?: string;
  interests?: string;
  pet_info?: string;
  notes?: string;
  preferred_communities?: string[];
  property_preferences?: string;
  price_range_low?: number;
  price_range_high?: number;
  is_buyer?: boolean;
  is_seller?: boolean;
  current_property_address?: string;
}

export interface Interaction {
  id: string;
  client_id: string;
  interaction_type: string;
  direction: string;
  channel: string | null;
  subject: string | null;
  content: string | null;
  ai_generated: boolean;
  approved_by_janine: boolean | null;
  sentiment: string | null;
  follow_up_needed: boolean;
  follow_up_date: string | null;
  follow_up_note: string | null;
  created_at: string;
}

export interface Milestone {
  id: string;
  client_id: string;
  milestone_type: string;
  title: string;
  milestone_date: string;
  recurring: boolean;
  notes: string | null;
  created_at: string;
}

export interface Transaction {
  id: string;
  client_id: string;
  transaction_type: string;
  status: string;
  property_address: string;
  community: string | null;
  list_price: number | null;
  sale_price: number | null;
  listing_date: string | null;
  closing_date: string | null;
  escrow_number: string | null;
  representing: string | null;
  co_agent_name: string | null;
  co_agent_brokerage: string | null;
  commission_rate: number | null;
  commission_amount: number | null;
  notes: string | null;
  created_at: string;
  updated_at: string;
}
