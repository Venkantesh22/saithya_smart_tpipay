# Saithya Smart / TPIPay — Vendor Web Portal & Enterprise RBAC Guide

## 1. Multi-Portal Web Architecture

```
┌────────────────────────────────────────────────────────┐
│               SAITHYA SMART / TPIPAY                   │
└───────────────────────────┬────────────────────────────┘
                            │
         ┌──────────────────┼──────────────────┐
         ▼                  ▼                  ▼
┌──────────────────┐ ┌──────────────────┐ ┌──────────────────┐
│   FLUTTER APP    │ │ ADMIN WEB PORTAL │ │VENDOR WEB PORTAL │
│ (Customer Only)  │ │ (Admin & Staff)  │ │    (Sellers)     │
├──────────────────┤ ├──────────────────┤ ├──────────────────┤
│• Mobile Buyers   │ │• Super Admin     │ │• Store Overview  │
│• Live Catalog    │ │• Product Approval│ │• Add Products    │
│• Orders & Cart   │ │• Role Management │ │• Edit & Resubmit │
│• Recharge/Wallet │ │• Vendor KYC      │ │• Orders & Shipped│
│• Referrals       │ │• Order Oversight │ │• Store & Payout  │
└──────────────────┘ └──────────────────┘ └──────────────────┘
```

---

## 2. Web Portals & Login URLs

Single Unified Web Login: `http://127.0.0.1:8000/admin/login` (or `http://127.0.0.1:8000/login`)
- **Super Admin / Staff** logs in $\rightarrow$ automatically redirected to `/admin/dashboard`
- **Vendor / Seller** logs in $\rightarrow$ automatically redirected to `/vendor/dashboard`
- **Customer** tries to log in $\rightarrow$ blocked with friendly message to use the Flutter Mobile App

### Credentials:
- **Super Admin**: `admin@saithyasmart.com` / `password123`
- **Moderation Staff**: `staff@saithyasmart.com` / `password123`
- **Vendor Merchant**: `vendor@saithyasmart.com` / `password123`
- **Mobile Customer**: `user@example.com` / `password123`

---

## 3. Vendor Web Portal Features (`/vendor/`)

1. **Vendor Dashboard (`/vendor/dashboard`)**:
   - Live products count (Approved by Admin).
   - Pending review count (Waiting for Admin approval).
   - Rejected count (Needs vendor modification).
   - Total items sold & Total earnings (₹).
   - Recent products & Recent customer orders.
2. **Add Product (`/vendor/products/create`)**:
   - Vendor fills title, category, MRP, selling price, stock, description, bullet points, image.
   - **Crucial Rule**: Automatically saved as `approval_status = 'pending'` and `status = 0` (hidden from mobile customers).
3. **My Products Catalog (`/vendor/products`)**:
   - Filter by status (`Approved`, `Pending`, `Rejected`).
   - If Admin rejected, displays Admin's exact reason directly with an **Edit** button.
4. **Edit Product (`/vendor/products/{id}/edit`)**:
   - Vendor modifies price or specs.
   - Resubmits for Admin approval (sets back to `pending`).
5. **Orders Tracking & Fulfillment (`/vendor/orders`)**:
   - View orders containing products from this vendor.
   - View customer delivery address.
   - Update shipping status: `processing` $\rightarrow$ `shipped` $\rightarrow$ `delivered`.
6. **Store Profile & Payout Settings (`/vendor/profile`)**:
   - Store Name, business contact, physical warehouse address.
   - GST number, PAN number.
   - Bank Account Details (Bank Name, Account Number, IFSC).

---

## 4. Admin Product Moderation (`/admin/products/`)

- Admin only reviews & moderates products:
  - **Approve (Make Live)**: Sets `approval_status = 'approved'` and `status = 1` $\rightarrow$ product is immediately LIVE in mobile app!
  - **Reject with Reason**: Modal pops up to write explanation for the vendor. Product remains hidden.
  - **Toggle Visibility**: Hide / Show approved products at any time.

---

## 5. Enterprise Role & Permission Management (Super Admin Exclusive)

