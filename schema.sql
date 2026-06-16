-- KI Coach Supabase Schema

-- Profiles table
create table if not exists profiles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users not null unique,
  personal_data jsonb default '{}',
  business_data jsonb default '{}',
  employees jsonb default '[]',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
alter table profiles enable row level security;
create policy "Users can view own profile" on profiles for select using (auth.uid() = user_id);
create policy "Users can insert own profile" on profiles for insert with check (auth.uid() = user_id);
create policy "Users can update own profile" on profiles for update using (auth.uid() = user_id);

-- Knowledge base
create table if not exists knowledge_base (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users not null,
  kategorie text not null,
  fakt text not null,
  tags text[] default '{}',
  created_at timestamptz default now()
);
alter table knowledge_base enable row level security;
create policy "Users can manage own knowledge" on knowledge_base for all using (auth.uid() = user_id);

-- File metadata
create table if not exists file_metadata (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users not null,
  file_name text not null,
  file_size integer,
  file_date timestamptz default now(),
  as_context boolean default false,
  created_at timestamptz default now()
);
alter table file_metadata enable row level security;
create policy "Users can manage own files" on file_metadata for all using (auth.uid() = user_id);

-- Chat histories
create table if not exists chat_histories (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users not null,
  title text,
  mode text default 'private',
  messages jsonb default '[]',
  created_at timestamptz default now()
);
alter table chat_histories enable row level security;
create policy "Users can manage own histories" on chat_histories for all using (auth.uid() = user_id);

-- Payroll records
create table if not exists payroll_records (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users not null,
  employee_name text,
  period text,
  content text,
  data jsonb default '{}',
  created_at timestamptz default now()
);
alter table payroll_records enable row level security;
create policy "Users can manage own payroll" on payroll_records for all using (auth.uid() = user_id);

-- USt records
create table if not exists ust_records (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users not null,
  period text,
  revenue_rows jsonb default '[]',
  vorsteuer_rows jsonb default '[]',
  totals jsonb default '{}',
  created_at timestamptz default now()
);
alter table ust_records enable row level security;
create policy "Users can manage own ust records" on ust_records for all using (auth.uid() = user_id);
