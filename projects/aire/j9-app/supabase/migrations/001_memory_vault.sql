-- J9-AiRE Memory Vault Schema
-- Module 1: The foundation. Every other module reads from this.

-- Clients: the people Janine knows
create table clients (
  id uuid primary key default gen_random_uuid(),
  first_name text not null,
  last_name text not null,
  email text,
  phone text,
  secondary_phone text,
  mailing_address text,
  city text,
  state text,
  zip text,

  -- Relationship context
  relationship_type text not null default 'client',  -- client, prospect, vendor, personal, referral
  relationship_tier text not null default 'standard', -- vip, standard, dormant
  source text,           -- how Janine knows them: referral, open house, repeat, etc.
  referred_by uuid references clients(id),

  -- Personal details the AI remembers
  spouse_name text,
  children text,         -- free text: "two sons, Mike and David"
  birthday date,
  anniversary date,
  interests text,        -- free text: "golf, wine, mid-century architecture"
  pet_info text,         -- "golden retriever named Max"
  notes text,            -- anything else Janine wants to remember

  -- Real estate specifics
  preferred_communities text[], -- '{Madison Club, The Hideaway, PGA West}'
  property_preferences text,    -- "single story, pool, mountain view, 3500+ sqft"
  price_range_low numeric,
  price_range_high numeric,
  is_buyer boolean default false,
  is_seller boolean default false,
  current_property_address text,

  -- Status
  last_contact_date timestamptz,
  next_followup_date timestamptz,
  engagement_score integer default 50, -- 0-100, calculated by the system
  is_active boolean default true,

  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Interactions: every touchpoint with a client
create table interactions (
  id uuid primary key default gen_random_uuid(),
  client_id uuid not null references clients(id) on delete cascade,

  interaction_type text not null, -- email, call, text, meeting, open_house, event, note
  direction text not null default 'outbound', -- inbound, outbound, internal
  channel text,          -- phone, email, sms, in_person, zoom

  subject text,
  content text,          -- the actual message or summary
  ai_generated boolean default false,  -- was this drafted by J9?
  approved_by_janine boolean,          -- did Janine approve it before sending?

  sentiment text,        -- positive, neutral, negative, urgent
  follow_up_needed boolean default false,
  follow_up_date date,
  follow_up_note text,

  created_at timestamptz default now()
);

-- Milestones: important dates and events per client
create table milestones (
  id uuid primary key default gen_random_uuid(),
  client_id uuid not null references clients(id) on delete cascade,

  milestone_type text not null, -- birthday, anniversary, purchase_anniversary, closing, listing, move_in, life_event
  title text not null,          -- "Bought 45678 Via Esperanza"
  milestone_date date not null,
  recurring boolean default false, -- birthdays recur, closings don't
  notes text,

  created_at timestamptz default now()
);

-- Transactions: deal history
create table transactions (
  id uuid primary key default gen_random_uuid(),
  client_id uuid not null references clients(id) on delete cascade,

  transaction_type text not null, -- purchase, sale, lease, referral
  status text not null default 'active', -- prospect, active, pending, closed, cancelled
  property_address text not null,
  community text,        -- Madison Club, PGA West, etc.

  list_price numeric,
  sale_price numeric,
  listing_date date,
  closing_date date,
  escrow_number text,

  representing text,     -- buyer, seller, dual
  co_agent_name text,
  co_agent_brokerage text,

  commission_rate numeric,
  commission_amount numeric,

  notes text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Tags: flexible labeling for clients
create table client_tags (
  id uuid primary key default gen_random_uuid(),
  client_id uuid not null references clients(id) on delete cascade,
  tag text not null,
  created_at timestamptz default now(),
  unique(client_id, tag)
);

-- Auto-update the updated_at timestamp
create or replace function update_modified_column()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger clients_updated_at before update on clients
  for each row execute function update_modified_column();

create trigger transactions_updated_at before update on transactions
  for each row execute function update_modified_column();

-- Row Level Security: lock everything down
alter table clients enable row level security;
alter table interactions enable row level security;
alter table milestones enable row level security;
alter table transactions enable row level security;
alter table client_tags enable row level security;

-- Indexes for the queries we'll hit most
create index idx_clients_last_contact on clients(last_contact_date);
create index idx_clients_next_followup on clients(next_followup_date);
create index idx_clients_tier on clients(relationship_tier);
create index idx_interactions_client on interactions(client_id, created_at desc);
create index idx_milestones_date on milestones(milestone_date);
create index idx_transactions_client on transactions(client_id);
create index idx_transactions_status on transactions(status);
