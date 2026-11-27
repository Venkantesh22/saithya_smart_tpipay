# Saithya Smart / TPIPay — API Dependency & Sequence Map

## 1. Overview
This document maps all API dependencies, mandatory preconditions, input prerequisites, and execution order constraints across the 66 endpoints in the Saithya Smart application.

---

## 2. Global Authentication Dependency Map

```
[Public Endpoints (No Auth)]
 ├── POST api/login
 ├── POST api/register-user
 ├── POST api/register-verify-otp
 ├── POST api/resend-otp
 ├── POST api/forgot-password
 ├── POST api/reset-password
 ├── GET  api/banners
 ├── GET  api/category
 ├── GET  api/category-details/{id}
 ├── GET  api/products
 ├── GET  api/products-details/{id}
 ├── GET  api/products/search
 ├── GET  api/app-settings
 ├── GET  api/privacy-policy
 └── GET  api/terms-and-conditions
       │
       ▼ (Issues Bearer Token)
[Protected Endpoints (Requires Authorization: Bearer {token})]
 ├── Profile & KYC: GET api/profile, POST api/profile-update
 ├── Wallet: GET api/wallet/balance, POST api/wallet/create-pin, GET api/wallet/transactions
 ├── Add Fund: POST api/add-fund/create-order, POST api/add-fund/status
 ├── Fund Requests: GET api/bank/list, POST api/fund/request/store, GET api/fund/request/history, GET api/fund/request/status/{id}/deatils
 ├── Recharge: POST api/recharge-operator-search, POST api/mobile-plans, POST api/recharge-payment, POST api/recharge-status
 ├── Shopping Cart: POST api/carts, POST api/add-carts/{productId}, POST api/cart/decrease, POST api/cart/remove
 ├── Coupons: POST api/coupon/apply
 ├── Addresses: GET api/addresses, POST api/address/store, POST api/address/update/{id}, POST api/address/delete/{id}
 ├── Orders: POST api/order/store, GET api/orders, GET api/order-details/{id}, POST api/tpipay/paymentOrder/{orderId}
 ├── Subscriptions: GET api/subscription/categories, GET api/membership/plans, POST api/membership/{id}/checkout, GET api/membership/history
 ├── Gamification: GET api/rewards, POST api/scratch-cards/scratch/{id}, GET api/spin-wheel/items, POST api/spin-wheel/spin, POST api/reward-points/convert
 ├── Referrals: GET api/referrals, GET api/referrals/levels, GET api/referrals/level/{id}
 └── Support: POST api/support/ticket, GET api/support/tickets, GET api/support/contact
```

---

## 3. Feature-Level Dependency Chains & Execution Sequences

### 3.1 Registration & Verification Sequence
```
Step 1: POST api/register-user
        ↳ Input: first_name, last_name, mobile, email, password, referral_code
        ↳ Output: OTP generated and queued/dispatched, status: true
Step 2: POST api/register-verify-otp
        ↳ Precondition: Mobile registered in Step 1
        ↳ Input: mobile, otp
        ↳ Output: Sanctum Bearer token issued, user verified
Step 3: GET api/profile
        ↳ Precondition: Bearer token from Step 2
```

### 3.2 Recharge Transaction Sequence
```
Step 1: POST api/recharge-operator-search
        ↳ Input: mobile
        ↳ Output: operator_id, circle_id
Step 2: POST api/mobile-plans
        ↳ Precondition: operator_id, circle_id obtained from Step 1 (or manually chosen)
        ↳ Output: Array of plan categories containing plans (amount, validity, talktime, data)
Step 3: POST api/wallet/create-pin (One-time prerequisite)
        ↳ Precondition: User must have created a 6-digit wallet PIN
Step 4: POST api/recharge-payment
        ↳ Preconditions: 
            a) operator_id, circle_id, amount
            b) wallet_pin matches hashed pin in database
            c) user wallet balance >= amount
        ↳ Output: transaction_id, status
Step 5: POST api/recharge-status (Optional/Polling)
        ↳ Input: transaction_id
```

### 3.3 Shopping Cart & Order Checkout Sequence
```
Step 1: GET api/category ➔ GET api/category-details/{id} OR GET api/products
Step 2: GET api/products-details/{id}
Step 3: POST api/add-carts/{productId}
        ↳ Input: quantity
Step 4: POST api/carts
        ↳ Displays aggregated cart items, subtotal, and tax
Step 5: POST api/coupon/apply (Optional)
        ↳ Precondition: Active cart with subtotal >= coupon.min_order_amount
Step 6: GET api/addresses (or POST api/address/store)
        ↳ Precondition: Saved address with id
Step 7: POST api/order/store
        ↳ Preconditions: Cart must not be empty, valid address_id
        ↳ Output: order_id
Step 8: POST api/tpipay/paymentOrder/{orderId}
        ↳ Precondition: Order created in Step 7
        ↳ Output: dynamic UPI QR data string / intent link
Step 9: GET api/order-details/{id}
```

