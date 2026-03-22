'use client'

import { useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import { useRouter } from 'next/navigation'

const TYPES = [
  { value: 'call', label: 'Call' },
  { value: 'email', label: 'Email' },
  { value: 'text', label: 'Text' },
  { value: 'meeting', label: 'Meeting' },
  { value: 'note', label: 'Note' },
]

const DIRECTIONS = [
  { value: 'outbound', label: 'Outbound' },
  { value: 'inbound', label: 'Inbound' },
  { value: 'internal', label: 'Internal' },
]

export default function LogInteraction({ clientId }: { clientId: string }) {
  const router = useRouter()
  const [open, setOpen] = useState(false)
  const [saving, setSaving] = useState(false)
  const [type, setType] = useState('call')
  const [direction, setDirection] = useState('outbound')
  const [content, setContent] = useState('')
  const [sentiment, setSentiment] = useState('neutral')

  async function handleSubmit() {
    if (!content.trim()) return
    setSaving(true)

    const supabase = createClient()
    const { data: { session } } = await supabase.auth.getSession()
    const token = session?.access_token ?? ''
    const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000'

    try {
      const res = await fetch(`${apiUrl}/api/clients/${clientId}/interactions`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`,
        },
        body: JSON.stringify({
          interaction_type: type,
          direction,
          content: content.trim(),
          sentiment,
        }),
      })

      if (res.ok) {
        setContent('')
        setOpen(false)
        router.refresh()
      }
    } finally {
      setSaving(false)
    }
  }

  if (!open) {
    return (
      <button
        onClick={() => setOpen(true)}
        className="w-full py-3 rounded-xl text-sm font-semibold text-white mb-4"
        style={{ background: 'var(--accent)' }}
      >
        + Log Interaction
      </button>
    )
  }

  return (
    <div className="p-4 rounded-xl mb-4" style={{ background: 'var(--card)', border: '1px solid var(--accent)' }}>
      <p className="text-xs font-semibold uppercase tracking-wider mb-3" style={{ color: 'var(--accent-light)' }}>Log Interaction</p>

      {/* Type selector */}
      <div className="flex flex-wrap gap-2 mb-3">
        {TYPES.map((t) => (
          <button
            key={t.value}
            onClick={() => setType(t.value)}
            className="text-xs px-3 py-1.5 rounded-full font-medium transition-colors"
            style={{
              background: type === t.value ? 'var(--accent)' : 'transparent',
              color: type === t.value ? '#fff' : 'var(--muted)',
              border: `1px solid ${type === t.value ? 'var(--accent)' : 'var(--card-border)'}`,
            }}
          >
            {t.label}
          </button>
        ))}
      </div>

      {/* Direction selector */}
      <div className="flex gap-2 mb-3">
        {DIRECTIONS.map((d) => (
          <button
            key={d.value}
            onClick={() => setDirection(d.value)}
            className="text-xs px-3 py-1.5 rounded-full font-medium transition-colors"
            style={{
              background: direction === d.value ? 'var(--accent)' : 'transparent',
              color: direction === d.value ? '#fff' : 'var(--muted)',
              border: `1px solid ${direction === d.value ? 'var(--accent)' : 'var(--card-border)'}`,
            }}
          >
            {d.label}
          </button>
        ))}
      </div>

      {/* Content */}
      <textarea
        value={content}
        onChange={(e) => setContent(e.target.value)}
        placeholder="What happened? Quick summary…"
        rows={3}
        className="w-full px-3 py-2 rounded-lg text-sm outline-none resize-none mb-3"
        style={{
          background: 'var(--background)',
          border: '1px solid var(--card-border)',
          color: 'var(--foreground)',
        }}
      />

      {/* Sentiment */}
      <div className="flex gap-2 mb-3">
        {['positive', 'neutral', 'negative'].map((s) => (
          <button
            key={s}
            onClick={() => setSentiment(s)}
            className="text-xs px-3 py-1.5 rounded-full font-medium capitalize"
            style={{
              background: sentiment === s
                ? s === 'positive' ? '#052e16' : s === 'negative' ? '#2d1b1b' : '#1a1a2e'
                : 'transparent',
              color: sentiment === s
                ? s === 'positive' ? '#10b981' : s === 'negative' ? '#ef4444' : 'var(--accent-light)'
                : 'var(--muted)',
              border: `1px solid ${sentiment === s ? (s === 'positive' ? '#10b981' : s === 'negative' ? '#ef4444' : 'var(--accent)') : 'var(--card-border)'}`,
            }}
          >
            {s}
          </button>
        ))}
      </div>

      {/* Actions */}
      <div className="flex gap-2">
        <button
          onClick={() => setOpen(false)}
          className="flex-1 py-2.5 rounded-lg text-sm font-medium"
          style={{ color: 'var(--muted)', border: '1px solid var(--card-border)' }}
        >
          Cancel
        </button>
        <button
          onClick={handleSubmit}
          disabled={saving || !content.trim()}
          className="flex-1 py-2.5 rounded-lg text-sm font-semibold text-white disabled:opacity-50"
          style={{ background: 'var(--accent)' }}
        >
          {saving ? 'Saving…' : 'Save'}
        </button>
      </div>
    </div>
  )
}
