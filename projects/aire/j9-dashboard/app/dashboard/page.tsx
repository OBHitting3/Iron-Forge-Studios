import { createClient } from '@/lib/supabase/server'
import ClientList from '@/components/client-list'
import Link from 'next/link'

export const dynamic = 'force-dynamic'

async function getClients(token: string) {
  const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000'
  try {
    const res = await fetch(`${apiUrl}/api/clients`, {
      cache: 'no-store',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
    })
    if (!res.ok) return []
    const data = await res.json()
    return data.clients ?? data ?? []
  } catch {
    return []
  }
}

async function getFollowUps(token: string) {
  const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000'
  try {
    const res = await fetch(`${apiUrl}/api/clients/followups`, {
      cache: 'no-store',
      headers: { 'Authorization': `Bearer ${token}` },
    })
    if (!res.ok) return []
    const data = await res.json()
    return data.clients ?? data ?? []
  } catch {
    return []
  }
}

export default async function DashboardPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  const { data: { session } } = await supabase.auth.getSession()
  const token = session?.access_token ?? ''
  const [clients, followUps] = await Promise.all([
    getClients(token),
    getFollowUps(token),
  ])

  return (
    <div className="px-4 max-w-2xl mx-auto">
      {/* Follow-up banner */}
      {followUps.length > 0 && (
        <div className="mb-4 px-4 py-3 rounded-xl flex items-center justify-between" style={{ background: '#2d1b1b', border: '1px solid #7f1d1d' }}>
          <div>
            <p className="text-sm font-semibold text-red-400">
              {followUps.length} follow-up{followUps.length !== 1 ? 's' : ''} due today
            </p>
            <p className="text-xs text-red-400/70 mt-0.5">Tap to see who needs attention</p>
          </div>
          <div className="flex items-center justify-center w-8 h-8 rounded-full bg-red-500">
            <span className="text-sm font-bold text-white">{followUps.length}</span>
          </div>
        </div>
      )}

      {/* Header */}
      <div className="flex items-center justify-between mb-4">
        <h1 className="text-xl font-bold" style={{ color: 'var(--foreground)' }}>
          Clients <span className="text-sm font-normal ml-1" style={{ color: 'var(--muted)' }}>({clients.length})</span>
        </h1>
        <Link
          href="/dashboard/clients/import"
          className="text-sm font-medium px-3 py-1.5 rounded-lg"
          style={{ background: 'var(--accent)', color: '#fff' }}
        >
          + Import
        </Link>
      </div>

      <ClientList clients={clients} />
    </div>
  )
}
