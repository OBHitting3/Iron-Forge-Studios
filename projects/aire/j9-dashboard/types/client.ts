export type ClientStatus = 'active' | 'past' | 'prospect' | 'vip'

export interface Client {
  id: string
  agent_id: string
  first_name: string
  last_name: string
  email: string | null
  phone: string | null
  status: ClientStatus
  engagement_score: number | null
  last_contacted_at: string | null
  follow_up_date: string | null
  notes: string | null
  tags: string[] | null
  created_at: string
  updated_at: string
}

export interface Interaction {
  id: string
  client_id: string
  type: string
  summary: string
  occurred_at: string
  created_at: string
}

export interface Milestone {
  id: string
  client_id: string
  type: string
  label: string
  date: string
  notes: string | null
}
