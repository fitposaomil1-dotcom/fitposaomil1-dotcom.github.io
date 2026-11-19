-- FormZen: lista čekanja
-- Pokreni jednom u Supabase > SQL Editor.

create table if not exists public.waitlist (
  id         bigint generated always as identity primary key,
  email      text not null unique
             check (length(email) <= 254 and email ~ '^[^\s@]+@[^\s@]+\.[^\s@]{2,}$'),
  created_at timestamptz not null default now()
);

-- Zaključaj tabelu: bez pravila niko spolja ne može ništa.
alter table public.waitlist enable row level security;

-- Posetilac sajta (javni ključ) sme SAMO da doda email.
-- Nema pravila za čitanje, izmenu ni brisanje, pa javni ključ ne može da vidi tuđe adrese.
grant insert (email) on public.waitlist to anon;

drop policy if exists "Posetilac moze da se prijavi" on public.waitlist;
create policy "Posetilac moze da se prijavi"
  on public.waitlist for insert
  to anon
  with check (true);
