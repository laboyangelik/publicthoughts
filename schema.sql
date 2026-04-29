-- Run this in the Supabase SQL editor after creating your project.

create table if not exists receipts (
  id bigint primary key generated always as identity,
  name text not null default 'Anon' check (char_length(name) between 1 and 40),
  message text not null check (char_length(message) between 1 and 500),
  created_at timestamptz not null default now()
);

create index if not exists receipts_created_at_idx on receipts (created_at desc);

alter table receipts enable row level security;

drop policy if exists "public read" on receipts;
create policy "public read" on receipts for select using (true);

drop policy if exists "public insert" on receipts;
create policy "public insert" on receipts for insert with check (
  char_length(message) between 1 and 500
  and char_length(name) between 1 and 40
);

-- Enable realtime so the page can subscribe to inserts.
alter publication supabase_realtime add table receipts;
