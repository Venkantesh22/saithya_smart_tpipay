# Saithya Smart / TPIPay — REST API Backend Documentation

## 1. Introduction
This documentation provides comprehensive details for the Laravel REST API backend developed to serve the **Saithya Smart / TPIPay** Flutter mobile application.
The backend faithfully reproduces all endpoint contracts, authentication mechanisms, parameters, nested JSON responses, and business workflows reverse-engineered from the Flutter app.

---

## 2. Server Environment & Configuration

- **Framework**: Laravel 13.x (PHP 8.3+)
- **Database Engine**: MySQL / MariaDB (InnoDB, `utf8mb4`)
- **Authentication**: Laravel Sanctum (`PersonalAccessToken`, Bearer token)
- **Default Port**: `8000`
- **File Storage**: `public` disk (`storage/uploads/...` linked via `php artisan storage:link`)

### Quick Server Launch
To start the backend server accessible to web clients and mobile emulators:
```powershell
cd backend
php artisan serve --host=0.0.0.0 --port=8000
```

---

## 3. Connecting the Flutter Application

In Flutter file [`lib/services/constants.dart`](file:///d:/Desktop/Flutter/saithya_smart_tpipay-main/lib/services/constants.dart#L150-L155):
```dart
class AppConstants {
  // Development (Android Emulator):
  static String baseUrl = 'http://10.0.2.2:8000/';

  // Development (Physical Device on same Wi-Fi / Windows):
  // static String baseUrl = 'http://192.168.1.XX:8000/';

  // Production:
  // static String baseUrl = 'https://sathiyasmart.com/';
...
```

---

## 4. Complete API Endpoint Reference

### 4.1 Authentication & Profile Module

#### 1. Login
- **URL**: `POST /api/login` (Alias: `POST /api/login-post`)
- **Headers**: `Accept: application/json`
- **Body**: (FormData / JSON)
  - `mobile` (string, required): 10-digit mobile number or email
  - `password` (string, required): User password
- **Success Response (200)**:
```json
{
  "status": true,
  "message": "Login successful",
  "data": {
    "token": "1|qWf98d...sanctum_token...",
    "user": {
      "id": 2,
      "first_name": "John",
      "last_name": "Doe",
      "name": "John Doe",
      "email": "user@example.com",
      "mobile": "9876543210",
      "referral_code": "SAITHYA1234",
      "image": null,
      "dob": "1995-06-15",
      "gender": "Male",
      "wallet_pin_set": true,
      "wallet_balance": 5000.0,
      "reward_points": 500,
      "is_verified": true,
      "created_at": "2026-10-08T09:16:30Z"
    }
  }
}
```

#### 2. User Registration
- **URL**: `POST /api/register-user`
- **Body**:
  - `first_name` (string, required)
  - `last_name` (string, optional)
  - `mobile` (string, required, 10 digits)
  - `email` (string, required, email format)
  - `password` (string, required, min 6)
  - `referral_code` (string, optional)
- **Success Response (200)**:
```json
{
  "status": true,
  "success": true,
  "message": "OTP sent successfully to your mobile number",
  "data": {
    "mobile": "9876543210",
    "debug_otp": "482910"
  }
}
```

#### 3. Verify Registration OTP
- **URL**: `POST /api/register-verify-otp` (Alias: `POST /api/verify-otp`)
- **Body**:
  - `mobile` (string, required)
  - `otp` (string, required)
- **Success Response (200)**:
```json
{
  "status": true,
  "success": true,
  "message": "Account verified successfully.",
  "data": {
    "token": "2|...",
    "user": { ... }
  }
}
```

#### 4. Resend OTP
- **URL**: `POST /api/resend-otp` (Alias: `POST /api/send-otp`)
- **Body**:
  - `mobile` (string, required)
  - `type` (string, optional: `register` or `forgot_password`)

#### 5. Forgot Password & Reset Password
- **URL**: `POST /api/forgot-password` -> Dispatches OTP
- **URL**: `POST /api/reset-password` -> Takes `mobile`, `otp`, `password`

#### 6. Profile Inquiries & Updates
- **URL**: `GET /api/profile` [Protected] -> Returns user profile and wallet balance.
- **URL**: `POST /api/profile-update` (Alias: `POST /api/edit-profile`) [Protected]
  - Multipart Form: `first_name`, `last_name`, `email`, `dob`, `gender`, `image` (file).
- **URL**: `POST /api/logout` [Protected] -> Revokes Sanctum token.

---

### 4.2 Banners & Catalog Module

#### 1. Banners
- **URL**: `GET /api/banners`
- **Response**: Array of banner records `{ id, title, image, link }`.

#### 2. Categories
- **URL**: `GET /api/category`
- **Response**:
```json
{
  "status": true,
  "data": {
    "data": [
      {
        "id": 1,
        "name": "Electronics & Gadgets",
        "slug": "electronics-gadgets",
        "icon": "http://localhost:8000/..."
      }
    ]
  }
}
```

#### 3. Category Details
- **URL**: `GET /api/category-details/{id}`
- **Response**: Category entity containing nested `products` array with images and features.

#### 4. Products Listing & Search
- **URL**: `GET /api/products` (Alias: `GET /api/today-hot-deals`) -> Paginated products.
- **URL**: `GET /api/products-details/{id}` -> Detailed product spec, features JSON, gallery images.
- **URL**: `GET /api/products/search?query={keyword}` -> Multi-attribute catalog search.

---

### 4.3 Cart & Coupons Module

#### 1. Add to Cart
- **URL**: `POST /api/add-carts/{productId}` [Protected]
- **Body**: `quantity` (integer, default 1)

#### 2. Get Cart
- **URL**: `POST /api/carts` [Protected]
- **Response**:
```json
{
  "status": true,
  "data": {
    "items": [
      {
        "id": 1,
        "cart_id": 1,
        "product_id": 1,
        "quantity": 2,
        "price": 1499.0,
        "total": 2998.0,
        "product": { ... }
      }
    ],
    "subtotal": 2998.0,
    "discount": 0.0,
    "total": 2998.0
  }
}
```

#### 3. Decrease / Remove Cart Item
- **URL**: `POST /api/cart/decrease` [Protected] -> `product_id`
- **URL**: `POST /api/cart/remove` [Protected] -> `product_id`

#### 4. Apply Coupon
- **URL**: `POST /api/coupon/apply` (Alias: `POST /api/check-coupon-code`) [Protected]
- **Body**: `code`
- **Response**:
```json
{
  "status": true,
  "message": "Coupon applied successfully",
  "data": {
    "coupon_code": "WELCOME50",
    "discount_amount": 100.0,
    "subtotal": 1499.0,
    "final_amount": 1399.0
  }
}
```

---

### 4.4 Orders & Dynamic UPI QR Payments

#### 1. Place Order
- **URL**: `POST /api/order/store` (Alias: `POST /api/checkout`, `POST /api/pay-order`) [Protected]
- **Body**:
  - `address_id` (integer, required)
  - `billing_name` (string)
  - `billing_phone` (string)
  - `coupon_code` (string, optional)
- **Response**:
```json
{
  "status": true,
  "message": "Order created successfully",
  "data": {
    "order_id": 1,
    "order_number": "ORD-ABC123XYZ",
    "total_price": 1399.0
  }
}
```

#### 2. Dynamic QR Payment
- **URL**: `POST /api/tpipay/paymentOrder/{orderId}` [Protected]
- **Response**:
```json
{
  "status": true,
  "data": {
    "order_id": 1,
    "order_number": "ORD-ABC123XYZ",
    "amount": 1399.0,
    "qr_data": "upi://pay?pa=saithya@tpipay&pn=SaithyaSmart&am=1399.00&tr=ORD-ABC123XYZ",
    "payment_status": "pending"
  }
}
```

---

### 4.5 Wallet & Dynamic Add-Fund Module

#### 1. Wallet Balance
- **URL**: `GET /api/wallet/balance` (Alias: `GET /api/consumer/wallet`) [Protected]
- **Response**: `{ "status": true, "data": { "balance": 5000.0, "currency": "INR" } }`

#### 2. Wallet PIN Setup
- **URL**: `POST /api/wallet/create-pin` (Aliases: `POST /api/create/consumer/wallet`, `POST /api/wallet/pin/verify`) [Protected]
- **Body**: `pin` (6 digits numeric)

#### 3. Dynamic QR Add-Fund Order
- **URL**: `POST /api/add-fund/create-order` [Protected]
- **Body**: `amount`
- **Response**:
```json
{
  "status": "success",
  "message": "Payment order generated successfully",
  "data": {
    "order_id": "AF-928419",
    "amount": 500.0,
    "qr_data": "upi://pay?pa=saithya@tpipay&pn=SaithyaSmart&am=500.00&tr=AF-928419",
    "expires_in": 300
  }
}
```

#### 4. Add-Fund Status Polling
- **URL**: `POST /api/add-fund/status` (Alias: `POST /api/upi/status`) [Protected]
- **Body**: `order_id`

---

### 4.6 Bank Fund Requests (Manual Deposit)

- **URL**: `GET /api/bank/list` (Alias: `GET /api/assign/account`) [Protected] -> Returns active company bank accounts.
- **URL**: `POST /api/fund/request/store` (Alias: `POST /api/fund/request`) [Protected] -> Multipart submission: `bank_id`, `amount`, `trans_date`, `utr`, `slip` (file).
- **URL**: `GET /api/fund/request/history` (Alias: `GET /api/fund/request/status`) [Protected] -> List past fund requests.
- **URL**: `GET /api/fund/request/status/{id}/deatils` [Protected] -> Specific request verification breakdown.

---

### 4.7 Mobile & DTH Recharge Module

- **URL**: `POST /api/recharge-operator-search` [Protected] -> Input `mobile` (10 digits), returns `operator_id` and `circle_id`.
- **URL**: `POST /api/mobile-plans` [Protected] -> Input `operator_id`, `circle_id`. Returns categorized plans (Daily, Unlimited, 5G, Annual).
- **URL**: `POST /api/recharge-payment` (Aliases: `POST /api/recharge`, `POST /api/recharge/create`) [Protected]
  - Body: `mobile`, `operator_id`, `circle_id`, `amount`, `wallet_pin`.
  - Verifies hashed wallet PIN, checks balance, debits wallet ledger, records transaction.
- **URL**: `POST /api/recharge-status` [Protected] -> Input `transaction_id`.

---

### 4.8 Memberships & Subscriptions Module

- **URL**: `GET /api/subscription/categories` (Alias: `GET /api/membership-plans-category`) [Protected]
- **URL**: `GET /api/membership/plans` (Alias: `GET /api/membership-plans`) [Protected]
- **URL**: `POST /api/membership/{id}/checkout` [Protected] -> Subscribes with `wallet_pin`.
- **URL**: `GET /api/membership/history` (Alias: `GET /api/memberships/user/plan`) [Protected]

---

### 4.9 Gamification (Rewards, Scratch Cards & Spin Wheel)

- **URL**: `GET /api/rewards` [Protected] -> Returns active scratch cards and points balance.
- **URL**: `POST /api/scratch-cards/scratch/{id}` [Protected] -> Reveals randomized won points.
- **URL**: `GET /api/spin-wheel/items` (Alias: `GET /api/spin/wheels`) [Protected] -> Wheel sector items.
- **URL**: `POST /api/spin-wheel/spin` [Protected] -> Executes spin and awards points.
- **URL**: `POST /api/reward-points/convert` [Protected] -> Converts points to wallet at 10 points = ₹1.

---

### 4.10 Multi-Tier Referrals Module

- **URL**: `GET /api/referrals` [Protected] -> Returns complete recursive tree of team referrals.
- **URL**: `GET /api/referrals/levels` [Protected] -> Returns count of users in Level 1 through Level 5.
- **URL**: `GET /api/referrals/level/{id}` [Protected] -> Lists downline members with ranks and wallet status.

---

### 4.11 Support & Application Settings

- **URL**: `POST /api/support/ticket` [Protected] -> Creates support ticket with optional attachment.
- **URL**: `GET /api/support/tickets` [Protected] -> User ticket history.
- **URL**: `GET /api/support/contact` (Alias: `GET /api/support`) [Public/Protected] -> Mobile, email, WhatsApp.
- **URL**: `GET /api/app-settings` [Public] -> Key-value configuration.
- **URL**: `GET /api/privacy-policy` [Public] -> HTML policy content.
- **URL**: `GET /api/terms-and-conditions` (Alias: `GET /api/terms-conditions`) [Public] -> HTML terms content.
