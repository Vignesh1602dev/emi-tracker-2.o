-- Run ONCE in Supabase SQL Editor if you deployed before this version (adds the account holder's name)
alter table app_users add column if not exists name text;
