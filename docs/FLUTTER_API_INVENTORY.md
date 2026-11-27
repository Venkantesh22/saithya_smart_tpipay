# Complete Flutter API Inventory — Saithya Smart / TPIPay

## Overview
This inventory documents every REST API endpoint discovered during deep reverse engineering of the **Saithya Smart (TPIPay)** Flutter mobile application.
- **Application Package**: `com.saithiya.smart` / `lekra`
- **Original Base URL**: `https://sathiyasmart.com/` (Configured in `lib/services/constants.dart`)
- **HTTP Client**: GetConnect / http via `ApiClient` (`lib/data/api/api_client.dart`)
- **Default Headers**:
  - `Accept: application/json`
  - `Authorization: Bearer {token}` (when authenticated)

---

## Complete API Inventory Table

| Module | Screen | API Endpoint | Method | Parameters | Authentication | Response Format | Status |
|---|---|---|---|---|---|---|---|
| Authentication | Forgot Password, Reset PIN | `api/send-otp` | POST | `mobile` (FormData) | Public | `{ status: true, message: "..." }` | Verified |
| Authentication | OTP Verification | `api/verify-otp` | POST | `mobile`, `otp` (FormData) | Public | `{ status: true, message: "..." }` | Verified |
| Authentication | Sign Up | `api/register-user` | POST | `first_name`, `last_name`, `email`, `password`, `referral_code`, `mobile` (FormData) | Public | `{ status: true, message: "...", token: "..." }` | Verified |
| Authentication | Login | `api/login-post` | POST | `email`, `mobile`, `password` (FormData) | Public | `{ status: true, message: "...", token: "...", user: { ... } }` | Verified |
| Authentication | Account Screen | `api/logout` | POST | None | Bearer Token | `{ status: true, message: "..." }` | Verified |
| Authentication | Splash, Profile, Dashboard | `api/profile` | GET | None | Bearer Token | `{ status: true, message: "...", data: { UserModel } }` | Verified |
| Authentication | Password Update Screen | `api/update-password` | POST | `mobile`, `password`, `password_confirmation` (FormData) | Public / Bearer | `{ status: true, message: "..." }` | Verified |
| Authentication | Sign Up OTP Verification | `api/register-verify-otp` | POST | `mobile`, `otp` (FormData) | Public | `{ status: true, message: "...", token: "..." }` | Verified |
| Authentication | OTP Verification | `api/resend-otp` | POST | `mobile` (FormData) | Public | `{ status: true, message: "..." }` | Verified |
| User Profile | Edit Profile Screen | `api/edit-otp-send` | POST | `mobile` (FormData) | Bearer Token | `{ status: true, message: "..." }` | Verified |
| User Profile | Edit Profile Screen | `api/edit-verify-otp` | POST | `mobile`, `otp` (FormData) | Bearer Token | `{ status: true, message: "..." }` | Verified |
| User Profile | Edit Profile Screen | `api/edit-profile` | POST (Multipart) | `first_name`, `last_name`, `email`, `dob`, `gender`, `image` (file) | Bearer Token | `{ status: true, message: "..." }` | Verified |
| Addresses | Saved Address List | `api/get-address` | GET | None | Bearer Token | `{ status: true, message: "...", data: [ AddressModel ] }` | Verified |
| Addresses | Add Address Screen | `api/add-address` | POST | `street`, `city`, `state`, `pincode` (FormData) | Bearer Token | `{ status: true, message: "..." }` | Verified |
| Addresses | Address Screen | `api/delete-address/{addressId}` | POST | Path: `addressId` | Bearer Token | `{ status: true, message: "..." }` | Verified |
| Addresses | Checkout Screen | `api/order-address/{addressId}` | GET | Path: `addressId` | Bearer Token | `{ status: true, message: "...", data: AddressModel }` | Verified |
| Content | Home Screen | `api/banners` | GET | None | Public / Bearer | `{ status: true, message: "...", data: [ BannerModel ] }` | Verified |
| E-Commerce | Home, Category Screen | `api/category` | GET | None | Public / Bearer | `{ status: true, data: { data: [ CategoryModel ] } }` | Verified |
| E-Commerce | Home Screen | `api/products` | GET | Query: `page` | Public / Bearer | `{ status: true, data: { current_page, last_page, total, data: [ ProductModel ] } }` | Verified |
| E-Commerce | Home Screen | `api/today-hot-deals` | GET | None | Public / Bearer | `{ status: true, data: { data: [ ProductModel ] } }` | Verified |
| E-Commerce | Search Screen | `api/products/search` | GET | Query: `query` | Public / Bearer | `{ status: true, products: [ ProductModel ] }` | Verified |
| E-Commerce | Category Detail Screen | `api/category-details/{categoryId}` | GET | Path: `categoryId`, Query: `page`, `sort` (`low_high`/`high_low`) | Public / Bearer | `{ success: true, products: { current_page, last_page, data: [ ProductModel ] } }` | Verified |
| E-Commerce | Product Detail Screen | `api/products-details/{productId}` | GET | Path: `productId` | Public / Bearer | `{ success: true, data: ProductModel }` | Verified |
| Cart | Product Details | `api/add-carts/{productId}` | POST | Path: `productId`, Body: `productName`, `productPrice`, `productId` (FormData) | Bearer Token | `{ status: true, message: "..." }` | Verified |
| Cart | Cart Screen | `api/cart/decrease` | POST | `product_id` (JSON/FormData) | Bearer Token | `{ status: true, message: "..." }` | Verified |
| Cart | Cart, Checkout Screens | `api/carts` | POST | `code` (optional coupon), `rewardcoins` (bool) (FormData) | Bearer Token | `{ status: true, message: "...", data: CardModel }` | Verified |
| Coupons | Checkout Screen | `api/check-coupon-code` | POST | `code` (FormData) | Bearer Token | `{ status: true, message: "..." }` | Verified |
| Orders | Checkout Screen | `api/checkout` | POST | `address_id`, `billing_name`, `billing_email`, `billing_phone`, `code` (FormData) | Bearer Token | `{ status: true, order: { id: 123, ... } }` | Verified |
| Orders | Wallet Enter PIN Screen | `api/pay-order/{orderId}` | POST | Path: `orderId`, Body: `wallet_pin` (FormData) | Bearer Token | `{ status: true, message: "..." }` | Verified |
| Orders | Orders List Screen | `api/orders` | GET | None | Bearer Token | `{ status: true, message: "...", data: [ OrderModel with products ] }` | Verified |
| Orders | Dynamic QR Screen | `api/order/payment-status` | POST | `gateway_order_id` (FormData) | Bearer Token | `{ status: true, transaction_status: "success", message: "..." }` | Verified |
| Dynamic QR | Select Payment Screen | `api/tpipay/paymentOrder/{orderId}` | POST | Path: `orderId` | Bearer Token | `{ status: true, data: DynamicModel }` | Verified |
| Dynamic QR | Payment Gateway Callback | `api/tpipay/callback` | POST | Gateway callback payload | Public | `{ status: true, message: "..." }` | Verified |
| Wallet | Wallet Screen, App Bar | `api/consumer/wallet` | GET | None | Bearer Token | `{ status: true, wallet: 500.00, message: "..." }` | Verified |
| Wallet | Wallet PIN Creation | `api/create/consumer/wallet` | POST | `wallet_pin`, `wallet_pin_confirmation` (FormData) | Bearer Token | `{ status: true, message: "..." }` | Verified |
| Wallet | Wallet PIN Verify | `api/wallet/pin/verify` | POST | `old_pin` (FormData) | Bearer Token | `{ status: true, message: "..." }` | Verified |
| Wallet | Wallet PIN Reset | `api/wallet/pin/reset` | POST | `new_pin`, `confirm_pin` (FormData) | Bearer Token | `{ status: true, message: "..." }` | Verified |
| Wallet | Wallet Transactions | `api/wallet/transactions` | GET | Query: `page`, optional `date`, optional `amount` | Bearer Token | `{ status: true, data: { transactions: { current_page, last_page, data: [...] }, addfund: [...], recharge: [...] } }` | Verified |
| Membership | Subscription Category | `api/membership-plans-category` | GET | None | Bearer Token | `{ status: true, message: "...", data: [ SubscriptionCategoryModel ] }` | Verified |
| Membership | Subscription Category | `api/membership-plans/{id}` | GET | Path: `id` (category ID) | Bearer Token | `{ status: true, message: "...", data: [ SubscriptionModel ] }` | Verified |
| Membership | Subscription Details | `api/membership-plans-details/{id}` | GET | Path: `id` (plan ID) | Bearer Token | `{ status: true, message: "...", data: SubscriptionModel }` | Verified |
| Membership | Membership Wallet Pay | `api/membership/{id}/checkout` | POST | Path: `id`, Body: `wallet_pin` (FormData) | Bearer Token | `{ status: true, message: "...", data: SubscriptionModel }` | Verified |
| Membership | Profile, Subscription History | `api/memberships/user/plan` | GET | None | Bearer Token | `{ status: true, message: "...", data: [ SubscriptionHistoryModel ] }` | Verified |
| Membership | Membership QR Pay | `api/membership/payment/{subscriptionID}` | POST | Path: `subscriptionID` | Bearer Token | `{ status: true, message: "...", data: DynamicModel }` | Verified |
| Membership | Membership QR Status | `api/membership/payment/status/qr/{orderID}` | GET | Path: `orderID` | Bearer Token | `{ status: true, transaction_status: "success", message: "..." }` | Verified |
| Referrals | Referral Tree Graph View | `api/referrals` | GET | None | Bearer Token | `{ status: true, data: { referrals: [ ReferralModel ] } }` | Verified |
| Referrals | Referral Level Tab | `api/referrals/levels` | GET | None | Bearer Token | `{ status: true, data: [ ReferralLevelModel ] }` | Verified |
| Referrals | Referral Level Detail | `api/referrals/level/{levelId}` | GET | Path: `levelId` | Bearer Token | `{ status: true, data: [ ReferralLevelDetailsModel ] }` | Verified |
| Rewards | Rewards Screen | `api/rewards` | GET | None | Bearer Token | `{ status: true, data: { active_scratch_cards: [ ScratchCardModel ] } }` | Verified |
| Rewards | Scratch Card Reveal | `api/scratch-cards/{scratchId}/redeem` | POST | Path: `scratchId` | Bearer Token | `{ status: true, data: { ... }, message: "..." }` | Verified |
| Rewards | Reward History Screen | `api/reward-wallet-history` | GET | None | Bearer Token | `{ status: true, data: [ RewardsTransactionModel ] }` | Verified |
| Rewards | Spin Wheel Screen | `api/spin/wheels` | GET | None | Bearer Token | `{ status: true, data: [ SpinWheelModel ] }` | Verified |
| Rewards | Spin Wheel Screen | `api/scratchcard/create` | POST | `value`, `type` (FormData) | Bearer Token | `{ status: true, message: "..." }` | Verified |
| Fund Request | Fund Request Bank Option | `api/assign/account` | GET | None | Bearer Token | `{ status: true, data: [ BankModel ] }` | Verified |
| Fund Request | Manual Fund Submit | `api/fund/request` | POST | `bank_id`, `amount`, `trans_date`, `utr` (FormData) | Bearer Token | `{ status: true, message: "..." }` | Verified |
| Fund Request | Fund Request Status List | `api/fund/request/status` | GET | None | Bearer Token | `{ status: true, data: [ FundRequestsModel ] }` | Verified |
| Fund Request | Fund Request Details | `api/fund/request/status/{id}/deatils` | GET | Path: `id` | Bearer Token | `{ status: true, data: FundRequestsModel }` | Verified |
| Add Fund QR | Dynamic UPI QR | `api/add-fund/create-order` | POST | `amount` (FormData) | Bearer Token | `{ status: "success", order_id: 12, amount: "100", qrString: "...", gateway_order_id: 456, message: "..." }` | Verified |
| Add Fund QR | UPI Gateway Status Polling | `api/upi/status/{gatewayOrderId}` | POST | Path: `gatewayOrderId` | Bearer Token | `{ status: true, payment_status: "success", message: "..." }` | Verified |
| Add Fund QR | Add Fund Status Check | `api/add-fund/status` | POST | `order_id` (FormData) | Bearer Token | `{ status: "success", data: DynamicWalletPaymentDoneModel }` | Verified |
| Recharge | Recharge Plan Browser | `api/mobile-plans` | GET | Query: `operator_code`, `circle_code` | Bearer Token | `{ success: true, operator_code: "...", circle_code: "...", plans: { "TOPUP": [ ... ], "DATA": [ ... ] } }` | Verified |
| Recharge | Recharge Wallet PIN Pay | `api/recharge` | POST | `mobile`, `amount`, `operator_id`, `wallet_pin` (FormData) | Bearer Token | `{ status: true, message: "...", data: RechargeSuccessModel }` | Verified |
| Recharge | Dynamic QR for Recharge | `api/recharge/create` | POST | `mobile`, `operator_id`, `amount` (FormData) | Bearer Token | `{ status: true, data: DynamicModel }` | Verified |
| Legal & Info | Privacy Center Screen | `api/privacy-policy` | GET | None | Public | `{ status: true, message: "...", data: { description: "..." } }` | Verified |
| Legal & Info | Terms & Conditions | `api/terms-conditions` | GET | None | Public | `{ status: true, message: "...", data: { description: "..." } }` | Verified |
| Help & Info | Help & Support Screen | `api/support` | GET | None | Public | `{ status: true, message: "...", data: { mobile: "...", email: "...", whatsapp: "..." } }` | Verified |

