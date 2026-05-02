import { createClient } from '@/lib/supabase/server'

export const dynamic = 'force-dynamic'

export default async function SettingsPage() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  return (
    <div className="px-4 max-w-2xl mx-auto">
      <h1 className="text-xl font-bold mb-6" style={{ color: 'var(--foreground)' }}>Settings</h1>

      {/* Account Info */}
      <div className="p-4 rounded-xl mb-4" style={{ background: 'var(--card)', border: '1px solid var(--card-border)' }}>
        <p className="text-xs font-semibold uppercase tracking-wider mb-3" style={{ color: 'var(--muted)' }}>Account</p>
        <div className="flex items-center gap-3">
          <div className="w-12 h-12 rounded-full flex items-center justify-center" style={{ background: 'var(--accent)' }}>
            <span className="text-lg font-bold text-white">
              {user?.email?.[0]?.toUpperCase() ?? 'A'}
            </span>
          </div>
          <div>
            <p className="text-sm font-medium" style={{ color: 'var(--foreground)' }}>{user?.email}</p>
            <p className="text-xs mt-0.5" style={{ color: 'var(--muted)' }}>Agent account</p>
          </div>
        </div>
      </div>

      {/* Coming soon sections */}
      {['Voice Clone', 'Notification Preferences', 'Integrations', 'Billing'].map((section) => (
        <div key={section} className="p-4 rounded-xl mb-3 flex items-center justify-between" style={{ background: 'var(--card)', border: '1px solid var(--card-border)' }}>
          <div>
            <p className="text-sm font-medium" style={{ color: 'var(--foreground)' }}>{section}</p>
            <p className="text-xs mt-0.5" style={{ color: 'var(--muted)' }}>Coming in Week 2</p>
          </div>
          <span className="text-xs px-2 py-1 rounded-full" style={{ background: 'var(--card-border)', color: 'var(--muted)' }}>Soon</span>
        </div>
      ))}
    </div>
  )
}
