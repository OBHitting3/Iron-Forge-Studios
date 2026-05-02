import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import BottomNav from '@/components/bottom-nav'
import TopBar from '@/components/top-bar'

export const dynamic = 'force-dynamic'

export default async function DashboardLayout({
  children,
}: {
  children: React.ReactNode
}) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) redirect('/login')

  return (
    <div className="min-h-screen flex flex-col" style={{ background: 'var(--background)' }}>
      <TopBar userEmail={user.email ?? ''} />
      <main className="flex-1 pb-24 pt-4">
        {children}
      </main>
      <BottomNav />
    </div>
  )
}