---

## Detailed Endpoint Breakdown

### 1. `POST /api/send-otp`
- **Purpose**: Generates and sends OTP to a user's mobile number for password recovery or reset PIN flow.
- **Headers**: `Accept: application/json`
- **Auth**: Public
- **Body**: Form-data
  - `mobile` (string, required, 10 digits)
- **Response**:
```json
{
  "status": true,
  "message": "OTP sent successfully"
}
```
- **Error Response**:
```json
{
  "status": false,
  "message": "User not found or unable to send OTP"
}
```

### 2. `POST /api/verify-otp`
- **Purpose**: Verifies 6-digit OTP for forgot password or wallet reset pin flows.
- **Headers**: `Accept: application/json`
- **Auth**: Public
- **Body**: Form-data
  - `mobile` (string, required)
  - `otp` (string, required, 6 digits)
- **Response**:
```json
{
  "status": true,
  "message": "OTP verified successfully"
}
```
- **Error Response**:
```json
{
  "status": false,
  "error": "Invalid or expired OTP"
}
```

### 3. `POST /api/register-user`
- **Purpose**: Registers a new customer account.
- **Headers**: `Accept: application/json`
- **Auth**: Public
- **Body**: Form-data
  - `first_name` (string, required)
  - `last_name` (string, required)
  - `email` (string, required, email format)
  - `mobile` (string, required, 10 digits)
  - `password` (string, required, min 8 chars with uppercase, lowercase, number, special char)
  - `referral_code` (string, optional)
