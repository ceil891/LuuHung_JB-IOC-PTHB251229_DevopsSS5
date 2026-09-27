# QuickBite — Session 05

Bốn ứng dụng Spring Boot tối thiểu, biên dịch bytecode Java 17. Mỗi dịch vụ dùng PostgreSQL, Spring Data JPA và Actuator (`/actuator/health`). Đây là bộ khung làm bài Docker, chưa triển khai API nghiệp vụ.

## 1. Cấu hình

Chạy các lệnh dưới đây tại `quickbite-project`. Cần JDK 17 trở lên, Docker Desktop chạy Linux containers và Docker Compose.

`.env` đã được tạo cho máy hiện tại. Khi clone sang máy khác:

```powershell
Copy-Item .env.example .env
```

Sửa bốn mật khẩu `CHANGE_ME` trong `.env` cho khớp các tài khoản PostgreSQL. `DB_HOST=quickbite-db` là tên container database trên mạng Docker, không phải localhost. Không commit `.env`.

## 2. Database độc lập

Nếu đã có database Session 04, giữ nguyên container và dữ liệu đó. Kiểm tra:

```powershell
docker network inspect quickbite-net
docker exec quickbite-db psql -U postgres -c '\l'
docker exec quickbite-db psql -U postgres -c '\du'
```

Cần đủ bốn database `quickbite_user_db`, `quickbite_restaurant_db`, `quickbite_order_db`, `quickbite_notification_db`, mỗi database thuộc tài khoản tương ứng trong `.env`. Hibernate tạo bảng nhưng không tạo database hay tài khoản.

Chỉ khi chưa có container `quickbite-db`, có thể dùng stack database bổ sung:

```powershell
$env:POSTGRES_PASSWORD = 'replace-with-local-admin-password'
docker compose -f database/docker-compose.yml up -d --wait
```

Stack này tạo mạng `quickbite-net` và bốn database; backend chỉ sử dụng mạng ngoài. `database/init.sql` chỉ chạy khi volume mới, không tạo bảng ứng dụng. Thay `.env` sau đó không tự thay mật khẩu database đã tồn tại. Không xóa volume để xử lý lỗi đăng nhập.

## 3. Build JAR và image

Windows PowerShell:

```powershell
.\build.ps1
```

Linux/macOS:

```bash
sh build.sh
```

Script build từng JAR rồi build đồng thời bốn image bằng `docker compose build --parallel`. Có thể chạy thủ công cho từng dịch vụ:

```powershell
cd user-service
.\gradlew.bat bootJar
docker build -t quickbite-user-service:latest .
cd ..
```

Lặp lại với restaurant, order, notification. Mỗi JAR ở `<service>/build/libs/app.jar`. Dockerfile chỉ sao chép JAR này, tránh lấy nhầm plain JAR. `--build` của Compose không tự chạy Gradle; sau mỗi lần sửa Java phải build JAR lại.

## 4. Xác minh và chụp ảnh nộp bài

```powershell
docker images --filter 'reference=quickbite-*-service:latest'
docker compose config
docker compose up -d --build
docker compose ps
8081..8084 | ForEach-Object { Invoke-RestMethod "http://localhost:$_/actuator/health" }
docker exec quickbite-db psql -U postgres -d quickbite_user_db -c '\dt'
```

Chờ cả bốn health endpoint trả về `UP`; trạng thái container Up ngay sau khởi động chưa đủ chứng minh kết nối DB thành công. Nếu lỗi, xem `docker compose logs --tail 100`.

Chụp terminal thật và lưu tại thư mục `homework/session_05` ở gốc workspace:

- `exercise_01/build_images.png`: đủ bốn image, tag `latest`.
- `exercise_02/compose_up.png`: bốn container Up, cổng 8081–8084.
- `exercise_03/env_config.png`: cấu hình nội suy hợp lệ. Để không lộ mật khẩu thật, có thể chụp `docker compose --env-file .env.example config`, nêu rõ đây là cấu hình mẫu.
- `exercise_04/table_generation.png`: `users`, `user_addresses`, `user_wallets` trong `quickbite_user_db`.

Cả bốn ứng dụng cấu hình `spring.jpa.hibernate.ddl-auto: update`. Không có `schema.sql`; ba bảng user được ánh xạ bằng entity JPA. Muốn chứng minh bảng thực sự do Hibernate tạo, kiểm thử trên database rỗng dành riêng cho bài, không xóa dữ liệu đang có.

## 5. Nộp Git

Đưa `quickbite-project` và ảnh chụp vào repository nộp bài. Bỏ qua `.env`, `.gradle` và `build`. Các Gradle wrapper JAR cần được commit. Workspace hiện kế thừa Git repository tại ổ E và chưa cấu hình remote; cần chọn đúng repository/remote nộp bài trước khi push.
