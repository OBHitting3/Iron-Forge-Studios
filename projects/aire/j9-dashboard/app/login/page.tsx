'use client'

import { useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import { useRouter } from 'next/navigation'

export default function LoginPage() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const router = useRouter()

  async function handleLogin(e: React.FormEvent) {
    e.preventDefault()
    setLoading(true)
    setError('')

    const supabase = createClient()
    const { error } = await supabase.auth.signInWithPassword({ email, password })

    if (error) {
      setError(error.message)
      setLoading(false)
    } else {
      router.push('/dashboard')
      router.refresh()
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center px-6 py-12" style={{ background: 'var(--background)' }}>
      <div className="w-full max-w-sm">
        {/* Logo / Brand */}
        <div className="text-center mb-10">
          <div className="inline-flex items-center justify-center w-16 h-16 rounded-2xl mb-4" style={{ background: 'var(--accent)' }}>
            <span className="text-2xl font-bold text-white">J9</span>
          </div>
          <h1 className="text-2xl font-bold" style={{ color: 'var(--foreground)' }}>AiRE</h1>
          <p className="text-sm mt-1" style={{ color: 'var(--muted)' }}>Luxury Real Estate Platform</p>
        </div>

        {/* Login Form */}
        <form onSubmit={handleLogin} className="space-y-4">
          <div>
            <label className="block text-sm font-medium mb-1.5" style={{ color: 'var(--foreground)' }}>
              Email
            </label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              placeholder="you@example.com"
              className="w-full px-4 py-3 rounded-xl text-base outline-none transition-all"
              style={{
                background: 'var(--card)',
                border: '1px solid var(--card-border)',
                color: 'var(--foreground)',
              }}
            />
          </div>

          <div>
            <label className="block text-sm font-medium mb-1.5" style={{ color: 'var(--foreground)' }}>
              Password
            </label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              placeholder="••••••••"
              className="w-full px-4 py-3 rounded-xl text-base outline-none transition-all"
              style={{
                background: 'var(--card)',
                border: '1px solid var(--card-border)',
                color: 'var(--foreground)',
              }}
            />
          </div>

          {error && (
            <p className="text-sm text-red-400 text-center">{error}</p>
          )}

          <button
            type="submit"
            disabled={loading}
            className="w-full py-3 rounded-xl text-base font-semibold text-white transition-opacity disabled:opacity-60 mt-2"
            style={{ background: 'var(--accent)' }}
          >
            {loading ? 'Signing in…' : 'Sign In'}
          </button>
        </form>

        <p className="text-center text-xs mt-8" style={{ color: 'var(--muted)' }}>
          Need access? Contact your Iron Forge Studios rep.
        </p>
      </div>
    </div>
  )
}