- **Response**:
```json
{
  "status": true,
  "message": "User registered successfully",
  "token": "1|sanctum_token_string"
}
```

### 4. `POST /api/login-post`
- **Purpose**: Authenticates user via email or 10-digit mobile number + password.
- **Headers**: `Accept: application/json`
- **Auth**: Public
- **Body**: Form-data
  - `email` (string, optional - provided if email login)
  - `mobile` (string, optional - provided if mobile login)
  - `password` (string, required)
- **Response**:
```json
{
  "status": true,
  "message": "Login successful",
  "token": "2|sanctum_token_string",
  "user": {
    "id": 1,
    "first_name": "John",
    "last_name": "Doe",
    "email": "john@example.com",
    "mobile": "9876543210",
    "is_verified": 1
  }
}
```

### 5. `POST /api/logout`
- **Purpose**: Revokes current access token.
- **Headers**: `Accept: application/json`, `Authorization: Bearer {token}`
- **Auth**: Required
- **Response**:
```json
{
  "status": true,
  "message": "Logged out successfully"
}
```

### 6. `GET /api/profile`
- **Purpose**: Fetches the authenticated user profile, wallet balance, active subscription, reward coins, referral links and hierarchy status.
- **Headers**: `Accept: application/json`, `Authorization: Bearer {token}`
- **Auth**: Required
- **Response**:
```json
{
  "status": true,
  "message": "Profile fetched successfully",
  "data": {
    "id": 1,
    "first_name": "John",
    "last_name": "Doe",
    "gender": "Male",
    "is_verified": 1,
    "image": "https://sathiyasmart.com/uploads/profile/user1.jpg",
    "email": "john@example.com",
    "mobile": "9876543210",
    "referral_code": "JOHN123",
    "created_at": "2026-01-01T00:00:00.000000Z",
    "updated_at": "2026-01-02T00:00:00.000000Z",
    "dob": "1995-05-15",
    "current_wallet": 1250.50,
    "reward_point": 150,
    "referralLink": "https://sathiyasmart.com/register?ref=JOHN123",
    "referral_links": {
      "web": "https://sathiyasmart.com/register?ref=JOHN123",
      "app": "https://sathiyasmart.com/app/ref=JOHN123",
      "playstore": "https://play.google.com/store/apps/details?id=com.tpipay.trustindia&referrer=JOHN123"
    },
    "subscription": {
      "subscription_id": 5,
      "start_date": "2026-01-01T00:00:00.000000Z",
      "end_date": "2026-12-31T00:00:00.000000Z",
      "status": 1,
      "plan_name": "VIP Annual Plan",
      "price": "999.00",
      "discount_price": "799.00",
      "total_days": 365,
      "used_days": 10,
      "remaining_days": 355
    },
    "referred_level": {
      "total_downline": 25,
      "levels_completed": 2,
      "current_rank": "Silver",
      "next_rank": "Gold",
      "people_needed_for_next_rank": 15
    }
  }
}
```

