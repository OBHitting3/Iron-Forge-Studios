'use client'

import { useState, useRef } from 'react'
import { createClient } from '@/lib/supabase/client'

type ParsedRow = Record<string, string>

// Common column name aliases → our field names
const FIELD_MAP: Record<string, string> = {
  // First name
  'first name': 'first_name', 'firstname': 'first_name', 'first': 'first_name',
  'given name': 'first_name', 'given_name': 'first_name',
  // Last name
  'last name': 'last_name', 'lastname': 'last_name', 'last': 'last_name',
  'surname': 'last_name', 'family name': 'last_name',
  // Full name (we'll split it)
  'name': 'full_name', 'full name': 'full_name', 'contact': 'full_name',
  // Email
  'email': 'email', 'email address': 'email', 'e-mail': 'email',
  'email 1 - value': 'email',
  // Phone
  'phone': 'phone', 'phone number': 'phone', 'mobile': 'phone',
  'cell': 'phone', 'cell phone': 'phone', 'telephone': 'phone',
  'phone 1 - value': 'phone', 'mobile phone': 'phone',
  // Birthday
  'birthday': 'birthday', 'birth date': 'birthday', 'date of birth': 'birthday',
  // Notes
  'notes': 'notes', 'note': 'notes', 'comments': 'notes', 'description': 'notes',
}

function normalizeHeader(h: string): string {
  return h.trim().toLowerCase()
}

function mapHeaders(headers: string[]): Record<string, string> {
  const mapping: Record<string, string> = {}
  for (const header of headers) {
    const normalized = normalizeHeader(header)
    if (FIELD_MAP[normalized]) {
      mapping[header] = FIELD_MAP[normalized]
    }
  }
  return mapping
}

function parseCsv(text: string): { headers: string[]; rows: ParsedRow[] } {
  const lines = text.trim().split('\n').filter(Boolean)
  if (lines.length < 2) return { headers: [], rows: [] }

  // Simple CSV parser (handles quoted fields)
  function parseLine(line: string): string[] {
    const result: string[] = []
    let current = ''
    let inQuotes = false
    for (let i = 0; i < line.length; i++) {
      const ch = line[i]
      if (ch === '"') {
        if (inQuotes && line[i + 1] === '"') { current += '"'; i++ }
        else inQuotes = !inQuotes
      } else if (ch === ',' && !inQuotes) {
        result.push(current.trim())
        current = ''
      } else {
        current += ch
      }
    }
    result.push(current.trim())
    return result
  }

  const headers = parseLine(lines[0])
  const rows = lines.slice(1).map((line) => {
    const values = parseLine(line)
    return Object.fromEntries(headers.map((h, i) => [h, values[i] ?? '']))
  })

  return { headers, rows }
}

function rowToClient(row: ParsedRow, mapping: Record<string, string>) {
  const mapped: Record<string, string> = {}
  for (const [col, field] of Object.entries(mapping)) {
    if (row[col]) mapped[field] = row[col]
  }

  // Split full_name if we didn't get separate first/last
  if (mapped.full_name && !mapped.first_name) {
    const parts = mapped.full_name.split(' ')
    mapped.first_name = parts[0] ?? ''
    mapped.last_name = parts.slice(1).join(' ') ?? ''
    delete mapped.full_name
  }

  return {
    first_name: mapped.first_name ?? '',
    last_name: mapped.last_name ?? '',
    email: mapped.email || null,
    phone: mapped.phone || null,
    notes: mapped.notes || null,
  }
}

