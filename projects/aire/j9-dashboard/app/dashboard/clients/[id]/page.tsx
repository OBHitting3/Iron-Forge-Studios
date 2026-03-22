import { createClient } from '@/lib/supabase/server'
import { notFound } from 'next/navigation'

export const dynamic = 'force-dynamic'
import Link from 'next/link'
import { formatDate, daysSince, engagementColor, engagementLabel } from '@/lib/utils'
import type { Client, Interaction, Milestone, Transaction } from '@/types/client'
import LogInteraction from '@/components/log-interaction'

async function getClientFull(clientId: string, token: string) {
  const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000'
  try {
    const res = await fetch(`${apiUrl}/api/clients/${clientId}/full`, {
      cache: 'no-store',
      headers: { 'Authorization': `Bearer ${token}` },
    })
    if (!res.ok) return null
    return res.json()
  } catch {
    return null
  }
}

export default async function ClientProfilePage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) notFound()

  const { data: { session } } = await supabase.auth.getSession()
  const data = await getClientFull(id, session?.access_token ?? '')
  if (!data) notFound()

  const client: Client = data.client ?? data
  const interactions: Interaction[] = data.interactions ?? []
  const milestones: Milestone[] = data.milestones ?? []
  const transactions: Transaction[] = data.transactions ?? []

  const days = daysSince(client.last_contact_date)
  const dotColor = engagementColor(client.engagement_score)
  const label = engagementLabel(client.engagement_score)

  return (
    <div className="px-4 max-w-2xl mx-auto">
      {/* Back */}
      <Link href="/dashboard" className="inline-flex items-center gap-1.5 text-sm mb-5" style={{ color: 'var(--muted)' }}>
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} className="w-4 h-4">
          <path d="M19 12H5M5 12l7-7M5 12l7 7" strokeLinecap="round" strokeLinejoin="round" />
        </svg>
        Back to Clients
      </Link>

      {/* Client Header */}
      <div className="p-5 rounded-2xl mb-4" style={{ background: 'var(--card)', border: '1px solid var(--card-border)' }}>
        <div className="flex items-center gap-4">
          <div className="w-16 h-16 rounded-full flex items-center justify-center text-xl font-bold" style={{ background: 'var(--accent)', color: '#fff' }}>
            {client.first_name[0]}{client.last_name[0]}
          </div>
          <div className="flex-1 min-w-0">
            <h1 className="text-xl font-bold truncate" style={{ color: 'var(--foreground)' }}>
              {client.first_name} {client.last_name}
            </h1>
            <div className="flex items-center gap-1.5 mt-1">
              <div className={`w-2 h-2 rounded-full ${dotColor}`} />
              <span className="text-sm" style={{ color: 'var(--muted)' }}>{label}</span>
              {client.relationship_tier === 'vip' && (
                <span className="text-xs px-2 py-0.5 rounded-full font-medium" style={{ background: '#3b2505', color: '#f59e0b' }}>VIP</span>
              )}
            </div>
          </div>
        </div>

        {/* Contact Info */}
        <div className="mt-4 space-y-2">
          {client.email && (
            <a href={`mailto:${client.email}`} className="flex items-center gap-2 text-sm" style={{ color: 'var(--foreground)' }}>
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} className="w-4 h-4 flex-shrink-0" style={{ color: 'var(--muted)' }}>
                <rect width="20" height="16" x="2" y="4" rx="2" /><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7" strokeLinecap="round" />
              </svg>
              {client.email}
            </a>
          )}
          {client.phone && (
            <a href={`tel:${client.phone}`} className="flex items-center gap-2 text-sm" style={{ color: 'var(--foreground)' }}>
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} className="w-4 h-4 flex-shrink-0" style={{ color: 'var(--muted)' }}>
                <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 12a19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 3.64 1h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L7.91 8.6a16 16 0 0 0 5.55 5.55l.98-.98a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z" strokeLinecap="round" strokeLinejoin="round" />
              </svg>
              {client.phone}
            </a>
          )}
        </div>

        {/* Real estate context */}
        {(client.interests || client.property_preferences) && (
          <div className="mt-4 pt-4 space-y-2" style={{ borderTop: '1px solid var(--card-border)' }}>
            {client.interests && (
              <p className="text-sm" style={{ color: 'var(--muted)' }}>
                <span className="font-medium" style={{ color: 'var(--foreground)' }}>Interests:</span> {client.interests}
              </p>
            )}
            {client.property_preferences && (
              <p className="text-sm" style={{ color: 'var(--muted)' }}>
                <span className="font-medium" style={{ color: 'var(--foreground)' }}>Looking for:</span> {client.property_preferences}
              </p>
            )}
          </div>
        )}

        {/* Stats row */}
        <div className="grid grid-cols-3 gap-3 mt-4 pt-4" style={{ borderTop: '1px solid var(--card-border)' }}>
          <div className="text-center">
            <p className="text-lg font-bold" style={{ color: 'var(--foreground)' }}>{client.engagement_score ?? 0}</p>
            <p className="text-xs" style={{ color: 'var(--muted)' }}>Score</p>
          </div>
          <div className="text-center">
            <p className="text-lg font-bold" style={{ color: 'var(--foreground)' }}>{days === 999 ? '—' : `${days}d`}</p>
            <p className="text-xs" style={{ color: 'var(--muted)' }}>Since contact</p>
          </div>
          <div className="text-center">
            <p className="text-lg font-bold" style={{ color: 'var(--foreground)' }}>{interactions.length}</p>
            <p className="text-xs" style={{ color: 'var(--muted)' }}>Interactions</p>
          </div>
        </div>
      </div>

      {/* Follow-up date */}
      {client.next_followup_date && (
        <div className="px-4 py-3 rounded-xl mb-4 flex items-center gap-2" style={{ background: '#1a1a2e', border: '1px solid var(--accent)' }}>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} className="w-4 h-4 flex-shrink-0" style={{ color: 'var(--accent-light)' }}>
            <rect width="18" height="18" x="3" y="4" rx="2" /><path d="M16 2v4M8 2v4M3 10h18" strokeLinecap="round" />
          </svg>
          <p className="text-sm" style={{ color: 'var(--accent-light)' }}>
            Follow up on <strong>{formatDate(client.next_followup_date)}</strong>
          </p>
        </div>
      )}

      {/* Notes */}
      {client.notes && (
        <div className="p-4 rounded-xl mb-4" style={{ background: 'var(--card)', border: '1px solid var(--card-border)' }}>
          <p className="text-xs font-semibold uppercase tracking-wider mb-2" style={{ color: 'var(--muted)' }}>Notes</p>
          <p className="text-sm leading-relaxed" style={{ color: 'var(--foreground)' }}>{client.notes}</p>
        </div>
      )}

      {/* Log Interaction */}
      <LogInteraction clientId={client.id} />

      {/* Personal details */}
      {(client.spouse_name || client.children || client.pet_info || client.birthday) && (
        <div className="p-4 rounded-xl mb-4" style={{ background: 'var(--card)', border: '1px solid var(--card-border)' }}>
          <p className="text-xs font-semibold uppercase tracking-wider mb-3" style={{ color: 'var(--muted)' }}>Personal Details</p>
          <div className="space-y-2 text-sm">
            {client.spouse_name && (
              <p style={{ color: 'var(--foreground)' }}><span style={{ color: 'var(--muted)' }}>Spouse:</span> {client.spouse_name}</p>
            )}
            {client.children && (
              <p style={{ color: 'var(--foreground)' }}><span style={{ color: 'var(--muted)' }}>Children:</span> {client.children}</p>
            )}
            {client.pet_info && (
              <p style={{ color: 'var(--foreground)' }}><span style={{ color: 'var(--muted)' }}>Pets:</span> {client.pet_info}</p>
            )}
            {client.birthday && (
              <p style={{ color: 'var(--foreground)' }}><span style={{ color: 'var(--muted)' }}>Birthday:</span> {formatDate(client.birthday)}</p>
            )}
            {client.anniversary && (
              <p style={{ color: 'var(--foreground)' }}><span style={{ color: 'var(--muted)' }}>Anniversary:</span> {formatDate(client.anniversary)}</p>
            )}
          </div>
        </div>
      )}

      {/* Milestones */}
      {milestones.length > 0 && (
        <div className="p-4 rounded-xl mb-4" style={{ background: 'var(--card)', border: '1px solid var(--card-border)' }}>
          <p className="text-xs font-semibold uppercase tracking-wider mb-3" style={{ color: 'var(--muted)' }}>Milestones</p>
          <div className="space-y-2">
            {milestones.map((m) => (
              <div key={m.id} className="flex items-center justify-between">
                <span className="text-sm" style={{ color: 'var(--foreground)' }}>{m.title}</span>
                <span className="text-xs" style={{ color: 'var(--muted)' }}>{formatDate(m.milestone_date)}</span>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Transactions */}
      {transactions.length > 0 && (
        <div className="p-4 rounded-xl mb-4" style={{ background: 'var(--card)', border: '1px solid var(--card-border)' }}>
          <p className="text-xs font-semibold uppercase tracking-wider mb-3" style={{ color: 'var(--muted)' }}>Transactions</p>
          <div className="space-y-3">
            {transactions.map((t) => (
              <div key={t.id} className="flex gap-3">
                <div className="flex-shrink-0 w-1 rounded-full" style={{ background: t.status === 'closed' ? '#10b981' : 'var(--accent)' }} />
                <div className="flex-1 min-w-0">
                  <p className="text-xs font-medium uppercase" style={{ color: t.status === 'closed' ? '#10b981' : 'var(--accent-light)' }}>
                    {t.transaction_type} — {t.status}
                  </p>
                  <p className="text-sm mt-0.5" style={{ color: 'var(--foreground)' }}>{t.property_address}</p>
                  {t.sale_price && (
                    <p className="text-xs mt-0.5" style={{ color: 'var(--muted)' }}>
                      ${t.sale_price.toLocaleString()}
                    </p>
                  )}
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Recent Interactions */}
      {interactions.length > 0 && (
        <div className="p-4 rounded-xl mb-4" style={{ background: 'var(--card)', border: '1px solid var(--card-border)' }}>
          <p className="text-xs font-semibold uppercase tracking-wider mb-3" style={{ color: 'var(--muted)' }}>Interaction History</p>
          <div className="space-y-3">
            {interactions.slice(0, 10).map((i) => (
              <div key={i.id} className="flex gap-3">
                <div className="flex-shrink-0 w-1 rounded-full" style={{ background: 'var(--accent)' }} />
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2">
                    <p className="text-xs font-medium uppercase" style={{ color: 'var(--accent-light)' }}>{i.interaction_type}</p>
                    <p className="text-xs" style={{ color: 'var(--muted)' }}>{i.direction}</p>
                  </div>
                  {i.subject && <p className="text-sm font-medium mt-0.5" style={{ color: 'var(--foreground)' }}>{i.subject}</p>}
                  {i.content && <p className="text-sm mt-0.5" style={{ color: 'var(--foreground)' }}>{i.content}</p>}
                  <p className="text-xs mt-1" style={{ color: 'var(--muted)' }}>{formatDate(i.created_at)}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  )
}
