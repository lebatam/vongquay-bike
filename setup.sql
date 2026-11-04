-- =====================================================================
-- Vòng Quay Bike: tạo database
-- Cách chạy: Supabase → SQL Editor → New query → dán toàn bộ file → Run
-- Chạy lại nhiều lần cũng không sao.
-- =====================================================================

-- 1) Danh sách email được vào trang quản trị
create table if not exists public.admins (
  email text primary key
);

-- Hàm kiểm tra người đang đăng nhập có phải quản trị viên không
create or replace function public.is_admin()
returns boolean
language sql stable security definer set search_path = public
as $$
  select exists (
    select 1 from public.admins
    where lower(email) = lower(coalesce(auth.jwt() ->> 'email', ''))
  );
$$;

-- 2) Đơn hàng
create table if not exists public.orders (
  id            bigint generated always as identity primary key,
  code          text not null,
  created_at    timestamptz not null default now(),
  customer_name text not null,
  phone         text not null,
  address       text not null,
  payment       text not null,
  note          text default '',
  items         jsonb not null,
  total         integer not null,
  status        text not null default 'Mới',
  delivered_at  timestamptz
);

-- 3) Ảnh sản phẩm (mã xe → link ảnh)
create table if not exists public.product_photos (
  sku        text primary key,
  url        text not null,
  updated_at timestamptz not null default now()
);

-- 4) Bật bảo mật theo dòng (Row Level Security)
alter table public.admins         enable row level security;
alter table public.orders         enable row level security;
alter table public.product_photos enable row level security;

-- Xóa chính sách cũ (nếu chạy lại)
drop policy if exists "khach gui don"        on public.orders;
drop policy if exists "admin xem don"        on public.orders;
drop policy if exists "admin sua don"        on public.orders;
drop policy if exists "admin xoa don"        on public.orders;
drop policy if exists "ai cung xem anh"      on public.product_photos;
drop policy if exists "admin quan ly anh"    on public.product_photos;
drop policy if exists "admin tu xem minh"    on public.admins;

-- Khách (kể cả không đăng nhập) chỉ được GỬI đơn mới, không đọc được đơn của ai
create policy "khach gui don" on public.orders
  for insert to anon, authenticated
  with check (
    status = 'Mới'
    and delivered_at is null
    and phone ~ '^0[0-9]{9}$'
    and char_length(customer_name) between 1 and 80
    and char_length(address) between 1 and 250
    and char_length(coalesce(note, '')) <= 250
    and jsonb_typeof(items) = 'array'
    and jsonb_array_length(items) between 1 and 20
    and total > 0
  );

-- Chỉ quản trị viên được xem, sửa, xóa đơn
create policy "admin xem don" on public.orders for select to authenticated using (public.is_admin());
create policy "admin sua don" on public.orders for update to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "admin xoa don" on public.orders for delete to authenticated using (public.is_admin());

-- Ai cũng xem được ảnh sản phẩm; chỉ quản trị viên được thay đổi
create policy "ai cung xem anh" on public.product_photos for select to anon, authenticated using (true);
create policy "admin quan ly anh" on public.product_photos for all to authenticated
  using (public.is_admin()) with check (public.is_admin());

-- Quản trị viên chỉ thấy dòng email của chính mình
create policy "admin tu xem minh" on public.admins for select to authenticated
  using (lower(email) = lower(coalesce(auth.jwt() ->> 'email', '')));

-- 5) Kho lưu ảnh (Storage): ai cũng xem, chỉ quản trị viên tải lên
insert into storage.buckets (id, name, public)
values ('bike-photos', 'bike-photos', true)
on conflict (id) do nothing;

drop policy if exists "admin tai anh len"  on storage.objects;
drop policy if exists "admin sua anh"      on storage.objects;
drop policy if exists "admin xoa anh"      on storage.objects;

create policy "admin tai anh len" on storage.objects for insert to authenticated
  with check (bucket_id = 'bike-photos' and public.is_admin());
create policy "admin sua anh" on storage.objects for update to authenticated
  using (bucket_id = 'bike-photos' and public.is_admin());
create policy "admin xoa anh" on storage.objects for delete to authenticated
  using (bucket_id = 'bike-photos' and public.is_admin());

-- 6) THÊM EMAIL QUẢN TRỊ CỦA BẠN (sửa email rồi chạy lại riêng dòng này nếu cần)
insert into public.admins (email) values ('email-cua-ban@vidu.com')
on conflict (email) do nothing;
