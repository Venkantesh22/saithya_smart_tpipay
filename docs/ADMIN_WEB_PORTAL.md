# Saithya Smart / TPIPay — Admin Web Management Portal Specification

## 1. Overview & Architecture
Per the business requirement:
> **"Admin ka portal web me banana hai, mobile app me bas only customer ka rahega."**

The **Flutter Mobile Application** remains strictly dedicated to **Customers (End Users / Buyers)**.
The **Admin and Staff Management Portal** is built directly inside the Laravel backend (`D:\Laravel\foozzy\sathyasmart`) as a responsive Web Application utilizing server-rendered Blade templates, Tailwind CSS, FontAwesome icons, and Chart.js.

---

## 2. Access Credentials & URL

- **Portal Web URL**: `http://127.0.0.1:8000/admin/login` (or `/login`)
- **Dashboard URL**: `http://127.0.0.1:8000/admin/dashboard`

| Role | Email | Mobile | Password | Capabilities |
|---|---|---|---|---|
| **Super Admin** | `admin@saithyasmart.com` | `9999999999` | `password123` | Master control: System overview, review and approve vendor products, manage vendor KYC, manage staff, assign roles/permissions, manage banners and categories. |
| **Staff Member** | `staff@saithyasmart.com` | `9911223344` | `password123` | Delegated operations: Review pending vendor products, approve/reject products, review orders. |

---

## 3. Web Pages & Features

### 3.1 Authentication (`/admin/login`)
- Web session authentication using `Auth::guard('web')`.
- Accepts either **Email Address** or **Mobile Number** + Password.
- Rejects users with role `customer` (with clean error alert).
- Remember Me support and preloaded test credentials box.
- Secure CSRF protection on form submission.

### 3.2 Platform Dashboard (`/admin/dashboard`)
- **KPI Metrics Cards**:
  - **Pending Approvals Queue Count** (urgent amber alert badge with 1-click navigation).
  - **Live Products Count** (approved and active in customer mobile app).
  - **Verified Vendor Stores Count**.
  - **Total Mobile App Customers Count**.
  - **Total Customer Orders Count** & **Total Sales Revenue (₹)**.
  - **Pending Bank Fund Requests Count**.
- **Pending Products Action Table**:
  - Displays submitted vendor products with thumbnails, vendor store name, MRP, selling price, stock.
  - **1-Click "Approve (Make Live)" Button**: instantly activates the product into the mobile app.
  - **"Reject" Button**: triggers modal to input rejection reason for the vendor.
- **Recent Orders Table**: Real-time snapshot of latest mobile orders placed.

### 3.3 Vendor Product Moderation Queue (`/admin/products/pending`)
- Dedicated queue for reviewing products submitted by marketplace vendors.
- Filter by Category, Vendor Store, or search term.
- Product card with photo, specifications, pricing, margin (% OFF), and submitted date.
- **Approve Action**: Updates `approval_status = 'approved'`, `status = 1`, `approved_by = admin_id`, `approved_at = now()`.
- **Reject Action**: Updates `approval_status = 'rejected'`, `status = 0`, stores `rejection_reason`.

### 3.4 All Products Catalog (`/admin/products`)
- Full catalog view of all products in the database.
- Filters:
  - Approval Status (`Pending`, `Approved`, `Rejected`).
  - Mobile App Visibility (`LIVE in App`, `Hidden from App`).
  - Category and Vendor Store.
- Actions: Toggle Live/Inactive, View Detailed Specs, Delete Product.

### 3.5 Detailed Product Inspection (`/admin/products/{id}`)
- Multi-image gallery preview.
- Pricing breakdown (MRP, Selling Price, Customer Discount %, Stock units).
- Full description and features list.
- Vendor profile snapshot (store name, owner, phone, email, GST).
- Moderation history (Approved by name and timestamp, or rejection reason).

### 3.6 Vendor Stores & KYC Verification (`/admin/vendors`)
- Directory of all registered marketplace sellers.
- Displays Store Name, Owner, Contact Phone, Email, GST Number, PAN Number, Bank Account Details (Account #, IFSC, Bank Name).
- Store Status management: `Approved (Active)`, `Pending (KYC)`, `Suspended`.
- Detailed store view (`/admin/vendors/{id}`) showing all products belonging to the vendor.

### 3.7 Customer Orders & Fulfillment (`/admin/orders`)
- Orders table with order number, customer name, items count, total price, payment method, payment status, order status.
- Order details & invoice (`/admin/orders/{id}`) with shipping address, itemized products, and vendor store info.
- Order Status update dropdown (`pending`, `confirmed`, `processing`, `shipped`, `delivered`, `cancelled`).

### 3.8 Mobile App Customer Directory (`/admin/customers`)
- Complete list of customers using the Flutter mobile app.
- Search by name, mobile, email, or referral code.
- View customer wallet balance, reward points, KYC status, and placed orders.

### 3.9 Categories & Banners (`/admin/categories`, `/admin/banners`)
- Visual banner slider management for the mobile app home screen.
- Category management (add category, update status, view product counts).

### 3.10 Staff & Role Management (`/admin/staff`, `/admin/roles`)
- Super Admin exclusive access.
- Create new staff accounts with checkbox selection for any of the 16 system permissions.
- Overview matrix of all roles (`super_admin`, `staff`, `vendor`, `customer`) and system permissions.

---

## 4. Separation of Mobile App vs Web Portal

```
┌────────────────────────────────────────────────────────┐
│                  SAITHYA SMART PLATFORM                │
└───────────────────────────┬────────────────────────────┘
                            │
              ┌─────────────┴─────────────┐
              ▼                           ▼
   ┌──────────────────────┐   ┌──────────────────────┐
   │ FLUTTER MOBILE APP   │   │  LARAVEL WEB PORTAL  │
   │   (Android / iOS)    │   │  (Web Browser / PC)  │
   ├──────────────────────┤   ├──────────────────────┤
   │ • Only Customers     │   │ • Super Admin        │
   │ • Browse Live Items  │   │ • Staff Operations   │
   │ • Add to Cart / Buy  │   │ • Product Approvals  │
   │ • Recharge & Wallet  │   │ • Vendor Store KYC   │
   │ • Referral & Team    │   │ • Order Fulfillment  │
   └──────────────────────┘   └──────────────────────┘
```

Mobile customers never see the admin portal and can only browse products with `status = 1` AND `approval_status = 'approved'`.

---

## 5. Automated Test Coverage
- **Total Test Suites**: 32 (100% Passed)
- **Total Assertions**: 278 (100% Passed)
- **Web Portal Tests**: `tests/Feature/AdminWebPortalTest.php` covers:
  - Guest redirection to `/admin/login`.
  - Customer role access blocked with 403 Forbidden.
  - Admin login and dashboard metrics rendering.
  - Pending approval queue review and instant approve action (making product live).
  - Product rejection action with reason tracking.
  - Admin logout session invalidation.
