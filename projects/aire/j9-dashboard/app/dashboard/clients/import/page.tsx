import CsvImporter from '@/components/csv-importer'

export default function ImportPage() {
  return (
    <div className="px-4 max-w-2xl mx-auto">
      <h1 className="text-xl font-bold mb-2" style={{ color: 'var(--foreground)' }}>Import Contacts</h1>
      <p className="text-sm mb-6" style={{ color: 'var(--muted)' }}>
        Upload a CSV from Google Contacts, iPhone, KVCore, Follow Up Boss, or any spreadsheet.
      </p>
      <CsvImporter />
    </div>
  )
}