### 7. `POST /api/update-password`
- **Purpose**: Updates the user's password using mobile verification.
- **Headers**: `Accept: application/json`
- **Body**: Form-data
  - `mobile` (string, required)
  - `password` (string, required)
  - `password_confirmation` (string, required)
- **Response**:
```json
{
  "status": true,
  "message": "Password updated successfully"
}
```

### 8. `POST /api/register-verify-otp`
- **Purpose**: Verifies OTP sent during registration.
- **Headers**: `Accept: application/json`
- **Body**: Form-data
  - `mobile` (string, required)
  - `otp` (string, required)
- **Response**:
```json
{
  "status": true,
  "message": "Mobile number verified successfully",
  "token": "3|sanctum_token"
}
```

### 9. `POST /api/resend-otp`
- **Purpose**: Resends registration or phone verification OTP.
- **Headers**: `Accept: application/json`
- **Body**: Form-data
  - `mobile` (string, required)
- **Response**:
```json
{
  "status": true,
  "message": "OTP resent successfully"
}
```

### 10. `POST /api/edit-otp-send`
- **Purpose**: Sends OTP to mobile when user requests phone number change in Profile Edit.
- **Headers**: `Accept: application/json`, `Authorization: Bearer {token}`
- **Body**: Form-data
  - `mobile` (string, required)
- **Response**:
```json
{
  "status": true,
  "message": "OTP sent to new mobile number"
}
```

### 11. `POST /api/edit-verify-otp`
- **Purpose**: Verifies OTP for updating mobile number.
- **Headers**: `Accept: application/json`, `Authorization: Bearer {token}`
- **Body**: Form-data
  - `mobile` (string, required)
  - `otp` (string, required)
- **Response**:
```json
{
  "status": true,
  "message": "Mobile number updated successfully"
}
```

### 12. `POST /api/edit-profile`
- **Purpose**: Updates user profile info and avatar image.
- **Headers**: `Accept: application/json`, `Authorization: Bearer {token}`
- **Body**: Multipart Form-data
  - `first_name` (string, required)
  - `last_name` (string, required)
  - `email` (string, required)
  - `dob` (string, required, e.g. "15-05-1995")
  - `gender` (string, required, Male/Female/Other)
  - `image` (file, optional)
- **Response**:
```json
{
  "status": true,
  "message": "Profile updated successfully"
}
```

### 13. `GET /api/get-address`
- **Purpose**: Retrieves all delivery addresses for the user.
- **Headers**: `Accept: application/json`, `Authorization: Bearer {token}`
- **Response**:
```json
{
  "status": true,
  "message": "Addresses retrieved",
  "data": [
    {
      "id": 1,
      "user_id": 1,
      "street": "123 Main Road",
      "city": "Chennai",
      "state": "Tamil Nadu",
      "pincode": "600001",
      "created_at": "2026-01-01T00:00:00.000000Z",
      "updated_at": "2026-01-01T00:00:00.000000Z"
    }
  ]
}
```

### 14. `POST /api/add-address`
- **Purpose**: Creates a new user shipping address.
- **Headers**: `Accept: application/json`, `Authorization: Bearer {token}`
- **Body**: Form-data
  - `street` (string, required)
  - `city` (string, required)
  - `state` (string, required)
  - `pincode` (string, required)
- **Response**:
```json
{
  "status": true,
  "message": "Address added successfully"
}
```

### 15. `POST /api/delete-address/{addressId}`
- **Purpose**: Deletes an address by ID.
- **Headers**: `Accept: application/json`, `Authorization: Bearer {token}`
- **Response**:
```json
{
  "status": true,
  "message": "Address deleted successfully"
}
```

### 16. `GET /api/order-address/{addressId}`
- **Purpose**: Retrieves single address details for an order.
- **Headers**: `Accept: application/json`, `Authorization: Bearer {token}`
- **Response**:
```json
{
  "status": true,
  "message": "Address fetched",
  "data": {
    "id": 1,
    "user_id": 1,
    "street": "123 Main Road",
    "city": "Chennai",
    "state": "Tamil Nadu",
    "pincode": "600001"
  }
}
```

### 17. `GET /api/banners`
- **Purpose**: Returns active banners for carousel slider on Home page.
- **Response**:
```json
{
  "status": true,
  "message": "Banners fetched",
  "data": [
    {
      "id": 1,
      "image": "https://sathiyasmart.com/uploads/banners/banner1.jpg",
      "created_at": "2026-01-01T00:00:00.000000Z",
      "updated_at": "2026-01-01T00:00:00.000000Z"
    }
  ]
}
```

### 18. `GET /api/category`
- **Purpose**: Lists product categories.
- **Response**:
```json
{
  "status": true,
  "data": {
    "data": [
      {
        "id": 1,
        "name": "Electronics",
        "icon": "https://sathiyasmart.com/uploads/categories/electronics.png",
        "created_at": "2026-01-01T00:00:00.000000Z",
        "updated_at": "2026-01-01T00:00:00.000000Z"
      }
    ]
  }
}
```

### 19. `GET /api/products`
- **Purpose**: Featured products with pagination.
- **Query Params**: `page` (int)
- **Response**:
```json
{
  "status": true,
  "message": "Products fetched",
  "data": {
    "current_page": 1,
    "last_page": 5,
    "per_page": 10,
    "total": 50,
    "data": [
      {
        "id": 10,
        "name": "Smart Watch",
        "description": "High quality smart watch",
        "price": 2999.00,
        "discounted_price": 1999.00,
        "features": ["Heart Rate Monitor", "Bluetooth Calling"],
        "offers": "33%",
        "offer_type": "percentage",
        "price_category": "Standard",
        "category_name": "Electronics",
        "status": "active",
        "images": [
          { "id": 1, "url": "https://sathiyasmart.com/uploads/products/watch1.jpg" }
        ],
        "quantity": 50,
        "created_at": "2026-01-01T00:00:00.000000Z"
      }
    ]
  }
}
```