### 3.4 Bank Fund Request Sequence
```
Step 1: GET api/bank/list
        ↳ Returns active admin company bank accounts (id, bank_name, account_number, ifsc, qr_image)
Step 2: POST api/fund/request/store
        ↳ Precondition: bank_id from Step 1, user bank transfer completed (UTR + payment slip)
        ↳ Output: Request record created with status: "Pending"
Step 3: GET api/fund/request/history
        ↳ Lists user's past fund requests
Step 4: GET api/fund/request/status/{id}/deatils
        ↳ Precondition: fund_request_id from history
        ↳ Returns full verification breakdown & slip image
```

### 3.5 Dynamic QR Add-Fund Sequence
```
Step 1: POST api/add-fund/create-order
        ↳ Input: amount (min ₹100)
        ↳ Output: order_id, dynamic UPI QR URL, expires_in
Step 2: POST api/add-fund/status
        ↳ Input: order_id
        ↳ Precondition: order_id from Step 1
        ↳ Polls gateway status until "success" or "failed"
```

### 3.6 Gamification (Scratch Cards & Spin Wheel) Sequence
```
Step 1: GET api/rewards
        ↳ Returns active scratch cards (each has card_id, title, max_reward)
Step 2: POST api/scratch-cards/scratch/{id}
        ↳ Precondition: Valid unclaimed scratch card id
        ↳ Output: won_amount, updated reward points
Step 3: GET api/spin-wheel/items
        ↳ Returns wheel sectors (id, label, points, color, probability)
Step 4: POST api/spin-wheel/spin
        ↳ Precondition: Daily spins remaining > 0
        ↳ Output: selected sector id, points earned
Step 5: POST api/reward-points/convert
        ↳ Precondition: Reward points >= minimum threshold (e.g., 100 points)
        ↳ Calculation: 10 points = ₹1
        ↳ Output: converted_amount, credited to user's main wallet
```

### 3.7 Multi-Level Referral Network Sequence
```
Step 1: GET api/referrals
        ↳ Returns user's direct referrals and full recursive tree
Step 2: GET api/referrals/levels
        ↳ Returns summary count per level: [{level_number: 1, current_people_in_level: 5}, ...]
Step 3: GET api/referrals/level/{id}
        ↳ Precondition: level_id (integer 1..N)
        ↳ Returns detailed list of members under that level, including rank & downline count
```

---

## 4. Cross-Module Data Dependencies Summary Matrix

| Target Endpoint | Requires Prior Data From | Required Keys / Variables | Validation Constraints |
|---|---|---|---|
| `POST api/register-verify-otp` | `POST api/register-user` | `mobile`, `otp` | OTP must not be expired (< 10 mins) |
| `POST api/mobile-plans` | `POST api/recharge-operator-search` | `operator_id`, `circle_id` | Valid operator and circle IDs |
| `POST api/recharge-payment` | `POST api/mobile-plans`, `POST api/wallet/create-pin` | `operator_id`, `circle_id`, `amount`, `wallet_pin` | Wallet PIN must match; balance >= amount |
| `POST api/add-carts/{productId}` | `GET api/products` or `GET api/products-details/{id}` | `productId`, `quantity` | Product must exist and `status=1` |
| `POST api/order/store` | `POST api/carts`, `GET api/addresses` | `address_id`, `billing_name`, `billing_phone` | Cart cannot be empty; address must belong to user |
| `POST api/tpipay/paymentOrder/{orderId}` | `POST api/order/store` | `orderId` | Order must exist and belong to user |
| `POST api/fund/request/store` | `GET api/bank/list` | `bank_id`, `amount`, `utr`, `slip` | Bank must be active; UTR must be unique; slip file required |
| `POST api/fund/request/status/{id}/deatils` | `GET api/fund/request/history` | `id` | Fund request must belong to user |
| `POST api/scratch-cards/scratch/{id}` | `GET api/rewards` | `id` | Card must be active and not yet scratched |
| `POST api/referrals/level/{id}` | `GET api/referrals/levels` | `id` | Valid level number (>= 1) |
| `POST api/membership/{id}/checkout` | `GET api/membership/plans`, `POST api/wallet/create-pin` | `id`, `wallet_pin` | Wallet PIN match; wallet balance >= plan price |
