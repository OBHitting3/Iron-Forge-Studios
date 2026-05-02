'use client'

import { createClient } from '@/lib/supabase/client'
import { useRouter } from 'next/navigation'

interface TopBarProps {
  userEmail: string
}

export default function TopBar({ userEmail }: TopBarProps) {
  const router = useRouter()

  async function handleSignOut() {
    const supabase = createClient()
    await supabase.auth.signOut()
    router.push('/login')
    router.refresh()
  }

  return (
    <header className="sticky top-0 z-40 px-4 py-3 flex items-center justify-between" style={{ background: 'var(--background)', borderBottom: '1px solid var(--card-border)' }}>
      <div className="flex items-center gap-2">
        <div className="w-8 h-8 rounded-lg flex items-center justify-center" style={{ background: 'var(--accent)' }}>
          <span className="text-xs font-bold text-white">J9</span>
        </div>
        <span className="text-sm font-semibold" style={{ color: 'var(--foreground)' }}>AiRE</span>
      </div>

      <button
        onClick={handleSignOut}
        className="text-xs px-3 py-1.5 rounded-lg transition-opacity hover:opacity-70"
        style={{ color: 'var(--muted)', border: '1px solid var(--card-border)' }}
      >
        Sign out
      </button>
    </header>
  )
}