export default function CsvImporter() {
  const [step, setStep] = useState<'upload' | 'preview' | 'importing' | 'done'>('upload')
  const [rows, setRows] = useState<ParsedRow[]>([])
  const [headers, setHeaders] = useState<string[]>([])
  const [mapping, setMapping] = useState<Record<string, string>>({})
  const [results, setResults] = useState({ success: 0, failed: 0 })
  const [dragging, setDragging] = useState(false)
  const fileRef = useRef<HTMLInputElement>(null)

  function handleFile(file: File) {
    const reader = new FileReader()
    reader.onload = (e) => {
      const text = e.target?.result as string
      const { headers, rows } = parseCsv(text)
      const autoMapping = mapHeaders(headers)
      setHeaders(headers)
      setRows(rows)
      setMapping(autoMapping)
      setStep('preview')
    }
    reader.readAsText(file)
  }

  function handleDrop(e: React.DragEvent) {
    e.preventDefault()
    setDragging(false)
    const file = e.dataTransfer.files[0]
    if (file?.name.endsWith('.csv')) handleFile(file)
  }

  async function handleImport() {
    setStep('importing')
    const supabase = createClient()
    const { data: { session } } = await supabase.auth.getSession()
    const token = session?.access_token ?? ''
    const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000'

    let success = 0
    let failed = 0

    for (const row of rows) {
      const client = rowToClient(row, mapping)
      if (!client.first_name) { failed++; continue }

      try {
        const res = await fetch(`${apiUrl}/api/clients`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`,
          },
          body: JSON.stringify(client),
        })
        if (res.ok) success++
        else failed++
      } catch {
        failed++
      }
    }

    setResults({ success, failed })
    setStep('done')
  }

  if (step === 'upload') {
    return (
      <div>
        <div
          onDragOver={(e) => { e.preventDefault(); setDragging(true) }}
          onDragLeave={() => setDragging(false)}
          onDrop={handleDrop}
          onClick={() => fileRef.current?.click()}
          className="flex flex-col items-center justify-center py-16 rounded-2xl cursor-pointer transition-colors"
          style={{
            border: `2px dashed ${dragging ? 'var(--accent)' : 'var(--card-border)'}`,
            background: dragging ? '#1a0a2e' : 'var(--card)',
          }}
        >
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={1.5} className="w-12 h-12 mb-3" style={{ color: 'var(--accent)' }}>
            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" strokeLinecap="round" strokeLinejoin="round" />
            <polyline points="17 8 12 3 7 8" strokeLinecap="round" strokeLinejoin="round" />
            <line x1="12" y1="3" x2="12" y2="15" strokeLinecap="round" />
          </svg>
          <p className="text-base font-semibold" style={{ color: 'var(--foreground)' }}>
            {dragging ? 'Drop it here' : 'Tap to upload CSV'}
          </p>
          <p className="text-sm mt-1" style={{ color: 'var(--muted)' }}>or drag and drop</p>
          <input
            ref={fileRef}
            type="file"
            accept=".csv"
            className="hidden"
            onChange={(e) => { const f = e.target.files?.[0]; if (f) handleFile(f) }}
          />
        </div>

        {/* Supported sources */}
        <div className="mt-6">
          <p className="text-xs font-semibold uppercase tracking-wider mb-3" style={{ color: 'var(--muted)' }}>Works with exports from</p>
          <div className="flex flex-wrap gap-2">
            {['Google Contacts', 'iPhone Contacts', 'KVCore', 'Follow Up Boss', 'Top Producer', 'Excel / Sheets'].map((src) => (
              <span key={src} className="text-xs px-2.5 py-1 rounded-full" style={{ background: 'var(--card)', border: '1px solid var(--card-border)', color: 'var(--muted)' }}>
                {src}
              </span>
            ))}
          </div>
        </div>
      </div>
    )
  }

  if (step === 'preview') {
    const previewRows = rows.slice(0, 5)
    const clientRows = rows.map((r) => rowToClient(r, mapping)).filter((r) => r.first_name)

    return (
      <div>
        <div className="flex items-center justify-between mb-4">
          <div>
            <p className="font-semibold" style={{ color: 'var(--foreground)' }}>
              {rows.length} contacts found
            </p>
            <p className="text-sm" style={{ color: 'var(--muted)' }}>
              {clientRows.length} ready to import
            </p>
          </div>
          <button
            onClick={() => { setStep('upload'); setRows([]); setHeaders([]) }}
            className="text-sm px-3 py-1.5 rounded-lg"
            style={{ color: 'var(--muted)', border: '1px solid var(--card-border)' }}
          >
            Change file
          </button>
        </div>

        {/* Preview table */}
        <div className="rounded-xl overflow-hidden mb-4" style={{ border: '1px solid var(--card-border)' }}>
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr style={{ background: 'var(--card-border)' }}>
                  {headers.slice(0, 5).map((h) => (
                    <th key={h} className="text-left px-3 py-2 text-xs font-semibold" style={{ color: 'var(--muted)' }}>
                      {h}
                      {mapping[h] && <span className="ml-1 text-purple-400">→ {mapping[h]}</span>}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {previewRows.map((row, i) => (
                  <tr key={i} style={{ borderTop: '1px solid var(--card-border)', background: i % 2 === 0 ? 'var(--card)' : 'transparent' }}>
                    {headers.slice(0, 5).map((h) => (
                      <td key={h} className="px-3 py-2 text-xs truncate max-w-28" style={{ color: 'var(--foreground)' }}>
                        {row[h] || <span style={{ color: 'var(--muted)' }}>—</span>}
                      </td>
                    ))}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          {rows.length > 5 && (
            <p className="text-center text-xs py-2" style={{ color: 'var(--muted)', borderTop: '1px solid var(--card-border)' }}>
              +{rows.length - 5} more rows
            </p>
          )}
        </div>

        <button
          onClick={handleImport}
          className="w-full py-3.5 rounded-xl text-base font-semibold text-white"
          style={{ background: 'var(--accent)' }}
        >
          Import {clientRows.length} Contacts
        </button>
      </div>
    )
  }

  if (step === 'importing') {
    return (
      <div className="text-center py-16">
        <div className="w-12 h-12 rounded-full border-4 border-t-purple-500 animate-spin mx-auto mb-4" style={{ borderColor: 'var(--card-border)', borderTopColor: 'var(--accent)' }} />
        <p className="font-semibold" style={{ color: 'var(--foreground)' }}>Importing contacts…</p>
        <p className="text-sm mt-1" style={{ color: 'var(--muted)' }}>This only takes a moment</p>
      </div>
    )
  }

  // Done
  return (
    <div className="text-center py-16">
      <div className="w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4" style={{ background: results.failed === 0 ? '#052e16' : '#2d1b1b' }}>
        {results.failed === 0 ? (
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2.5} className="w-8 h-8 text-emerald-400">
            <path d="M20 6 9 17l-5-5" strokeLinecap="round" strokeLinejoin="round" />
          </svg>
        ) : (
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2.5} className="w-8 h-8 text-amber-400">
            <path d="M12 9v4M12 17h.01" strokeLinecap="round" />
            <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z" strokeLinecap="round" strokeLinejoin="round" />
          </svg>
        )}
      </div>
      <p className="text-xl font-bold mb-1" style={{ color: 'var(--foreground)' }}>
        {results.success} contacts imported
      </p>
      {results.failed > 0 && (
        <p className="text-sm text-amber-400">{results.failed} rows skipped (missing name)</p>
      )}
      <a
        href="/dashboard"
        className="inline-block mt-6 px-6 py-3 rounded-xl font-semibold text-white"
        style={{ background: 'var(--accent)' }}
      >
        View Clients
      </a>
    </div>
  )
}
