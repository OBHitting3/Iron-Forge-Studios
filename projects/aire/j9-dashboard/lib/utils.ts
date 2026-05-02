import { clsx, type ClassValue } from 'clsx'
import { twMerge } from 'tailwind-merge'

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export function formatDate(dateString: string | null | undefined): string {
  if (!dateString) return '—'
  const date = new Date(dateString)
  return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
}

export function daysSince(dateString: string | null | undefined): number {
  if (!dateString) return 999
  const then = new Date(dateString)
  const now = new Date()
  return Math.floor((now.getTime() - then.getTime()) / (1000 * 60 * 60 * 24))
}

export function engagementColor(score: number | null | undefined): string {
  const s = score ?? 0
  if (s >= 70) return 'bg-emerald-500'
  if (s >= 40) return 'bg-amber-400'
  return 'bg-red-500'
}

export function engagementLabel(score: number | null | undefined): string {
  const s = score ?? 0
  if (s >= 70) return 'Active'
  if (s >= 40) return 'Warm'
  return 'Cold'
}
