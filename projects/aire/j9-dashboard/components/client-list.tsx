'use client'

import { useState } from 'react'
import Link from 'next/link'
import { Client } from '@/types/client'
import { engagementColor, engagementLabel, daysSince, formatDate } from '@/lib/utils'

interface ClientListProps {
  clients: Client[]
}

export default function ClientList({ clients }: ClientListProps) {
  const [search, setSearch] = useState('')

  const filtered = clients.filter((c) => {
    const q = search.toLowerCase()
    return (
      c.first_name.toLowerCase().includes(q) ||
      c.last_name.toLowerCase().includes(q) ||
      (c.email ?? '').toLowerCase().includes(q) ||
      (c.phone ?? '').includes(q)
    )
  })

  if (clients.length === 0) {
    return (
      <div className="text-center py-16">
        <p className="text-4xl mb-3">📋</p>
        <p className="font-semibold" style={{ color: 'var(--foreground)' }}>No clients yet</p>
        <p className="text-sm mt-1" style={{ color: 'var(--muted)' }}>Import a CSV to get started</p>
        <Link
          href="/dashboard/clients/import"
          className="inline-block mt-4 px-5 py-2.5 rounded-xl text-sm font-semibold text-white"
          style={{ background: 'var(--accent)' }}
        >
          Import Contacts
        </Link>
      </div>
    )
  }

  return (
    <div>
      {/* Search */}
      <div className="relative mb-4">
        <svg className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} style={{ color: 'var(--muted)' }}>
          <circle cx="11" cy="11" r="8" /><path d="m21 21-4.35-4.35" strokeLinecap="round" />
        </svg>
        <input
          type="search"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          placeholder="Search clients…"
          className="w-full pl-9 pr-4 py-3 rounded-xl text-sm outline-none"
          style={{
            background: 'var(--card)',
            border: '1px solid var(--card-border)',
            color: 'var(--foreground)',
          }}
        />
      </div>

      {/* Client Cards */}
      <div className="space-y-2">
        {filtered.length === 0 ? (
          <p className="text-center py-8 text-sm" style={{ color: 'var(--muted)' }}>No clients match "{search}"</p>
        ) : (
          filtered.map((client) => (
            <ClientCard key={client.id} client={client} />
          ))
        )}
      </div>
    </div>
  )
}

function ClientCard({ client }: { client: Client }) {
  const days = daysSince(client.last_contacted_at)
  const dotColor = engagementColor(client.engagement_score)
  const label = engagementLabel(client.engagement_score)

  return (
    <Link
      href={`/dashboard/clients/${client.id}`}
      className="flex items-center gap-3 px-4 py-3.5 rounded-xl transition-opacity active:opacity-70"
      style={{ background: 'var(--card)', border: '1px solid var(--card-border)' }}
    >
      {/* Avatar */}
      <div className="flex-shrink-0 w-11 h-11 rounded-full flex items-center justify-center text-sm font-semibold" style={{ background: 'var(--accent)', color: '#fff' }}>
        {client.first_name[0]}{client.last_name[0]}
      </div>

      {/* Info */}
      <div className="flex-1 min-w-0">
        <p className="font-semibold text-sm truncate" style={{ color: 'var(--foreground)' }}>
          {client.first_name} {client.last_name}
        </p>
        <p className="text-xs truncate mt-0.5" style={{ color: 'var(--muted)' }}>
          {client.email ?? client.phone ?? 'No contact info'}
        </p>
      </div>

      {/* Engagement + Last Contact */}
      <div className="flex-shrink-0 text-right">
        <div className="flex items-center gap-1.5 justify-end">
          <div className={`w-2 h-2 rounded-full ${dotColor}`} />
          <span className="text-xs font-medium" style={{ color: 'var(--muted)' }}>{label}</span>
        </div>
        <p className="text-xs mt-1" style={{ color: 'var(--muted)' }}>
          {days === 999 ? 'Never' : days === 0 ? 'Today' : `${days}d ago`}
        </p>
      </div>
    </Link>
  )
}
