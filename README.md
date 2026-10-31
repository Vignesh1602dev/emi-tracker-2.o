# EMI Tracker on Vercel + Supabase (same data on phone and PC)

public/index.html     the web app
api/[...path].js      Vercel Function: handles every /api/* request
lib/core.js           API logic (login, customers, payments, reports data, users, documents, AI)
supabase/schema.sql   database tables (run once on a new project; includes the expenses table)
supabase/add-expenses.sql   run once if you deployed an older version (adds the Expense Register table)
vercel.json           output folder = public, security headers

## 1. Supabase (once)
1. supabase.com > New project (pick a region near you).
2. SQL Editor > New query > paste supabase/schema.sql > Run.
3. Project Settings > API: copy the Project URL and the service_role key (secret).

## Run locally
1. Copy `.env.example` to `.env` and fill in the real Supabase Project URL, service_role key, a long `SESSION_SECRET`, and `SETUP_KEY`.
2. Run `npm install`, then `npm run dev`.
3. Open http://localhost:3000 and check http://localhost:3000/api/health. `db` must be `true` before logging in.

## 2. GitHub
Create a PRIVATE repository and upload everything from this zip. index.html must end up at public/index.html and the api folder must be at the top level (you will see: api, lib, public, supabase, package.json, vercel.json).

## 3. Vercel
1. vercel.com > Add New > Project > import the repository.
2. Framework Preset: Other. Leave Build Command and Output Directory empty (vercel.json sets them).
3. Environment Variables (add before Deploy):
   SUPABASE_URL           your Project URL
   SUPABASE_SERVICE_KEY   your service_role key
   SESSION_SECRET         any long random text (40+ characters)
   SETUP_KEY              a word only you know
   optional: MIN_PASSWORD=4 (allows a password like 1234), ANTHROPIC_API_KEY or GEMINI_API_KEY
4. Deploy. Open https://YOUR-PROJECT.vercel.app/api/health  -> "db": true and "sessionSecret": true

## 4. First login and moving your existing data
1. Open the site on the device that has your CORRECT data. First screen = First-time setup:
   business name, setup key, username, password > Create account.
2. Press "Upload this data" in the box "Server has no data yet". Wait 10 to 20 seconds.
3. On every other device just open the site and sign in. Same data everywhere.

## Already deployed earlier?
If you used an older version, run supabase/add-documents.sql once, then redeploy.
Changing an environment variable needs a Redeploy in Vercel.

## Login right after deploying (no setup key needed)
On a brand-new server just sign in with  admin  /  1234 . The first login creates your Admin account.
Then press the "Password" button (top right) and set a strong password. Anyone who opens the link before you
could do the same, so open your site and sign in right after deploying, and change the password at once.
Optional variables: ADMIN_USER and ADMIN_PASSWORD (use your own first login instead of admin / 1234),
DISABLE_DEFAULT_ADMIN=1 (turn this default off and use the First-time setup with SETUP_KEY instead).

## Accounts: Admin Panel (mobile number + password)
Sign in as Admin > open "Admin Panel" (bottom menu on the phone, left menu on the PC).
Create account: Name, Mobile number, Password, Role (Staff or Admin). That person signs in with the 10-digit mobile number and the password.
Staff can view and collect payments only. Admin can also reset passwords and delete accounts there.
If you deployed before this version, run supabase/add-user-name.sql once in the Supabase SQL Editor (adds the Name column), then redeploy.

## Collection forecast (dashboard)
Dashboard shows, category wise: money coming in the next 15 and 30 days (EMI loans and monthly-interest loans separately),
monthly interest income, overdue, collection efficiency of the last 30 days, overdue ageing (1-15, 16-30, 31+ days) and the top overdue customers.
Admin can Print or Download PDF. A loan type "Monthly interest only (principal stays, settled later)" is in Add/Edit customer.

## Expense Register (new)
Admin menu > Expense Register (bottom menu on the phone). Not visible to Staff.
- Add entry: Type (Expense = cash balance less, Cash added = cash balance add), Date, Category (DAD, MAMA, ...), Head (Rent, Salary, Petrol ... or type a new head), Amount, Mode, Note.
- Every entry changes the Cash Book of its own category: Cash balance = Opening + Collection + Cash added - Loan given - Expense.
  The form shows the category cash balance before and after the entry.
- Entries dated before the opening date (Cash Book > Category master) are treated as already inside the opening balance, the same as loans.
- Filters: dates (today, this month, this year, all time, custom), category, type, head and note search.
- Category wise table, expense head wise table, full register with totals, edit and delete.
- Print, Download PDF, Excel and Share (shares the PDF where the phone supports it, otherwise a summary on WhatsApp).
- Cash Book Print and PDF now show Expense and Cash added columns too.
- Staff can see the resulting cash balance in Cash Book but cannot add, edit or delete expenses (enforced on the server).

Upgrade from an older deployment: run supabase/add-expenses.sql once in Supabase > SQL Editor, then Redeploy in Vercel.
Until the table exists the app still works and the Expense Register shows a clear message.

## Statements: Pending / All, Print, PDF, Share
Customer Directory > Statement (or Collect Payment > Full / Pending statement) opens a statement with a Pending | All switch.
- Pending: only loans that are not closed, and only the EMIs not yet paid.
- All: every loan of the customer with the full EMI schedule.
- Buttons (Admin): Share (PDF through the phone share sheet, otherwise a summary on WhatsApp to the customer number), Download PDF, Print. The PDF follows the Pending / All choice.
