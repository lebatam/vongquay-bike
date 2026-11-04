# Đưa Vòng Quay Bike lên internet

Tổng thời gian: khoảng 30–45 phút. Không cần cài đặt gì trên máy, chỉ cần trình duyệt.

## Trong thư mục này có gì

| File | Dùng để |
|---|---|
| `index.html` | Trang cửa hàng khách nhìn thấy |
| `admin.html` | Trang quản trị: xem đơn, đánh dấu đã giao, tải ảnh xe |
| `products.js` | Danh sách xe, giá, thông số. **Sửa giá, thêm xe ở đây** |
| `config.js` | Khóa kết nối Supabase, tên shop, hotline, địa chỉ |
| `style.css` | Giao diện |
| `img/` | Ảnh sản phẩm có sẵn |
| `setup.sql` | Lệnh tạo database, chạy 1 lần trong Supabase |

---

## Bước 0: Tạo 3 tài khoản (khoảng 15 phút)

Làm theo đúng thứ tự: **GitHub trước**, vì Supabase và Vercel sẽ đăng nhập bằng tài khoản GitHub. Bạn chỉ cần nhớ một mật khẩu.

### 0.1 GitHub: nơi lưu code
1. Vào **github.com** → **Sign up**.
2. Nhập email, mật khẩu (ít nhất 15 ký tự, hoặc 8 ký tự có cả số và chữ thường).
3. **Username:** viết thường, không dấu, không khoảng trắng, ví dụ `tam-vongquay`. Tên này xuất hiện trong đường link nên chọn tên gọn.
4. Giải câu đố xác minh, mở email và nhập mã GitHub gửi.
5. Nếu được hỏi về gói dịch vụ, chọn **Free**. Các câu hỏi cá nhân hóa có thể bỏ qua (Skip).
6. **Bật xác thực 2 lớp (bắt buộc nên làm):** ảnh đại diện → **Settings** → **Password and authentication** → **Enable two-factor authentication** → quét mã QR bằng Google Authenticator hoặc Microsoft Authenticator → **tải và cất kỹ Recovery codes** (mất điện thoại thì dùng mã này để vào lại).

### 0.2 Supabase: database lưu đơn hàng và ảnh
1. Vào **supabase.com** → **Start your project**.
2. Chọn **Continue with GitHub** → bấm **Authorize supabase**.
3. Tạo Organization: Name `Vong Quay Bike`, Type **Personal**, Plan **Free** → Create.
4. Dừng ở đây, việc tạo project nằm ở Bước 1 bên dưới.

### 0.3 Vercel: đưa website lên mạng
1. Vào **vercel.com** → **Sign Up**.
2. Chọn **Hobby** (miễn phí), nhập tên của bạn → **Continue with GitHub** → **Authorize Vercel**.
3. Ở Bước 6, khi Vercel xin quyền truy cập GitHub, chọn **Only select repositories** → chọn `vongquay-bike`. Vercel chỉ thấy đúng repo này.

> **Lưu ý về gói miễn phí**
> - **Vercel Hobby chỉ dành cho mục đích cá nhân, phi thương mại.** Dùng để học và chạy thử thì hoàn toàn ổn. Khi website bắt đầu bán hàng thật, cần nâng lên gói Pro (khoảng 20 USD/tháng) hoặc chuyển sang dịch vụ lưu trữ cho phép dùng thương mại miễn phí.
> - **Supabase Free** tạm dừng project khi gần một tuần không có hoạt động (có email báo trước). Dữ liệu vẫn được giữ, vào bấm Restore là chạy lại.
> - Lưu mật khẩu và Recovery codes vào trình quản lý mật khẩu. Không gửi mật khẩu hay khóa bí mật cho bất kỳ ai, kể cả AI.

---

## Bước 1: Tạo database trên Supabase

1. Vào **supabase.com** → Start your project → đăng nhập bằng GitHub hoặc email.
2. Bấm **New project**:
   - Name: `vongquay-bike`
   - Database Password: bấm Generate rồi **lưu lại** mật khẩu này
   - Region: **Southeast Asia (Singapore)** (gần Việt Nam nhất)
3. Chờ khoảng 2 phút cho project khởi tạo xong.

## Bước 2: Chạy file setup.sql

1. Mở file `setup.sql` bằng Notepad hoặc TextEdit.
2. Kéo xuống dòng cuối, đổi `email-cua-ban@vidu.com` thành **email bạn dùng để đăng nhập trang quản trị**.
3. Trong Supabase: menu trái → **SQL Editor** → **New query** → dán toàn bộ nội dung file → bấm **Run**.
4. Thấy dòng `Success. No rows returned` là xong.

## Bước 3: Tạo tài khoản quản trị và khóa đăng ký