### 20. `GET /api/today-hot-deals`
- **Purpose**: Hot deals featured on the home screen.
- **Response**:
```json
{
  "status": true,
  "data": {
    "data": [
      {
        "id": 12,
        "name": "Earbuds Pro",
        "description": "True wireless earbuds",
        "price": 1499.00,
        "discounted_price": 999.00,
        "offers": "33%",
        "offer_type": "percentage",
        "category_name": "Electronics",
        "status": "active",
        "images": [
          { "id": 2, "url": "https://sathiyasmart.com/uploads/products/earbuds.jpg" }
        ]
      }
    ]
  }
}
```

### 21. `GET /api/products/search?query={query}`
- **Purpose**: Searches products by name or keywords.
- **Query Params**: `query` (string)
- **Response**:
```json
{
  "status": true,
  "products": [
    {
      "id": 10,
      "name": "Smart Watch",
      "price": 2999.00,
      "discounted_price": 1999.00,
      "category_name": "Electronics",
      "images": [
        { "id": 1, "url": "https://sathiyasmart.com/uploads/products/watch1.jpg" }
      ]
    }
  ]
}
```

### 22. `GET /api/category-details/{categoryId}?page={page}&sort={sort}`
- **Purpose**: Retrieves products under a specific category, with optional sorting (`low_high` or `high_low`).
- **Response**:
```json
{
  "success": true,
  "message": "Category products fetched",
  "products": {
    "current_page": 1,
    "last_page": 3,
    "per_page": 10,
    "total": 25,
    "data": [
      {
        "id": 10,
        "name": "Smart Watch",
        "price": 2999.00,
        "discounted_price": 1999.00,
        "category_name": "Electronics",
        "images": [
          { "id": 1, "url": "https://sathiyasmart.com/uploads/products/watch1.jpg" }
        ]
      }
    ]
  }
}
```

### 23. `GET /api/products-details/{productId}`
- **Purpose**: Retrieves comprehensive single product detail.
- **Response**:
```json
{
  "success": true,
  "message": "Product details fetched",
  "data": {
    "id": 10,
    "name": "Smart Watch",
    "description": "Full specifications and features...",
    "price": 2999.00,
    "discounted_price": 1999.00,
    "features": ["AMOLED Screen", "Waterproof IP68", "7 Days Battery"],
    "offers": "33%",
    "offer_type": "percentage",
    "price_category": "Standard",
    "category_name": "Electronics",
    "status": "active",
    "images": [
      { "id": 1, "url": "https://sathiyasmart.com/uploads/products/watch1.jpg" },
      { "id": 2, "url": "https://sathiyasmart.com/uploads/products/watch2.jpg" }
    ],
    "quantity": 50,
    "created_at": "2026-01-01T00:00:00.000000Z"
  }
}
```

### 24. `POST /api/add-carts/{productId}`
- **Purpose**: Adds an item to user cart.
- **Headers**: `Accept: application/json`, `Authorization: Bearer {token}`
- **Body**: Form-data
  - `productName` (string)
  - `productPrice` (num)
  - `productId` (int)
- **Response**:
```json
{
  "status": true,
  "message": "Product added to cart successfully"
}
```

### 25. `POST /api/cart/decrease`
- **Purpose**: Decrements quantity of an item in cart or removes if 0.
- **Headers**: `Accept: application/json`, `Authorization: Bearer {token}`
- **Body**: `product_id` (int)
- **Response**:
```json
{
  "status": true,
  "message": "Item quantity updated in cart"
}
```

### 26. `POST /api/carts`
- **Purpose**: Calculates and returns the user's current shopping cart, applying coupon code and reward points discount if requested.
- **Headers**: `Accept: application/json`, `Authorization: Bearer {token}`
- **Body**: Form-data
  - `code` (string, optional coupon code)
  - `rewardcoins` (bool, optional true to use reward points)
- **Response**:
```json
{
  "status": true,
  "message": "Cart retrieved successfully",
  "data": {
    "cart_id": 15,
    "products": [
      {
        "id": 10,
        "name": "Smart Watch",
        "price": 2999.00,
        "discounted_price": 1999.00,
        "quantity": 1,
        "images": [
          { "id": 1, "url": "https://sathiyasmart.com/uploads/products/watch1.jpg" }
        ]
      }
    ],
    "subtotal": "2999.00",
    "product_discount": "1000.00",
    "coupon_type": "flat",
    "coupon_value": "100.00",
    "coupon_discount": "100.00",
    "reward_points_used": 50,
    "reward_points_balance": 100,
    "reward_discount": "5.00",
    "total_price": "1894.00"
  }
}
```

### 27. `POST /api/check-coupon-code`
- **Purpose**: Validates coupon promo code.
- **Body**: Form-data
  - `code` (string, required)
- **Response**:
```json
{
  "status": true,
  "message": "Coupon code applied successfully"
}
```

### 28. `POST /api/checkout`
- **Purpose**: Creates an order in pending payment state.
- **Headers**: `Accept: application/json`, `Authorization: Bearer {token}`
- **Body**: Form-data
  - `address_id` (int, required)
  - `billing_name` (string, required)
  - `billing_email` (string, required)
  - `billing_phone` (string, required)
  - `code` (string, optional coupon)
- **Response**:
```json
{
  "status": true,
  "message": "Order created successfully",
  "order": {
    "id": 101,
    "address_id": 1,
    "subtotal": "2999.00",
    "total_price": "1894.00",
    "discount": "1105.00",
    "status": "pending",
    "payment_status": "unpaid",
    "billing_name": "John Doe",
    "billing_phone": "9876543210",
    "billing_email": "john@example.com"
  }
}
```

### 29. `POST /api/pay-order/{orderId}`
- **Purpose**: Deducts order total from consumer wallet after verifying 6-digit wallet PIN.
- **Headers**: `Accept: application/json`, `Authorization: Bearer {token}`
- **Body**: Form-data
  - `wallet_pin` (string, required, 6 digits)
