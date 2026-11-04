/* Kết nối Supabase
   - SUPABASE_URL: đã điền sẵn theo project của bạn (lấy từ mã project trên thanh địa chỉ).
   - SUPABASE_ANON_KEY: dán "sb_publishable_9JTSyy6lRsHR4NmTLx61fw_NKvYCEu5" (bắt đầu bằng sb_publishable_...)
     lấy ở Supabase → Project Settings → API Keys → bảng "Publishable key" → bấm biểu tượng sao chép.
   Publishable key được phép công khai: quyền của nó bị giới hạn bởi file setup.sql.
   TUYỆT ĐỐI KHÔNG dán "Secret key" (sb_secret_...) vào đây. */
window.APP_CONFIG = {
  SUPABASE_URL: "https://sgquftgrydylwafnfowg.supabase.co",
  SUPABASE_ANON_KEY: "sb_publishable_9JTSyy6lRsHR4NmTLx61fw_NKvYCEu5",
  SHOP_NAME: "Vòng Quay Bike",
  HOTLINE: "0909 123 456",
  ADDRESS: "128 Trần Hưng Đạo, Quận 5, TP.HCM"
};
