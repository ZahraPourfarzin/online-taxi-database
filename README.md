# 🚖 Ride-Sharing Database System (Online Taxi Platform)

A robust, enterprise-grade relational database system modeled after modern ride-sharing ecosystems (e.g., Uber, Snapp). Built utilizing **Microsoft SQL Server (T-SQL)**, this project demonstrates advanced database architecture, comprehensive schema normalization, strict referential integrity, and sophisticated role-based business logic split across specific operational dashboards.

---

## 🛠️ Core Tech Stack & Tooling
* **Database Management System:** Microsoft SQL Server (MSSQL)
* **Query Language:** T-SQL (Transact-SQL)
* **Architecture Design:** Modular script deployment separated by core schema definitions, testing datasets, and end-user business domains.

---

## 📂 Project Architecture & Execution Flow

To cleanly deploy, test, and query the entire infrastructure, the scripts are structured to execute in the following production order:

1. **`Create tables.sql`** -> Core Schema & Constraints Definition
2. **`Set Values.sql`** -> Realistic Mock Data Insertion (Manual Seeding)
3. **`Admin Dashboard.sql`** -> Global platform management & Business Intelligence
4. **`Driver Dashboard.sql`** -> On-trip logistics & driver-side profile operations
5. **`Passenger Dashboard.sql`** -> End-user trip pipelines & payment history

### 🚀 Quick Start Guide
* Open **SQL Server Management Studio (SSMS)**.
* Connect to your database instance.
* Open and execute `Create tables.sql` first to lay down the foundational schema.
* Open and execute `Set Values.sql` to populate relational records for active validation.
* Dive into the standalone dashboards inside the project folder to explore customized analytics and see live query results.

---

## 🧪 Automated Testing & Mock Data Pipeline (`Set Values.sql`)

To ensure all dashboard queries, complex joins, and operational workflows could be verified instantly, the project includes a dedicated data seeding pipeline via `Set Values.sql`. 

Instead of testing with an empty database, we manually designed and injected a curated set of realistic mock data, mimicking real-world production entries:
* **Core Entities:** Pre-seeded with operational cities (Tehran, Isfahan, Mashhad), dynamic passenger accounts with varying wallet balances, and active/pending driver profiles.
* **Relational Seeding:** Enforces valid foreign key mappings (e.g., automatically binding newly created vehicles directly to approved drivers via subqueries).
* **Promotion & Access Controls:** Injects active/expired promo codes (both percentage-based and fixed-amount) and initialization profiles for system administrators.

This manual data setup ensures that anyone executing the query scripts can immediately observe live, interconnected, and accurate database responses reflecting real platform analytics.

---

## 🔍 Detailed Component & Dashboard Breakdowns

### 📑 1. Architectural Schema (`Create tables.sql`)
Enforces absolute transactional reliability and prevents orphan records by implementing tight primary-foreign key bonds across 14 decoupled relational tables:
* **Core Entities:** `City`, `Passenger`, `Driver`, `Vehicle`, `Admin`.
* **System Automation:** `DriverApplication` (applicant workflows), `Fare` (dynamic tariff management), `DiscountCode`.
* **Core Transactions:** `Trip` (stateful trips), `TripHistory` (real-time auditing logs), `Transactions` (ledger entries), `Location` (telemetry data storage), and `RatingAndReview`.

### 👑 2. Administrative Controls (`Admin Dashboard.sql`)
Simulates the core back-office control panel, incorporating heavy analytics and system monitoring:
* **Applicant Pipeline:** Advanced validation to audit, accept, or reject driver submissions, instantly auto-generating corporate identity codes (`LIC_APP_`) and shifting vehicle compliance statuses.
* **Dynamic Fare Adjustments:** Allows live modification of tariff metrics (`cost_per_km`) mapped to cities and trip classifications.
* **Business Intelligence Reporting:**
  * *Passenger Engagement:* Aggregates monthly active travel metrics and parses historical expenditures to isolate high-value accounts.
  * *Driver Optimization:* Audits performance by processing total successfully completed urban (`درون شهری`) vs inter-city (`برون شهری`) commutes alongside active driver star ratings.
  * *Geospatial Logistics:* Traverses geo-coordinates (`Location`) logs to detect high-density choke points and track maximum location timestamps.
  * *Traffic Patterns:* Extracts hour-of-day trip metrics (`DATEPART`) to pinpoint rush hours and map top 10 bottleneck commuter routes.

### 🚗 3. Driver Ecosystem (`Driver Dashboard.sql`)
Engineered to process the fast-paced life-cycle of field agents:
* **Credential Handshakes:** Implements dual-factor profile verification matching phone signatures and active emails against existing vehicle metadata.
* **Trip Dispatch Pipeline:** Pulls incoming queues (`pending` requests) sorted chronologically, mapping single-atomic actions to instantly lock trips (`accepted`) or drop orders back into public queues.
* **State Machine Logistics:** Seamlessly advances the trip states across critical nodes (`started` ➔ `on_trip` ➔ `completed`) while programmatically stamping global `GETDATE()` timestamps.

### 🎒 4. Passenger Experience (`Passenger Dashboard.sql`)
Manages consumer interaction mechanics and high-concurrency payment integrations:
* **Flexible Booking Engines:** Supports diverse multi-tier travel methods including basic commutes (`درون شهری`), long-distance routes (`برون شهری`), or round-trips.
* **Auditing Logs:** Tracks granular delay deviations (e.g., updating trips to `on_trip_traffic` with explanatory system logs into `TripHistory`).
* **Financial Ledgering:** Registers precise payment responses linked to promo code discounts, updates electronic balances, and stores consumer reviews to calculate driver performance benchmarks.

---

## 💡 Engineering Highlights
* **Strict Data Normalization:** Schema architectures adhere closely to normalization standards, preventing redundant updates across highly dynamic data fields.
* **Domain Constraints:** Implements localized `CHECK` arrays ensuring absolute system safety over dynamic attributes like trip types, financial statuses, and ride states.
* **Real-Time Simulation Data:** Pre-configured with exact Persian unicode entries, multi-city boundaries, and operational limits to simulate true system load profiles.