- **Response**:
```json
{
  "status": true,
  "message": "Payment successful and order placed"
}
```

### 30. `GET /api/orders`
- **Purpose**: Fetches order history with ordered products and status tracking.
- **Headers**: `Accept: application/json`, `Authorization: Bearer {token}`
- **Response**:
```json
{
  "status": true,
  "message": "Orders fetched",
  "data": [
    {
      "id": 101,
      "address_id": 1,
      "subtotal": "2999.00",
      "total_price": "1894.00",
      "discount": "1105.00",
      "status": "processing",
      "payment_status": "paid",
      "billing_name": "John Doe",
      "billing_phone": "9876543210",
      "billing_email": "john@example.com",
      "created_at": "2026-01-01T12:00:00.000000Z",
      "updated_at": "2026-01-01T12:05:00.000000Z",
      "products": [
        {
          "id": 10,
          "name": "Smart Watch",
          "price": 2999.00,
          "discounted_price": 1999.00,
          "quantity": 1,
          "status": "processing",
          "order_id": 101,
          "images": [
            { "id": 1, "url": "https://sathiyasmart.com/uploads/products/watch1.jpg" }
          ]
        }
      ]
    }
  ]
}
```

### 31. `POST /api/order/payment-status`
- **Purpose**: Checks status of dynamic QR or payment gateway order.
- **Body**: Form-data
  - `gateway_order_id` (string/int, required)
- **Response**:
```json
{
  "status": true,
  "transaction_status": "success",
  "message": "Payment verified"
}
```

### 32. `GET /api/consumer/wallet`
- **Purpose**: Returns the user's wallet balance.
- **Response**:
```json
{
  "status": true,
  "wallet": "1250.00",
  "message": "Wallet balance fetched"
}
```

### 33. `POST /api/create/consumer/wallet`
- **Purpose**: Sets up initial 6-digit wallet PIN and consumer wallet.
- **Body**: Form-data
  - `wallet_pin` (string, required, 6 digits)
  - `wallet_pin_confirmation` (string, required, 6 digits)
- **Response**:
```json
{
  "status": true,
  "message": "Wallet PIN created successfully"
}
```

### 34. `POST /api/wallet/pin/verify`
- **Purpose**: Verifies existing wallet PIN before entering reset flow.
- **Body**: Form-data
  - `old_pin` (string, required, 6 digits)
- **Response**:
```json
{
  "status": true,
  "message": "PIN verified successfully"
}
```

### 35. `POST /api/wallet/pin/reset`
- **Purpose**: Resets wallet PIN to a new 6-digit PIN.
- **Body**: Form-data
  - `new_pin` (string, required, 6 digits)
  - `confirm_pin` (string, required, 6 digits)
- **Response**:
```json
{
  "status": true,
  "message": "Wallet PIN reset successfully"
}
```

### 36. `GET /api/wallet/transactions`
- **Purpose**: Fetches unified wallet transactions: paginated general transactions, manual addfund history, and mobile recharge records. Supports date and amount filters.
- **Query Params**: `page` (int), `date` (YYYY-MM-DD, optional), `amount` (string, optional)
- **Response**:
```json
{
  "status": true,
  "data": {
    "transactions": {
      "current_page": 1,
      "last_page": 2,
      "per_page": 10,
      "total": 15,
      "data": [
        {
          "id": 1,
          "type": "debit",
          "amount": 1894.00,
          "balance_after": "1250.00",
          "description": "Order #101 payment",
          "created_at": "2026-01-01T12:05:00.000000Z",
          "order_id": "101",
          "status": "success"
        }
      ]
    },
    "addfund": [
      {
        "id": 101,
        "amount": 500.00,
        "product": "addfund",
        "type": "credit",
        "description": "Wallet Add Fund UPI",
        "status": "success",
        "utr": "402918291829",
        "created_at": "2026-01-01T10:00:00.000000Z"
      }
    ],
    "recharge": [
      {
        "id": 201,
        "amount": 299.00,
        "type": "debit",
        "description": "Jio Mobile Recharge",
        "mobile": "9876543210",
        "operator_id": "5",
        "operator_txn_id": "OP9281928",
        "status": "success",
        "created_at": "2026-01-01T11:00:00.000000Z"
      }
    ]
  }
}
```

### 37. `POST /api/tpipay/paymentOrder/{orderId}`
- **Purpose**: Generates dynamic UPI QR for order payment.
- **Response**:
```json
{
  "status": true,
  "message": "QR generated",
  "data": {
    "vpa": "tpipay@upi",
    "qrString": "upi://pay?pa=tpipay@upi&pn=TPIPay&am=1894.00&tr=ORDER101",
    "order_id": 101,
    "amount": "1894.00"
  }
}
```

### 38. `POST /api/tpipay/callback`
- **Purpose**: Webhook / callback for TPIPay dynamic QR payments.
- **Response**:
```json
{
  "status": true,
  "message": "Callback processed"
}
```

### 39. `GET /api/membership-plans-category`
- **Purpose**: Lists categories of membership / subscription plans.
- **Response**:
```json
{
  "status": true,
  "message": "Categories fetched",
  "data": [
    {
      "id": 1,
      "name": "Standard Membership",
      "created_at": "2026-01-01T00:00:00.000000Z"
    }
  ]
}
```

### 40. `GET /api/membership-plans/{id}`
- **Purpose**: Lists subscription plans by category ID.
- **Response**:
```json
{
  "status": true,
  "message": "Plans fetched",
  "data": [
    {
      "id": 5,
      "name": "Gold VIP Plan",
      "price": "999.00",
      "discount_price": "799.00",
      "time_periods": "365",
      "features": ["Free Delivery on all orders", "2x Referral Coins", "Priority Support"]
    }
  ]
}
```