1. Menu trái → **Authentication** → **Users** → **Add user** → **Create new user**.
2. Nhập đúng email ở bước 2, đặt mật khẩu mạnh, **tích chọn "Auto Confirm User"** → Create user.
3. Vào **Authentication** → **Sign In / Providers** (hoặc Settings) → **tắt "Allow new users to sign up"** → Save.
   *Lý do: chỉ bạn được có tài khoản. Kể cả khi ai đó tạo được tài khoản, họ cũng không xem được đơn vì không có trong bảng `admins`. Tắt đăng ký là thêm một lớp an toàn.*

## Bước 4: Dán khóa kết nối vào config.js

1. Supabase → **Project Settings** (biểu tượng bánh răng ở thanh trái) → **API Keys**.
2. Ở bảng **Publishable key**, dòng `default`, bấm biểu tượng **sao chép** bên cạnh khóa `sb_publishable_...`.
3. Mở `config.js`, thay `DAN_PUBLISHABLE_KEY_VAO_DAY` bằng khóa vừa sao chép (giữ nguyên dấu ngoặc kép).
4. **Project URL** đã được điền sẵn. Nếu cần tự tìm: bấm nút xanh **Connect** ở đầu trang, hoặc lấy mã project trên thanh địa chỉ (`.../project/MA-PROJECT/...`) rồi ghép thành `https://MA-PROJECT.supabase.co`.
5. Sửa luôn tên shop, hotline, địa chỉ trong `config.js`.

> ⚠️ Chỉ dùng **Publishable key** (`sb_publishable_...`). Không bao giờ dán **Secret key** (`sb_secret_...`) vào bất kỳ file nào trên web.
> Giao diện cũ của Supabase gọi khóa này là "anon public". Supabase sẽ ngừng khóa kiểu cũ vào đầu năm 2027, nên dự án này dùng khóa mới.

## Bước 5: Đưa code lên GitHub

1. Vào **github.com** → tạo tài khoản → góc phải bấm **+** → **New repository**.
2. Repository name: `vongquay-bike`, chọn **Public** → **Create repository**.
3. Bấm link **uploading an existing file**.
4. Kéo thả **toàn bộ file và thư mục `img`** vào (không kéo thư mục cha) → **Commit changes**.

## Bước 6: Đưa lên mạng bằng Vercel

1. Vào **vercel.com** → **Sign up** → chọn **Continue with GitHub**.
2. **Add New… → Project** → chọn repo `vongquay-bike` → **Import**.
3. Framework Preset: **Other**. Không cần đổi gì khác → **Deploy**.
4. Khoảng 30 giây sau bạn có link dạng `vongquay-bike.vercel.app`. 🎉

Trang quản trị: thêm `/admin.html` vào cuối link, ví dụ `vongquay-bike.vercel.app/admin.html`.

## Bước 7: Kiểm tra trên web thật

- [ ] Mở link trên điện thoại ở **chế độ ẩn danh** (giống khách lạ), đặt 1 đơn thử
- [ ] Vào `/admin.html`, đăng nhập, thấy đơn vừa đặt
- [ ] Bấm "Đánh dấu đã giao" rồi "Hoàn tác"
- [ ] Tab "Ảnh sản phẩm": tải ảnh cho 1 mẫu xe, quay lại cửa hàng thấy ảnh mới
- [ ] Mở `/admin.html` ở chế độ ẩn danh, **không** đăng nhập thì không thấy đơn nào

---

## Sau này: sửa website thế nào?

1. Sửa file trên máy (ví dụ đổi giá trong `products.js`).
2. Vào repo GitHub → mở file → biểu tượng bút chì → dán nội dung mới → **Commit changes**.
3. Vercel tự cập nhật website sau khoảng 30 giây.

Đơn hàng và ảnh nằm trong Supabase, nên sửa code không làm mất dữ liệu.

## Lưu ý trước khi bán thật

- **Ảnh Giant** trong thư mục `img/` lấy từ website nhà phân phối. Hãy xin phép giant.vn hoặc thay bằng ảnh tự chụp trước khi quảng bá.
- **Giá và tồn kho:** sửa trong `products.js` theo giá bạn thực bán. Ba mẫu Giant Escape đang báo hết hàng tại nhà phân phối.
- **Kiểm tra giá trên mỗi đơn:** khách rành kỹ thuật có thể sửa giá gửi lên. Vì bạn luôn gọi xác nhận trước khi giao, hãy đối chiếu tổng tiền với bảng giá khi gọi.
- **Gói miễn phí của Supabase** tạm dừng project nếu 7 ngày liền không có ai truy cập. Vào bấm "Restore" là chạy lại, dữ liệu không mất.
- **Tên miền riêng** (ví dụ `vongquaybike.vn`): mua tại nhà đăng ký tên miền, rồi vào Vercel → Project → Settings → Domains để gắn.
