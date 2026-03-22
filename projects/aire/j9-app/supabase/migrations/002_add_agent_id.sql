-- Add agent_id to all tables for multi-tenant isolation
-- agent_id maps to auth.users.id (the Supabase Auth user)

alter table clients add column agent_id uuid references auth.users(id);
alter table interactions add column agent_id uuid references auth.users(id);
alter table milestones add column agent_id uuid references auth.users(id);
alter table transactions add column agent_id uuid references auth.users(id);

-- Indexes for filtering by agent
create index idx_clients_agent on clients(agent_id);
create index idx_interactions_agent on interactions(agent_id);
create index idx_milestones_agent on milestones(agent_id);
create index idx_transactions_agent on transactions(agent_id);

-- RLS policies: agents can only see/modify their own data
-- Using the service role key bypasses RLS, so these protect direct DB access

create policy "Agents see own clients"
  on clients for select
  using (agent_id = auth.uid());

create policy "Agents insert own clients"
  on clients for insert
  with check (agent_id = auth.uid());

create policy "Agents update own clients"
  on clients for update
  using (agent_id = auth.uid());

create policy "Agents see own interactions"
  on interactions for select
  using (agent_id = auth.uid());

create policy "Agents insert own interactions"
  on interactions for insert
  with check (agent_id = auth.uid());

create policy "Agents see own milestones"
  on milestones for select
  using (agent_id = auth.uid());

create policy "Agents insert own milestones"
  on milestones for insert
  with check (agent_id = auth.uid());

create policy "Agents see own transactions"
  on transactions for select
  using (agent_id = auth.uid());

create policy "Agents insert own transactions"
  on transactions for insert
  with check (agent_id = auth.uid());

create policy "Agents update own transactions"
  on transactions for update
  using (agent_id = auth.uid());