- **Access URL**: `http://127.0.0.1:8000/admin/roles`
- **Security Policy**: Strictly guarded by `role:super_admin` middleware. Only Super Admin has access; Staff accounts receive HTTP 403 Forbidden.

### 4 Core RBAC Management Tabs:

1. **Tab 1: Interactive Permission Matrix (`matrix`)**:
   - **Live Keyword Search & Module Filters**: Instant filtering by slug, action title, or module name.
   - **Capability Filters**: Toggle by capability: `All`, `View`, `Create`, `Edit`, `Delete`, `Approve`, `Manage`.
   - **Color-Coded Action Badges**:
     - `VIEW` (Sky Blue)
     - `CREATE` (Emerald Green)
     - `EDIT` (Amber)
     - `DELETE` (Rose Red)
     - `APPROVE` (Purple)
     - `MANAGE` (Indigo)
     - `EXPORT` (Teal)
   - **Quick Column Presets**: 1-Click "Toggle All", "View Only Preset" per role column.
   - **Module Section Header Toggles**: Toggle an entire module's permissions for a specific role with 1 click.
   - **Live Counters**: Real-time counter badge (e.g., `12 / 31 active`) updating dynamically as checkboxes change.
   - **Permanent Root Lock**: Super Admin is locked as permanent full access and cannot be accidentally revoked.
   - **Single-Click Matrix Sync**: `POST /admin/roles/matrix` syncs all roles across the platform at once.

2. **Tab 2: Role Configuration & Custom Roles (`roles`)**:
   - **Role KPI Cards**: Shows user count, active capability percentage progress bar, role slug, and description.
   - **Create Custom Role Modal (`POST /admin/roles`)**:
     - Custom slug (e.g. `inventory_manager`, `support_lead`)
     - Display name & detailed description
     - Optional **Clone Permissions**: Copies all permissions from an existing role (e.g. clone from Staff).
   - **Edit Role Modal (`POST /admin/roles/{id}/update`)**: Rename and update descriptions.
   - **Delete Custom Role (`DELETE /admin/roles/{id}`)**: System roles (`super_admin`, `staff`, `vendor`, `customer`) are protected from deletion; roles with active assigned users are blocked until users are reassigned.
   - **Module-by-Module Accordion / Grid**: Toggle permissions per module for individual roles.

3. **Tab 3: Permission Registry & Directory (`permissions`)**:
   - **Directory of 31+ Granular Permissions**: Across Dashboard, Products, Categories, Vendors, Orders, Customers, Banners, Promotions/Coupons, Reviews, Staff, RBAC, Finance, Reports, and Settings.
   - **Create Custom Permission Modal (`POST /admin/permissions`)**:
     - Custom dot-notation key (e.g. `reports.export`, `inventory.audit`)
     - Display name & Module group
     - Immediate multi-role grant checkboxes.
   - **Edit Permission Modal (`POST /admin/permissions/{id}/update`)**: Change display name and module grouping.
   - **Delete Custom Permission (`DELETE /admin/permissions/{id}`)**: Safely delete custom permissions (core system baseline permissions are protected).

4. **Tab 4: Individual Staff Member Overrides (`staff`)**:
   - Shows all employee accounts, their base role, role-inherited permissions, and direct overrides.
   - **Edit Staff Overrides Modal (`POST /admin/staff/{id}/permissions`)**: Directly grant or revoke specific permissions for an individual staff member.

---

## 6. Bug Fix: Product Inspection Page (`/admin/products/{id}`)

- **Issue**: Accessing product 24 (`/admin/products/24`) threw `htmlspecialchars(): Argument #1 ($string) must be of type string, array given`.
- **Cause**: The `features` field in the database was cast as an `array` in Eloquent `Product`, but blade view was rendering `{{ $product->features }}` directly.
- **Resolution**:
  - Implemented array detection in blade view: if array, renders clean bulleted list items; if string, renders text.
  - Added safe navigation check for vendor store profile links (`optional($product->vendor)->vendorProfile`).
  - Verified with HTTP 200 test.
