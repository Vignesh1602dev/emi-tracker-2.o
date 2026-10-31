-- Run this ONCE in Supabase SQL Editor (adds the Expense Register table)
create table if not exists expenses (
  org_id uuid not null references orgs(id) on delete cascade,
  rid text not null,
  data jsonb not null,
  created_at timestamptz not null default now(),
  primary key (org_id, rid)
);
alter table expenses enable row level security;
revoke all on expenses from anon, authenticated;