### 41. `GET /api/membership-plans-details/{id}`
- **Purpose**: Single membership plan details.
- **Response**:
```json
{
  "status": true,
  "message": "Plan details fetched",
  "data": {
    "id": 5,
    "name": "Gold VIP Plan",
    "price": "999.00",
    "discount_price": "799.00",
    "time_periods": "365",
    "features": ["Free Delivery on all orders", "2x Referral Coins", "Priority Support"]
  }
}
```

### 42. `POST /api/membership/{id}/checkout`
- **Purpose**: Purchases a membership plan directly using wallet balance and 6-digit PIN.
- **Body**: Form-data
  - `wallet_pin` (string, required, 6 digits)
- **Response**:
```json
{
  "status": true,
  "message": "Membership activated successfully",
  "data": {
    "id": 5,
    "name": "Gold VIP Plan",
    "price": "799.00"
  }
}
```

### 43. `GET /api/memberships/user/plan`
- **Purpose**: Returns active and past membership subscriptions for user.
- **Response**:
```json
{
  "status": true,
  "message": "Subscription history fetched",
  "data": [
    {
      "subscription_id": 5,
      "start_date": "2026-01-01T00:00:00.000000Z",
      "end_date": "2026-12-31T00:00:00.000000Z",
      "status": 1,
      "plan_name": "Gold VIP Plan",
      "price": "999.00",
      "discount_price": "799.00",
      "total_days": 365,
      "used_days": 10,
      "remaining_days": 355
    }
  ]
}
```

### 44. `POST /api/membership/payment/{subscriptionID}`
- **Purpose**: Generates dynamic QR for subscription payment.
- **Response**:
```json
{
  "status": true,
  "message": "QR generated for subscription",
  "data": {
    "vpa": "tpipay@upi",
    "qrString": "upi://pay?pa=tpipay@upi&am=799.00",
    "order_id": 501,
    "amount": "799.00"
  }
}
```

### 45. `GET /api/membership/payment/status/qr/{orderID}`
- **Purpose**: Polling status for membership dynamic QR payment.
- **Response**:
```json
{
  "status": true,
  "transaction_status": "success",
  "message": "Membership payment successful"
}
```

### 46. `GET /api/referrals`
- **Purpose**: Hierarchical downline graph structure.
- **Response**:
```json
{
  "status": true,
  "data": {
    "referrals": [
      {
        "name": "Jane Doe",
        "email": "jane@example.com",
        "wallet": "250.00",
        "referral_code": "JANE99",
        "level": 1,
        "referrals": []
      }
    ]
  }
}
```

### 47. `GET /api/referrals/levels`
- **Purpose**: Summarizes total people count per level.
- **Response**:
```json
{
  "status": true,
  "data": [
    {
      "level_number": 1,
      "current_people_in_level": 5
    },
    {
      "level_number": 2,
      "current_people_in_level": 20
    }
  ]
}
```

### 48. `GET /api/referrals/level/{levelId}`
- **Purpose**: Lists members at a specific referral level.
- **Response**:
```json
{
  "status": true,
  "data": [
    {
      "id": 2,
      "name": "Jane Doe",
      "email": "jane@example.com",
      "referral_code": "JANE99",
      "wallet_balance": "250.00",
      "referred_level": {
        "total_downline": 4,
        "current_rank": "Bronze"
      }
    }
  ]
}
```

### 49. `GET /api/rewards`
- **Purpose**: Lists active scratch cards available for the user.
- **Response**:
```json
{
  "status": true,
  "message": "Rewards fetched",
  "data": {
    "active_scratch_cards": [
      {
        "id": 1,
        "code": "SCRATCH100",
        "type": "points",
        "reward_points": "50",
        "expiry_date": "2026-12-31T23:59:59.000000Z",
        "is_redeemed": 0
      }
    ]
  }
}
```

### 50. `POST /api/scratch-cards/{scratchId}/redeem`
- **Purpose**: Redeems a scratch card once scratched in UI and adds reward coins to wallet.
- **Response**:
```json
{
  "status": true,
  "message": "Scratch card redeemed successfully",
  "data": {
    "reward_points": 50
  }
}
```

### 51. `GET /api/reward-wallet-history`
- **Purpose**: History of earned/spent reward coins.
- **Response**:
```json
{
  "status": true,
  "message": "Reward history fetched",
  "data": [
    {
      "points": "50",
      "description": "Scratch Card win",
      "type": "credit",
      "created_at": "2026-01-01T12:00:00.000000Z"
    }
  ]
}
```

### 52. `GET /api/spin/wheels`
- **Purpose**: Slices on the fortune spin wheel.
- **Response**:
```json
{
  "status": true,
  "message": "Spin wheel options fetched",
  "data": [
    {
      "id": 1,
      "offer_name": "100 Coins",
      "offer_value": "100",
      "type": "points"
    },
    {
      "id": 2,
      "offer_name": "₹50 OFF",
      "offer_value": "50",
      "type": "discount"
    }
  ]
}
```

### 53. `POST /api/scratchcard/create`
- **Purpose**: Creates an un-scratched reward scratch card based on the spin wheel outcome.
- **Body**: Form-data
  - `value` (string, required)
  - `type` (string, required, e.g. "points" or "discount")
- **Response**:
```json
{
  "status": true,
  "message": "Scratch card created from spin reward"
}
```

### 54. `GET /api/assign/account`
- **Purpose**: Returns company bank accounts assigned for manual fund transfer.
- **Response**:
```json
{
  "status": true,
  "message": "Bank details fetched",
  "data": [
    {
      "id": 1,
      "account_name": "TPI Pay Trust Bank",
      "account_number": "123456789012",
      "ifsc": "HDFC0001234",
      "created_at": "2026-01-01T00:00:00.000000Z"
    }
  ]
}
```

### 55. `POST /api/fund/request`
- **Purpose**: Submits manual bank transfer / NEFT / IMPS fund request with UTR number.
- **Body**: Form-data
  - `bank_id` (int, required)
  - `amount` (string, required)
  - `trans_date` (string, required, YYYY-MM-DD)
  - `utr` (string, required)
- **Response**:
```json
{
  "status": true,
  "message": "Fund request submitted for verification"
}
```

### 56. `GET /api/fund/request/status`
- **Purpose**: Lists all fund requests submitted by the user.
- **Response**:
```json
{
  "status": true,
  "message": "Fund requests fetched",
  "data": [
    {
      "id": 1,
      "utr": "UTR123456789",
      "cancelReason": null,
      "trans_date": "2026-01-01",
      "amount": "1000.00",
      "status": "pending",
      "bankaccount": {
        "id": 1,
        "account_name": "TPI Pay Trust Bank",
        "account_number": "123456789012",
        "ifsc": "HDFC0001234"
      },
      "account_name": "TPI Pay Trust Bank",
      "created_at": "2026-01-01T12:00:00.000000Z"
    }
  ]
}
```

### 57. `GET /api/fund/request/status/{id}/deatils`
- **Purpose**: Retrieves details of a specific fund request. (Note: endpoint path preserves the Flutter spelling `deatils`).
- **Response**:
```json
{
  "status": true,
  "message": "Fund request details fetched",
  "data": {
    "id": 1,
    "utr": "UTR123456789",
    "cancelReason": null,
    "trans_date": "2026-01-01",
    "amount": "1000.00",
    "status": "approved",
    "bankaccount": {
      "id": 1,
      "account_name": "TPI Pay Trust Bank",
      "account_number": "123456789012",
      "ifsc": "HDFC0001234"
    },
    "account_name": "TPI Pay Trust Bank"
  }
}
```

### 58. `POST /api/add-fund/create-order`
- **Purpose**: Creates an instant UPI QR payment order to add funds to user wallet.
- **Body**: Form-data
  - `amount` (string, required)
- **Response**:
```json
{
  "status": "success",
  "order_id": "ORD_WALLET_102",
  "amount": "500",
  "qrString": "upi://pay?pa=tpipay@icici&pn=TPIPay&am=500.00&tr=ORD_WALLET_102",
  "gateway_order_id": 901,
  "merchant_order_id": "M_ORD_102",
  "message": "QR generated successfully"
}
```

### 59. `POST /api/upi/status/{gatewayOrderId}`
- **Purpose**: Polls payment gateway status for an instant UPI QR fund addition.
- **Response**:
```json
{
  "status": true,
  "payment_status": "success",
  "message": "Payment verified and credited"
}
```

### 60. `POST /api/add-fund/status`
- **Purpose**: Verifies status of an add-fund dynamic QR order and returns completed transaction details.
- **Body**: Form-data
  - `order_id` (string/int, required)
- **Response**:
```json
{
  "status": "success",
  "message": "Payment verified",
  "data": {
    "order_id": "ORD_WALLET_102",
    "merchant_order_id": "M_ORD_102",
    "amount": "500.00",
    "status": "success",
    "utr": "402918291829",
    "payment_method": "UPI",
    "paid_at": "2026-01-01T12:05:00.000000Z"
  }
}
```

### 61. `GET /api/mobile-plans`
- **Purpose**: Retrieves operator plans categorized by type (TOPUP, DATA, ROAMING, etc.) for a specific circle.
- **Query Params**:
  - `operator_code` (string, e.g. "1", "2", "167")
  - `circle_code` (int, circle ID)
- **Response**:
```json
{
  "success": true,
  "operator_code": "1",
  "circle_code": "20",
  "plans": {
    "TOPUP": [
      {
        "rs": "10",
        "desc": "Talktime: Rs. 7.47",
        "validity": "NA",
        "last_update": "2026-01-01"
      }
    ],
    "DATA": [
      {
        "rs": "19",
        "desc": "1 GB Data",
        "validity": "1 Day",
        "last_update": "2026-01-01"
      }
    ]
  }
}
```

### 62. `POST /api/recharge`
- **Purpose**: Executes mobile prepaid recharge using consumer wallet balance after verifying 6-digit PIN.
- **Body**: Form-data
  - `mobile` (string, required, 10 digits)
  - `amount` (string, required)
  - `operator_id` (string, required)
  - `wallet_pin` (string, required, 6 digits)
- **Response**:
```json
{
  "status": true,
  "message": "Recharge successful",
  "data": {
    "reqid": "REC_981928",
    "mobile": "9876543210",
    "amount": "299.00",
    "status": "SUCCESS",
    "remark": "Recharge successful",
    "operator_txn_id": "OPTXN871829",
    "error_code": "0",
    "created_at": "2026-01-01T12:00:00.000000Z",
    "updated_at": "2026-01-01T12:00:05.000000Z"
  }
}
```

### 63. `POST /api/recharge/create`
- **Purpose**: Generates dynamic QR for directly paying a mobile recharge.
- **Body**: Form-data
  - `mobile` (string, required)
  - `operator_id` (string, required)
  - `amount` (string, required)
- **Response**:
```json
{
  "status": true,
  "message": "QR generated",
  "data": {
    "vpa": "tpipay@upi",
    "qrString": "upi://pay?pa=tpipay@upi&am=299.00",
    "order_id": 801,
    "amount": "299.00"
  }
}
```

### 64. `GET /api/privacy-policy`
- **Purpose**: Fetches privacy policy HTML or text content.
- **Response**:
```json
{
  "status": true,
  "message": "Privacy policy fetched",
  "data": {
    "description": "<h3>Privacy Policy</h3><p>Your privacy is important to us...</p>"
  }
}
```

### 65. `GET /api/terms-conditions`
- **Purpose**: Fetches terms and conditions HTML or text content.
- **Response**:
```json
{
  "status": true,
  "message": "Terms and conditions fetched",
  "data": {
    "description": "<h3>Terms & Conditions</h3><p>By using this service, you agree...</p>"
  }
}
```

### 66. `GET /api/support`
- **Purpose**: Fetches customer support contact info (Phone, Email, WhatsApp).
- **Response**:
```json
{
  "status": true,
  "message": "Support details fetched",
  "data": {
    "id": 1,
    "mobile": "9876543210",
    "email": "support@sathiyasmart.com",
    "whatsapp": "9876543210"
  }
}
```
