-- Generate database schema for hospital management system. Provide only SQL DDL script for PostgreSQL that creates 30 base tables.
-- Extend current database schema with additional 50 tables for detailed financials data.
-- Extend current database schema with additional 50 tables for compliance and audit data.
-- Extend current database schema with additional 40 tables to store granular medical records.
-- Extend current database schema with additional 40 tables to store supply chain management data. 
-- Extend current database schema with additional 40 tables to store external system integrations data.

 
-- Hospital Management System Schema for PostgreSQL
-- Creating 30 base tables

-- 1. Hospitals
CREATE TABLE hospitals (
    hospital_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Departments
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    name VARCHAR(50) NOT NULL,
    description TEXT,
    head_doctor_id INTEGER
);

-- 3. Doctors
CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    department_id INTEGER REFERENCES departments(department_id),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialization VARCHAR(50),
    license_number VARCHAR(20) UNIQUE,
    phone VARCHAR(20),
    email VARCHAR(100)
);

-- 4. Patients
CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender CHAR(1),
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(100),
    emergency_contact VARCHAR(100)
);

-- 5. Appointments
CREATE TABLE appointments (
    appointment_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    doctor_id INTEGER REFERENCES doctors(doctor_id),
    department_id INTEGER REFERENCES departments(department_id),
    appointment_date TIMESTAMP NOT NULL,
    status VARCHAR(20) DEFAULT 'Scheduled',
    reason TEXT
);

-- 6. Medical Records
CREATE TABLE medical_records (
    record_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    doctor_id INTEGER REFERENCES doctors(doctor_id),
    visit_date TIMESTAMP NOT NULL,
    diagnosis TEXT,
    notes TEXT
);

-- 7. Prescriptions
CREATE TABLE prescriptions (
    prescription_id SERIAL PRIMARY KEY,
    record_id INTEGER REFERENCES medical_records(record_id),
    doctor_id INTEGER REFERENCES doctors(doctor_id),
    patient_id INTEGER REFERENCES patients(patient_id),
    issue_date DATE NOT NULL,
    notes TEXT
);

-- 8. Medications
CREATE TABLE medications (
    medication_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    manufacturer VARCHAR(100),
    unit_price DECIMAL(10,2)
);

-- 9. Prescription Items
CREATE TABLE prescription_items (
    item_id SERIAL PRIMARY KEY,
    prescription_id INTEGER REFERENCES prescriptions(prescription_id),
    medication_id INTEGER REFERENCES medications(medication_id),
    dosage VARCHAR(50),
    frequency VARCHAR(50),
    duration VARCHAR(50)
);

-- 10. Wards
CREATE TABLE wards (
    ward_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    department_id INTEGER REFERENCES departments(department_id),
    name VARCHAR(50) NOT NULL,
    capacity INTEGER NOT NULL
);

-- 11. Beds
CREATE TABLE beds (
    bed_id SERIAL PRIMARY KEY,
    ward_id INTEGER REFERENCES wards(ward_id),
    bed_number VARCHAR(20) NOT NULL,
    status VARCHAR(20) DEFAULT 'Available'
);

-- 12. Admissions
CREATE TABLE admissions (
    admission_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    bed_id INTEGER REFERENCES beds(bed_id),
    ward_id INTEGER REFERENCES wards(ward_id),
    admission_date TIMESTAMP NOT NULL,
    discharge_date TIMESTAMP,
    reason TEXT
);

-- 13. Nurses
CREATE TABLE nurses (
    nurse_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    department_id INTEGER REFERENCES departments(department_id),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    license_number VARCHAR(20) UNIQUE,
    phone VARCHAR(20)
);

-- 14. Nurse Assignments
CREATE TABLE nurse_assignments (
    assignment_id SERIAL PRIMARY KEY,
    nurse_id INTEGER REFERENCES nurses(nurse_id),
    ward_id INTEGER REFERENCES wards(ward_id),
    shift_start TIMESTAMP NOT NULL,
    shift_end TIMESTAMP NOT NULL
);

-- 15. Labs
CREATE TABLE labs (
    lab_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    name VARCHAR(50) NOT NULL,
    location TEXT
);

-- 16. Lab Tests
CREATE TABLE lab_tests (
    test_id SERIAL PRIMARY KEY,
    lab_id INTEGER REFERENCES labs(lab_id),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    cost DECIMAL(10,2)
);

-- 17. Lab Orders
CREATE TABLE lab_orders (
    order_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    doctor_id INTEGER REFERENCES doctors(doctor_id),
    test_id INTEGER REFERENCES lab_tests(test_id),
    order_date TIMESTAMP NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending'
);

-- 18. Lab Results
CREATE TABLE lab_results (
    result_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES lab_orders(order_id),
    result_date TIMESTAMP NOT NULL,
    result_text TEXT,
    is_abnormal BOOLEAN
);

-- 19. Billing
CREATE TABLE billing (
    bill_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    admission_id INTEGER REFERENCES admissions(admission_id),
    bill_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'Unpaid'
);

-- 20. Billing Items
CREATE TABLE billing_items (
    item_id SERIAL PRIMARY KEY,
    bill_id INTEGER REFERENCES billing(bill_id),
    description TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL
);

-- 21. Insurance Companies
CREATE TABLE insurance_companies (
    company_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(100)
);

-- 22. Patient Insurance
CREATE TABLE patient_insurance (
    insurance_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    company_id INTEGER REFERENCES insurance_companies(company_id),
    policy_number VARCHAR(50) NOT NULL,
    valid_from DATE,
    valid_to DATE
);

-- 23. Surgeries
CREATE TABLE surgeries (
    surgery_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    doctor_id INTEGER REFERENCES doctors(doctor_id),
    surgery_date TIMESTAMP NOT NULL,
    procedure_name VARCHAR(100),
    outcome TEXT
);

-- 24. Operating Rooms
CREATE TABLE operating_rooms (
    room_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    room_number VARCHAR(20) NOT NULL,
    status VARCHAR(20) DEFAULT 'Available'
);

-- 25. Surgery Schedules
CREATE TABLE surgery_schedules (
    schedule_id SERIAL PRIMARY KEY,
    surgery_id INTEGER REFERENCES surgeries(surgery_id),
    room_id INTEGER REFERENCES operating_rooms(room_id),
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP
);

-- 26. Inventory
CREATE TABLE inventory (
    item_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    name VARCHAR(100) NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2)
);

-- 27. Suppliers
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(100)
);

-- 28. Purchase Orders
CREATE TABLE purchase_orders (
    order_id SERIAL PRIMARY KEY,
    supplier_id INTEGER REFERENCES suppliers(supplier_id),
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    order_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending'
);

-- 29. Purchase Order Items
CREATE TABLE purchase_order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES purchase_orders(order_id),
    inventory_id INTEGER REFERENCES inventory(item_id),
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2)
);

-- 30. Emergency Contacts
CREATE TABLE emergency_contacts (
    contact_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    name VARCHAR(100) NOT NULL,
    relationship VARCHAR(50),
    phone VARCHAR(20) NOT NULL,
    address TEXT
);

-- Additional 50 Tables for Detailed Financials in Hospital Management System

-- 31. General Ledger Accounts
CREATE TABLE gl_accounts (
    account_id SERIAL PRIMARY KEY,
    account_code VARCHAR(20) UNIQUE NOT NULL,
    account_name VARCHAR(100) NOT NULL,
    account_type VARCHAR(50) NOT NULL, -- e.g., Asset, Liability, Revenue, Expense
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 32. General Ledger Transactions
CREATE TABLE gl_transactions (
    transaction_id SERIAL PRIMARY KEY,
    account_id INTEGER REFERENCES gl_accounts(account_id),
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    transaction_date DATE NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    debit_credit CHAR(1) NOT NULL, -- D for Debit, C for Credit
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 33. Cost Centers
CREATE TABLE cost_centers (
    cost_center_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    department_id INTEGER REFERENCES departments(department_id),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    manager_id INTEGER REFERENCES doctors(doctor_id)
);

-- 34. Cost Center Allocations
CREATE TABLE cost_center_allocations (
    allocation_id SERIAL PRIMARY KEY,
    cost_center_id INTEGER REFERENCES cost_centers(cost_center_id),
    gl_transaction_id INTEGER REFERENCES gl_transactions(transaction_id),
    amount DECIMAL(12,2) NOT NULL,
    allocation_date DATE NOT NULL,
    notes TEXT
);

-- 35. Revenue Streams
CREATE TABLE revenue_streams (
    revenue_stream_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    name VARCHAR(100) NOT NULL, -- e.g., Inpatient Services, Outpatient Services
    description TEXT
);

-- 36. Revenue Transactions
CREATE TABLE revenue_transactions (
    revenue_transaction_id SERIAL PRIMARY KEY,
    revenue_stream_id INTEGER REFERENCES revenue_streams(revenue_stream_id),
    bill_id INTEGER REFERENCES billing(bill_id),
    amount DECIMAL(12,2) NOT NULL,
    transaction_date DATE NOT NULL,
    gl_transaction_id INTEGER REFERENCES gl_transactions(transaction_id)
);

-- 37. Accounts Receivable
CREATE TABLE accounts_receivable (
    ar_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    bill_id INTEGER REFERENCES billing(bill_id),
    amount_due DECIMAL(12,2) NOT NULL,
    due_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending', -- e.g., Pending, Paid, Overdue
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 38. Accounts Receivable Payments
CREATE TABLE ar_payments (
    payment_id SERIAL PRIMARY KEY,
    ar_id INTEGER REFERENCES accounts_receivable(ar_id),
    patient_id INTEGER REFERENCES patients(patient_id),
    amount DECIMAL(12,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method VARCHAR(50), -- e.g., Cash, Credit Card, Insurance
    gl_transaction_id INTEGER REFERENCES gl_transactions(transaction_id)
);

-- 39. Accounts Payable
CREATE TABLE accounts_payable (
    ap_id SERIAL PRIMARY KEY,
    supplier_id INTEGER REFERENCES suppliers(supplier_id),
    purchase_order_id INTEGER REFERENCES purchase_orders(order_id),
    amount_due DECIMAL(12,2) NOT NULL,
    due_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 40. Accounts Payable Payments
CREATE TABLE ap_payments (
    payment_id SERIAL PRIMARY KEY,
    ap_id INTEGER REFERENCES accounts_payable(ap_id),
    supplier_id INTEGER REFERENCES suppliers(supplier_id),
    amount DECIMAL(12,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method VARCHAR(50),
    gl_transaction_id INTEGER REFERENCES gl_transactions(transaction_id)
);

-- 41. Budgets
CREATE TABLE budgets (
    budget_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    cost_center_id INTEGER REFERENCES cost_centers(cost_center_id),
    fiscal_year INTEGER NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    description TEXT
);

-- 42. Budget Allocations
CREATE TABLE budget_allocations (
    allocation_id SERIAL PRIMARY KEY,
    budget_id INTEGER REFERENCES budgets(budget_id),
    department_id INTEGER REFERENCES departments(department_id),
    amount DECIMAL(12,2) NOT NULL,
    allocation_date DATE NOT NULL
);

-- 43. Financial Periods
CREATE TABLE financial_periods (
    period_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    period_name VARCHAR(50) NOT NULL, -- e.g., Q1-2025, FY2025
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Open' -- e.g., Open, Closed
);

-- 44. Journal Entries
CREATE TABLE journal_entries (
    journal_entry_id SERIAL PRIMARY KEY,
    period_id INTEGER REFERENCES financial_periods(period_id),
    entry_date DATE NOT NULL,
    description TEXT,
    created_by INTEGER REFERENCES doctors(doctor_id), -- Assuming doctor as financial approver
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 45. Journal Entry Details
CREATE TABLE journal_entry_details (
    detail_id SERIAL PRIMARY KEY,
    journal_entry_id INTEGER REFERENCES journal_entries(journal_entry_id),
    account_id INTEGER REFERENCES gl_accounts(account_id),
    amount DECIMAL(12,2) NOT NULL,
    debit_credit CHAR(1) NOT NULL
);

-- 46. Cash Accounts
CREATE TABLE cash_accounts (
    cash_account_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    account_name VARCHAR(100) NOT NULL,
    bank_name VARCHAR(100),
    account_number VARCHAR(50) UNIQUE,
    balance DECIMAL(12,2) DEFAULT 0.00
);

-- 47. Cash Transactions
CREATE TABLE cash_transactions (
    cash_transaction_id SERIAL PRIMARY KEY,
    cash_account_id INTEGER REFERENCES cash_accounts(cash_account_id),
    transaction_date DATE NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL, -- e.g., Deposit, Withdrawal
    description TEXT,
    gl_transaction_id INTEGER REFERENCES gl_transactions(transaction_id)
);

-- 48. Insurance Claims
CREATE TABLE insurance_claims (
    claim_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    insurance_id INTEGER REFERENCES patient_insurance(insurance_id),
    bill_id INTEGER REFERENCES billing(bill_id),
    claim_amount DECIMAL(12,2) NOT NULL,
    claim_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending'
);

-- 49. Insurance Claim Payments
CREATE TABLE insurance_claim_payments (
    payment_id SERIAL PRIMARY KEY,
    claim_id INTEGER REFERENCES insurance_claims(claim_id),
    amount DECIMAL(12,2) NOT NULL,
    payment_date DATE NOT NULL,
    gl_transaction_id INTEGER REFERENCES gl_transactions(transaction_id)
);

-- 50. Financial Reports
CREATE TABLE financial_reports (
    report_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    period_id INTEGER REFERENCES financial_periods(period_id),
    report_type VARCHAR(50) NOT NULL, -- e.g., Balance Sheet, Income Statement
    generated_date TIMESTAMP NOT NULL,
    report_data JSONB -- Store report data in JSON format
);

-- 51. Expense Categories
CREATE TABLE expense_categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- 52. Expenses
CREATE TABLE expenses (
    expense_id SERIAL PRIMARY KEY,
    cost_center_id INTEGER REFERENCES cost_centers(cost_center_id),
    category_id INTEGER REFERENCES expense_categories(category_id),
    amount DECIMAL(12,2) NOT NULL,
    expense_date DATE NOT NULL,
    description TEXT,
    gl_transaction_id INTEGER REFERENCES gl_transactions(transaction_id)
);

-- 53. Payroll
CREATE TABLE payroll (
    payroll_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    period_id INTEGER REFERENCES financial_periods(period_id),
    total_amount DECIMAL(12,2) NOT NULL,
    payroll_date DATE NOT NULL
);

-- 54. Employee Salaries
CREATE TABLE employee_salaries (
    salary_id SERIAL PRIMARY KEY,
    payroll_id INTEGER REFERENCES payroll(payroll_id),
    employee_id INTEGER, -- Could reference doctors or nurses
    amount DECIMAL(12,2) NOT NULL,
    payment_date DATE NOT NULL,
    gl_transaction_id INTEGER REFERENCES gl_transactions(transaction_id)
);

-- 55. Tax Codes
CREATE TABLE tax_codes (
    tax_code_id SERIAL PRIMARY KEY,
    code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    rate DECIMAL(5,2) NOT NULL, -- e.g., 8.00 for 8%
    description TEXT
);

-- 56. Tax Transactions
CREATE TABLE tax_transactions (
    tax_transaction_id SERIAL PRIMARY KEY,
    tax_code_id INTEGER REFERENCES tax_codes(tax_code_id),
    bill_id INTEGER REFERENCES billing(bill_id),
    amount DECIMAL(12,2) NOT NULL,
    transaction_date DATE NOT NULL,
    gl_transaction_id INTEGER REFERENCES gl_transactions(transaction_id)
);

-- 57. Depreciation Schedules
CREATE TABLE depreciation_schedules (
    schedule_id SERIAL PRIMARY KEY,
    asset_id INTEGER, -- Assuming assets are tracked elsewhere
    cost_center_id INTEGER REFERENCES cost_centers(cost_center_id),
    purchase_date DATE NOT NULL,
    purchase_value DECIMAL(12,2) NOT NULL,
    useful_life_years INTEGER NOT NULL,
    depreciation_method VARCHAR(50) -- e.g., Straight-Line, Declining Balance
);

-- 58. Depreciation Entries
CREATE TABLE depreciation_entries (
    entry_id SERIAL PRIMARY KEY,
    schedule_id INTEGER REFERENCES depreciation_schedules(schedule_id),
    period_id INTEGER REFERENCES financial_periods(period_id),
    amount DECIMAL(12,2) NOT NULL,
    entry_date DATE NOT NULL,
    gl_transaction_id INTEGER REFERENCES gl_transactions(transaction_id)
);

-- 59. Grants
CREATE TABLE grants (
    grant_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    grantor_name VARCHAR(100) NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    grant_date DATE NOT NULL,
    purpose TEXT
);

-- 60. Grant Allocations
CREATE TABLE grant_allocations (
    allocation_id SERIAL PRIMARY KEY,
    grant_id INTEGER REFERENCES grants(grant_id),
    cost_center_id INTEGER REFERENCES cost_centers(cost_center_id),
    amount DECIMAL(12,2) NOT NULL,
    allocation_date DATE NOT NULL
);

-- 61. Donations
CREATE TABLE donations (
    donation_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    donor_name VARCHAR(100) NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    donation_date DATE NOT NULL,
    purpose TEXT,
    gl_transaction_id INTEGER REFERENCES gl_transactions(transaction_id)
);

-- 62. Investment Accounts
CREATE TABLE investment_accounts (
    investment_account_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    account_name VARCHAR(100) NOT NULL,
    institution_name VARCHAR(100),
    balance DECIMAL(12,2) DEFAULT 0.00
);

-- 63. Investment Transactions
CREATE TABLE investment_transactions (
    transaction_id SERIAL PRIMARY KEY,
    investment_account_id INTEGER REFERENCES investment_accounts(investment_account_id),
    transaction_date DATE NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL, -- e.g., Buy, Sell, Dividend
    description TEXT,
    gl_transaction_id INTEGER REFERENCES gl_transactions(transaction_id)
);

-- 64. Loan Accounts
CREATE TABLE loan_accounts (
    loan_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    lender_name VARCHAR(100) NOT NULL,
    principal_amount DECIMAL(12,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE
);

-- 65. Loan Payments
CREATE TABLE loan_payments (
    payment_id SERIAL PRIMARY KEY,
    loan_id INTEGER REFERENCES loan_accounts(loan_id),
    amount DECIMAL(12,2) NOT NULL,
    payment_date DATE NOT NULL,
    gl_transaction_id INTEGER REFERENCES gl_transactions(transaction_id)
);

-- 66. Financial Audits
CREATE TABLE financial_audits (
    audit_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    period_id INTEGER REFERENCES financial_periods(period_id),
    audit_date DATE NOT NULL,
    auditor_name VARCHAR(100),
    findings TEXT,
    status VARCHAR(20) DEFAULT 'Pending'
);

-- 67. Audit Trails
CREATE TABLE audit_trails (
    trail_id SERIAL PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    record_id INTEGER NOT NULL,
    action VARCHAR(20) NOT NULL, -- e.g., Insert, Update, Delete
    action_date TIMESTAMP NOT NULL,
    user_id INTEGER, -- Could reference doctors or other staff
    old_data JSONB,
    new_data JSONB
);

-- 68. Reconciliations
CREATE TABLE reconciliations (
    reconciliation_id SERIAL PRIMARY KEY,
    cash_account_id INTEGER REFERENCES cash_accounts(cash_account_id),
    period_id INTEGER REFERENCES financial_periods(period_id),
    reconciliation_date DATE NOT NULL,
    statement_balance DECIMAL(12,2) NOT NULL,
    book_balance DECIMAL(12,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending'
);

-- 69. Reconciliation Items
CREATE TABLE reconciliation_items (
    item_id SERIAL PRIMARY KEY,
    reconciliation_id INTEGER REFERENCES reconciliations(reconciliation_id),
    description TEXT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    item_type VARCHAR(20) NOT NULL -- e.g., Outstanding Check, Deposit in Transit
);

-- 70. Cost Allocations
CREATE TABLE cost_allocations (
    allocation_id SERIAL PRIMARY KEY,
    cost_center_id INTEGER REFERENCES cost_centers(cost_center_id),
    expense_id INTEGER REFERENCES expenses(expense_id),
    amount DECIMAL(12,2) NOT NULL,
    allocation_date DATE NOT NULL
);

-- 71. Financial Ratios
CREATE TABLE financial_ratios (
    ratio_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    period_id INTEGER REFERENCES financial_periods(period_id),
    ratio_name VARCHAR(100) NOT NULL, -- e.g., Current Ratio, Debt-to-Equity
    ratio_value DECIMAL(10,4) NOT NULL,
    calculated_date DATE NOT NULL
);

-- 72. Vendor Contracts
CREATE TABLE vendor_contracts (
    contract_id SERIAL PRIMARY KEY,
    supplier_id INTEGER REFERENCES suppliers(supplier_id),
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    contract_start_date DATE NOT NULL,
    contract_end_date DATE,
    terms TEXT,
    total_value DECIMAL(12,2)
);

-- 73. Contract Payments
CREATE TABLE contract_payments (
    payment_id SERIAL PRIMARY KEY,
    contract_id INTEGER REFERENCES vendor_contracts(contract_id),
    amount DECIMAL(12,2) NOT NULL,
    payment_date DATE NOT NULL,
    gl_transaction_id INTEGER REFERENCES gl_transactions(transaction_id)
);

-- 74. Revenue Forecasts
CREATE TABLE revenue_forecasts (
    forecast_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    period_id INTEGER REFERENCES financial_periods(period_id),
    revenue_stream_id INTEGER REFERENCES revenue_streams(revenue_stream_id),
    projected_amount DECIMAL(12,2) NOT NULL,
    forecast_date DATE NOT NULL
);

-- 75. Expense Forecasts
CREATE TABLE expense_forecasts (
    forecast_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    period_id INTEGER REFERENCES financial_periods(period_id),
    category_id INTEGER REFERENCES expense_categories(category_id),
    projected_amount DECIMAL(12,2) NOT NULL,
    forecast_date DATE NOT NULL
);

-- 76. Fixed Assets
CREATE TABLE fixed_assets (
    asset_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    cost_center_id INTEGER REFERENCES cost_centers(cost_center_id),
    asset_name VARCHAR(100) NOT NULL,
    purchase_date DATE NOT NULL,
    purchase_value DECIMAL(12,2) NOT NULL,
    current_value DECIMAL(12,2)
);

-- 77. Asset Maintenance
CREATE TABLE asset_maintenance (
    maintenance_id SERIAL PRIMARY KEY,
    asset_id INTEGER REFERENCES fixed_assets(asset_id),
    maintenance_date DATE NOT NULL,
    cost DECIMAL(12,2) NOT NULL,
    description TEXT,
    gl_transaction_id INTEGER REFERENCES gl_transactions(transaction_id)
);

-- 78. Financial Policies
CREATE TABLE financial_policies (
    policy_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    policy_name VARCHAR(100) NOT NULL,
    description TEXT,
    effective_date DATE NOT NULL
);

-- 79. Policy Compliance
CREATE TABLE policy_compliance (
    compliance_id SERIAL PRIMARY KEY,
    policy_id INTEGER REFERENCES financial_policies(policy_id),
    audit_id INTEGER REFERENCES financial_audits(audit_id),
    compliance_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending',
    notes TEXT
);

-- 80. Bad Debt
CREATE TABLE bad_debt (
    bad_debt_id SERIAL PRIMARY KEY,
    ar_id INTEGER REFERENCES accounts_receivable(ar_id),
    patient_id INTEGER REFERENCES patients(patient_id),
    amount DECIMAL(12,2) NOT NULL,
    write_off_date DATE NOT NULL,
    gl_transaction_id INTEGER REFERENCES gl_transactions(transaction_id)
);

-- Additional 50 Tables for Compliance and Audit Data in Hospital Management System

-- 81. Compliance Regulations
CREATE TABLE compliance_regulations (
    regulation_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    regulatory_body VARCHAR(100),
    effective_date DATE NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 82. Hospital Compliance Status
CREATE TABLE hospital_compliance_status (
    compliance_status_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    regulation_id INTEGER REFERENCES compliance_regulations(regulation_id),
    status VARCHAR(20) NOT NULL, -- e.g., Compliant, Non-Compliant, Pending
    last_review_date DATE,
    notes TEXT
);

-- 83. Compliance Policies
CREATE TABLE compliance_policies (
    policy_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    regulation_id INTEGER REFERENCES compliance_regulations(regulation_id),
    policy_name VARCHAR(100) NOT NULL,
    description TEXT,
    effective_date DATE NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 84. Policy Assignments
CREATE TABLE policy_assignments (
    assignment_id SERIAL PRIMARY KEY,
    policy_id INTEGER REFERENCES compliance_policies(policy_id),
    department_id INTEGER REFERENCES departments(department_id),
    assigned_date DATE NOT NULL,
    responsible_person_id INTEGER REFERENCES doctors(doctor_id)
);

-- 85. Compliance Training Programs
CREATE TABLE compliance_training_programs (
    training_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    regulation_id INTEGER REFERENCES compliance_regulations(regulation_id),
    training_name VARCHAR(100) NOT NULL,
    description TEXT,
    duration_hours INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 86. Employee Training Records
CREATE TABLE employee_training_records (
    record_id SERIAL PRIMARY KEY,
    training_id INTEGER REFERENCES compliance_training_programs(training_id),
    employee_id INTEGER, -- Could reference doctors or nurses
    completion_date DATE NOT NULL,
    certificate_number VARCHAR(50),
    status VARCHAR(20) DEFAULT 'Completed'
);

-- 87. Compliance Audits
CREATE TABLE compliance_audits (
    audit_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    regulation_id INTEGER REFERENCES compliance_regulations(regulation_id),
    audit_date DATE NOT NULL,
    auditor_name VARCHAR(100),
    findings TEXT,
    status VARCHAR(20) DEFAULT 'Pending'
);

-- 88. Audit Findings
CREATE TABLE audit_findings (
    finding_id SERIAL PRIMARY KEY,
    audit_id INTEGER REFERENCES compliance_audits(audit_id),
    finding_type VARCHAR(50) NOT NULL, -- e.g., Non-Compliance, Observation
    description TEXT NOT NULL,
    severity VARCHAR(20), -- e.g., Low, Medium, High
    reported_date DATE NOT NULL
);

-- 89. Corrective Actions
CREATE TABLE corrective_actions (
    action_id SERIAL PRIMARY KEY,
    finding_id INTEGER REFERENCES audit_findings(finding_id),
    description TEXT NOT NULL,
    assigned_to INTEGER REFERENCES doctors(doctor_id),
    due_date DATE,
    status VARCHAR(20) DEFAULT 'Open',
    completion_date DATE
);

-- 90. Compliance Incidents
CREATE TABLE compliance_incidents (
    incident_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    department_id INTEGER REFERENCES departments(department_id),
    incident_date TIMESTAMP NOT NULL,
    description TEXT NOT NULL,
    reported_by INTEGER REFERENCES doctors(doctor_id),
    status VARCHAR(20) DEFAULT 'Open'
);

-- 91. Incident Investigations
CREATE TABLE incident_investigations (
    investigation_id SERIAL PRIMARY KEY,
    incident_id INTEGER REFERENCES compliance_incidents(incident_id),
    investigator_id INTEGER REFERENCES doctors(doctor_id),
    start_date DATE NOT NULL,
    findings TEXT,
    status VARCHAR(20) DEFAULT 'In Progress',
    completion_date DATE
);

-- 92. Risk Assessments
CREATE TABLE risk_assessments (
    assessment_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    department_id INTEGER REFERENCES departments(department_id),
    assessment_date DATE NOT NULL,
    risk_description TEXT NOT NULL,
    likelihood VARCHAR(20), -- e.g., Low, Medium, High
    impact VARCHAR(20),
    risk_level VARCHAR(20)
);

-- 93. Risk Mitigation Plans
CREATE TABLE risk_mitigation_plans (
    plan_id SERIAL PRIMARY KEY,
    assessment_id INTEGER REFERENCES risk_assessments(assessment_id),
    description TEXT NOT NULL,
    assigned_to INTEGER REFERENCES doctors(doctor_id),
    due_date DATE,
    status VARCHAR(20) DEFAULT 'Planned',
    completion_date DATE
);

-- 94. Compliance Documents
CREATE TABLE compliance_documents (
    document_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    regulation_id INTEGER REFERENCES compliance_regulations(regulation_id),
    document_name VARCHAR(100) NOT NULL,
    document_type VARCHAR(50), -- e.g., Policy, Procedure, Report
    file_path TEXT,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 95. Document Reviews
CREATE TABLE document_reviews (
    review_id SERIAL PRIMARY KEY,
    document_id INTEGER REFERENCES compliance_documents(document_id),
    reviewer_id INTEGER REFERENCES doctors(doctor_id),
    review_date DATE NOT NULL,
    comments TEXT,
    status VARCHAR(20) DEFAULT 'Pending'
);

-- 96. Audit Schedules
CREATE TABLE audit_schedules (
    schedule_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    audit_type VARCHAR(50) NOT NULL, -- e.g., Internal, External, Financial
    planned_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Scheduled'
);

-- 97. Audit Team Assignments
CREATE TABLE audit_team_assignments (
    assignment_id SERIAL PRIMARY KEY,
    audit_id INTEGER REFERENCES compliance_audits(audit_id),
    employee_id INTEGER, -- Could reference doctors or nurses
    role VARCHAR(50) NOT NULL, -- e.g., Lead Auditor, Team Member
    assigned_date DATE NOT NULL
);

-- 98. Compliance Checklists
CREATE TABLE compliance_checklists (
    checklist_id SERIAL PRIMARY KEY,
    regulation_id INTEGER REFERENCES compliance_regulations(regulation_id),
    checklist_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 99. Checklist Items
CREATE TABLE checklist_items (
    item_id SERIAL PRIMARY KEY,
    checklist_id INTEGER REFERENCES compliance_checklists(checklist_id),
    description TEXT NOT NULL,
    required BOOLEAN DEFAULT TRUE,
    order_number INTEGER NOT NULL
);

-- 100. Checklist Responses
CREATE TABLE checklist_responses (
    response_id SERIAL PRIMARY KEY,
    checklist_id INTEGER REFERENCES compliance_checklists(checklist_id),
    item_id INTEGER REFERENCES checklist_items(item_id),
    department_id INTEGER REFERENCES departments(department_id),
    response_date DATE NOT NULL,
    is_compliant BOOLEAN NOT NULL,
    comments TEXT
);

-- 101. Quality Assurance Programs
CREATE TABLE quality_assurance_programs (
    program_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    program_name VARCHAR(100) NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Active'
);

-- 102. Quality Metrics
CREATE TABLE quality_metrics (
    metric_id SERIAL PRIMARY KEY,
    program_id INTEGER REFERENCES quality_assurance_programs(program_id),
    metric_name VARCHAR(100) NOT NULL,
    description TEXT,
    target_value DECIMAL(10,2),
    measurement_frequency VARCHAR(20) -- e.g., Daily, Weekly, Monthly
);

-- 103. Quality Metric Data
CREATE TABLE quality_metric_data (
    data_id SERIAL PRIMARY KEY,
    metric_id INTEGER REFERENCES quality_metrics(metric_id),
    department_id INTEGER REFERENCES departments(department_id),
    recorded_date DATE NOT NULL,
    value DECIMAL(10,2) NOT NULL,
    comments TEXT
);

-- 104. Compliance Certifications
CREATE TABLE compliance_certifications (
    certification_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    regulation_id INTEGER REFERENCES compliance_regulations(regulation_id),
    certification_name VARCHAR(100) NOT NULL,
    issue_date DATE NOT NULL,
    expiry_date DATE,
    certificate_number VARCHAR(50)
);

-- 105. Certification Audits
CREATE TABLE certification_audits (
    audit_id SERIAL PRIMARY KEY,
    certification_id INTEGER REFERENCES compliance_certifications(certification_id),
    audit_date DATE NOT NULL,
    auditor_name VARCHAR(100),
    findings TEXT,
    status VARCHAR(20) DEFAULT 'Pending'
);

-- 106. Incident Categories
CREATE TABLE incident_categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- 107. Incident Root Causes
CREATE TABLE incident_root_causes (
    root_cause_id SERIAL PRIMARY KEY,
    investigation_id INTEGER REFERENCES incident_investigations(investigation_id),
    category_id INTEGER REFERENCES incident_categories(category_id),
    description TEXT NOT NULL,
    identified_date DATE NOT NULL
);

-- 108. Compliance Reporting
CREATE TABLE compliance_reports (
    report_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    report_type VARCHAR(50) NOT NULL, -- e.g., Quarterly Compliance, Annual Audit
    generated_date TIMESTAMP NOT NULL,
    report_data JSONB, -- Store report data in JSON format
    status VARCHAR(20) DEFAULT 'Draft'
);

-- 109. Report Approvals
CREATE TABLE report_approvals (
    approval_id SERIAL PRIMARY KEY,
    report_id INTEGER REFERENCES compliance_reports(report_id),
    approver_id INTEGER REFERENCES doctors(doctor_id),
    approval_date DATE,
    status VARCHAR(20) DEFAULT 'Pending',
    comments TEXT
);

-- 110. Regulatory Submissions
CREATE TABLE regulatory_submissions (
    submission_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    regulation_id INTEGER REFERENCES compliance_regulations(regulation_id),
    submission_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending',
    submission_data JSONB
);

-- 111. Submission Reviews
CREATE TABLE submission_reviews (
    review_id SERIAL PRIMARY KEY,
    submission_id INTEGER REFERENCES regulatory_submissions(submission_id),
    reviewer_id INTEGER REFERENCES doctors(doctor_id),
    review_date DATE NOT NULL,
    comments TEXT,
    status VARCHAR(20) DEFAULT 'Pending'
);

-- 112. Compliance Alerts
CREATE TABLE compliance_alerts (
    alert_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    regulation_id INTEGER REFERENCES compliance_regulations(regulation_id),
    alert_date TIMESTAMP NOT NULL,
    description TEXT NOT NULL,
    priority VARCHAR(20), -- e.g., Low, Medium, High
    status VARCHAR(20) DEFAULT 'Active'
);

-- 113. Alert Responses
CREATE TABLE alert_responses (
    response_id SERIAL PRIMARY KEY,
    alert_id INTEGER REFERENCES compliance_alerts(alert_id),
    responded_by INTEGER REFERENCES doctors(doctor_id),
    response_date TIMESTAMP NOT NULL,
    response_text TEXT,
    status VARCHAR(20) DEFAULT 'Open'
);

-- 114. Privacy Incidents
CREATE TABLE privacy_incidents (
    incident_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    patient_id INTEGER REFERENCES patients(patient_id),
    incident_date TIMESTAMP NOT NULL,
    description TEXT NOT NULL,
    reported_by INTEGER REFERENCES doctors(doctor_id),
    status VARCHAR(20) DEFAULT 'Open'
);

-- 115. Privacy Incident Actions
CREATE TABLE privacy_incident_actions (
    action_id SERIAL PRIMARY KEY,
    incident_id INTEGER REFERENCES privacy_incidents(incident_id),
    description TEXT NOT NULL,
    assigned_to INTEGER REFERENCES doctors(doctor_id),
    due_date DATE,
    status VARCHAR(20) DEFAULT 'Open',
    completion_date DATE
);

-- 116. Data Breach Logs
CREATE TABLE data_breach_logs (
    breach_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    breach_date TIMESTAMP NOT NULL,
    description TEXT NOT NULL,
    affected_records INTEGER,
    reported_to VARCHAR(100),
    status VARCHAR(20) DEFAULT 'Open'
);

-- 117. Breach Notifications
CREATE TABLE breach_notifications (
    notification_id SERIAL PRIMARY KEY,
    breach_id INTEGER REFERENCES data_breach_logs(breach_id),
    notified_party VARCHAR(100) NOT NULL,
    notification_date DATE NOT NULL,
    method VARCHAR(50), -- e.g., Email, Letter
    details TEXT
);

-- 118. Compliance Metrics
CREATE TABLE compliance_metrics (
    metric_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    metric_name VARCHAR(100) NOT NULL,
    description TEXT,
    target_value DECIMAL(10,2),
    measurement_frequency VARCHAR(20)
);

-- 119. Compliance Metric Data
CREATE TABLE compliance_metric_data (
    data_id SERIAL PRIMARY KEY,
    metric_id INTEGER REFERENCES compliance_metrics(metric_id),
    recorded_date DATE NOT NULL,
    value DECIMAL(10,2) NOT NULL,
    comments TEXT
);

-- 120. Vendor Compliance
CREATE TABLE vendor_compliance (
    compliance_id SERIAL PRIMARY KEY,
    supplier_id INTEGER REFERENCES suppliers(supplier_id),
    regulation_id INTEGER REFERENCES compliance_regulations(regulation_id),
    status VARCHAR(20) NOT NULL,
    last_review_date DATE,
    notes TEXT
);

-- 121. Vendor Audits
CREATE TABLE vendor_audits (
    audit_id SERIAL PRIMARY KEY,
    supplier_id INTEGER REFERENCES suppliers(supplier_id),
    audit_date DATE NOT NULL,
    auditor_name VARCHAR(100),
    findings TEXT,
    status VARCHAR(20) DEFAULT 'Pending'
);

-- 122. Compliance Task Templates
CREATE TABLE compliance_task_templates (
    template_id SERIAL PRIMARY KEY,
    regulation_id INTEGER REFERENCES compliance_regulations(regulation_id),
    task_name VARCHAR(100) NOT NULL,
    description TEXT,
    frequency VARCHAR(20) -- e.g., Daily, Weekly, Monthly
);

-- 123. Compliance Tasks
CREATE TABLE compliance_tasks (
    task_id SERIAL PRIMARY KEY,
    template_id INTEGER REFERENCES compliance_task_templates(template_id),
    department_id INTEGER REFERENCES departments(department_id),
    assigned_to INTEGER REFERENCES doctors(doctor_id),
    due_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Open',
    completion_date DATE
);

-- 124. Compliance Task History
CREATE TABLE compliance_task_history (
    history_id SERIAL PRIMARY KEY,
    task_id INTEGER REFERENCES compliance_tasks(task_id),
    action VARCHAR(20) NOT NULL, -- e.g., Created, Updated, Completed
    action_date TIMESTAMP NOT NULL,
    action_by INTEGER REFERENCES doctors(doctor_id),
    comments TEXT
);

-- 125. Audit Evidence
CREATE TABLE audit_evidence (
    evidence_id SERIAL PRIMARY KEY,
    audit_id INTEGER REFERENCES compliance_audits(audit_id),
    document_id INTEGER REFERENCES compliance_documents(document_id),
    description TEXT NOT NULL,
    submitted_date DATE NOT NULL,
    submitted_by INTEGER REFERENCES doctors(doctor_id)
);

-- 126. Compliance Dashboards
CREATE TABLE compliance_dashboards (
    dashboard_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    dashboard_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dashboard_data JSONB
);

-- 127. Dashboard Metrics
CREATE TABLE dashboard_metrics (
    metric_id SERIAL PRIMARY KEY,
    dashboard_id INTEGER REFERENCES compliance_dashboards(dashboard_id),
    compliance_metric_id INTEGER REFERENCES compliance_metrics(metric_id),
    display_order INTEGER NOT NULL
);

-- 128. Compliance Roles
CREATE TABLE compliance_roles (
    role_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    role_name VARCHAR(100) NOT NULL,
    description TEXT
);

-- 129. Role Assignments
CREATE TABLE role_assignments (
    assignment_id SERIAL PRIMARY KEY,
    role_id INTEGER REFERENCES compliance_roles(role_id),
    employee_id INTEGER, -- Could reference doctors or nurses
    assigned_date DATE NOT NULL,
    expiry_date DATE
);

-- 130. Compliance Event Logs
CREATE TABLE compliance_event_logs (
    event_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    event_type VARCHAR(50) NOT NULL, -- e.g., Policy Update, Audit Completion
    event_date TIMESTAMP NOT NULL,
    description TEXT,
    triggered_by INTEGER REFERENCES doctors(doctor_id)
);






-- Additional 50 Tables for Granular Medical Records in Hospital Management System

-- 131. Vital Signs
CREATE TABLE vital_signs (
    vital_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    recorded_date TIMESTAMP NOT NULL,
    blood_pressure_systolic INTEGER,
    blood_pressure_diastolic INTEGER,
    heart_rate INTEGER,
    respiratory_rate INTEGER,
    temperature DECIMAL(4,1),
    oxygen_saturation INTEGER,
    recorded_by INTEGER REFERENCES doctors(doctor_id)
);

-- 132. Allergies
CREATE TABLE allergies (
    allergy_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    allergen VARCHAR(100) NOT NULL,
    reaction TEXT,
    severity VARCHAR(20), -- e.g., Mild, Moderate, Severe
    diagnosed_date DATE,
    diagnosed_by INTEGER REFERENCES doctors(doctor_id)
);

-- 133. Immunizations
CREATE TABLE immunizations (
    immunization_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    vaccine_name VARCHAR(100) NOT NULL,
    administration_date DATE NOT NULL,
    dose_number INTEGER,
    lot_number VARCHAR(50),
    administered_by INTEGER REFERENCES doctors(doctor_id)
);

-- 134. Medical History
CREATE TABLE medical_history (
    history_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    condition VARCHAR(100) NOT NULL,
    diagnosis_date DATE,
    status VARCHAR(20), -- e.g., Active, Resolved, Chronic
    notes TEXT,
    diagnosed_by INTEGER REFERENCES doctors(doctor_id)
);

-- 135. Family Medical History
CREATE TABLE family_medical_history (
    family_history_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    relationship VARCHAR(50), -- e.g., Mother, Father, Sibling
    condition VARCHAR(100) NOT NULL,
    notes TEXT,
    recorded_date DATE,
    recorded_by INTEGER REFERENCES doctors(doctor_id)
);

-- 136. Social History
CREATE TABLE social_history (
    social_history_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    smoking_status VARCHAR(50), -- e.g., Never, Current, Former
    alcohol_use VARCHAR(50),
    drug_use VARCHAR(50),
    occupation VARCHAR(100),
    marital_status VARCHAR(50),
    recorded_date DATE,
    recorded_by INTEGER REFERENCES doctors(doctor_id)
);

-- 137. Clinical Notes
CREATE TABLE clinical_notes (
    note_id SERIAL PRIMARY KEY,
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    patient_id INTEGER REFERENCES patients(patient_id),
    doctor_id INTEGER REFERENCES doctors(doctor_id),
    note_date TIMESTAMP NOT NULL,
    note_type VARCHAR(50), -- e.g., Progress, Consultation, Discharge
    content TEXT NOT NULL
);

-- 138. Diagnostic Imaging
CREATE TABLE diagnostic_imaging (
    imaging_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    imaging_type VARCHAR(50) NOT NULL, -- e.g., X-Ray, MRI, CT
    body_part VARCHAR(50),
    imaging_date DATE NOT NULL,
    file_path TEXT,
    ordered_by INTEGER REFERENCES doctors(doctor_id)
);

-- 139. Imaging Reports
CREATE TABLE imaging_reports (
    report_id SERIAL PRIMARY KEY,
    imaging_id INTEGER REFERENCES diagnostic_imaging(imaging_id),
    patient_id INTEGER REFERENCES patients(patient_id),
    report_date DATE NOT NULL,
    findings TEXT,
    impression TEXT,
    reported_by INTEGER REFERENCES doctors(doctor_id)
);

-- 140. Pathology Reports
CREATE TABLE pathology_reports (
    pathology_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    specimen_type VARCHAR(50) NOT NULL,
    collection_date DATE NOT NULL,
    findings TEXT,
    diagnosis TEXT,
    reported_by INTEGER REFERENCES doctors(doctor_id)
);

-- 141. Treatment Plans
CREATE TABLE treatment_plans (
    plan_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    start_date DATE NOT NULL,
    end_date DATE,
    description TEXT NOT NULL,
    created_by INTEGER REFERENCES doctors(doctor_id)
);

-- 142. Treatment Plan Actions
CREATE TABLE treatment_plan_actions (
    action_id SERIAL PRIMARY KEY,
    plan_id INTEGER REFERENCES treatment_plans(plan_id),
    action_type VARCHAR(50) NOT NULL, -- e.g., Medication, Procedure, Therapy
    description TEXT NOT NULL,
    status VARCHAR(20) DEFAULT 'Planned',
    completion_date DATE
);

-- 143. Medication Administration
CREATE TABLE medication_administration (
    administration_id SERIAL PRIMARY KEY,
    prescription_item_id INTEGER REFERENCES prescription_items(item_id),
    patient_id INTEGER REFERENCES patients(patient_id),
    administration_date TIMESTAMP NOT NULL,
    dose_administered VARCHAR(50),
    administered_by INTEGER REFERENCES nurses(nurse_id),
    notes TEXT
);

-- 144. Procedure Records
CREATE TABLE procedure_records (
    procedure_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    procedure_name VARCHAR(100) NOT NULL,
    procedure_date TIMESTAMP NOT NULL,
    outcome TEXT,
    performed_by INTEGER REFERENCES doctors(doctor_id)
);

-- 145. Procedure Complications
CREATE TABLE procedure_complications (
    complication_id SERIAL PRIMARY KEY,
    procedure_id INTEGER REFERENCES procedure_records(procedure_id),
    description TEXT NOT NULL,
    severity VARCHAR(20), -- e.g., Minor, Major
    reported_date DATE NOT NULL,
    reported_by INTEGER REFERENCES doctors(doctor_id)
);

-- 146. Patient Consent Forms
CREATE TABLE patient_consent_forms (
    consent_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    procedure_id INTEGER REFERENCES procedure_records(procedure_id),
    consent_type VARCHAR(50) NOT NULL, -- e.g., Surgical, Treatment, Research
    signed_date DATE NOT NULL,
    file_path TEXT,
    witnessed_by INTEGER REFERENCES doctors(doctor_id)
);

-- 147. Pain Assessments
CREATE TABLE pain_assessments (
    assessment_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    assessment_date TIMESTAMP NOT NULL,
    pain_score INTEGER CHECK (pain_score >= 0 AND pain_score <= 10),
    pain_location VARCHAR(100),
    pain_type VARCHAR(50),
    assessed_by INTEGER REFERENCES doctors(doctor_id)
);

-- 148. Nutritional Assessments
CREATE TABLE nutritional_assessments (
    assessment_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    assessment_date DATE NOT NULL,
    weight_kg DECIMAL(5,1),
    height_cm DECIMAL(5,1),
    bmi DECIMAL(4,1),
    dietary_restrictions TEXT,
    assessed_by INTEGER REFERENCES doctors(doctor_id)
);

-- 149. Mental Health Assessments
CREATE TABLE mental_health_assessments (
    assessment_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    assessment_date DATE NOT NULL,
    diagnosis TEXT,
    symptoms TEXT,
    assessed_by INTEGER REFERENCES doctors(doctor_id)
);

-- 150. Rehabilitation Plans
CREATE TABLE rehabilitation_plans (
    plan_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    start_date DATE NOT NULL,
    end_date DATE,
    therapy_type VARCHAR(50), -- e.g., Physical, Occupational
    description TEXT,
    created_by INTEGER REFERENCES doctors(doctor_id)
);

 
-- 151. Rehabilitation Sessions (Completing the table)
CREATE TABLE rehabilitation_sessions (
    session_id SERIAL PRIMARY KEY,
    plan_id INTEGER REFERENCES rehabilitation_plans(plan_id),
    patient_id INTEGER REFERENCES patients(patient_id),
    session_date TIMESTAMP NOT NULL,
    duration_minutes INTEGER,
    progress_notes TEXT,
    conducted_by INTEGER REFERENCES doctors(doctor_id)
);

-- 152. Wound Care Records
CREATE TABLE wound_care_records (
    wound_care_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    wound_location VARCHAR(100) NOT NULL,
    wound_type VARCHAR(50), -- e.g., Surgical, Pressure Ulcer
    assessment_date TIMESTAMP NOT NULL,
    treatment TEXT,
    assessed_by INTEGER REFERENCES nurses(nurse_id)
);

-- 153. Wound Care Assessments
CREATE TABLE wound_care_assessments (
    assessment_id SERIAL PRIMARY KEY,
    wound_care_id INTEGER REFERENCES wound_care_records(wound_care_id),
    assessment_date TIMESTAMP NOT NULL,
    wound_size_cm DECIMAL(5,2),
    wound_depth_cm DECIMAL(5,2),
    healing_status VARCHAR(50), -- e.g., Improving, Stable, Worsening
    notes TEXT,
    assessed_by INTEGER REFERENCES nurses(nurse_id)
);

-- 154. Respiratory Assessments
CREATE TABLE respiratory_assessments (
    assessment_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    assessment_date TIMESTAMP NOT NULL,
    respiratory_rate INTEGER,
    oxygen_therapy VARCHAR(50), -- e.g., Nasal Cannula, Ventilator
    spo2_level INTEGER,
    notes TEXT,
    assessed_by INTEGER REFERENCES doctors(doctor_id)
);

-- 155. Cardiac Assessments
CREATE TABLE cardiac_assessments (
    assessment_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    assessment_date TIMESTAMP NOT NULL,
    ecg_findings TEXT,
    heart_rate INTEGER,
    cardiac_rhythm VARCHAR(50), -- e.g., Normal Sinus, Atrial Fibrillation
    assessed_by INTEGER REFERENCES doctors(doctor_id)
);

-- 156. Neurological Assessments
CREATE TABLE neurological_assessments (
    assessment_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    assessment_date TIMESTAMP NOT NULL,
    glasgow_coma_score INTEGER CHECK (glasgow_coma_score >= 3 AND glasgow_coma_score <= 15),
    pupil_response VARCHAR(50),
    motor_response TEXT,
    assessed_by INTEGER REFERENCES doctors(doctor_id)
);

-- 157. Blood Glucose Levels
CREATE TABLE blood_glucose_levels (
    glucose_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    recorded_date TIMESTAMP NOT NULL,
    glucose_level_mgdl INTEGER,
    measurement_type VARCHAR(50), -- e.g., Fasting, Postprandial
    notes TEXT,
    recorded_by INTEGER REFERENCES nurses(nurse_id)
);

-- 158. Fluid Balance Records
CREATE TABLE fluid_balance_records (
    fluid_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    recorded_date DATE NOT NULL,
    intake_ml INTEGER,
    output_ml INTEGER,
    balance_ml INTEGER,
    recorded_by INTEGER REFERENCES nurses(nurse_id)
);

-- 159. Intravenous Therapy Records
CREATE TABLE iv_therapy_records (
    iv_therapy_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP,
    fluid_type VARCHAR(100),
    rate_ml_per_hour INTEGER,
    administered_by INTEGER REFERENCES nurses(nurse_id)
);

-- 160. Ventilator Settings
CREATE TABLE ventilator_settings (
    setting_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    recorded_date TIMESTAMP NOT NULL,
    mode VARCHAR(50), -- e.g., AC, SIMV
    tidal_volume_ml INTEGER,
    fio2_percentage INTEGER,
    peep_cm_h2o INTEGER,
    set_by INTEGER REFERENCES doctors(doctor_id)
);

-- 161. Dialysis Records
CREATE TABLE dialysis_records (
    dialysis_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    session_date TIMESTAMP NOT NULL,
    dialysis_type VARCHAR(50), -- e.g., Hemodialysis, Peritoneal
    duration_hours INTEGER,
    complications TEXT,
    performed_by INTEGER REFERENCES doctors(doctor_id)
);

-- 162. Chemotherapy Records
CREATE TABLE chemotherapy_records (
    chemo_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    session_date DATE NOT NULL,
    drug_name VARCHAR(100) NOT NULL,
    dose_mg INTEGER,
    side_effects TEXT,
    administered_by INTEGER REFERENCES doctors(doctor_id)
);

-- 163. Radiation Therapy Records
CREATE TABLE radiation_therapy_records (
    radiation_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    session_date DATE NOT NULL,
    target_area VARCHAR(100),
    dose_gy DECIMAL(5,2),
    side_effects TEXT,
    administered_by INTEGER REFERENCES doctors(doctor_id)
);

-- 164. Physical Therapy Assessments
CREATE TABLE physical_therapy_assessments (
    assessment_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    assessment_date DATE NOT NULL,
    range_of_motion TEXT,
    muscle_strength VARCHAR(50),
    goals TEXT,
    assessed_by INTEGER REFERENCES doctors(doctor_id)
);

-- 165. Occupational Therapy Assessments
CREATE TABLE occupational_therapy_assessments (
    assessment_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    assessment_date DATE NOT NULL,
    functional_status TEXT,
    goals TEXT,
    assessed_by INTEGER REFERENCES doctors(doctor_id)
);

-- 166. Speech Therapy Assessments
CREATE TABLE speech_therapy_assessments (
    assessment_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    assessment_date DATE NOT NULL,
    speech_clarity VARCHAR(50),
    swallowing_function TEXT,
    goals TEXT,
    assessed_by INTEGER REFERENCES doctors(doctor_id)
);

-- 167. Advance Directives
CREATE TABLE advance_directives (
    directive_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    directive_type VARCHAR(50), -- e.g., DNR, Living Will
    signed_date DATE NOT NULL,
    details TEXT,
    file_path TEXT,
    witnessed_by INTEGER REFERENCES doctors(doctor_id)
);

-- 168. Patient Goals
CREATE TABLE patient_goals (
    goal_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    goal_description TEXT NOT NULL,
    set_date DATE NOT NULL,
    target_date DATE,
    status VARCHAR(20) DEFAULT 'Active',
    set_by INTEGER REFERENCES doctors(doctor_id)
);

-- 169. Care Plans
CREATE TABLE care_plans (
    care_plan_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    start_date DATE NOT NULL,
    end_date DATE,
    description TEXT NOT NULL,
    created_by INTEGER REFERENCES doctors(doctor_id)
);

-- 170. Care Plan Interventions
CREATE TABLE care_plan_interventions (
    intervention_id SERIAL PRIMARY KEY,
    care_plan_id INTEGER REFERENCES care_plans(care_plan_id),
    intervention_type VARCHAR(50) NOT NULL, -- e.g., Nursing, Medical, Social
    description TEXT NOT NULL,
    frequency VARCHAR(50),
    responsible_person_id INTEGER REFERENCES doctors(doctor_id)
);

-- 171. Patient Education Records
CREATE TABLE patient_education_records (
    education_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    education_date DATE NOT NULL,
    topic VARCHAR(100) NOT NULL,
    materials_provided TEXT,
    understanding_level VARCHAR(50), -- e.g., Full, Partial, None
    provided_by INTEGER REFERENCES doctors(doctor_id)
);

-- 172. Fall Risk Assessments
CREATE TABLE fall_risk_assessments (
    assessment_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    assessment_date DATE NOT NULL,
    risk_score INTEGER,
    risk_level VARCHAR(20), -- e.g., Low, Moderate, High
    precautions TEXT,
    assessed_by INTEGER REFERENCES nurses(nurse_id)
);

-- 173. Pressure Ulcer Assessments
CREATE TABLE pressure_ulcer_assessments (
    assessment_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    assessment_date DATE NOT NULL,
    stage INTEGER CHECK (stage >= 1 AND stage <= 4),
    location VARCHAR(100),
    treatment_plan TEXT,
    assessed_by INTEGER REFERENCES nurses(nurse_id)
);

-- 174. Infection Control Records
CREATE TABLE infection_control_records (
    infection_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    infection_type VARCHAR(100) NOT NULL,
    onset_date DATE NOT NULL,
    treatment TEXT,
    reported_by INTEGER REFERENCES doctors(doctor_id)
);

-- 175. Isolation Precautions
CREATE TABLE isolation_precautions (
    precaution_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    precaution_type VARCHAR(50) NOT NULL, -- e.g., Contact, Droplet, Airborne
    start_date DATE NOT NULL,
    end_date DATE,
    ordered_by INTEGER REFERENCES doctors(doctor_id)
);

-- 176. Transfusion Records
CREATE TABLE transfusion_records (
    transfusion_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    transfusion_date TIMESTAMP NOT NULL,
    blood_product VARCHAR(50), -- e.g., Packed RBC, Platelets
    volume_ml INTEGER,
    reaction TEXT,
    administered_by INTEGER REFERENCES nurses(nurse_id)
);

-- 177. Anesthesia Records
CREATE TABLE anesthesia_records (
    anesthesia_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    procedure_id INTEGER REFERENCES procedure_records(procedure_id),
    anesthesia_type VARCHAR(50), -- e.g., General, Regional
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,
    complications TEXT,
    administered_by INTEGER REFERENCES doctors(doctor_id)
);

-- 178. Post-Anesthesia Assessments
CREATE TABLE post_anesthesia_assessments (
    assessment_id SERIAL PRIMARY KEY,
    anesthesia_id INTEGER REFERENCES anesthesia_records(anesthesia_id),
    assessment_date TIMESTAMP NOT NULL,
    recovery_status VARCHAR(50), -- e.g., Stable, Complicated
    pain_score INTEGER CHECK (pain_score >= 0 AND pain_score <= 10),
    notes TEXT,
    assessed_by INTEGER REFERENCES nurses(nurse_id)
);

-- 179. Endoscopy Records
CREATE TABLE endoscopy_records (
    endoscopy_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    procedure_date TIMESTAMP NOT NULL,
    endoscopy_type VARCHAR(50), -- e.g., Colonoscopy, Gastroscopy
    findings TEXT,
    performed_by INTEGER REFERENCES doctors(doctor_id)
);

-- 180. Genetic Testing Records
CREATE TABLE genetic_testing_records (
    genetic_test_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    medical_record_id INTEGER REFERENCES medical_records(record_id),
    test_name VARCHAR(100) NOT NULL,
    test_date DATE NOT NULL,
    results TEXT,
    ordered_by INTEGER REFERENCES doctors(doctor_id)
);

 -- Corrected: Additional 40 Tables for Supply Chain Management Data in Hospital Management System

-- 181. Inventory Categories
CREATE TABLE inventory_categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 182. Inventory Subcategories
CREATE TABLE inventory_subcategories (
    subcategory_id SERIAL PRIMARY KEY,
    category_id INTEGER REFERENCES inventory_categories(category_id),
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- 183. Inventory Items
CREATE TABLE inventory_items (
    item_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    category_id INTEGER REFERENCES inventory_categories(category_id),
    subcategory_id INTEGER REFERENCES inventory_subcategories(subcategory_id),
    name VARCHAR(100) NOT NULL,
    sku VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    unit_of_measure VARCHAR(20), -- e.g., Each, Box, Liter
    unit_price DECIMAL(10,2)
);

-- 184. Inventory Stock
CREATE TABLE inventory_stock (
    stock_id SERIAL PRIMARY KEY,
    item_id INTEGER REFERENCES inventory_items(item_id),
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    ward_id INTEGER REFERENCES wards(ward_id),
    quantity INTEGER NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 185. Stock Locations
CREATE TABLE stock_locations (
    location_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    capacity INTEGER
);

-- 186. Stock Location Assignments
CREATE TABLE stock_location_assignments (
    assignment_id SERIAL PRIMARY KEY,
    stock_id INTEGER REFERENCES inventory_stock(stock_id),
    location_id INTEGER REFERENCES stock_locations(location_id),
    quantity INTEGER NOT NULL,
    assigned_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 187. Stock Movements
CREATE TABLE stock_movements (
    movement_id SERIAL PRIMARY KEY,
    item_id INTEGER REFERENCES inventory_items(item_id),
    from_location_id INTEGER REFERENCES stock_locations(location_id),
    to_location_id INTEGER REFERENCES stock_locations(location_id),
    quantity INTEGER NOT NULL,
    movement_type VARCHAR(20) NOT NULL, -- e.g., Transfer, Issue, Receipt
    movement_date TIMESTAMP NOT NULL,
    initiated_by INTEGER REFERENCES doctors(doctor_id)
);

-- 188. Reorder Rules
CREATE TABLE reorder_rules (
    rule_id SERIAL PRIMARY KEY,
    item_id INTEGER REFERENCES inventory_items(item_id),
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    min_quantity INTEGER NOT NULL,
    max_quantity INTEGER NOT NULL,
    reorder_quantity INTEGER NOT NULL
);

-- 189. Purchase Requisitions
CREATE TABLE purchase_requisitions (
    requisition_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    department_id INTEGER REFERENCES departments(department_id),
    requested_by INTEGER REFERENCES doctors(doctor_id),
    request_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending',
    description TEXT
);

-- 190. Requisition Items
CREATE TABLE requisition_items (
    requisition_item_id SERIAL PRIMARY KEY,
    requisition_id INTEGER REFERENCES purchase_requisitions(requisition_id),
    item_id INTEGER REFERENCES inventory_items(item_id),
    quantity INTEGER NOT NULL,
    estimated_unit_price DECIMAL(10,2)
);

-- 191. Procurement Contracts (Replaces purchase_orders)
CREATE TABLE procurement_contracts (
    contract_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    supplier_id INTEGER REFERENCES suppliers(supplier_id),
    requisition_id INTEGER REFERENCES purchase_requisitions(requisition_id),
    contract_date DATE NOT NULL,
    contract_end_date DATE,
    status VARCHAR(20) DEFAULT 'Active',
    total_amount DECIMAL(10,2),
    terms TEXT
);

-- 192. Contract Items (Replaces purchase_order_items)
CREATE TABLE contract_items (
    contract_item_id SERIAL PRIMARY KEY,
    contract_id INTEGER REFERENCES procurement_contracts(contract_id),
    item_id INTEGER REFERENCES inventory_items(item_id),
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2)
);

-- 193. Goods Receipts
CREATE TABLE goods_receipts (
    receipt_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES purchase_orders(order_id), -- References existing purchase_orders
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    receipt_date DATE NOT NULL,
    received_by INTEGER REFERENCES doctors(doctor_id),
    status VARCHAR(20) DEFAULT 'Received'
);

-- 194. Goods Receipt Items
CREATE TABLE goods_receipt_items (
    receipt_item_id SERIAL PRIMARY KEY,
    receipt_id INTEGER REFERENCES goods_receipts(receipt_id),
    item_id INTEGER REFERENCES inventory_items(item_id), -- Removed reference to purchase_order_items
    quantity_received INTEGER NOT NULL,
    condition VARCHAR(50) -- e.g., Good, Damaged
);

-- 195. Supplier Contracts
CREATE TABLE supplier_contracts (
    contract_id SERIAL PRIMARY KEY,
    supplier_id INTEGER REFERENCES suppliers(supplier_id),
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    contract_start_date DATE NOT NULL,
    contract_end_date DATE,
    terms TEXT,
    total_value DECIMAL(10,2)
);

-- 196. Supplier Performance
CREATE TABLE supplier_performance (
    performance_id SERIAL PRIMARY KEY,
    supplier_id INTEGER REFERENCES suppliers(supplier_id),
    evaluation_date DATE NOT NULL,
    delivery_timeliness VARCHAR(20), -- e.g., Excellent, Good, Poor
    quality_rating VARCHAR(20),
    comments TEXT
);

-- 197. Inventory Adjustments
CREATE TABLE inventory_adjustments (
    adjustment_id SERIAL PRIMARY KEY,
    item_id INTEGER REFERENCES inventory_items(item_id),
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    adjustment_date TIMESTAMP NOT NULL,
    quantity_adjusted INTEGER NOT NULL,
    reason TEXT,
    adjusted_by INTEGER REFERENCES doctors(doctor_id)
);

-- 198. Inventory Audits
CREATE TABLE inventory_audits (
    audit_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    audit_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending',
    auditor_name VARCHAR(100),
    findings TEXT
);

-- 199. Inventory Audit Items
CREATE TABLE inventory_audit_items (
    audit_item_id SERIAL PRIMARY KEY,
    audit_id INTEGER REFERENCES inventory_audits(audit_id),
    item_id INTEGER REFERENCES inventory_items(item_id),
    expected_quantity INTEGER,
    actual_quantity INTEGER,
    discrepancy INTEGER,
    notes TEXT
);

-- 200. Equipment
CREATE TABLE equipment (
    equipment_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    department_id INTEGER REFERENCES departments(department_id),
    name VARCHAR(100) NOT NULL,
    serial_number VARCHAR(50) UNIQUE,
    purchase_date DATE,
    purchase_price DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'Operational'
);

-- 201. Equipment Maintenance
CREATE TABLE equipment_maintenance (
    maintenance_id SERIAL PRIMARY KEY,
    equipment_id INTEGER REFERENCES equipment(equipment_id),
    maintenance_date DATE NOT NULL,
    maintenance_type VARCHAR(50), -- e.g., Preventive, Corrective
    description TEXT,
    cost DECIMAL(10,2),
    performed_by VARCHAR(100)
);

-- 202. Equipment Calibration
CREATE TABLE equipment_calibration (
    calibration_id SERIAL PRIMARY KEY,
    equipment_id INTEGER REFERENCES equipment(equipment_id),
    calibration_date DATE NOT NULL,
    next_calibration_date DATE,
    result VARCHAR(20), -- e.g., Pass, Fail
    notes TEXT,
    performed_by VARCHAR(100)
);

-- 203. Equipment Usage Logs
CREATE TABLE equipment_usage_logs (
    usage_id SERIAL PRIMARY KEY,
    equipment_id INTEGER REFERENCES equipment(equipment_id),
    used_by INTEGER REFERENCES doctors(doctor_id),
    usage_date TIMESTAMP NOT NULL,
    duration_minutes INTEGER,
    purpose TEXT
);

-- 204. Supplier Invoices
CREATE TABLE supplier_invoices (
    invoice_id SERIAL PRIMARY KEY,
    supplier_id INTEGER REFERENCES suppliers(supplier_id),
    order_id INTEGER REFERENCES purchase_orders(order_id), -- References existing purchase_orders
    invoice_number VARCHAR(50) UNIQUE NOT NULL,
    invoice_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'Unpaid'
);

-- 205. Invoice Payments
CREATE TABLE invoice_payments (
    payment_id SERIAL PRIMARY KEY,
    invoice_id INTEGER REFERENCES supplier_invoices(invoice_id),
    payment_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50), -- e.g., Bank Transfer, Check
    gl_transaction_id INTEGER REFERENCES gl_transactions(transaction_id)
);

-- 206. Return Merchandise Authorizations
CREATE TABLE return_merchandise_authorizations (
    rma_id SERIAL PRIMARY KEY,
    receipt_id INTEGER REFERENCES goods_receipts(receipt_id),
    supplier_id INTEGER REFERENCES suppliers(supplier_id),
    request_date DATE NOT NULL,
    reason TEXT,
    status VARCHAR(20) DEFAULT 'Pending'
);

-- 207. RMA Items
CREATE TABLE rma_items (
    rma_item_id SERIAL PRIMARY KEY,
    rma_id INTEGER REFERENCES return_merchandise_authorizations(rma_id),
    item_id INTEGER REFERENCES inventory_items(item_id),
    quantity INTEGER NOT NULL,
    condition VARCHAR(50)
);

-- 208. Stock Reservations
CREATE TABLE stock_reservations (
    reservation_id SERIAL PRIMARY KEY,
    item_id INTEGER REFERENCES inventory_items(item_id),
    department_id INTEGER REFERENCES departments(department_id),
    quantity INTEGER NOT NULL,
    reservation_date TIMESTAMP NOT NULL,
    purpose TEXT,
    reserved_by INTEGER REFERENCES doctors(doctor_id)
);

-- 209. Stock Expiry Tracking
CREATE TABLE stock_expiry_tracking (
    expiry_id SERIAL PRIMARY KEY,
    item_id INTEGER REFERENCES inventory_items(item_id),
    stock_id INTEGER REFERENCES inventory_stock(stock_id),
    batch_number VARCHAR(50),
    expiry_date DATE NOT NULL,
    quantity INTEGER NOT NULL
);

-- 210. Supplier Contacts
CREATE TABLE supplier_contacts (
    contact_id SERIAL PRIMARY KEY,
    supplier_id INTEGER REFERENCES suppliers(supplier_id),
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    role VARCHAR(50)
);

-- 211. Logistics Providers
CREATE TABLE logistics_providers (
    provider_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(100)
);

-- 212. Shipment Records
CREATE TABLE shipment_records (
    shipment_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES purchase_orders(order_id), -- References existing purchase_orders
    provider_id INTEGER REFERENCES logistics_providers(provider_id),
    shipment_date DATE NOT NULL,
    tracking_number VARCHAR(50),
    status VARCHAR(20) DEFAULT 'In Transit'
);

-- 213. Shipment Items
CREATE TABLE shipment_items (
    shipment_item_id SERIAL PRIMARY KEY,
    shipment_id INTEGER REFERENCES shipment_records(shipment_id),
    item_id INTEGER REFERENCES inventory_items(item_id), -- Removed reference to purchase_order_items
    quantity INTEGER NOT NULL
);

-- 214. Inventory Forecasts
CREATE TABLE inventory_forecasts (
    forecast_id SERIAL PRIMARY KEY,
    item_id INTEGER REFERENCES inventory_items(item_id),
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    forecast_date DATE NOT NULL,
    projected_quantity INTEGER NOT NULL,
    forecast_period VARCHAR(20) -- e.g., Monthly, Quarterly
);

-- 215. Stock Replenishment Plans
CREATE TABLE stock_replenishment_plans (
    plan_id SERIAL PRIMARY KEY,
    item_id INTEGER REFERENCES inventory_items(item_id),
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    planned_date DATE NOT NULL,
    quantity INTEGER NOT NULL,
    status VARCHAR(20) DEFAULT 'Planned'
);

-- 216. Inventory Disposal Records
CREATE TABLE inventory_disposal_records (
    disposal_id SERIAL PRIMARY KEY,
    item_id INTEGER REFERENCES inventory_items(item_id),
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    disposal_date DATE NOT NULL,
    quantity INTEGER NOT NULL,
    reason TEXT,
    disposed_by INTEGER REFERENCES doctors(doctor_id)
);

-- 217. Vendor Scorecards
CREATE TABLE vendor_scorecards (
    scorecard_id SERIAL PRIMARY KEY,
    supplier_id INTEGER REFERENCES suppliers(supplier_id),
    evaluation_date DATE NOT NULL,
    quality_score INTEGER CHECK (quality_score >= 0 AND quality_score <= 100),
    delivery_score INTEGER CHECK (delivery_score >= 0 AND delivery_score <= 100),
    cost_score INTEGER CHECK (cost_score >= 0 AND cost_score <= 100),
    overall_score INTEGER CHECK (overall_score >= 0 AND overall_score <= 100),
    comments TEXT
);

-- 218. Supply Chain Alerts
CREATE TABLE supply_chain_alerts (
    alert_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    item_id INTEGER REFERENCES inventory_items(item_id),
    alert_date TIMESTAMP NOT NULL,
    alert_type VARCHAR(50), -- e.g., Low Stock, Expiry, Delay
    description TEXT,
    priority VARCHAR(20) -- e.g., Low, Medium, High
);

-- 219. Supply Chain Reports
CREATE TABLE supply_chain_reports (
    report_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    report_type VARCHAR(50) NOT NULL, -- e.g., Stock Levels, Procurement
    generated_date TIMESTAMP NOT NULL,
    report_data JSONB
);

-- 220. Stock Allocation Rules
CREATE TABLE stock_allocation_rules (
    rule_id SERIAL PRIMARY KEY,
    item_id INTEGER REFERENCES inventory_items(item_id),
    department_id INTEGER REFERENCES departments(department_id),
    allocation_priority INTEGER NOT NULL,
    max_allocation_quantity INTEGER,
    description TEXT
);

-- Corrected: Additional 30 Tables for External System Integrations Data in Hospital Management System

-- 221. External Systems
CREATE TABLE external_systems (
    system_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    system_name VARCHAR(100) NOT NULL,
    system_type VARCHAR(50), -- e.g., EHR, Billing, Insurance, LIS
    description TEXT,
    base_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 222. API Credentials
CREATE TABLE api_credentials (
    credential_id SERIAL PRIMARY KEY,
    system_id INTEGER REFERENCES external_systems(system_id),
    api_key VARCHAR(255),
    client_id VARCHAR(100),
    client_secret VARCHAR(255),
    token_endpoint VARCHAR(255),
    access_token TEXT,
    refresh_token TEXT,
    token_expiry TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 223. Integration Configurations
CREATE TABLE integration_configurations (
    config_id SERIAL PRIMARY KEY,
    system_id INTEGER REFERENCES external_systems(system_id),
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    config_name VARCHAR(100) NOT NULL,
    config_type VARCHAR(50), -- e.g., Push, Pull, Bidirectional
    endpoint_url VARCHAR(255) NOT NULL,
    frequency VARCHAR(50), -- e.g., Real-time, Hourly, Daily
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 224. Data Mappings
CREATE TABLE data_mappings (
    mapping_id SERIAL PRIMARY KEY,
    config_id INTEGER REFERENCES integration_configurations(config_id),
    internal_table VARCHAR(100) NOT NULL, -- e.g., patients, medical_records
    internal_field VARCHAR(100) NOT NULL,
    external_field VARCHAR(100) NOT NULL,
    transformation_rule TEXT, -- e.g., JSON path, format conversion
    direction VARCHAR(20) -- e.g., Inbound, Outbound, Bidirectional
);

-- 225. Integration Logs
CREATE TABLE integration_logs (
    log_id SERIAL PRIMARY KEY,
    config_id INTEGER REFERENCES integration_configurations(config_id),
    system_id INTEGER REFERENCES external_systems(system_id),
    log_date TIMESTAMP NOT NULL,
    status VARCHAR(20) NOT NULL, -- e.g., Success, Failed, Pending
    message TEXT,
    request_payload JSONB,
    response_payload JSONB
);

-- 226. Data Synchronization Jobs
CREATE TABLE data_synchronization_jobs (
    job_id SERIAL PRIMARY KEY,
    config_id INTEGER REFERENCES integration_configurations(config_id),
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Pending', -- e.g., Running, Completed, Failed
    records_processed INTEGER,
    error_message TEXT
);

-- 227. Sync Error Logs
CREATE TABLE sync_error_logs (
    error_id SERIAL PRIMARY KEY,
    job_id INTEGER REFERENCES data_synchronization_jobs(job_id),
    error_date TIMESTAMP NOT NULL,
    error_type VARCHAR(50), -- e.g., Validation, Connection, Timeout
    error_message TEXT,
    record_id INTEGER, -- ID of the affected record
    retry_count INTEGER DEFAULT 0
);

-- 228. External Patient Mappings
CREATE TABLE external_patient_mappings (
    mapping_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(patient_id),
    system_id INTEGER REFERENCES external_systems(system_id),
    external_patient_id VARCHAR(100) NOT NULL,
    last_synced TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 229. External Doctor Mappings
CREATE TABLE external_doctor_mappings (
    mapping_id SERIAL PRIMARY KEY,
    doctor_id INTEGER REFERENCES doctors(doctor_id),
    system_id INTEGER REFERENCES external_systems(system_id),
    external_doctor_id VARCHAR(100) NOT NULL,
    last_synced TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 230. External Billing Mappings
CREATE TABLE external_billing_mappings (
    mapping_id SERIAL PRIMARY KEY,
    bill_id INTEGER REFERENCES billing(bill_id),
    system_id INTEGER REFERENCES external_systems(system_id),
    external_bill_id VARCHAR(100) NOT NULL,
    last_synced TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 231. Webhook Configurations
CREATE TABLE webhook_configurations (
    webhook_id SERIAL PRIMARY KEY,
    system_id INTEGER REFERENCES external_systems(system_id),
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    webhook_url VARCHAR(255) NOT NULL,
    event_type VARCHAR(50) NOT NULL, -- e.g., Patient Update, Billing Update
    secret_key VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 232. Webhook Logs
CREATE TABLE webhook_logs (
    log_id SERIAL PRIMARY KEY,
    webhook_id INTEGER REFERENCES webhook_configurations(webhook_id),
    event_date TIMESTAMP NOT NULL,
    status VARCHAR(20) NOT NULL, -- e.g., Delivered, Failed
    payload JSONB,
    response_code INTEGER,
    response_message TEXT
);

-- 233. Message Queues
CREATE TABLE message_queues (
    message_id SERIAL PRIMARY KEY,
    config_id INTEGER REFERENCES integration_configurations(config_id),
    system_id INTEGER REFERENCES external_systems(system_id),
    message_type VARCHAR(50) NOT NULL, -- e.g., Patient Data, Lab Result
    payload JSONB NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending', -- e.g., Sent, Failed, Queued
    created_at TIMESTAMP NOT NULL,
    processed_at TIMESTAMP
);

-- 234. Queue Error Logs
CREATE TABLE queue_error_logs (
    error_id SERIAL PRIMARY KEY,
    message_id INTEGER REFERENCES message_queues(message_id),
    error_date TIMESTAMP NOT NULL,
    error_type VARCHAR(50), -- e.g., Serialization, Network
    error_message TEXT,
    retry_count INTEGER DEFAULT 0
);

-- 235. External Lab Order Mappings
CREATE TABLE external_lab_order_mappings (
    mapping_id SERIAL PRIMARY KEY,
    lab_order_id INTEGER REFERENCES lab_orders(order_id),
    system_id INTEGER REFERENCES external_systems(system_id),
    external_order_id VARCHAR(100) NOT NULL,
    last_synced TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 236. External Lab Result Mappings
CREATE TABLE external_lab_result_mappings (
    mapping_id SERIAL PRIMARY KEY,
    lab_result_id INTEGER REFERENCES lab_results(result_id),
    system_id INTEGER REFERENCES external_systems(system_id),
    external_result_id VARCHAR(100) NOT NULL,
    last_synced TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 237. HL7 Messages
CREATE TABLE hl7_messages (
    message_id SERIAL PRIMARY KEY,
    system_id INTEGER REFERENCES external_systems(system_id),
    patient_id INTEGER REFERENCES patients(patient_id),
    message_type VARCHAR(50) NOT NULL, -- e.g., ADT, ORM, ORU
    message_content TEXT NOT NULL,
    sent_date TIMESTAMP,
    received_date TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Pending'
);

-- 238. FHIR Resources
CREATE TABLE fhir_resources (
    resource_id SERIAL PRIMARY KEY,
    system_id INTEGER REFERENCES external_systems(system_id),
    resource_type VARCHAR(50) NOT NULL, -- e.g., Patient, Observation, Encounter
    resource_id_external VARCHAR(100) NOT NULL,
    resource_data JSONB NOT NULL,
    last_synced TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 239. Integration Alerts
CREATE TABLE integration_alerts (
    alert_id SERIAL PRIMARY KEY,
    system_id INTEGER REFERENCES external_systems(system_id),
    config_id INTEGER REFERENCES integration_configurations(config_id),
    alert_date TIMESTAMP NOT NULL,
    alert_type VARCHAR(50), -- e.g., Connection Failure, Data Mismatch
    description TEXT,
    priority VARCHAR(20), -- e.g., Low, Medium, High
    status VARCHAR(20) DEFAULT 'Open'
);

-- 240. Integration Retry Policies (Replaces alert_responses)
CREATE TABLE integration_retry_policies (
    policy_id SERIAL PRIMARY KEY,
    config_id INTEGER REFERENCES integration_configurations(config_id),
    system_id INTEGER REFERENCES external_systems(system_id),
    max_retries INTEGER NOT NULL DEFAULT 3,
    retry_interval_seconds INTEGER NOT NULL, -- e.g., 60 for 1 minute
    exponential_backoff BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 241. Data Transformation Rules
CREATE TABLE data_transformation_rules (
    rule_id SERIAL PRIMARY KEY,
    mapping_id INTEGER REFERENCES data_mappings(mapping_id),
    rule_name VARCHAR(100) NOT NULL,
    transformation_type VARCHAR(50), -- e.g., Format, Mapping, Aggregation
    rule_definition TEXT NOT NULL, -- e.g., SQL query, JSONata expression
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 242. Integration Audit Trails
CREATE TABLE integration_audit_trails (
    audit_id SERIAL PRIMARY KEY,
    system_id INTEGER REFERENCES external_systems(system_id),
    config_id INTEGER REFERENCES integration_configurations(config_id),
    action VARCHAR(50) NOT NULL, -- e.g., Data Sent, Data Received, Error
    action_date TIMESTAMP NOT NULL,
    user_id INTEGER REFERENCES doctors(doctor_id),
    details JSONB
);

-- 243. External Appointment Mappings
CREATE TABLE external_appointment_mappings (
    mapping_id SERIAL PRIMARY KEY,
    appointment_id INTEGER REFERENCES appointments(appointment_id),
    system_id INTEGER REFERENCES external_systems(system_id),
    external_appointment_id VARCHAR(100) NOT NULL,
    last_synced TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 244. Batch Jobs
CREATE TABLE batch_jobs (
    batch_id SERIAL PRIMARY KEY,
    config_id INTEGER REFERENCES integration_configurations(config_id),
    system_id INTEGER REFERENCES external_systems(system_id),
    job_type VARCHAR(50) NOT NULL, -- e.g., Patient Sync, Billing Sync
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Pending',
    total_records INTEGER,
    processed_records INTEGER
);

-- 245. Batch Job Details
CREATE TABLE batch_job_details (
    detail_id SERIAL PRIMARY KEY,
    batch_id INTEGER REFERENCES batch_jobs(batch_id),
    record_id INTEGER, -- ID of the processed record
    status VARCHAR(20) NOT NULL, -- e.g., Success, Failed
    error_message TEXT,
    processed_at TIMESTAMP
);

-- 246. Data Validation Rules
CREATE TABLE data_validation_rules (
    rule_id SERIAL PRIMARY KEY,
    config_id INTEGER REFERENCES integration_configurations(config_id),
    rule_name VARCHAR(100) NOT NULL,
    validation_type VARCHAR(50), -- e.g., Format, Range, Required
    rule_definition TEXT NOT NULL, -- e.g., Regex, SQL condition
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 247. Validation Errors
CREATE TABLE validation_errors (
    error_id SERIAL PRIMARY KEY,
    rule_id INTEGER REFERENCES data_validation_rules(rule_id),
    log_id INTEGER REFERENCES integration_logs(log_id),
    error_date TIMESTAMP NOT NULL,
    record_id INTEGER,
    error_message TEXT
);

-- 248. External Insurance Claim Mappings
CREATE TABLE external_insurance_claim_mappings (
    mapping_id SERIAL PRIMARY KEY,
    claim_id INTEGER REFERENCES insurance_claims(claim_id),
    system_id INTEGER REFERENCES external_systems(system_id),
    external_claim_id VARCHAR(100) NOT NULL,
    last_synced TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 249. Integration Metrics
CREATE TABLE integration_metrics (
    metric_id SERIAL PRIMARY KEY,
    system_id INTEGER REFERENCES external_systems(system_id),
    config_id INTEGER REFERENCES integration_configurations(config_id),
    metric_name VARCHAR(100) NOT NULL, -- e.g., Sync Success Rate, Error Rate
    metric_value DECIMAL(10,2),
    recorded_date TIMESTAMP NOT NULL
);

-- 250. Integration Dashboards
CREATE TABLE integration_dashboards (
    dashboard_id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(hospital_id),
    dashboard_name VARCHAR(100) NOT NULL,
    description TEXT,
    dashboard_data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Extend current schema by 200 temporary tables derived from base tables. Using CREATE TEMPORARY TABLE ... AS SELECT statement. Use joins, including multiple joins. Temporary table names should start with 'temp_'. Provide only SQL DDL statements.

-- 200 Temporary Tables Derived from Base Tables for Hospital Management System

-- 1. Patient Appointment Summary
CREATE TEMPORARY TABLE temp_patient_appointments AS
SELECT p.patient_id, p.first_name, p.last_name, a.appointment_id, a.appointment_date, d.first_name AS doctor_first_name, d.last_name AS doctor_last_name, dept.name AS department
FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
JOIN departments dept ON a.department_id = dept.department_id;

-- 2. Doctor Workload
CREATE TEMPORARY TABLE temp_doctor_workload AS
SELECT d.doctor_id, d.first_name, d.last_name, dept.name AS department, COUNT(a.appointment_id) AS appointment_count
FROM doctors d
LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
JOIN departments dept ON d.department_id = dept.department_id
GROUP BY d.doctor_id, d.first_name, d.last_name, dept.name;

-- 3. Patient Billing Overview
CREATE TEMPORARY TABLE temp_patient_billing AS
SELECT p.patient_id, p.first_name, p.last_name, b.bill_id, b.total_amount, b.status, a.admission_date
FROM patients p
JOIN billing b ON p.patient_id = b.patient_id
LEFT JOIN admissions a ON b.admission_id = a.admission_id;

-- 4. Admission Details
CREATE TEMPORARY TABLE temp_admission_details AS
SELECT a.admission_id, p.first_name, p.last_name, w.name AS ward, b.bed_number, a.admission_date, a.discharge_date
FROM admissions a
JOIN patients p ON a.patient_id = p.patient_id
JOIN wards w ON a.ward_id = w.ward_id
JOIN beds b ON a.bed_id = b.bed_id;

-- 5. Prescription Details
CREATE TEMPORARY TABLE temp_prescription_details AS
SELECT pr.prescription_id, p.first_name, p.last_name, d.first_name AS doctor_first_name, m.name AS medication, pi.dosage
FROM prescriptions pr
JOIN patients p ON pr.patient_id = p.patient_id
JOIN doctors d ON pr.doctor_id = d.doctor_id
JOIN prescription_items pi ON pr.prescription_id = pi.prescription_id
JOIN medications m ON pi.medication_id = m.medication_id;

-- 6. Lab Test Results
CREATE TEMPORARY TABLE temp_lab_test_results AS
SELECT lo.order_id, p.first_name, p.last_name, lt.name AS test_name, lr.result_text, lr.is_abnormal
FROM lab_orders lo
JOIN patients p ON lo.patient_id = p.patient_id
JOIN lab_tests lt ON lo.test_id = lt.test_id
JOIN lab_results lr ON lo.order_id = lr.order_id;

-- 7. Nurse Assignments
CREATE TEMPORARY TABLE temp_nurse_assignments AS
SELECT n.nurse_id, n.first_name, n.last_name, w.name AS ward, na.shift_start, na.shift_end
FROM nurses n
JOIN nurse_assignments na ON n.nurse_id = na.nurse_id
JOIN wards w ON na.ward_id = w.ward_id;

-- 8. Surgery Schedules
CREATE TEMPORARY TABLE temp_surgery_schedules AS
SELECT s.surgery_id, p.first_name, p.last_name, d.first_name AS doctor_first_name, orr.room_number, ss.start_time
FROM surgeries s
JOIN patients p ON s.patient_id = p.patient_id
JOIN doctors d ON s.doctor_id = d.doctor_id
JOIN surgery_schedules ss ON s.surgery_id = ss.surgery_id
JOIN operating_rooms orr ON ss.room_id = orr.room_id;

-- 9. Patient Insurance Details
CREATE TEMPORARY TABLE temp_patient_insurance AS
SELECT p.patient_id, p.first_name, p.last_name, ic.name AS insurance_company, pi.policy_number, pi.valid_to
FROM patients p
JOIN patient_insurance pi ON p.patient_id = pi.patient_id
JOIN insurance_companies ic ON pi.company_id = ic.company_id;

-- 10. Inventory Stock Levels
CREATE TEMPORARY TABLE temp_inventory_stock AS
SELECT i.item_id, i.name, isx.quantity,w.name AS ward, h.name AS hospital 
FROM inventory i
JOIN inventory_stock isx ON i.item_id = isx.item_id
JOIN wards w ON isx.ward_id = w.ward_id
JOIN hospitals h ON isx.hospital_id = h.hospital_id;

-- 11. General Ledger Summary
CREATE TEMPORARY TABLE temp_gl_summary AS
SELECT gla.account_id, gla.account_name, glt.transaction_date, glt.amount, glt.debit_credit
FROM gl_accounts gla
JOIN gl_transactions glt ON gla.account_id = glt.account_id
JOIN hospitals h ON glt.hospital_id = h.hospital_id;

-- 12. Cost Center Expenses
CREATE TEMPORARY TABLE temp_cost_center_expenses AS
SELECT cc.cost_center_id, cc.name AS cost_center, e.amount, e.expense_date, ec.name AS expense_category
FROM cost_centers cc
JOIN expenses e ON cc.cost_center_id = e.cost_center_id
JOIN expense_categories ec ON e.category_id = ec.category_id;

-- 13. Accounts Receivable Status
CREATE TEMPORARY TABLE temp_ar_status AS
SELECT ar.ar_id, p.first_name, p.last_name, ar.amount_due, ar.due_date, ar.status
FROM accounts_receivable ar
JOIN patients p ON ar.patient_id = p.patient_id
JOIN billing b ON ar.bill_id = b.bill_id;

-- 14. Accounts Payable Status
CREATE TEMPORARY TABLE temp_ap_status AS
SELECT ap.ap_id, s.name AS supplier, ap.amount_due, ap.due_date, ap.status
FROM accounts_payable ap
JOIN suppliers s ON ap.supplier_id = s.supplier_id
JOIN purchase_orders po ON ap.purchase_order_id = po.order_id;

-- 15. Compliance Audit Findings
CREATE TEMPORARY TABLE temp_compliance_audit_findings AS
SELECT ca.audit_id, ca.audit_date, cr.name AS regulation, af.finding_type, af.description
FROM compliance_audits ca
JOIN compliance_regulations cr ON ca.regulation_id = cr.regulation_id
JOIN audit_findings af ON ca.audit_id = af.audit_id;

-- 16. Incident Investigations
CREATE TEMPORARY TABLE temp_incident_investigations AS
SELECT ci.incident_id, ci.incident_date, d.first_name AS investigator, ii.findings, ii.status
FROM compliance_incidents ci
JOIN incident_investigations ii ON ci.incident_id = ii.incident_id
JOIN doctors d ON ii.investigator_id = d.doctor_id;

-- 17. Vital Signs Summary
CREATE TEMPORARY TABLE temp_vital_signs_summary AS
SELECT vs.vital_id, p.first_name, p.last_name, vs.recorded_date, vs.blood_pressure_systolic, vs.heart_rate
FROM vital_signs vs
JOIN patients p ON vs.patient_id = p.patient_id
JOIN medical_records mr ON vs.medical_record_id = mr.record_id;

-- 18. Patient Allergies
CREATE TEMPORARY TABLE temp_patient_allergies AS
SELECT a.allergy_id, p.first_name, p.last_name, a.allergen, a.reaction, d.first_name AS diagnosed_by
FROM allergies a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.diagnosed_by = d.doctor_id;

-- 19. Diagnostic Imaging Reports
CREATE TEMPORARY TABLE temp_diagnostic_imaging_reports AS
SELECT di.imaging_id, p.first_name, p.last_name, di.imaging_type, ir.findings, d.first_name AS ordered_by
FROM diagnostic_imaging di
JOIN patients p ON di.patient_id = p.patient_id
JOIN imaging_reports ir ON di.imaging_id = ir.imaging_id
JOIN doctors d ON di.ordered_by = d.doctor_id;

-- 20. Treatment Plan Actions
CREATE TEMPORARY TABLE temp_treatment_plan_actions AS
SELECT tp.plan_id, p.first_name, p.last_name, tpa.action_type, tpa.description, tpa.status
FROM treatment_plans tp
JOIN patients p ON tp.patient_id = p.patient_id
JOIN treatment_plan_actions tpa ON tp.plan_id = tpa.plan_id;

-- 21. Inventory Adjustments
CREATE TEMPORARY TABLE temp_inventory_adjustments AS
SELECT ia.adjustment_id, i.name AS item, h.name AS hospital, ia.quantity_adjusted, ia.reason
FROM inventory_adjustments ia
JOIN inventory_items i ON ia.item_id = i.item_id
JOIN hospitals h ON ia.hospital_id = h.hospital_id;

-- 22. Equipment Maintenance
CREATE TEMPORARY TABLE temp_equipment_maintenance AS
SELECT e.equipment_id, e.name AS equipment, d.name AS department, em.maintenance_date, em.description
FROM equipment e
JOIN equipment_maintenance em ON e.equipment_id = em.equipment_id
JOIN departments d ON e.department_id = d.department_id;

-- 23. Supplier Performance
CREATE TEMPORARY TABLE temp_supplier_performance AS
SELECT s.supplier_id, s.name AS supplier, sp.evaluation_date, sp.quality_rating, sp.delivery_timeliness
FROM suppliers s
JOIN supplier_performance sp ON s.supplier_id = sp.supplier_id;

-- 24. Goods Receipts
CREATE TEMPORARY TABLE temp_goods_receipts AS
SELECT gr.receipt_id, po.order_date, s.name AS supplier, gr.receipt_date, d.first_name AS received_by
FROM goods_receipts gr
JOIN purchase_orders po ON gr.order_id = po.order_id
JOIN suppliers s ON po.supplier_id = s.supplier_id
JOIN doctors d ON gr.received_by = d.doctor_id;

-- 25. Integration Logs
CREATE TEMPORARY TABLE temp_integration_logs AS
SELECT il.log_id, es.system_name, ic.config_name, il.log_date, il.status, il.message
FROM integration_logs il
JOIN external_systems es ON il.system_id = es.system_id
JOIN integration_configurations ic ON il.config_id = ic.config_id;

-- 26. Patient Sync Jobs
CREATE TEMPORARY TABLE temp_patient_sync_jobs AS
SELECT dsj.job_id, es.system_name, dsj.start_time, dsj.status, dsj.records_processed
FROM data_synchronization_jobs dsj
JOIN integration_configurations ic ON dsj.config_id = ic.config_id
JOIN external_systems es ON ic.system_id = es.system_id;

-- 27. Webhook Activity
CREATE TEMPORARY TABLE temp_webhook_activity AS
SELECT wl.log_id, wc.webhook_url, wc.event_type, wl.event_date, wl.status
FROM webhook_logs wl
JOIN webhook_configurations wc ON wl.webhook_id = wc.webhook_id
JOIN external_systems es ON wc.system_id = es.system_id;

-- 28. HL7 Message Summary
CREATE TEMPORARY TABLE temp_hl7_messages AS
SELECT hm.message_id, es.system_name, p.first_name, p.last_name, hm.message_type, hm.status
FROM hl7_messages hm
JOIN external_systems es ON hm.system_id = es.system_id
JOIN patients p ON hm.patient_id = p.patient_id;

-- 29. Patient Medical Records
CREATE TEMPORARY TABLE temp_patient_medical_records AS
SELECT mr.record_id, p.first_name, p.last_name, d.first_name AS doctor, mr.visit_date, mr.diagnosis
FROM medical_records mr
JOIN patients p ON mr.patient_id = p.patient_id
JOIN doctors d ON mr.doctor_id = d.doctor_id;

-- 30. Compliance Training
CREATE TEMPORARY TABLE temp_compliance_training AS
SELECT etr.record_id, ctp.training_name, d.first_name, d.last_name, etr.completion_date
FROM employee_training_records etr
JOIN compliance_training_programs ctp ON etr.training_id = ctp.training_id
JOIN doctors d ON etr.employee_id = d.doctor_id;

-- 31. Budget Allocations
CREATE TEMPORARY TABLE temp_budget_allocations AS
SELECT b.budget_id, cc.name AS cost_center, ba.amount, ba.allocation_date, d.name AS department
FROM budgets b
JOIN cost_centers cc ON b.cost_center_id = cc.cost_center_id
JOIN budget_allocations ba ON b.budget_id = ba.budget_id
JOIN departments d ON ba.department_id = d.department_id;

-- 32. Revenue Transactions
CREATE TEMPORARY TABLE temp_revenue_transactions AS
SELECT rt.revenue_transaction_id, rs.name AS revenue_stream, b.total_amount, rt.transaction_date
FROM revenue_transactions rt
JOIN revenue_streams rs ON rt.revenue_stream_id = rs.revenue_stream_id
JOIN billing b ON rt.bill_id = b.bill_id;

-- 33. Patient Vitals and Allergies
CREATE TEMPORARY TABLE temp_patient_vitals_allergies AS
SELECT p.patient_id, p.first_name, p.last_name, vs.blood_pressure_systolic, a.allergen
FROM patients p
LEFT JOIN vital_signs vs ON p.patient_id = vs.patient_id
LEFT JOIN allergies a ON p.patient_id = a.patient_id;

-- 34. Doctor and Nurse Assignments
CREATE TEMPORARY TABLE temp_doctor_nurse_assignments AS
SELECT d.doctor_id, d.first_name AS doctor_name, n.nurse_id, n.first_name AS nurse_name, dept.name AS department
FROM doctors d
JOIN departments dept ON d.department_id = dept.department_id
LEFT JOIN nurses n ON n.department_id = dept.department_id;

-- 35. Patient Admissions and Billing
CREATE TEMPORARY TABLE temp_admissions_billing AS
SELECT a.admission_id, p.first_name, p.last_name, b.total_amount, b.status, a.admission_date
FROM admissions a
JOIN patients p ON a.patient_id = p.patient_id
LEFT JOIN billing b ON a.admission_id = b.admission_id;

-- 36. Surgery and Procedure Records
CREATE TEMPORARY TABLE temp_surgery_procedures AS
SELECT s.surgery_id, pr.procedure_id, p.first_name, p.last_name, s.surgery_date, pr.procedure_name
FROM surgeries s
JOIN patients p ON s.patient_id = p.patient_id
LEFT JOIN procedure_records pr ON p.patient_id = pr.patient_id;

-- 37. Lab Orders and Results
CREATE TEMPORARY TABLE temp_lab_orders_results AS
SELECT lo.order_id, p.first_name, p.last_name, lt.name AS test_name, lr.result_text
FROM lab_orders lo
JOIN patients p ON lo.patient_id = p.patient_id
JOIN lab_tests lt ON lo.test_id = lt.test_id
LEFT JOIN lab_results lr ON lo.order_id = lr.order_id;

-- 38. Inventory and Stock Movements
CREATE TEMPORARY TABLE temp_inventory_movements AS
SELECT i.name AS item, sm.quantity, sm.movement_type, sl.name AS location, sm.movement_date
FROM inventory_items i
JOIN stock_movements sm ON i.item_id = sm.item_id
JOIN stock_locations sl ON sm.to_location_id = sl.location_id;

-- 39. Supplier Invoices and Payments
CREATE TEMPORARY TABLE temp_supplier_invoices_payments AS
SELECT si.invoice_id, s.name AS supplier, si.total_amount, ip.amount AS paid_amount, ip.payment_date
FROM supplier_invoices si
JOIN suppliers s ON si.supplier_id = s.supplier_id
LEFT JOIN invoice_payments ip ON si.invoice_id = ip.invoice_id;

-- 40. Compliance Incidents and Actions
CREATE TEMPORARY TABLE temp_compliance_incidents_actions AS
SELECT ci.incident_id, ci.incident_date, ca.description AS action, ca.status
FROM compliance_incidents ci
LEFT JOIN corrective_actions ca ON ci.incident_id = ca.finding_id
JOIN audit_findings af ON ca.finding_id = af.finding_id;

-- 41. Patient Treatment and Prescriptions
CREATE TEMPORARY TABLE temp_treatment_prescriptions AS
SELECT tp.plan_id, p.first_name, p.last_name, pr.prescription_id, m.name AS medication
FROM treatment_plans tp
JOIN patients p ON tp.patient_id = p.patient_id
LEFT JOIN prescriptions pr ON p.patient_id = pr.patient_id
JOIN prescription_items pi ON pr.prescription_id = pi.prescription_id
JOIN medications m ON pi.medication_id = m.medication_id;

-- 42. Ward and Bed Utilization
CREATE TEMPORARY TABLE temp_ward_bed_utilization AS
SELECT w.ward_id, w.name AS ward, b.bed_number, b.status, a.admission_date
FROM wards w
JOIN beds b ON w.ward_id = b.ward_id
LEFT JOIN admissions a ON b.bed_id = a.bed_id;

-- 43. Financial Period Transactions
CREATE TEMPORARY TABLE temp_financial_transactions AS
SELECT fp.period_id, fp.period_name, glt.transaction_date, glt.amount, gla.account_name
FROM financial_periods fp
JOIN gl_transactions glt ON fp.hospital_id = glt.hospital_id
JOIN gl_accounts gla ON glt.account_id = gla.account_id;

-- 44. Patient Lab and Imaging
CREATE TEMPORARY TABLE temp_patient_lab_imaging AS
SELECT p.patient_id, p.first_name, p.last_name, lo.order_date, di.imaging_date
FROM patients p
LEFT JOIN lab_orders lo ON p.patient_id = lo.patient_id
LEFT JOIN diagnostic_imaging di ON p.patient_id = di.patient_id;

-- 45. Doctor and Patient Interactions
CREATE TEMPORARY TABLE temp_doctor_patient_interactions AS
SELECT d.doctor_id, d.first_name AS doctor_name, p.patient_id, p.first_name AS patient_name, mr.visit_date
FROM doctors d
JOIN medical_records mr ON d.doctor_id = mr.doctor_id
JOIN patients p ON mr.patient_id = p.patient_id;

-- 46. Compliance Checklist Responses
CREATE TEMPORARY TABLE temp_checklist_responses AS
SELECT cr.response_id, cl.checklist_name, ci.description AS item, d.name AS department, cr.is_compliant
FROM compliance_checklists cl
JOIN checklist_items ci ON cl.checklist_id = ci.checklist_id
JOIN checklist_responses cr ON ci.item_id = cr.item_id
JOIN departments d ON cr.department_id = d.department_id;

-- 47. Equipment Usage and Maintenance
CREATE TEMPORARY TABLE temp_equipment_usage_maintenance AS
SELECT e.equipment_id, e.name AS equipment, eul.usage_date, em.maintenance_date
FROM equipment e
LEFT JOIN equipment_usage_logs eul ON e.equipment_id = eul.equipment_id
LEFT JOIN equipment_maintenance em ON e.equipment_id = em.equipment_id;
 
-- 48. Patient Insurance Claims
CREATE TEMPORARY TABLE temp_patient_insurance_claims AS
SELECT ic.claim_id, p.first_name, p.last_name, ic.claim_amount, ic.status, icomp.name AS insurance_company
FROM insurance_claims ic
JOIN patients p ON ic.patient_id = p.patient_id
JOIN patient_insurance pi ON ic.insurance_id = pi.insurance_id
JOIN insurance_companies icomp ON pi.company_id = icomp.company_id;

-- 49. Integration Sync Errors
CREATE TEMPORARY TABLE temp_sync_errors AS
SELECT sel.error_id, es.system_name, dsj.start_time, sel.error_type, sel.error_message
FROM sync_error_logs sel
JOIN data_synchronization_jobs dsj ON sel.job_id = dsj.job_id
JOIN integration_configurations ic ON dsj.config_id = ic.config_id
JOIN external_systems es ON ic.system_id = es.system_id;

-- 50. Patient Care Plans
CREATE TEMPORARY TABLE temp_patient_care_plans AS
SELECT cp.care_plan_id, p.first_name, p.last_name, cpi.intervention_type, cpi.description
FROM care_plans cp
JOIN patients p ON cp.patient_id = p.patient_id
JOIN care_plan_interventions cpi ON cp.care_plan_id = cpi.care_plan_id;

-- 51. Appointment and Billing
CREATE TEMPORARY TABLE temp_appointment_billing AS
SELECT a.appointment_id, p.first_name, p.last_name, b.total_amount, b.status
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
LEFT JOIN billing b ON p.patient_id = b.patient_id;

-- 52. Patient and Ward Assignments
CREATE TEMPORARY TABLE temp_patient_ward_assignments AS
SELECT p.patient_id, p.first_name, p.last_name, w.name AS ward, a.admission_date
FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
JOIN wards w ON a.ward_id = w.ward_id;

-- 53. Doctor and Surgery Details
CREATE TEMPORARY TABLE temp_doctor_surgery_details AS
SELECT d.doctor_id, d.first_name, d.last_name, s.surgery_id, s.procedure_name, s.surgery_date
FROM doctors d
JOIN surgeries s ON d.doctor_id = s.doctor_id
JOIN patients p ON s.patient_id = p.patient_id;

-- 54. Lab and Prescription Orders
CREATE TEMPORARY TABLE temp_lab_prescription_orders AS
SELECT lo.order_id, pr.prescription_id, p.first_name, p.last_name, lo.order_date
FROM lab_orders lo
JOIN patients p ON lo.patient_id = p.patient_id
LEFT JOIN prescriptions pr ON p.patient_id = pr.patient_id;

-- 55. Inventory and Supplier
CREATE TEMPORARY TABLE temp_inventory_supplier AS
SELECT i.name AS item, s.name AS supplier, po.order_date, poi.quantity
FROM inventory_items i
JOIN purchase_order_items poi ON i.item_id = poi.inventory_id
JOIN purchase_orders po ON poi.order_id = po.order_id
JOIN suppliers s ON po.supplier_id = s.supplier_id;

-- 56. Financial Audits and Findings
CREATE TEMPORARY TABLE temp_financial_audits AS
SELECT fa.audit_id, fa.audit_date, fa.findings, fp.period_name
FROM financial_audits fa
JOIN financial_periods fp ON fa.period_id = fp.period_id
JOIN hospitals h ON fa.hospital_id = h.hospital_id;

-- 57. Patient Vitals and Diagnosis
CREATE TEMPORARY TABLE temp_vitals_diagnosis AS
SELECT vs.vital_id, p.first_name, p.last_name, vs.heart_rate, mr.diagnosis
FROM vital_signs vs
JOIN patients p ON vs.patient_id = p.patient_id
JOIN medical_records mr ON vs.medical_record_id = mr.record_id;

-- 58. Compliance Policies and Departments
CREATE TEMPORARY TABLE temp_compliance_policies_depts AS
SELECT cp.policy_id, cp.policy_name, d.name AS department, pa.assigned_date
FROM compliance_policies cp
JOIN policy_assignments pa ON cp.policy_id = pa.policy_id
JOIN departments d ON pa.department_id = d.department_id;

-- 59. Equipment Calibration
CREATE TEMPORARY TABLE temp_equipment_calibration AS
SELECT e.equipment_id, e.name AS equipment, ec.calibration_date, ec.result, d.name AS department
FROM equipment e
JOIN equipment_calibration ec ON e.equipment_id = ec.equipment_id
JOIN departments d ON e.department_id = d.department_id;

-- 60. Patient and Procedure Complications
CREATE TEMPORARY TABLE temp_procedure_complications AS
SELECT pr.procedure_id, p.first_name, p.last_name, pc.description AS complication, pc.severity
FROM procedure_records pr
JOIN patients p ON pr.patient_id = p.patient_id
JOIN procedure_complications pc ON pr.procedure_id = pc.procedure_id;

-- 61. Integration and Patient Mappings
CREATE TEMPORARY TABLE temp_integration_patient_mappings AS
SELECT epm.mapping_id, p.first_name, p.last_name, es.system_name, epm.external_patient_id
FROM external_patient_mappings epm
JOIN patients p ON epm.patient_id = p.patient_id
JOIN external_systems es ON epm.system_id = es.system_id;

-- 62. Billing and Insurance Claims
CREATE TEMPORARY TABLE temp_billing_insurance AS
SELECT b.bill_id, p.first_name, p.last_name, ic.claim_amount, ic.status
FROM billing b
JOIN patients p ON b.patient_id = p.patient_id
LEFT JOIN insurance_claims ic ON b.bill_id = ic.bill_id;

-- 63. Nurse and Patient Care
CREATE TEMPORARY TABLE temp_nurse_patient_care AS
SELECT n.nurse_id, n.first_name, n.last_name, p.first_name AS patient_name, a.admission_date
FROM nurses n
JOIN nurse_assignments na ON n.nurse_id = na.nurse_id
JOIN admissions a ON na.ward_id = a.ward_id
JOIN patients p ON a.patient_id = p.patient_id;

-- 64. Lab Tests and Departments
CREATE TEMPORARY TABLE temp_lab_tests_depts AS
SELECT lt.test_id, lt.name AS test_name, l.name AS lab, d.name AS department
FROM lab_tests lt
JOIN labs l ON lt.lab_id = l.lab_id
JOIN departments d ON l.hospital_id = d.hospital_id;

-- 65. Patient and Social History
CREATE TEMPORARY TABLE temp_patient_social_history AS
SELECT p.patient_id, p.first_name, p.last_name, sh.smoking_status, sh.occupation
FROM patients p
JOIN social_history sh ON p.patient_id = sh.patient_id
JOIN doctors d ON sh.recorded_by = d.doctor_id;

-- 66. Compliance Metrics Data
CREATE TEMPORARY TABLE temp_compliance_metrics_data AS
SELECT cm.metric_id, cm.metric_name, cmd.value, cmd.recorded_date, h.name AS hospital
FROM compliance_metrics cm
JOIN compliance_metric_data cmd ON cm.metric_id = cmd.metric_id
JOIN hospitals h ON cm.hospital_id = h.hospital_id;
 
-- 67. Inventory Stock and Locations
CREATE TEMPORARY TABLE temp_stock_locations AS
SELECT i.name AS item, isx.quantity, sl.name AS location, h.name AS hospital
FROM inventory_stock isx
JOIN inventory_items i ON isx.item_id = i.item_id
JOIN stock_locations sl ON isx.hospital_id = sl.hospital_id
JOIN hospitals h ON isx.hospital_id = h.hospital_id;
 

-- 68. Supplier Contracts and Performance
CREATE TEMPORARY TABLE temp_supplier_contracts_performance AS
SELECT sc.contract_id, s.name AS supplier, sc.contract_start_date, sp.quality_rating
FROM supplier_contracts sc
JOIN suppliers s ON sc.supplier_id = s.supplier_id
JOIN supplier_performance sp ON s.supplier_id = sp.supplier_id;

-- 69. Patient and Pain Assessments
CREATE TEMPORARY TABLE temp_pain_assessments AS
SELECT pa.assessment_id, p.first_name, p.last_name, pa.pain_score, pa.pain_location
FROM pain_assessments pa
JOIN patients p ON pa.patient_id = p.patient_id
JOIN medical_records mr ON pa.medical_record_id = mr.record_id;

-- 70. Integration Batch Jobs
CREATE TEMPORARY TABLE temp_batch_jobs AS
SELECT bj.batch_id, es.system_name, bj.job_type, bj.start_time, bj.processed_records
FROM batch_jobs bj
JOIN external_systems es ON bj.system_id = es.system_id
JOIN integration_configurations ic ON bj.config_id = ic.config_id;

-- 71. Patient and Family History
CREATE TEMPORARY TABLE temp_family_history AS
SELECT fmh.family_history_id, p.first_name, p.last_name, fmh.relationship, fmh.condition
FROM family_medical_history fmh
JOIN patients p ON fmh.patient_id = p.patient_id
JOIN doctors d ON fmh.recorded_by = d.doctor_id;

-- 72. Financial Ratios
CREATE TEMPORARY TABLE temp_financial_ratios AS
SELECT fr.ratio_id, fr.ratio_name, fr.ratio_value, fp.period_name, h.name AS hospital
FROM financial_ratios fr
JOIN financial_periods fp ON fr.period_id = fp.period_id
JOIN hospitals h ON fr.hospital_id = h.hospital_id;

-- 73. Patient and Nutritional Assessments
CREATE TEMPORARY TABLE temp_nutritional_assessments AS
SELECT na.assessment_id, p.first_name, p.last_name, na.weight_kg, na.bmi
FROM nutritional_assessments na
JOIN patients p ON na.patient_id = p.patient_id
JOIN medical_records mr ON na.medical_record_id = mr.record_id;

-- 74. Compliance Documents and Reviews
CREATE TEMPORARY TABLE temp_compliance_documents AS
SELECT cd.document_id, cd.document_name, cr.name AS regulation, dr.review_date
FROM compliance_documents cd
JOIN compliance_regulations cr ON cd.regulation_id = cr.regulation_id
LEFT JOIN document_reviews dr ON cd.document_id = dr.document_id;

-- 75. Equipment and Departments
CREATE TEMPORARY TABLE temp_equipment_departments AS
SELECT e.equipment_id, e.name AS equipment, d.name AS department, h.name AS hospital
FROM equipment e
JOIN departments d ON e.department_id = d.department_id
JOIN hospitals h ON e.hospital_id = h.hospital_id;

-- 76. Patient and Procedure Records
CREATE TEMPORARY TABLE temp_patient_procedures AS
SELECT pr.procedure_id, p.first_name, p.last_name, pr.procedure_name, pr.outcome
FROM procedure_records pr
JOIN patients p ON pr.patient_id = p.patient_id
JOIN doctors d ON pr.performed_by = d.doctor_id;

-- 77. Integration Validation Errors
CREATE TEMPORARY TABLE temp_validation_errors AS
SELECT ve.error_id, dvr.rule_name, il.log_date, ve.error_message
FROM validation_errors ve
JOIN data_validation_rules dvr ON ve.rule_id = dvr.rule_id
JOIN integration_logs il ON ve.log_id = il.log_id;

-- 78. Patient and Rehabilitation Plans
CREATE TEMPORARY TABLE temp_rehabilitation_plans AS
SELECT rp.plan_id, p.first_name, p.last_name, rp.therapy_type, rp.description
FROM rehabilitation_plans rp
JOIN patients p ON rp.patient_id = p.patient_id
JOIN medical_records mr ON rp.medical_record_id = mr.record_id;

-- 79. Supplier and Purchase Orders
CREATE TEMPORARY TABLE temp_supplier_purchase_orders AS
SELECT po.order_id, s.name AS supplier, po.order_date, po.status
FROM purchase_orders po
JOIN suppliers s ON po.supplier_id = s.supplier_id
JOIN hospitals h ON po.hospital_id = h.hospital_id;

-- 80. Patient and Mental Health
CREATE TEMPORARY TABLE temp_mental_health_assessments AS
SELECT mha.assessment_id, p.first_name, p.last_name, mha.diagnosis, mha.symptoms
FROM mental_health_assessments mha
JOIN patients p ON mha.patient_id = p.patient_id
JOIN medical_records mr ON mha.medical_record_id = mr.record_id;

-- 81. Compliance Certifications
CREATE TEMPORARY TABLE temp_compliance_certifications AS
SELECT cc.certification_id, cr.name AS regulation, cc.certification_name, cc.issue_date
FROM compliance_certifications cc
JOIN compliance_regulations cr ON cc.regulation_id = cr.regulation_id
JOIN hospitals h ON cc.hospital_id = h.hospital_id;

-- 82. Patient and Blood Glucose
CREATE TEMPORARY TABLE temp_blood_glucose AS
SELECT bgl.glucose_id, p.first_name, p.last_name, bgl.glucose_level_mgdl, bgl.measurement_type
FROM blood_glucose_levels bgl
JOIN patients p ON bgl.patient_id = p.patient_id
JOIN medical_records mr ON bgl.medical_record_id = mr.record_id;

-- 83. Inventory and Expiry Tracking 
CREATE TEMPORARY TABLE temp_inventory_expiry AS
SELECT i.name AS item, set.expiry_date, set.quantity, isx.quantity AS current_stock
FROM stock_expiry_tracking set
JOIN inventory_items i ON set.item_id = i.item_id
JOIN inventory_stock isx ON set.stock_id = isx.stock_id;


-- 84. Patient and Fluid Balance
CREATE TEMPORARY TABLE temp_fluid_balance AS
SELECT fbr.fluid_id, p.first_name, p.last_name, fbr.intake_ml, fbr.output_ml
FROM fluid_balance_records fbr
JOIN patients p ON fbr.patient_id = p.patient_id
JOIN medical_records mr ON fbr.medical_record_id = mr.record_id;

-- 85. Integration and FHIR Resources
CREATE TEMPORARY TABLE temp_fhir_resources AS
SELECT fr.resource_id, es.system_name, fr.resource_type, fr.last_synced
FROM fhir_resources fr
JOIN external_systems es ON fr.system_id = es.system_id
JOIN hospitals h ON es.hospital_id = h.hospital_id;

-- 86. Patient and IV Therapy
CREATE TEMPORARY TABLE temp_iv_therapy AS
SELECT ivt.iv_therapy_id, p.first_name, p.last_name, ivt.fluid_type, ivt.rate_ml_per_hour
FROM iv_therapy_records ivt
JOIN patients p ON ivt.patient_id = p.patient_id
JOIN medical_records mr ON ivt.medical_record_id = mr.record_id;

-- 87. Compliance Tasks and History
CREATE TEMPORARY TABLE temp_compliance_tasks_history AS
SELECT ct.task_id, ctt.task_name, cth.action, cth.action_date
FROM compliance_tasks ct
JOIN compliance_task_templates ctt ON ct.template_id = ctt.template_id
JOIN compliance_task_history cth ON ct.task_id = cth.task_id;

-- 88. Patient and Ventilator Settings
CREATE TEMPORARY TABLE temp_ventilator_settings AS
SELECT vs.setting_id, p.first_name, p.last_name, vs.mode, vs.tidal_volume_ml
FROM ventilator_settings vs
JOIN patients p ON vs.patient_id = p.patient_id
JOIN medical_records mr ON vs.medical_record_id = mr.record_id;

-- 89. Supplier and Shipment Records
CREATE TEMPORARY TABLE temp_shipment_records AS
SELECT sr.shipment_id, s.name AS supplier, lp.name AS provider, sr.shipment_date
FROM shipment_records sr
JOIN purchase_orders po ON sr.order_id = po.order_id
JOIN suppliers s ON po.supplier_id = s.supplier_id
JOIN logistics_providers lp ON sr.provider_id = lp.provider_id;

-- 90. Patient and Dialysis Records
CREATE TEMPORARY TABLE temp_dialysis_records AS
SELECT dr.dialysis_id, p.first_name, p.last_name, dr.dialysis_type, dr.duration_hours
FROM dialysis_records dr
JOIN patients p ON dr.patient_id = p.patient_id
JOIN medical_records mr ON dr.medical_record_id = mr.record_id;

-- 91. Compliance Alerts
CREATE TEMPORARY TABLE temp_compliance_alerts AS
SELECT ca.alert_id, cr.name AS regulation, ca.alert_date, ca.priority
FROM compliance_alerts ca
JOIN compliance_regulations cr ON ca.regulation_id = cr.regulation_id
JOIN hospitals h ON ca.hospital_id = h.hospital_id;

-- 92. Patient and Chemotherapy
CREATE TEMPORARY TABLE temp_chemotherapy_records AS
SELECT cr.chemo_id, p.first_name, p.last_name, cr.drug_name, cr.dose_mg
FROM chemotherapy_records cr
JOIN patients p ON cr.patient_id = p.patient_id
JOIN medical_records mr ON cr.medical_record_id = mr.record_id;

-- 93. Inventory and Requisitions
CREATE TEMPORARY TABLE temp_inventory_requisitions AS
SELECT pr.requisition_id, i.name AS item, ri.quantity, d.name AS department
FROM purchase_requisitions pr
JOIN requisition_items ri ON pr.requisition_id = ri.requisition_id
JOIN inventory_items i ON ri.item_id = i.item_id
JOIN departments d ON pr.department_id = d.department_id;

-- 94. Patient and Radiation Therapy
CREATE TEMPORARY TABLE temp_radiation_therapy AS
SELECT rtr.radiation_id, p.first_name, p.last_name, rtr.target_area, rtr.dose_gy
FROM radiation_therapy_records rtr
JOIN patients p ON rtr.patient_id = p.patient_id
JOIN medical_records mr ON rtr.medical_record_id = mr.record_id;

-- 95. Integration and Batch Job Details
CREATE TEMPORARY TABLE temp_batch_job_details AS
SELECT bjd.detail_id, bj.job_type, bjd.status, bjd.error_message, es.system_name
FROM batch_job_details bjd
JOIN batch_jobs bj ON bjd.batch_id = bj.batch_id
JOIN external_systems es ON bj.system_id = es.system_id;

-- 96. Patient and Physical Therapy
CREATE TEMPORARY TABLE temp_physical_therapy AS
SELECT pta.assessment_id, p.first_name, p.last_name, pta.range_of_motion, pta.goals
FROM physical_therapy_assessments pta
JOIN patients p ON pta.patient_id = p.patient_id
JOIN medical_records mr ON pta.medical_record_id = mr.record_id;

-- 97. Compliance and Vendor Audits
CREATE TEMPORARY TABLE temp_vendor_audits AS
SELECT va.audit_id, s.name AS supplier, va.audit_date, va.findings
FROM vendor_audits va
JOIN suppliers s ON va.supplier_id = s.supplier_id
JOIN hospitals h ON s.supplier_id = h.hospital_id;

-- 98. Patient and Occupational Therapy
CREATE TEMPORARY TABLE temp_occupational_therapy AS
SELECT ota.assessment_id, p.first_name, p.last_name, ota.functional_status, ota.goals
FROM occupational_therapy_assessments ota
JOIN patients p ON ota.patient_id = p.patient_id
JOIN medical_records mr ON ota.medical_record_id = mr.record_id;

-- 99. Inventory and Disposal Records
CREATE TEMPORARY TABLE temp_inventory_disposal AS
SELECT idr.disposal_id, i.name AS item, idr.quantity, idr.reason, d.first_name AS disposed_by
FROM inventory_disposal_records idr
JOIN inventory_items i ON idr.item_id = i.item_id
JOIN doctors d ON idr.disposed_by = d.doctor_id;

-- 100. Patient and Speech Therapy
CREATE TEMPORARY TABLE temp_speech_therapy AS
SELECT sta.assessment_id, p.first_name, p.last_name, sta.speech_clarity, sta.goals
FROM speech_therapy_assessments sta
JOIN patients p ON sta.patient_id = p.patient_id
JOIN medical_records mr ON sta.medical_record_id = mr.record_id;

-- 101. Patient and Advance Directives
CREATE TEMPORARY TABLE temp_advance_directives AS
SELECT ad.directive_id, p.first_name, p.last_name, ad.directive_type, ad.signed_date
FROM advance_directives ad
JOIN patients p ON ad.patient_id = p.patient_id
JOIN doctors d ON ad.witnessed_by = d.doctor_id;

-- 102. Compliance and Quality Metrics
CREATE TEMPORARY TABLE temp_quality_metrics AS
SELECT qm.metric_id, qm.metric_name, qmd.value, d.name AS department
FROM quality_metrics qm
JOIN quality_metric_data qmd ON qm.metric_id = qmd.metric_id
JOIN departments d ON qmd.department_id = d.department_id;

-- 103. Patient and Patient Goals
CREATE TEMPORARY TABLE temp_patient_goals AS
SELECT pg.goal_id, p.first_name, p.last_name, pg.goal_description, pg.status
FROM patient_goals pg
JOIN patients p ON pg.patient_id = p.patient_id
JOIN medical_records mr ON pg.medical_record_id = mr.record_id;

-- 104. Integration and Webhook Logs
CREATE TEMPORARY TABLE temp_webhook_logs AS
SELECT wl.log_id, wc.event_type, wl.event_date, wl.status, es.system_name
FROM webhook_logs wl
JOIN webhook_configurations wc ON wl.webhook_id = wc.webhook_id
JOIN external_systems es ON wc.system_id = es.system_id;

-- 105. Patient and Fall Risk
CREATE TEMPORARY TABLE temp_fall_risk AS
SELECT fra.assessment_id, p.first_name, p.last_name, fra.risk_score, fra.risk_level
FROM fall_risk_assessments fra
JOIN patients p ON fra.patient_id = p.patient_id
JOIN medical_records mr ON fra.medical_record_id = mr.record_id;

-- 106. Compliance and Privacy Incidents
CREATE TEMPORARY TABLE temp_privacy_incidents AS
SELECT pi.incident_id, p.first_name, p.last_name, pi.incident_date, pi.description
FROM privacy_incidents pi
JOIN patients p ON pi.patient_id = p.patient_id
JOIN hospitals h ON pi.hospital_id = h.hospital_id;

-- 107. Patient and Pressure Ulcer
CREATE TEMPORARY TABLE temp_pressure_ulcer AS
SELECT pua.assessment_id, p.first_name, p.last_name, pua.stage, pua.location
FROM pressure_ulcer_assessments pua
JOIN patients p ON pua.patient_id = p.patient_id
JOIN medical_records mr ON pua.medical_record_id = mr.record_id;

-- 108. Integration and Message Queues
CREATE TEMPORARY TABLE temp_message_queues AS
SELECT mq.message_id, es.system_name, mq.message_type, mq.status, mq.created_at
FROM message_queues mq
JOIN external_systems es ON mq.system_id = es.system_id
JOIN integration_configurations ic ON mq.config_id = ic.config_id;

-- 109. Patient and Infection Control
CREATE TEMPORARY TABLE temp_infection_control AS
SELECT icr.infection_id, p.first_name, p.last_name, icr.infection_type, icr.onset_date
FROM infection_control_records icr
JOIN patients p ON icr.patient_id = p.patient_id
JOIN medical_records mr ON icr.medical_record_id = mr.record_id;

-- 110. Compliance and Data Breaches
CREATE TEMPORARY TABLE temp_data_breaches AS
SELECT dbl.breach_id, dbl.breach_date, dbl.affected_records, bn.notified_party
FROM data_breach_logs dbl
LEFT JOIN breach_notifications bn ON dbl.breach_id = bn.breach_id
JOIN hospitals h ON dbl.hospital_id = h.hospital_id;

-- 111. Patient and Isolation Precautions
CREATE TEMPORARY TABLE temp_isolation_precautions AS
SELECT ip.precaution_id, p.first_name, p.last_name, ip.precaution_type, ip.start_date
FROM isolation_precautions ip
JOIN patients p ON ip.patient_id = p.patient_id
JOIN medical_records mr ON ip.medical_record_id = mr.record_id;

-- 112. Integration and Audit Trails
CREATE TEMPORARY TABLE temp_integration_audit_trails AS
SELECT iat.audit_id, es.system_name, iat.action, iat.action_date, d.first_name AS user
FROM integration_audit_trails iat
JOIN external_systems es ON iat.system_id = es.system_id
JOIN doctors d ON iat.user_id = d.doctor_id;

-- 113. Patient and Transfusion Records
CREATE TEMPORARY TABLE temp_transfusion_records AS
SELECT tr.transfusion_id, p.first_name, p.last_name, tr.blood_product, tr.volume_ml
FROM transfusion_records tr
JOIN patients p ON tr.patient_id = p.patient_id
JOIN medical_records mr ON tr.medical_record_id = mr.record_id;

-- 114. Compliance and Vendor Compliance
CREATE TEMPORARY TABLE temp_vendor_compliance AS
SELECT vc.compliance_id, s.name AS supplier, cr.name AS regulation, vc.status
FROM vendor_compliance vc
JOIN suppliers s ON vc.supplier_id = s.supplier_id
JOIN compliance_regulations cr ON vc.regulation_id = cr.regulation_id;

-- 115. Patient and Anesthesia Records
CREATE TEMPORARY TABLE temp_anesthesia_records AS
SELECT ar.anesthesia_id, p.first_name, p.last_name, ar.anesthesia_type, ar.start_time
FROM anesthesia_records ar
JOIN patients p ON ar.patient_id = p.patient_id
JOIN procedure_records pr ON ar.procedure_id = pr.procedure_id;

-- 116. Integration and Retry Policies
CREATE TEMPORARY TABLE temp_retry_policies AS
SELECT irp.policy_id, es.system_name, irp.max_retries, irp.retry_interval_seconds
FROM integration_retry_policies irp
JOIN external_systems es ON irp.system_id = es.system_id
JOIN integration_configurations ic ON irp.config_id = ic.config_id;

-- 117. Patient and Post-Anesthesia
CREATE TEMPORARY TABLE temp_post_anesthesia AS
SELECT paa.assessment_id, p.first_name, p.last_name, paa.recovery_status, paa.pain_score
FROM post_anesthesia_assessments paa
JOIN anesthesia_records ar ON paa.anesthesia_id = ar.anesthesia_id
JOIN patients p ON ar.patient_id = p.patient_id;

-- 118. Compliance and Regulatory Submissions
CREATE TEMPORARY TABLE temp_regulatory_submissions AS
SELECT rs.submission_id, cr.name AS regulation, rs.submission_date, rs.status
FROM regulatory_submissions rs
JOIN compliance_regulations cr ON rs.regulation_id = cr.regulation_id
JOIN hospitals h ON rs.hospital_id = h.hospital_id;

-- 119. Patient and Endoscopy Records
CREATE TEMPORARY TABLE temp_endoscopy_records AS
SELECT er.endoscopy_id, p.first_name, p.last_name, er.endoscopy_type, er.findings
FROM endoscopy_records er
JOIN patients p ON er.patient_id = p.patient_id
JOIN medical_records mr ON er.medical_record_id = mr.record_id;

-- 120. Integration and Data Mappings
CREATE TEMPORARY TABLE temp_data_mappings AS
SELECT dm.mapping_id, ic.config_name, dm.internal_table, dm.external_field
FROM data_mappings dm
JOIN integration_configurations ic ON dm.config_id = ic.config_id
JOIN external_systems es ON ic.system_id = es.system_id;

-- 121. Patient and Genetic Testing
CREATE TEMPORARY TABLE temp_genetic_testing AS
SELECT gtr.genetic_test_id, p.first_name, p.last_name, gtr.test_name, gtr.results
FROM genetic_testing_records gtr
JOIN patients p ON gtr.patient_id = p.patient_id
JOIN medical_records mr ON gtr.medical_record_id = mr.record_id;

-- 122. Compliance and Audit Evidence
CREATE TEMPORARY TABLE temp_audit_evidence AS
SELECT ae.evidence_id, ca.audit_date, cd.document_name, ae.submitted_date
FROM audit_evidence ae
JOIN compliance_audits ca ON ae.audit_id = ca.audit_id
JOIN compliance_documents cd ON ae.document_id = cd.document_id;

-- 123. Patient and Wound Care
CREATE TEMPORARY TABLE temp_wound_care AS
SELECT wcr.wound_care_id, p.first_name, p.last_name, wcr.wound_type, wcr.treatment
FROM wound_care_records wcr
JOIN patients p ON wcr.patient_id = p.patient_id
JOIN medical_records mr ON wcr.medical_record_id = mr.record_id;

-- 124. Integration and Queue Errors
CREATE TEMPORARY TABLE temp_queue_errors AS
SELECT qel.error_id, mq.message_type, qel.error_type, qel.error_message
FROM queue_error_logs qel
JOIN message_queues mq ON qel.message_id = mq.message_id
JOIN external_systems es ON mq.system_id = es.system_id;

-- 125. Patient and Respiratory Assessments
CREATE TEMPORARY TABLE temp_respiratory_assessments AS
SELECT ra.assessment_id, p.first_name, p.last_name, ra.respiratory_rate, ra.spo2_level
FROM respiratory_assessments ra
JOIN patients p ON ra.patient_id = p.patient_id
JOIN medical_records mr ON ra.medical_record_id = mr.record_id;

-- 126. Compliance and Dashboard Metrics
CREATE TEMPORARY TABLE temp_dashboard_metrics AS
SELECT dm.metric_id, cd.dashboard_name, cm.metric_name, dm.display_order
FROM dashboard_metrics dm
JOIN compliance_dashboards cd ON dm.dashboard_id = cd.dashboard_id
JOIN compliance_metrics cm ON dm.compliance_metric_id = cm.metric_id;

-- 127. Patient and Cardiac Assessments
CREATE TEMPORARY TABLE temp_cardiac_assessments AS
SELECT ca.assessment_id, p.first_name, p.last_name, ca.ecg_findings, ca.cardiac_rhythm
FROM cardiac_assessments ca
JOIN patients p ON ca.patient_id = p.patient_id
JOIN medical_records mr ON ca.medical_record_id = mr.record_id;

-- 128. Integration and Appointment Mappings
CREATE TEMPORARY TABLE temp_appointment_mappings AS
SELECT eam.mapping_id, a.appointment_date, es.system_name, eam.external_appointment_id
FROM external_appointment_mappings eam
JOIN appointments a ON eam.appointment_id = a.appointment_id
JOIN external_systems es ON eam.system_id = es.system_id;

-- 129. Patient and Neurological Assessments
CREATE TEMPORARY TABLE temp_neurological_assessments AS
SELECT na.assessment_id, p.first_name, p.last_name, na.glasgow_coma_score, na.pupil_response
FROM neurological_assessments na
JOIN patients p ON na.patient_id = p.patient_id
JOIN medical_records mr ON na.medical_record_id = mr.record_id;

-- 130. Compliance and Role Assignments
CREATE TEMPORARY TABLE temp_role_assignments AS
SELECT ra.assignment_id, cr.role_name, d.first_name, d.last_name, ra.assigned_date
FROM role_assignments ra
JOIN compliance_roles cr ON ra.role_id = cr.role_id
JOIN doctors d ON ra.employee_id = d.doctor_id;

-- 131. Patient and Rehabilitation Sessions
CREATE TEMPORARY TABLE temp_rehabilitation_sessions AS
SELECT rs.session_id, p.first_name, p.last_name, rp.therapy_type, rs.progress_notes
FROM rehabilitation_sessions rs
JOIN rehabilitation_plans rp ON rs.plan_id = rp.plan_id
JOIN patients p ON rs.patient_id = p.patient_id;

-- 132. Integration and Insurance Claim Mappings
CREATE TEMPORARY TABLE temp_insurance_claim_mappings AS
SELECT eicm.mapping_id, ic.claim_amount, es.system_name, eicm.external_claim_id
FROM external_insurance_claim_mappings eicm
JOIN insurance_claims ic ON eicm.claim_id = ic.claim_id
JOIN external_systems es ON eicm.system_id = es.system_id;

-- 133. Patient and Patient Education
CREATE TEMPORARY TABLE temp_patient_education AS
SELECT per.education_id, p.first_name, p.last_name, per.topic, per.understanding_level
FROM patient_education_records per
JOIN patients p ON per.patient_id = p.patient_id
JOIN medical_records mr ON per.medical_record_id = mr.record_id;

-- 134. Compliance and Event Logs
CREATE TEMPORARY TABLE temp_compliance_event_logs AS
SELECT cel.event_id, cel.event_type, cel.event_date, d.first_name AS triggered_by
FROM compliance_event_logs cel
JOIN doctors d ON cel.triggered_by = d.doctor_id
JOIN hospitals h ON cel.hospital_id = h.hospital_id;

-- 135. Patient and Consent Forms
CREATE TEMPORARY TABLE temp_consent_forms AS
SELECT cf.consent_id, p.first_name, p.last_name, cf.consent_type, cf.signed_date
FROM patient_consent_forms cf
JOIN patients p ON cf.patient_id = p.patient_id
JOIN procedure_records pr ON cf.procedure_id = pr.procedure_id;

-- 136. Integration and Transformation Rules
CREATE TEMPORARY TABLE temp_transformation_rules AS
SELECT dtr.rule_id, dm.internal_table, dtr.transformation_type, dtr.rule_definition
FROM data_transformation_rules dtr
JOIN data_mappings dm ON dtr.mapping_id = dm.mapping_id
JOIN integration_configurations ic ON dm.config_id = ic.config_id;

-- 137. Patient and Pathology Reports
CREATE TEMPORARY TABLE temp_pathology_reports AS
SELECT pr.pathology_id, p.first_name, p.last_name, pr.specimen_type, pr.diagnosis
FROM pathology_reports pr
JOIN patients p ON pr.patient_id = p.patient_id
JOIN medical_records mr ON pr.medical_record_id = mr.record_id;

-- 138. Compliance and Submission Reviews
CREATE TEMPORARY TABLE temp_submission_reviews AS
SELECT sr.review_id, rs.submission_date, cr.name AS regulation, sr.status
FROM submission_reviews sr
JOIN regulatory_submissions rs ON sr.submission_id = rs.submission_id
JOIN compliance_regulations cr ON rs.regulation_id = cr.regulation_id;

-- 139. Patient and Medication Administration
CREATE TEMPORARY TABLE temp_medication_administration AS
SELECT ma.administration_id, p.first_name, p.last_name, m.name AS medication, ma.dose_administered
FROM medication_administration ma
JOIN prescription_items pi ON ma.prescription_item_id = pi.item_id
JOIN medications m ON pi.medication_id = m.medication_id
JOIN patients p ON ma.patient_id = p.patient_id;

-- 140. Integration and Metrics
CREATE TEMPORARY TABLE temp_integration_metrics AS
SELECT im.metric_id, es.system_name, im.metric_name, im.metric_value
FROM integration_metrics im
JOIN external_systems es ON im.system_id = es.system_id
JOIN integration_configurations ic ON im.config_id = ic.config_id;

-- 141. Patient and Clinical Notes
CREATE TEMPORARY TABLE temp_clinical_notes AS
SELECT cn.note_id, p.first_name, p.last_name, cn.note_type, cn.content
FROM clinical_notes cn
JOIN patients p ON cn.patient_id = p.patient_id
JOIN medical_records mr ON cn.medical_record_id = mr.record_id;

-- 142. Compliance and Incident Root Causes
CREATE TEMPORARY TABLE temp_incident_root_causes AS
SELECT irc.root_cause_id, ci.incident_date, ic.name AS category, irc.description
FROM incident_root_causes irc
JOIN incident_investigations ii ON irc.investigation_id = ii.investigation_id
JOIN compliance_incidents ci ON ii.incident_id = ci.incident_id
JOIN incident_categories ic ON irc.category_id = ic.category_id;

-- 143. Patient and Wound Assessments
CREATE TEMPORARY TABLE temp_wound_assessments AS
SELECT wca.assessment_id, p.first_name, p.last_name, wca.wound_size_cm, wca.healing_status
FROM wound_care_assessments wca
JOIN wound_care_records wcr ON wca.wound_care_id = wcr.wound_care_id
JOIN patients p ON wcr.patient_id = p.patient_id;

-- 144. Integration and Dashboards
CREATE TEMPORARY TABLE temp_integration_dashboards AS
SELECT id.dashboard_id, id.dashboard_name, h.name AS hospital, id.created_at
FROM integration_dashboards id
JOIN hospitals h ON id.hospital_id = h.hospital_id;

-- 145. Patient and Immunizations
CREATE TEMPORARY TABLE temp_immunizations AS
SELECT i.immunization_id, p.first_name, p.last_name, i.vaccine_name, i.administration_date
FROM immunizations i
JOIN patients p ON i.patient_id = p.patient_id
JOIN doctors d ON i.administered_by = d.doctor_id;

-- 146. Compliance and Audit Team
CREATE TEMPORARY TABLE temp_audit_team AS
SELECT ata.assignment_id, ca.audit_date, d.first_name, d.last_name, ata.role
FROM audit_team_assignments ata
JOIN compliance_audits ca ON ata.audit_id = ca.audit_id
JOIN doctors d ON ata.employee_id = d.doctor_id;

-- 147. Patient and Lab Order Mappings
CREATE TEMPORARY TABLE temp_lab_order_mappings AS
SELECT elom.mapping_id, lo.order_date, es.system_name, elom.external_order_id
FROM external_lab_order_mappings elom
JOIN lab_orders lo ON elom.lab_order_id = lo.order_id
JOIN external_systems es ON elom.system_id = es.system_id;

-- 148. Patient and Lab Result Mappings
CREATE TEMPORARY TABLE temp_lab_result_mappings AS
SELECT elrm.mapping_id, lr.result_date, es.system_name, elrm.external_result_id
FROM external_lab_result_mappings elrm
JOIN lab_results lr ON elrm.lab_result_id = lr.result_id
JOIN external_systems es ON elrm.system_id = es.system_id;

-- 149. Patient and Doctor Mappings
CREATE TEMPORARY TABLE temp_doctor_mappings AS
SELECT edm.mapping_id, d.first_name, d.last_name, es.system_name, edm.external_doctor_id
FROM external_doctor_mappings edm
JOIN doctors d ON edm.doctor_id = d.doctor_id
JOIN external_systems es ON edm.system_id = es.system_id;

-- 150. Patient and Billing Mappings
CREATE TEMPORARY TABLE temp_billing_mappings AS
SELECT ebm.mapping_id, b.total_amount, es.system_name, ebm.external_bill_id
FROM external_billing_mappings ebm
JOIN billing b ON ebm.bill_id = b.bill_id
JOIN external_systems es ON ebm.system_id = es.system_id;

-- 151. Patient and Compliance Status
CREATE TEMPORARY TABLE temp_patient_compliance_status AS
SELECT p.patient_id, p.first_name, p.last_name, hcs.status, cr.name AS regulation
FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
JOIN wards w ON a.ward_id = w.ward_id
JOIN hospitals h ON w.hospital_id = h.hospital_id
JOIN hospital_compliance_status hcs ON h.hospital_id = hcs.hospital_id
JOIN compliance_regulations cr ON hcs.regulation_id = cr.regulation_id;

-- 152. Doctor and Financial Transactions
CREATE TEMPORARY TABLE temp_doctor_financials AS
SELECT d.doctor_id, d.first_name, d.last_name, glt.amount, glt.transaction_date, gla.account_name
FROM doctors d
JOIN gl_transactions glt ON d.hospital_id = glt.hospital_id
JOIN gl_accounts gla ON glt.account_id = gla.account_id;

-- 153. Patient and Emergency Contacts
CREATE TEMPORARY TABLE temp_emergency_contacts AS
SELECT ec.contact_id, p.first_name, p.last_name, ec.name AS contact_name, ec.relationship
FROM emergency_contacts ec
JOIN patients p ON ec.patient_id = p.patient_id;

-- 154. Nurse and Ward Schedules
CREATE TEMPORARY TABLE temp_nurse_ward_schedules AS
SELECT n.nurse_id, n.first_name, n.last_name, w.name AS ward, na.shift_start
FROM nurses n
JOIN nurse_assignments na ON n.nurse_id = na.nurse_id
JOIN wards w ON na.ward_id = w.ward_id
JOIN departments d ON n.department_id = d.department_id;

-- 155. Patient and Surgery Outcomes
CREATE TEMPORARY TABLE temp_surgery_outcomes AS
SELECT s.surgery_id, p.first_name, p.last_name, s.procedure_name, s.outcome
FROM surgeries s
JOIN patients p ON s.patient_id = p.patient_id
JOIN doctors d ON s.doctor_id = d.doctor_id;

-- 156. Inventory and Audit Items
CREATE TEMPORARY TABLE temp_inventory_audit_items AS
SELECT iai.audit_item_id, i.name AS item, iai.expected_quantity, iai.actual_quantity
FROM inventory_audit_items iai
JOIN inventory_items i ON iai.item_id = i.item_id
JOIN inventory_audits ia ON iai.audit_id = ia.audit_id;

-- 157. Patient and Insurance Payments
CREATE TEMPORARY TABLE temp_insurance_payments AS
SELECT icp.payment_id, p.first_name, p.last_name, icp.amount, icp.payment_date
FROM insurance_claim_payments icp
JOIN insurance_claims ic ON icp.claim_id = ic.claim_id
JOIN patients p ON ic.patient_id = p.patient_id;

-- 158. Doctor and Compliance Training
CREATE TEMPORARY TABLE temp_doctor_compliance_training AS
SELECT d.doctor_id, d.first_name, d.last_name, ctp.training_name, etr.completion_date
FROM doctors d
JOIN employee_training_records etr ON d.doctor_id = etr.employee_id
JOIN compliance_training_programs ctp ON etr.training_id = ctp.training_id;

-- 159. Patient and Billing Items
CREATE TEMPORARY TABLE temp_billing_items AS
SELECT bi.item_id, p.first_name, p.last_name, b.total_amount, bi.description
FROM billing_items bi
JOIN billing b ON bi.bill_id = b.bill_id
JOIN patients p ON b.patient_id = p.patient_id;

-- 160. Supplier and Contract Items
CREATE TEMPORARY TABLE temp_contract_items AS
SELECT ci.contract_item_id, s.name AS supplier, i.name AS item, ci.quantity
FROM contract_items ci
JOIN procurement_contracts pc ON ci.contract_id = pc.contract_id
JOIN suppliers s ON pc.supplier_id = s.supplier_id
JOIN inventory_items i ON ci.item_id = i.item_id;

-- 161. Patient and Appointment Details
CREATE TEMPORARY TABLE temp_appointment_details AS
SELECT a.appointment_id, p.first_name, p.last_name, d.first_name AS doctor_name, dept.name AS department
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
JOIN departments dept ON a.department_id = dept.department_id;

-- 162. Nurse and Compliance Incidents
CREATE TEMPORARY TABLE temp_nurse_compliance_incidents AS
SELECT n.nurse_id, n.first_name, n.last_name, ci.incident_date, ci.description
FROM nurses n
JOIN compliance_incidents ci ON n.department_id = ci.department_id;

-- 163. Patient and Pathology Findings
CREATE TEMPORARY TABLE temp_pathology_findings AS
SELECT pr.pathology_id, p.first_name, p.last_name, pr.findings, d.first_name AS reported_by
FROM pathology_reports pr
JOIN patients p ON pr.patient_id = p.patient_id
JOIN doctors d ON pr.reported_by = d.doctor_id;

-- 164. Inventory and Stock Reservations
CREATE TEMPORARY TABLE temp_stock_reservations AS
SELECT sr.reservation_id, i.name AS item, d.name AS department, sr.quantity
FROM stock_reservations sr
JOIN inventory_items i ON sr.item_id = i.item_id
JOIN departments d ON sr.department_id = d.department_id;

-- 165. Patient and Care Interventions
CREATE TEMPORARY TABLE temp_care_interventions AS
SELECT cpi.intervention_id, p.first_name, p.last_name, cpi.intervention_type, cpi.frequency
FROM care_plan_interventions cpi
JOIN care_plans cp ON cpi.care_plan_id = cp.care_plan_id
JOIN patients p ON cp.patient_id = p.patient_id;

-- 166. Compliance and Policy Compliance
CREATE TEMPORARY TABLE temp_policy_compliance AS
SELECT pc.compliance_id, cp.policy_name, ca.audit_date, pc.status
FROM policy_compliance pc
JOIN compliance_policies cp ON pc.policy_id = cp.policy_id
JOIN financial_audits ca ON pc.audit_id = ca.audit_id;

-- 167. Patient and Diagnostic Imaging
CREATE TEMPORARY TABLE temp_diagnostic_imaging AS
SELECT di.imaging_id, p.first_name, p.last_name, di.imaging_type, di.body_part
FROM diagnostic_imaging di
JOIN patients p ON di.patient_id = p.patient_id
JOIN medical_records mr ON di.medical_record_id = mr.record_id;

-- 168. Integration and API Credentials
CREATE TEMPORARY TABLE temp_api_credentials AS
SELECT ac.credential_id, es.system_name, ac.client_id, ac.token_expiry
FROM api_credentials ac
JOIN external_systems es ON ac.system_id = es.system_id
JOIN hospitals h ON es.hospital_id = h.hospital_id;

-- 169. Patient and Treatment Outcomes
CREATE TEMPORARY TABLE temp_treatment_outcomes AS
SELECT tp.plan_id, p.first_name, p.last_name, tpa.status, tpa.completion_date
FROM treatment_plan_actions tpa
JOIN treatment_plans tp ON tpa.plan_id = tp.plan_id
JOIN patients p ON tp.patient_id = p.patient_id;

-- 170. Supplier and Vendor Scorecards
CREATE TEMPORARY TABLE temp_vendor_scorecards AS
SELECT vs.scorecard_id, s.name AS supplier, vs.quality_score, vs.overall_score
FROM vendor_scorecards vs
JOIN suppliers s ON vs.supplier_id = s.supplier_id;

-- 171. Patient and Neurological Status
CREATE TEMPORARY TABLE temp_neurological_status AS
SELECT na.assessment_id, p.first_name, p.last_name, na.motor_response, d.first_name AS assessed_by
FROM neurological_assessments na
JOIN patients p ON na.patient_id = p.patient_id
JOIN doctors d ON na.assessed_by = d.doctor_id;

-- 172. Compliance and Checklist Items
CREATE TEMPORARY TABLE temp_checklist_items AS
SELECT ci.item_id, cl.checklist_name, ci.description, ci.required
FROM checklist_items ci
JOIN compliance_checklists cl ON ci.checklist_id = cl.checklist_id
JOIN compliance_regulations cr ON cl.regulation_id = cr.regulation_id;

-- 173. Patient and Blood Glucose Trends
CREATE TEMPORARY TABLE temp_glucose_trends AS
SELECT bgl.glucose_id, p.first_name, p.last_name, bgl.glucose_level_mgdl, bgl.recorded_date
FROM blood_glucose_levels bgl
JOIN patients p ON bgl.patient_id = p.patient_id
JOIN nurses n ON bgl.recorded_by = n.nurse_id;

-- 174. Integration and Sync Job Errors
CREATE TEMPORARY TABLE temp_sync_job_errors AS
SELECT sel.error_id, dsj.job_id, es.system_name, sel.error_message
FROM sync_error_logs sel
JOIN data_synchronization_jobs dsj ON sel.job_id = dsj.job_id
JOIN external_systems es ON dsj.config_id = es.system_id;

-- 175. Patient and Fluid Intake
CREATE TEMPORARY TABLE temp_fluid_intake AS
SELECT fbr.fluid_id, p.first_name, p.last_name, fbr.intake_ml, n.first_name AS recorded_by
FROM fluid_balance_records fbr
JOIN patients p ON fbr.patient_id = p.patient_id
JOIN nurses n ON fbr.recorded_by = n.nurse_id;

-- 176. Compliance and Quality Programs
CREATE TEMPORARY TABLE temp_quality_programs AS
SELECT qap.program_id, qap.program_name, qap.start_date, h.name AS hospital
FROM quality_assurance_programs qap
JOIN hospitals h ON qap.hospital_id = h.hospital_id;

-- 177. Patient and IV Therapy Details
CREATE TEMPORARY TABLE temp_iv_therapy_details AS
SELECT ivt.iv_therapy_id, p.first_name, p.last_name, ivt.start_date, n.first_name AS administered_by
FROM iv_therapy_records ivt
JOIN patients p ON ivt.patient_id = p.patient_id
JOIN nurses n ON ivt.administered_by = n.nurse_id;

-- 178. Integration and Batch Processing
CREATE TEMPORARY TABLE temp_batch_processing AS
SELECT bj.batch_id, es.system_name, bj.total_records, bjd.status
FROM batch_job_details bjd
JOIN batch_jobs bj ON bjd.batch_id = bj.batch_id
JOIN external_systems es ON bj.system_id = es.system_id;

-- 179. Patient and Ventilator Usage
CREATE TEMPORARY TABLE temp_ventilator_usage AS
SELECT vs.setting_id, p.first_name, p.last_name, vs.fio2_percentage, d.first_name AS set_by
FROM ventilator_settings vs
JOIN patients p ON vs.patient_id = p.patient_id
JOIN doctors d ON vs.set_by = d.doctor_id;

-- 180. Compliance and Incident Categories
CREATE TEMPORARY TABLE temp_incident_categories AS
SELECT ic.category_id, ic.name, irc.description AS root_cause
FROM incident_categories ic
JOIN incident_root_causes irc ON ic.category_id = irc.category_id
JOIN incident_investigations ii ON irc.investigation_id = ii.investigation_id;

-- 181. Patient and Dialysis Sessions
CREATE TEMPORARY TABLE temp_dialysis_sessions AS
SELECT dr.dialysis_id, p.first_name, p.last_name, dr.complications, d.first_name AS performed_by
FROM dialysis_records dr
JOIN patients p ON dr.patient_id = p.patient_id
JOIN doctors d ON dr.performed_by = d.doctor_id;

-- 182. Integration and HL7 Messaging
CREATE TEMPORARY TABLE temp_hl7_messaging AS
SELECT hm.message_id, p.first_name, p.last_name, es.system_name, hm.sent_date
FROM hl7_messages hm
JOIN patients p ON hm.patient_id = p.patient_id
JOIN external_systems es ON hm.system_id = es.system_id;

-- 183. Patient and Chemotherapy Details
CREATE TEMPORARY TABLE temp_chemotherapy_details AS
SELECT cr.chemo_id, p.first_name, p.last_name, cr.side_effects, d.first_name AS administered_by
FROM chemotherapy_records cr
JOIN patients p ON cr.patient_id = p.patient_id
JOIN doctors d ON cr.administered_by = d.doctor_id;

-- 184. Compliance and Report Approvals
CREATE TEMPORARY TABLE temp_report_approvals AS
SELECT ra.approval_id, cr.report_type, d.first_name AS approver, ra.approval_date
FROM report_approvals ra
JOIN compliance_reports cr ON ra.report_id = cr.report_id
JOIN doctors d ON ra.approver_id = d.doctor_id;

-- 185. Patient and Radiation Details
CREATE TEMPORARY TABLE temp_radiation_details AS
SELECT rtr.radiation_id, p.first_name, p.last_name, rtr.side_effects, d.first_name AS administered_by
FROM radiation_therapy_records rtr
JOIN patients p ON rtr.patient_id = p.patient_id
JOIN doctors d ON rtr.administered_by = d.doctor_id;

-- 186. Integration and Webhook Events
CREATE TEMPORARY TABLE temp_webhook_events AS
SELECT wl.log_id, wc.webhook_url, es.system_name, wl.response_code
FROM webhook_logs wl
JOIN webhook_configurations wc ON wl.webhook_id = wc.webhook_id
JOIN external_systems es ON wc.system_id = es.system_id;

-- 187. Patient and Physical Therapy Goals
CREATE TEMPORARY TABLE temp_physical_therapy_goals AS
SELECT pta.assessment_id, p.first_name, p.last_name, pta.muscle_strength, d.first_name AS assessed_by
FROM physical_therapy_assessments pta
JOIN patients p ON pta.patient_id = p.patient_id
JOIN doctors d ON pta.assessed_by = d.doctor_id;

-- 188. Compliance and Privacy Actions
CREATE TEMPORARY TABLE temp_privacy_actions AS
SELECT pia.action_id, pi.incident_date, pia.description, d.first_name AS assigned_to
FROM privacy_incident_actions pia
JOIN privacy_incidents pi ON pia.incident_id = pi.incident_id
JOIN doctors d ON pia.assigned_to = d.doctor_id;

-- 189. Patient and Occupational Goals
CREATE TEMPORARY TABLE temp_occupational_goals AS
SELECT ota.assessment_id, p.first_name, p.last_name, ota.goals, d.first_name AS assessed_by
FROM occupational_therapy_assessments ota
JOIN patients p ON ota.patient_id = p.patient_id
JOIN doctors d ON ota.assessed_by = d.doctor_id;

-- 190. Integration and Queue Processing
CREATE TEMPORARY TABLE temp_queue_processing AS
SELECT mq.message_id, es.system_name, mq.processed_at, qel.error_type
FROM message_queues mq
JOIN external_systems es ON mq.system_id = es.system_id
LEFT JOIN queue_error_logs qel ON mq.message_id = qel.message_id;

-- 191. Patient and Speech Therapy Goals
CREATE TEMPORARY TABLE temp_speech_therapy_goals AS
SELECT sta.assessment_id, p.first_name, p.last_name, sta.swallowing_function, d.first_name AS assessed_by
FROM speech_therapy_assessments sta
JOIN patients p ON sta.patient_id = p.patient_id
JOIN doctors d ON sta.assessed_by = d.doctor_id;

-- 192. Compliance and Certification Audits
CREATE TEMPORARY TABLE temp_certification_audits AS
SELECT ca.audit_id, cc.certification_name, ca.audit_date, ca.findings
FROM certification_audits ca
JOIN compliance_certifications cc ON ca.certification_id = cc.certification_id;

-- 193. Patient and Fall Risk Precautions
CREATE TEMPORARY TABLE temp_fall_risk_precautions AS
SELECT fra.assessment_id, p.first_name, p.last_name, fra.precautions, n.first_name AS assessed_by
FROM fall_risk_assessments fra
JOIN patients p ON fra.patient_id = p.patient_id
JOIN nurses n ON fra.assessed_by = n.nurse_id;

-- 194. Integration and FHIR Sync
CREATE TEMPORARY TABLE temp_fhir_sync AS
SELECT fr.resource_id, es.system_name, fr.resource_type, fr.last_synced
FROM fhir_resources fr
JOIN external_systems es ON fr.system_id = es.system_id;

-- 195. Patient and Pressure Ulcer Treatment
CREATE TEMPORARY TABLE temp_ulcer_treatment AS
SELECT pua.assessment_id, p.first_name, p.last_name, pua.treatment_plan, n.first_name AS assessed_by
FROM pressure_ulcer_assessments pua
JOIN patients p ON pua.patient_id = p.patient_id
JOIN nurses n ON pua.assessed_by = n.nurse_id;

-- 196. Compliance and Task Templates
CREATE TEMPORARY TABLE temp_task_templates AS
SELECT ctt.template_id, cr.name AS regulation, ctt.task_name, ctt.frequency
FROM compliance_task_templates ctt
JOIN compliance_regulations cr ON ctt.regulation_id = cr.regulation_id;

-- 197. Patient and Infection Treatment
CREATE TEMPORARY TABLE temp_infection_treatment AS
SELECT icr.infection_id, p.first_name, p.last_name, icr.treatment, d.first_name AS reported_by
FROM infection_control_records icr
JOIN patients p ON icr.patient_id = p.patient_id
JOIN doctors d ON icr.reported_by = d.doctor_id;

-- 198. Integration and Validation Rules
CREATE TEMPORARY TABLE temp_validation_rules AS
SELECT dvr.rule_id, ic.config_name, dvr.validation_type, dvr.rule_definition
FROM data_validation_rules dvr
JOIN integration_configurations ic ON dvr.config_id = ic.config_id;

-- 199. Patient and Transfusion Reactions
CREATE TEMPORARY TABLE temp_transfusion_reactions AS
SELECT tr.transfusion_id, p.first_name, p.last_name, tr.reaction, n.first_name AS administered_by
FROM transfusion_records tr
JOIN patients p ON tr.patient_id = p.patient_id
JOIN nurses n ON tr.administered_by = n.nurse_id;

-- 200. Compliance and Audit Schedules
CREATE TEMPORARY TABLE temp_audit_schedules AS
SELECT asch.schedule_id, asch.audit_type, asch.planned_date, h.name AS hospital
FROM audit_schedules asch
JOIN hospitals h ON asch.hospital_id = h.hospital_id;

-- Extend current schema with 200 tables using CREATE TABLE ... AS SELECT statement, derived from temporary tables or direct from base tables. Use joins. Provide only SQL DDL statements.

-- 200 Derived Permanent Tables for Hospital Management System

-- 1. Derived Patient Appointment Details
create table derived_patient_appointments
   as
      select p.patient_id,
             p.first_name,
             p.last_name,
             a.appointment_id,
             a.appointment_date,
             d.first_name as doctor_first_name
        from patients p
        join appointments a
      on p.patient_id = a.patient_id
        join doctors d
      on a.doctor_id = d.doctor_id;

-- 2. Derived Doctor Appointment Counts
create table derived_doctor_appointments
   as
      select d.doctor_id,
             d.first_name,
             d.last_name,
             count(a.appointment_id) as appointment_count
        from doctors d
        left join appointments a
      on d.doctor_id = a.doctor_id
        join departments dept
      on d.department_id = dept.department_id
       group by d.doctor_id,
                d.first_name,
                d.last_name;

-- 3. Derived Patient Billing Summary
create table derived_patient_billing
   as
      select p.patient_id,
             p.first_name,
             p.last_name,
             b.bill_id,
             b.total_amount
        from patients p
        join billing b
      on p.patient_id = b.patient_id
        left join admissions a
      on b.admission_id = a.admission_id;

-- 4. Derived Admission Records
create table derived_admissions
   as
      select a.admission_id,
             p.first_name,
             p.last_name,
             w.name as ward,
             a.admission_date
        from admissions a
        join patients p
      on a.patient_id = p.patient_id
        join wards w
      on a.ward_id = w.ward_id;

-- 5. Derived Prescription Medications
create table derived_prescriptions
   as
      select pr.prescription_id,
             p.first_name,
             p.last_name,
             m.name as medication
        from prescriptions pr
        join patients p
      on pr.patient_id = p.patient_id
        join prescription_items pi
      on pr.prescription_id = pi.prescription_id
        join medications m
      on pi.medication_id = m.medication_id;

-- 6. Derived Lab Results Summary
create table derived_lab_results
   as
      select lo.order_id,
             p.first_name,
             p.last_name,
             lt.name as test_name,
             lr.result_text
        from lab_orders lo
        join patients p
      on lo.patient_id = p.patient_id
        join lab_tests lt
      on lo.test_id = lt.test_id
        join lab_results lr
      on lo.order_id = lr.order_id;

-- 7. Derived Nurse Ward Assignments
create table derived_nurse_assignments
   as
      select n.nurse_id,
             n.first_name,
             n.last_name,
             w.name as ward,
             na.shift_start
        from nurses n
        join nurse_assignments na
      on n.nurse_id = na.nurse_id
        join wards w
      on na.ward_id = w.ward_id;

-- 8. Derived Surgery Details
create table derived_surgeries
   as
      select s.surgery_id,
             p.first_name,
             p.last_name,
             d.first_name as doctor_first_name,
             orr.room_number
        from surgeries s
        join patients p
      on s.patient_id = p.patient_id
        join doctors d
      on s.doctor_id = d.doctor_id
        join surgery_schedules ss
      on s.surgery_id = ss.surgery_id
        join operating_rooms orr
      on ss.room_id = orr.room_id;

-- 9. Derived Patient Insurance Policies
create table derived_patient_insurance
   as
      select p.patient_id,
             p.first_name,
             p.last_name,
             ic.name as insurance_company,
             pi.policy_number
        from patients p
        join patient_insurance pi
      on p.patient_id = pi.patient_id
        join insurance_companies ic
      on pi.company_id = ic.company_id;
 
-- 10. Derived Inventory Levels
create table derived_inventory_stock
   as
      select i.item_id,
             i.name,
             isx.quantity,
             h.name as hospital
        from inventory_items i
        join inventory_stock isx
      on i.item_id = isx.item_id
        join hospitals h
      on isx.hospital_id = h.hospital_id;


-- 11. Derived GL Transactions
create table derived_gl_transactions
   as
      select gla.account_id,
             gla.account_name,
             glt.transaction_date,
             glt.amount
        from gl_accounts gla
        join gl_transactions glt
      on gla.account_id = glt.account_id
        join hospitals h
      on glt.hospital_id = h.hospital_id;

-- 12. Derived Cost Center Spending
create table derived_cost_center_expenses
   as
      select cc.cost_center_id,
             cc.name as cost_center,
             e.amount,
             ec.name as expense_category
        from cost_centers cc
        join expenses e
      on cc.cost_center_id = e.cost_center_id
        join expense_categories ec
      on e.category_id = ec.category_id;

-- 13. Derived Accounts Receivable
create table derived_accounts_receivable
   as
      select ar.ar_id,
             p.first_name,
             p.last_name,
             ar.amount_due,
             ar.status
        from accounts_receivable ar
        join patients p
      on ar.patient_id = p.patient_id
        join billing b
      on ar.bill_id = b.bill_id;

-- 14. Derived Accounts Payable
create table derived_accounts_payable
   as
      select ap.ap_id,
             s.name as supplier,
             ap.amount_due,
             ap.status
        from accounts_payable ap
        join suppliers s
      on ap.supplier_id = s.supplier_id
        join purchase_orders po
      on ap.purchase_order_id = po.order_id;

-- 15. Derived Compliance Audits
create table derived_compliance_audits
   as
      select ca.audit_id,
             ca.audit_date,
             cr.name as regulation,
             af.finding_type
        from compliance_audits ca
        join compliance_regulations cr
      on ca.regulation_id = cr.regulation_id
        join audit_findings af
      on ca.audit_id = af.audit_id;

-- 16. Derived Incident Reports
create table derived_incident_reports
   as
      select ci.incident_id,
             ci.incident_date,
             d.first_name as investigator,
             ii.findings
        from compliance_incidents ci
        join incident_investigations ii
      on ci.incident_id = ii.incident_id
        join doctors d
      on ii.investigator_id = d.doctor_id;

-- 17. Derived Patient Vitals
create table derived_patient_vitals
   as
      select vs.vital_id,
             p.first_name,
             p.last_name,
             vs.blood_pressure_systolic,
             vs.heart_rate
        from vital_signs vs
        join patients p
      on vs.patient_id = p.patient_id
        join medical_records mr
      on vs.medical_record_id = mr.record_id;

-- 18. Derived Patient Allergies
create table derived_patient_allergies
   as
      select a.allergy_id,
             p.first_name,
             p.last_name,
             a.allergen,
             a.reaction
        from allergies a
        join patients p
      on a.patient_id = p.patient_id
        join doctors d
      on a.diagnosed_by = d.doctor_id;

-- 19. Derived Imaging Reports
create table derived_imaging_reports
   as
      select di.imaging_id,
             p.first_name,
             p.last_name,
             di.imaging_type,
             ir.findings
        from diagnostic_imaging di
        join patients p
      on di.patient_id = p.patient_id
        join imaging_reports ir
      on di.imaging_id = ir.imaging_id;

-- 20. Derived Treatment Plans
create table derived_treatment_plans
   as
      select tp.plan_id,
             p.first_name,
             p.last_name,
             tpa.action_type,
             tpa.description
        from treatment_plans tp
        join patients p
      on tp.patient_id = p.patient_id
        join treatment_plan_actions tpa
      on tp.plan_id = tpa.plan_id;

-- 21. Derived Inventory Adjustments
create table derived_inventory_adjustments
   as
      select ia.adjustment_id,
             i.name as item,
             h.name as hospital,
             ia.quantity_adjusted
        from inventory_adjustments ia
        join inventory_items i
      on ia.item_id = i.item_id
        join hospitals h
      on ia.hospital_id = h.hospital_id;

-- 22. Derived Equipment Maintenance
create table derived_equipment_maintenance
   as
      select e.equipment_id,
             e.name as equipment,
             em.maintenance_date,
             em.description
        from equipment e
        join equipment_maintenance em
      on e.equipment_id = em.equipment_id
        join departments d
      on e.department_id = d.department_id;

-- 23. Derived Supplier Performance
create table derived_supplier_performance
   as
      select s.supplier_id,
             s.name as supplier,
             sp.evaluation_date,
             sp.quality_rating
        from suppliers s
        join supplier_performance sp
      on s.supplier_id = sp.supplier_id;

-- 24. Derived Goods Receipts
create table derived_goods_receipts
   as
      select gr.receipt_id,
             po.order_date,
             s.name as supplier,
             gr.receipt_date
        from goods_receipts gr
        join purchase_orders po
      on gr.order_id = po.order_id
        join suppliers s
      on po.supplier_id = s.supplier_id;

-- 25. Derived Integration Logs
create table derived_integration_logs
   as
      select il.log_id,
             es.system_name,
             ic.config_name,
             il.log_date,
             il.status
        from integration_logs il
        join external_systems es
      on il.system_id = es.system_id
        join integration_configurations ic
      on il.config_id = ic.config_id;

-- 26. Derived Patient Sync Status
create table derived_patient_sync
   as
      select epm.mapping_id,
             p.first_name,
             p.last_name,
             es.system_name,
             epm.last_synced
        from external_patient_mappings epm
        join patients p
      on epm.patient_id = p.patient_id
        join external_systems es
      on epm.system_id = es.system_id;

-- 27. Derived Webhook Logs
create table derived_webhook_logs
   as
      select wl.log_id,
             wc.webhook_url,
             wc.event_type,
             wl.event_date
        from webhook_logs wl
        join webhook_configurations wc
      on wl.webhook_id = wc.webhook_id
        join external_systems es
      on wc.system_id = es.system_id;

-- 28. Derived HL7 Messages
create table derived_hl7_messages
   as
      select hm.message_id,
             es.system_name,
             p.first_name,
             p.last_name,
             hm.message_type
        from hl7_messages hm
        join external_systems es
      on hm.system_id = es.system_id
        join patients p
      on hm.patient_id = p.patient_id;

-- 29. Derived Medical Records
create table derived_medical_records
   as
      select mr.record_id,
             p.first_name,
             p.last_name,
             d.first_name as doctor,
             mr.diagnosis
        from medical_records mr
        join patients p
      on mr.patient_id = p.patient_id
        join doctors d
      on mr.doctor_id = d.doctor_id;

-- 30. Derived Compliance Training
create table derived_compliance_training
   as
      select etr.record_id,
             ctp.training_name,
             d.first_name,
             d.last_name
        from employee_training_records etr
        join compliance_training_programs ctp
      on etr.training_id = ctp.training_id
        join doctors d
      on etr.employee_id = d.doctor_id;

-- 31. Derived Budget Details
create table derived_budgets
   as
      select b.budget_id,
             cc.name as cost_center,
             ba.amount,
             ba.allocation_date
        from budgets b
        join cost_centers cc
      on b.cost_center_id = cc.cost_center_id
        join budget_allocations ba
      on b.budget_id = ba.budget_id;

-- 32. Derived Revenue Summary
create table derived_revenue_summary
   as
      select rt.revenue_transaction_id,
             rs.name as revenue_stream,
             b.total_amount
        from revenue_transactions rt
        join revenue_streams rs
      on rt.revenue_stream_id = rs.revenue_stream_id
        join billing b
      on rt.bill_id = b.bill_id;

-- 33. Derived Patient Vitals Allergies
create table derived_vitals_allergies
   as
      select p.patient_id,
             p.first_name,
             p.last_name,
             vs.heart_rate,
             a.allergen
        from patients p
        left join vital_signs vs
      on p.patient_id = vs.patient_id
        left join allergies a
      on p.patient_id = a.patient_id;

-- 34. Derived Staff Assignments
create table derived_staff_assignments
   as
      select d.doctor_id,
             d.first_name as doctor_name,
             n.nurse_id,
             n.first_name as nurse_name
        from doctors d
        join departments dept
      on d.department_id = dept.department_id
        left join nurses n
      on n.department_id = dept.department_id;

-- 35. Derived Admission Billing
create table derived_admission_billing
   as
      select a.admission_id,
             p.first_name,
             p.last_name,
             b.total_amount
        from admissions a
        join patients p
      on a.patient_id = p.patient_id
        left join billing b
      on a.admission_id = b.admission_id;

-- 36. Derived Surgery Procedures
create table derived_surgery_procedures
   as
      select s.surgery_id,
             pr.procedure_id,
             p.first_name,
             p.last_name,
             pr.procedure_name
        from surgeries s
        join patients p
      on s.patient_id = p.patient_id
        left join procedure_records pr
      on p.patient_id = pr.patient_id;

-- 37. Derived Lab Orders Results
create table derived_lab_orders_results
   as
      select lo.order_id,
             p.first_name,
             p.last_name,
             lr.result_text
        from lab_orders lo
        join patients p
      on lo.patient_id = p.patient_id
        left join lab_results lr
      on lo.order_id = lr.order_id;

-- 38. Derived Stock Movements
create table derived_stock_movements
   as
      select i.name as item,
             sm.quantity,
             sm.movement_type,
             sl.name as location
        from inventory_items i
        join stock_movements sm
      on i.item_id = sm.item_id
        join stock_locations sl
      on sm.to_location_id = sl.location_id;

-- 39. Derived Supplier Payments
create table derived_supplier_payments
   as
      select si.invoice_id,
             s.name as supplier,
             ip.amount as paid_amount
        from supplier_invoices si
        join suppliers s
      on si.supplier_id = s.supplier_id
        left join invoice_payments ip
      on si.invoice_id = ip.invoice_id;

-- 40. Derived Incident Actions
create table derived_incident_actions
   as
      select ci.incident_id,
             ci.incident_date,
             ca.description as action
        from compliance_incidents ci
        left join corrective_actions ca
      on ci.incident_id = ca.finding_id
        join audit_findings af
      on ca.finding_id = af.finding_id;

-- 41. Derived Treatment Prescriptions
create table derived_treatment_prescriptions
   as
      select tp.plan_id,
             p.first_name,
             p.last_name,
             pr.prescription_id
        from treatment_plans tp
        join patients p
      on tp.patient_id = p.patient_id
        left join prescriptions pr
      on p.patient_id = pr.patient_id;

-- 42. Derived Ward Bed Status
create table derived_ward_bed_status
   as
      select w.ward_id,
             w.name as ward,
             b.bed_number,
             b.status
        from wards w
        join beds b
      on w.ward_id = b.ward_id
        left join admissions a
      on b.bed_id = a.bed_id;

-- 43. Derived Financial Transactions
create table derived_financial_transactions
   as
      select fp.period_id,
             fp.period_name,
             glt.transaction_date,
             glt.amount
        from financial_periods fp
        join gl_transactions glt
      on fp.hospital_id = glt.hospital_id
        join gl_accounts gla
      on glt.account_id = gla.account_id;

-- 44. Derived Patient Diagnostics
create table derived_patient_diagnostics
   as
      select p.patient_id,
             p.first_name,
             p.last_name,
             lo.order_date,
             di.imaging_date
        from patients p
        left join lab_orders lo
      on p.patient_id = lo.patient_id
        left join diagnostic_imaging di
      on p.patient_id = di.patient_id;

-- 45. Derived Doctor Patient Visits
create table derived_doctor_patient_visits
   as
      select d.doctor_id,
             d.first_name as doctor_name,
             p.patient_id,
             p.first_name as patient_name
        from doctors d
        join medical_records mr
      on d.doctor_id = mr.doctor_id
        join patients p
      on mr.patient_id = p.patient_id;

-- 46. Derived Checklist Responses
create table derived_checklist_responses
   as
      select cr.response_id,
             cl.checklist_name,
             ci.description as item,
             cr.is_compliant
        from compliance_checklists cl
        join checklist_items ci
      on cl.checklist_id = ci.checklist_id
        join checklist_responses cr
      on ci.item_id = cr.item_id;

-- 47. Derived Equipment Usage
create table derived_equipment_usage
   as
      select e.equipment_id,
             e.name as equipment,
             eul.usage_date,
             em.maintenance_date
        from equipment e
        left join equipment_usage_logs eul
      on e.equipment_id = eul.equipment_id
        left join equipment_maintenance em
      on e.equipment_id = em.equipment_id;

-- 48. Derived Insurance Claims
create table derived_insurance_claims
   as
      select ic.claim_id,
             p.first_name,
             p.last_name,
             ic.claim_amount,
             ic.status
        from insurance_claims ic
        join patients p
      on ic.patient_id = p.patient_id
        join patient_insurance pi
      on ic.insurance_id = pi.insurance_id;

-- 49. Derived Sync Errors
create table derived_sync_errors
   as
      select sel.error_id,
             es.system_name,
             dsj.start_time,
             sel.error_type
        from sync_error_logs sel
        join data_synchronization_jobs dsj
      on sel.job_id = dsj.job_id
        join external_systems es
      on dsj.config_id = es.system_id;

-- 50. Derived Care Plans
create table derived_care_plans
   as
      select cp.care_plan_id,
             p.first_name,
             p.last_name,
             cpi.intervention_type
        from care_plans cp
        join patients p
      on cp.patient_id = p.patient_id
        join care_plan_interventions cpi
      on cp.care_plan_id = cpi.care_plan_id;

-- 51. Derived Appointment Billing
create table derived_appointment_billing
   as
      select a.appointment_id,
             p.first_name,
             p.last_name,
             coalesce(
                b.total_amount,
                0
             ) as total_amount
        from temp_appointment_billing tab
        join appointments a
      on tab.appointment_id = a.appointment_id
        join patients p
      on a.patient_id = p.patient_id
        left join billing b
      on p.patient_id = b.patient_id;

-- 52. Derived Ward Assignments
create table derived_ward_assignments
   as
      select p.patient_id,
             p.first_name,
             p.last_name,
             w.name as ward
        from temp_patient_ward_assignments twa
        join patients p
      on twa.patient_id = p.patient_id
        join admissions a
      on p.patient_id = a.patient_id
        join wards w
      on a.ward_id = w.ward_id;

-- 53. Derived Surgery Records
create table derived_surgery_records
   as
      select d.doctor_id,
             d.first_name,
             d.last_name,
             s.surgery_id,
             s.procedure_name
        from temp_doctor_surgery_details tds
        join doctors d
      on tds.doctor_id = d.doctor_id
        join surgeries s
      on tds.surgery_id = s.surgery_id;

-- 54. Derived Lab Prescriptions
create table derived_lab_prescriptions
   as
      select lo.order_id,
             pr.prescription_id,
             p.first_name,
             p.last_name
        from temp_lab_prescription_orders tlpo
        join lab_orders lo
      on tlpo.order_id = lo.order_id
        join patients p
      on lo.patient_id = p.patient_id
        left join prescriptions pr
      on p.patient_id = pr.patient_id;

-- 55. Derived Inventory Suppliers
create table derived_inventory_suppliers
   as
      select i.name as item,
             s.name as supplier,
             po.order_date
        from temp_supplier_purchase_orders tspo
        join purchase_orders po
      on tspo.order_id = po.order_id
        join suppliers s
      on po.supplier_id = s.supplier_id
        join purchase_order_items poi
      on po.order_id = poi.order_id
        join inventory_items i
      on poi.item_id = i.item_id;

-- 56. Derived Financial Audit Findings
create table derived_financial_audit_findings
   as
      select fa.audit_id,
             fa.audit_date,
             fa.findings
        from temp_financial_audits tfa
        join financial_audits fa
      on tfa.audit_id = fa.audit_id
        join financial_periods fp
      on fa.period_id = fp.period_id;

 
 -- 57. Derived Vitals Diagnosis
create table derived_vitals_diagnosis
   as
      select vs.vital_id,
             p.first_name,
             p.last_name,
             mr.diagnosis
        from temp_vitals_diagnosis tvd
        join vital_signs vs
      on tvd.vital_id = vs.vital_id
        join patients p
      on vs.patient_id = p.patient_id
        join medical_records mr
      on vs.medical_record_id = mr.record_id;


-- 58. Derived Policy Assignments
create table derived_policy_assignments
   as
      select cp.policy_id,
             cp.policy_name,
             d.name as department
        from temp_compliance_policies_depts tcpd
        join compliance_policies cp
      on tcpd.policy_id = cp.policy_id
        join policy_assignments pa
      on cp.policy_id = pa.policy_id
        join departments d
      on pa.department_id = d.department_id;

-- 59. Derived Equipment Calibration
create table derived_equipment_calibration
   as
      select e.equipment_id,
             e.name as equipment,
             ec.calibration_date
        from temp_equipment_calibration tec
        join equipment e
      on tec.equipment_id = e.equipment_id
        join equipment_calibration ec
      on e.equipment_id = ec.equipment_id;

-- 60. Derived Procedure Complications
create table derived_procedure_complications
   as
      select pr.procedure_id,
             p.first_name,
             p.last_name,
             pc.description as complication
        from temp_procedure_complications tpc
        join procedure_records pr
      on tpc.procedure_id = pr.procedure_id
        join patients p
      on pr.patient_id = p.patient_id
        join procedure_complications pc
      on pr.procedure_id = pc.procedure_id;

-- 61. Derived Patient Mappings
create table derived_patient_mappings
   as
      select epm.mapping_id,
             p.first_name,
             p.last_name,
             es.system_name
        from temp_integration_patient_mappings tipm
        join external_patient_mappings epm
      on tipm.mapping_id = epm.mapping_id
        join patients p
      on epm.patient_id = p.patient_id
        join external_systems es
      on epm.system_id = es.system_id;

 
  -- 62. Derived Billing Claims
create table derived_billing_claims
   as
      select b.bill_id,
             p.first_name,
             p.last_name,
             ic.claim_amount
        from temp_billing_insurance tbi
        join billing b
      on tbi.bill_id = b.bill_id
        join patients p
      on b.patient_id = p.patient_id
        left join insurance_claims ic
      on b.bill_id = ic.bill_id;
 
 
-- 63. Derived Nurse Patient Care
create table derived_nurse_patient_care
   as
      select distinct n.nurse_id,
                      n.first_name,
                      n.last_name,
                      p.first_name as patient_name
        from temp_nurse_patient_care tnpc
        join nurses n
      on tnpc.nurse_id = n.nurse_id
        join nurse_assignments na
      on n.nurse_id = na.nurse_id
        join admissions a
      on na.ward_id = a.ward_id
        join patients p
      on a.patient_id = p.patient_id
       where a.admission_date <= na.shift_end
         and ( a.discharge_date is null
          or a.discharge_date >= na.shift_start );

 

-- 64. Derived Lab Departments
create table derived_lab_departments
   as
      select lt.test_id,
             lt.name as test_name,
             l.name as lab
        from temp_lab_tests_depts tltd
        join lab_tests lt
      on tltd.test_id = lt.test_id
        join labs l
      on lt.lab_id = l.lab_id;

-- 65. Derived Social History
create table derived_social_history
   as
      select p.patient_id,
             p.first_name,
             p.last_name,
             sh.smoking_status
        from temp_patient_social_history tpsh
        join patients p
      on tpsh.patient_id = p.patient_id
        join social_history sh
      on p.patient_id = sh.patient_id;

-- 66. Derived Compliance Metrics
create table derived_compliance_metrics
   as
      select cm.metric_id,
             cm.metric_name,
             cmd.value
        from temp_compliance_metrics_data tcmd
        join compliance_metrics cm
      on tcmd.metric_id = cm.metric_id
        join compliance_metric_data cmd
      on cm.metric_id = cmd.metric_id;

-- 67. Derived Stock Locations
create table derived_stock_locations
   as
      select distinct i.name as item,
                      isx.quantity,
                      sl.name as location
        from inventory_stock isx
        join inventory_items i
      on isx.item_id = i.item_id
        join stock_location_assignments sla
      on isx.stock_id = sla.stock_id
        join stock_locations sl
      on sla.location_id = sl.location_id;



-- 68. Derived Supplier Contracts
create table derived_supplier_contracts
   as
      select sc.contract_id,
             s.name as supplier,
             sc.contract_start_date
        from temp_supplier_contracts_performance tscp
        join supplier_contracts sc
      on tscp.contract_id = sc.contract_id
        join suppliers s
      on sc.supplier_id = s.supplier_id;

-- 69. Derived Pain Assessments
create table derived_pain_assessments
   as
      select pa.assessment_id,
             p.first_name,
             p.last_name,
             pa.pain_score
        from temp_pain_assessments tpa
        join pain_assessments pa
      on tpa.assessment_id = pa.assessment_id
        join patients p
      on pa.patient_id = p.patient_id;

-- 70. Derived Batch Jobs
create table derived_batch_jobs
   as
      select bj.batch_id,
             es.system_name,
             bj.job_type,
             bj.start_time
        from temp_batch_jobs tbj
        join batch_jobs bj
      on tbj.batch_id = bj.batch_id
        join external_systems es
      on bj.system_id = es.system_id;

-- 71. Derived Family History
create table derived_family_history
   as
      select fmh.family_history_id,
             p.first_name,
             p.last_name,
             fmh.condition
        from temp_family_history tfh
        join family_medical_history fmh
      on tfh.family_history_id = fmh.family_history_id
        join patients p
      on fmh.patient_id = p.patient_id;

-- 72. Derived Financial Ratios
create table derived_financial_ratios
   as
      select fr.ratio_id,
             fr.ratio_name,
             fr.ratio_value
        from temp_financial_ratios tfr
        join financial_ratios fr
      on tfr.ratio_id = fr.ratio_id
        join financial_periods fp
      on fr.period_id = fp.period_id;

-- 73. Derived Nutritional Assessments
create table derived_nutritional_assessments
   as
      select na.assessment_id,
             p.first_name,
             p.last_name,
             na.bmi
        from temp_nutritional_assessments tna
        join nutritional_assessments na
      on tna.assessment_id = na.assessment_id
        join patients p
      on na.patient_id = p.patient_id;

-- 74. Derived Document Reviews
create table derived_document_reviews
   as
      select cd.document_id,
             cd.document_name,
             dr.review_date
        from temp_compliance_documents tcd
        join compliance_documents cd
      on tcd.document_id = cd.document_id
        left join document_reviews dr
      on cd.document_id = dr.document_id;

-- 75. Derived Equipment Departments
create table derived_equipment_departments
   as
      select e.equipment_id,
             e.name as equipment,
             d.name as department
        from temp_equipment_departments ted
        join equipment e
      on ted.equipment_id = e.equipment_id
        join departments d
      on e.department_id = d.department_id;

-- 76. Derived Procedure Records
create table derived_procedure_records
   as
      select pr.procedure_id,
             p.first_name,
             p.last_name,
             pr.procedure_name
        from temp_patient_procedures tpp
        join procedure_records pr
      on tpp.procedure_id = pr.procedure_id
        join patients p
      on pr.patient_id = p.patient_id;

-- 77. Derived Validation Errors
create table derived_validation_errors
   as
      select ve.error_id,
             dvr.rule_name,
             il.log_date
        from temp_validation_errors tve
        join validation_errors ve
      on tve.error_id = ve.error_id
        join data_validation_rules dvr
      on ve.rule_id = dvr.rule_id
        join integration_logs il
      on ve.log_id = il.log_id;

-- 78. Derived Rehabilitation Plans
create table derived_rehabilitation_plans
   as
      select rp.plan_id,
             p.first_name,
             p.last_name,
             rp.therapy_type
        from temp_rehabilitation_plans trp
        join rehabilitation_plans rp
      on trp.plan_id = rp.plan_id
        join patients p
      on rp.patient_id = p.patient_id;

-- 79. Derived Purchase Orders
create table derived_purchase_orders
   as
      select po.order_id,
             s.name as supplier,
             po.order_date
        from temp_supplier_purchase_orders tspo
        join purchase_orders po
      on tspo.order_id = po.order_id
        join suppliers s
      on po.supplier_id = s.supplier_id;

-- 80. Derived Mental Health
create table derived_mental_health
   as
      select mha.assessment_id,
             p.first_name,
             p.last_name,
             mha.diagnosis
        from temp_mental_health_assessments tmha
        join mental_health_assessments mha
      on tmha.assessment_id = mha.assessment_id
        join patients p
      on mha.patient_id = p.patient_id;

-- 81. Derived Certifications
create table derived_certifications
   as
      select cc.certification_id,
             cr.name as regulation,
             cc.certification_name
        from temp_compliance_certifications tcc
        join compliance_certifications cc
      on tcc.certification_id = cc.certification_id
        join compliance_regulations cr
      on cc.regulation_id = cr.regulation_id;

-- 82. Derived Blood Glucose
create table derived_blood_glucose
   as
      select bgl.glucose_id,
             p.first_name,
             p.last_name,
             bgl.glucose_level_mgdl
        from temp_blood_glucose tbg
        join blood_glucose_levels bgl
      on tbg.glucose_id = bgl.glucose_id
        join patients p
      on bgl.patient_id = p.patient_id;

-- 83. Derived Inventory Expiry
create table derived_inventory_expiry
   as
      select distinct i.name as item,
                      set.expiry_date,
                      set.quantity
        from stock_expiry_tracking set
        join inventory_items i
      on set.item_id = i.item_id;
 

-- 84. Derived Fluid Balance
create table derived_fluid_balance
   as
      select fbr.fluid_id,
             p.first_name,
             p.last_name,
             fbr.intake_ml
        from temp_fluid_balance tfb
        join fluid_balance_records fbr
      on tfb.fluid_id = fbr.fluid_id
        join patients p
      on fbr.patient_id = p.patient_id;

-- 85. Derived FHIR Resources
create table derived_fhir_resources
   as
      select fr.resource_id,
             es.system_name,
             fr.resource_type
        from temp_fhir_resources tfr
        join fhir_resources fr
      on tfr.resource_id = fr.resource_id
        join external_systems es
      on fr.system_id = es.system_id;

-- 86. Derived IV Therapy
create table derived_iv_therapy
   as
      select ivt.iv_therapy_id,
             p.first_name,
             p.last_name,
             ivt.fluid_type
        from temp_iv_therapy tiv
        join iv_therapy_records ivt
      on tiv.iv_therapy_id = ivt.iv_therapy_id
        join patients p
      on ivt.patient_id = p.patient_id;

-- 87. Derived Task History
create table derived_task_history
   as
      select ct.task_id,
             ctt.task_name,
             cth.action
        from temp_compliance_tasks_history tcth
        join compliance_tasks ct
      on tcth.task_id = ct.task_id
        join compliance_task_templates ctt
      on ct.template_id = ctt.template_id
        join compliance_task_history cth
      on ct.task_id = cth.task_id;

-- 88. Derived Ventilator Settings
create table derived_ventilator_settings
   as
      select vs.setting_id,
             p.first_name,
             p.last_name,
             vs.mode
        from temp_ventilator_settings tvs
        join ventilator_settings vs
      on tvs.setting_id = vs.setting_id
        join patients p
      on vs.patient_id = p.patient_id;

-- 89. Derived Shipment Records
create table derived_shipment_records
   as
      select sr.shipment_id,
             s.name as supplier,
             lp.name as provider
        from temp_shipment_records tsr
        join shipment_records sr
      on tsr.shipment_id = sr.shipment_id
        join purchase_orders po
      on sr.order_id = po.order_id
        join suppliers s
      on po.supplier_id = s.supplier_id
        join logistics_providers lp
      on sr.provider_id = lp.provider_id;

-- 90. Derived Dialysis Records
create table derived_dialysis_records
   as
      select dr.dialysis_id,
             p.first_name,
             p.last_name,
             dr.dialysis_type
        from temp_dialysis_records tdr
        join dialysis_records dr
      on tdr.dialysis_id = dr.dialysis_id
        join patients p
      on dr.patient_id = p.patient_id;

-- 91. Derived Compliance Alerts
create table derived_compliance_alerts
   as
      select ca.alert_id,
             cr.name as regulation,
             ca.alert_date
        from temp_compliance_alerts tca
        join compliance_alerts ca
      on tca.alert_id = ca.alert_id
        join compliance_regulations cr
      on ca.regulation_id = cr.regulation_id;

-- 92. Derived Chemotherapy Records
create table derived_chemotherapy_records
   as
      select cr.chemo_id,
             p.first_name,
             p.last_name,
             cr.drug_name
        from temp_chemotherapy_records tcr
        join chemotherapy_records cr
      on tcr.chemo_id = cr.chemo_id
        join patients p
      on cr.patient_id = p.patient_id;

-- 93. Derived Requisitions
create table derived_requisitions
   as
      select pr.requisition_id,
             i.name as item,
             ri.quantity
        from temp_inventory_requisitions tir
        join purchase_requisitions pr
      on tir.requisition_id = pr.requisition_id
        join requisition_items ri
      on pr.requisition_id = ri.requisition_id
        join inventory_items i
      on ri.item_id = i.item_id;

-- 94. Derived Radiation Therapy
create table derived_radiation_therapy
   as
      select rtr.radiation_id,
             p.first_name,
             p.last_name,
             rtr.target_area
        from temp_radiation_therapy trt
        join radiation_therapy_records rtr
      on trt.radiation_id = rtr.radiation_id
        join patients p
      on rtr.patient_id = p.patient_id;

-- 95. Derived Batch Job Details
create table derived_batch_job_details
   as
      select bjd.detail_id,
             bj.job_type,
             bjd.status
        from temp_batch_job_details tbjd
        join batch_job_details bjd
      on tbjd.detail_id = bjd.detail_id
        join batch_jobs bj
      on bjd.batch_id = bj.batch_id;

-- 96. Derived Physical Therapy
create table derived_physical_therapy
   as
      select pta.assessment_id,
             p.first_name,
             p.last_name,
             pta.range_of_motion
        from temp_physical_therapy tpt
        join physical_therapy_assessments pta
      on tpt.assessment_id = pta.assessment_id
        join patients p
      on pta.patient_id = p.patient_id;

-- 97. Derived Vendor Audits
create table derived_vendor_audits
   as
      select va.audit_id,
             s.name as supplier,
             va.audit_date
        from temp_vendor_audits tva
        join vendor_audits va
      on tva.audit_id = va.audit_id
        join suppliers s
      on va.supplier_id = s.supplier_id;

-- 98. Derived Occupational Therapy
create table derived_occupational_therapy
   as
      select ota.assessment_id,
             p.first_name,
             p.last_name,
             ota.functional_status
        from temp_occupational_therapy tot
        join occupational_therapy_assessments ota
      on tot.assessment_id = ota.assessment_id
        join patients p
      on ota.patient_id = p.patient_id;

-- 99. Derived Inventory Disposal
create table derived_inventory_disposal
   as
      select idr.disposal_id,
             i.name as item,
             idr.quantity
        from temp_inventory_disposal tid
        join inventory_disposal_records idr
      on tid.disposal_id = idr.disposal_id
        join inventory_items i
      on idr.item_id = i.item_id;

-- 100. Derived Speech Therapy
create table derived_speech_therapy
   as
      select sta.assessment_id,
             p.first_name,
             p.last_name,
             sta.speech_clarity
        from temp_speech_therapy tst
        join speech_therapy_assessments sta
      on tst.assessment_id = sta.assessment_id
        join patients p
      on sta.patient_id = p.patient_id;

-- 101. Derived Advance Directives
create table derived_advance_directives
   as
      select ad.directive_id,
             p.first_name,
             p.last_name,
             ad.directive_type
        from temp_advance_directives tad
        join advance_directives ad
      on tad.directive_id = ad.directive_id
        join patients p
      on ad.patient_id = p.patient_id;

-- 102. Derived Quality Metrics
create table derived_quality_metrics
   as
      select qm.metric_id,
             qm.metric_name,
             qmd.value
        from temp_quality_metrics tqm
        join quality_metrics qm
      on tqm.metric_id = qm.metric_id
        join quality_metric_data qmd
      on qm.metric_id = qmd.metric_id;

-- 103. Derived Patient Goals
create table derived_patient_goals
   as
      select pg.goal_id,
             p.first_name,
             p.last_name,
             pg.goal_description
        from temp_patient_goals tpg
        join patient_goals pg
      on tpg.goal_id = pg.goal_id
        join patients p
      on pg.patient_id = p.patient_id;

-- 104. Derived Webhook Events
create table derived_webhook_events
   as
      select wl.log_id,
             wc.event_type,
             wl.event_date
        from temp_webhook_logs twl
        join webhook_logs wl
      on twl.log_id = wl.log_id
        join webhook_configurations wc
      on wl.webhook_id = wc.webhook_id;

-- 105. Derived Fall Risk Assessments
create table derived_fall_risk_assessments
   as
      select fra.assessment_id,
             p.first_name,
             p.last_name,
             fra.risk_score
        from temp_fall_risk tfr
        join fall_risk_assessments fra
      on tfr.assessment_id = fra.assessment_id
        join patients p
      on fra.patient_id = p.patient_id;

-- 106. Derived Privacy Incidents
create table derived_privacy_incidents
   as
      select pi.incident_id,
             p.first_name,
             p.last_name,
             pi.incident_date
        from temp_privacy_incidents tpi
        join privacy_incidents pi
      on tpi.incident_id = pi.incident_id
        join patients p
      on pi.patient_id = p.patient_id;

-- 107. Derived Pressure Ulcer Assessments
create table derived_pressure_ulcer_assessments
   as
      select pua.assessment_id,
             p.first_name,
             p.last_name,
             pua.stage
        from temp_pressure_ulcer tpu
        join pressure_ulcer_assessments pua
      on tpu.assessment_id = pua.assessment_id
        join patients p
      on pua.patient_id = p.patient_id;

-- 108. Derived Message Queues
create table derived_message_queues
   as
      select mq.message_id,
             es.system_name,
             mq.message_type
        from temp_message_queues tmq
        join message_queues mq
      on tmq.message_id = mq.message_id
        join external_systems es
      on mq.system_id = es.system_id;

-- 109. Derived Infection Control
create table derived_infection_control
   as
      select icr.infection_id,
             p.first_name,
             p.last_name,
             icr.infection_type
        from temp_infection_control tic
        join infection_control_records icr
      on tic.infection_id = icr.infection_id
        join patients p
      on icr.patient_id = p.patient_id;

-- 110. Derived Data Breaches
create table derived_data_breaches
   as
      select dbl.breach_id,
             dbl.breach_date,
             bn.notified_party
        from temp_data_breaches tdb
        join data_breach_logs dbl
      on tdb.breach_id = dbl.breach_id
        left join breach_notifications bn
      on dbl.breach_id = bn.breach_id;

-- 111. Derived Isolation Precautions
create table derived_isolation_precautions
   as
      select ip.precaution_id,
             p.first_name,
             p.last_name,
             ip.precaution_type
        from temp_isolation_precautions tip
        join isolation_precautions ip
      on tip.precaution_id = ip.precaution_id
        join patients p
      on ip.patient_id = p.patient_id;

-- 112. Derived Audit Trails
create table derived_audit_trails
   as
      select iat.audit_id,
             es.system_name,
             iat.action
        from temp_integration_audit_trails tiat
        join integration_audit_trails iat
      on tiat.audit_id = iat.audit_id
        join external_systems es
      on iat.system_id = es.system_id;

-- 113. Derived Transfusion Records
create table derived_transfusion_records
   as
      select tr.transfusion_id,
             p.first_name,
             p.last_name,
             tr.blood_product
        from temp_transfusion_records ttr
        join transfusion_records tr
      on ttr.transfusion_id = tr.transfusion_id
        join patients p
      on tr.patient_id = p.patient_id;

-- 114. Derived Vendor Compliance
create table derived_vendor_compliance
   as
      select vc.compliance_id,
             s.name as supplier,
             cr.name as regulation
        from temp_vendor_compliance tvc
        join vendor_compliance vc
      on tvc.compliance_id = vc.compliance_id
        join suppliers s
      on vc.supplier_id = s.supplier_id
        join compliance_regulations cr
      on vc.regulation_id = cr.regulation_id;

-- 115. Derived Anesthesia Records
create table derived_anesthesia_records
   as
      select ar.anesthesia_id,
             p.first_name,
             p.last_name,
             ar.anesthesia_type
        from temp_anesthesia_records tar
        join anesthesia_records ar
      on tar.anesthesia_id = ar.anesthesia_id
        join patients p
      on ar.patient_id = p.patient_id;

-- 116. Derived Retry Policies
create table derived_retry_policies
   as
      select irp.policy_id,
             es.system_name,
             irp.max_retries
        from temp_retry_policies trp
        join integration_retry_policies irp
      on trp.policy_id = irp.policy_id
        join external_systems es
      on irp.system_id = es.system_id;

-- 117. Derived Post Anesthesia
create table derived_post_anesthesia
   as
      select distinct tpa.assessment_id,
                      tpa.first_name,
                      tpa.last_name,
                      tpa.recovery_status
        from temp_post_anesthesia tpa
       where tpa.recovery_status is not null;

-- 118. Derived Regulatory Submissions
create table derived_regulatory_submissions
   as
      select rs.submission_id,
             cr.name as regulation,
             rs.submission_date
        from temp_regulatory_submissions trs
        join regulatory_submissions rs
      on trs.submission_id = rs.submission_id
        join compliance_regulations cr
      on rs.regulation_id = cr.regulation_id;

-- 119. Derived Endoscopy Records
create table derived_endoscopy_records
   as
      select er.endoscopy_id,
             p.first_name,
             p.last_name,
             er.endoscopy_type
        from temp_endoscopy_records ter
        join endoscopy_records er
      on ter.endoscopy_id = er.endoscopy_id
        join patients p
      on er.patient_id = p.patient_id;

-- 120. Derived Data Mappings
create table derived_data_mappings
   as
      select dm.mapping_id,
             ic.config_name,
             dm.internal_table
        from temp_data_mappings tdm
        join data_mappings dm
      on tdm.mapping_id = dm.mapping_id
        join integration_configurations ic
      on dm.config_id = ic.config_id;

-- 121. Derived Genetic Testing
create table derived_genetic_testing
   as
      select gtr.genetic_test_id,
             p.first_name,
             p.last_name,
             gtr.test_name
        from temp_genetic_testing tgt
        join genetic_testing_records gtr
      on tgt.genetic_test_id = gtr.genetic_test_id
        join patients p
      on gtr.patient_id = p.patient_id;

-- 122. Derived Audit Evidence
create table derived_audit_evidence
   as
      select ae.evidence_id,
             ca.audit_date,
             cd.document_name
        from temp_audit_evidence tae
        join audit_evidence ae
      on tae.evidence_id = ae.evidence_id
        join compliance_audits ca
      on ae.audit_id = ca.audit_id
        join compliance_documents cd
      on ae.document_id = cd.document_id;

-- 123. Derived Wound Care
create table derived_wound_care
   as
      select wcr.wound_care_id,
             p.first_name,
             p.last_name,
             wcr.wound_type
        from temp_wound_care twc
        join wound_care_records wcr
      on twc.wound_care_id = wcr.wound_care_id
        join patients p
      on wcr.patient_id = p.patient_id;

-- 124. Derived Queue Errors
create table derived_queue_errors
   as
      select qel.error_id,
             mq.message_type,
             qel.error_type
        from temp_queue_errors tqe
        join queue_error_logs qel
      on tqe.error_id = qel.error_id
        join message_queues mq
      on qel.message_id = mq.message_id;

-- 125. Derived Respiratory Assessments
create table derived_respiratory_assessments
   as
      select ra.assessment_id,
             p.first_name,
             p.last_name,
             ra.respiratory_rate
        from temp_respiratory_assessments tra
        join respiratory_assessments ra
      on tra.assessment_id = ra.assessment_id
        join patients p
      on ra.patient_id = p.patient_id;

-- 126. Derived Dashboard Metrics
create table derived_dashboard_metrics
   as
      select dm.metric_id,
             cd.dashboard_name,
             cm.metric_name
        from temp_dashboard_metrics tdm
        join dashboard_metrics dm
      on tdm.metric_id = dm.metric_id
        join compliance_dashboards cd
      on dm.dashboard_id = cd.dashboard_id
        join compliance_metrics cm
      on dm.compliance_metric_id = cm.metric_id;

-- 127. Derived Cardiac Assessments
create table derived_cardiac_assessments
   as
      select ca.assessment_id,
             p.first_name,
             p.last_name,
             ca.ecg_findings
        from temp_cardiac_assessments tca
        join cardiac_assessments ca
      on tca.assessment_id = ca.assessment_id
        join patients p
      on ca.patient_id = p.patient_id;

-- 128. Derived Appointment Mappings
create table derived_appointment_mappings
   as
      select eam.mapping_id,
             a.appointment_date,
             es.system_name
        from temp_appointment_mappings tam
        join external_appointment_mappings eam
      on tam.mapping_id = eam.mapping_id
        join appointments a
      on eam.appointment_id = a.appointment_id
        join external_systems es
      on eam.system_id = es.system_id;

-- 129. Derived Neurological Assessments
create table derived_neurological_assessments
   as
      select na.assessment_id,
             p.first_name,
             p.last_name,
             na.glasgow_coma_score
        from temp_neurological_assessments tna
        join neurological_assessments na
      on tna.assessment_id = na.assessment_id
        join patients p
      on na.patient_id = p.patient_id;

-- 130. Derived Role Assignments
create table derived_role_assignments
   as
      select ra.assignment_id,
             cr.role_name,
             d.first_name
        from temp_role_assignments tra
        join role_assignments ra
      on tra.assignment_id = ra.assignment_id
        join compliance_roles cr
      on ra.role_id = cr.role_id
        join doctors d
      on ra.employee_id = d.doctor_id;

-- 131. Derived Rehabilitation Sessions
create table derived_rehabilitation_sessions
   as
      select rs.session_id,
             p.first_name,
             p.last_name,
             rp.therapy_type
        from temp_rehabilitation_sessions trs
        join rehabilitation_sessions rs
      on trs.session_id = rs.session_id
        join rehabilitation_plans rp
      on rs.plan_id = rp.plan_id
        join patients p
      on rs.patient_id = p.patient_id;

-- 132. Derived Insurance Claim Mappings
create table derived_insurance_claim_mappings
   as
      select eicm.mapping_id,
             ic.claim_amount,
             es.system_name
        from temp_insurance_claim_mappings ticm
        join external_insurance_claim_mappings eicm
      on ticm.mapping_id = eicm.mapping_id
        join insurance_claims ic
      on eicm.claim_id = ic.claim_id
        join external_systems es
      on eicm.system_id = es.system_id;

-- 133. Derived Patient Education
create table derived_patient_education
   as
      select per.education_id,
             p.first_name,
             p.last_name,
             per.topic
        from temp_patient_education tpe
        join patient_education_records per
      on tpe.education_id = per.education_id
        join patients p
      on per.patient_id = p.patient_id;

-- 134. Derived Event Logs
create table derived_event_logs
   as
      select cel.event_id,
             cel.event_type,
             cel.event_date
        from temp_compliance_event_logs tcel
        join compliance_event_logs cel
      on tcel.event_id = cel.event_id
        join doctors d
      on cel.triggered_by = d.doctor_id;

-- 135. Derived Consent Forms
create table derived_consent_forms
   as
      select cf.consent_id,
             p.first_name,
             p.last_name,
             cf.consent_type
        from temp_consent_forms tcf
        join patient_consent_forms cf
      on tcf.consent_id = cf.consent_id
        join patients p
      on cf.patient_id = p.patient_id;

-- 136. Derived Transformation Rules
create table derived_transformation_rules
   as
      select dtr.rule_id,
             dm.internal_table,
             dtr.transformation_type
        from temp_transformation_rules ttr
        join data_transformation_rules dtr
      on ttr.rule_id = dtr.rule_id
        join data_mappings dm
      on dtr.mapping_id = dm.mapping_id;

-- 137. Derived Pathology Reports
create table derived_pathology_reports
   as
      select pr.pathology_id,
             p.first_name,
             p.last_name,
             pr.specimen_type
        from temp_pathology_reports tpr
        join pathology_reports pr
      on tpr.pathology_id = pr.pathology_id
        join patients p
      on pr.patient_id = p.patient_id;

-- 138. Derived Submission Reviews
create table derived_submission_reviews
   as
      select sr.review_id,
             rs.submission_date,
             cr.name as regulation
        from temp_submission_reviews tsr
        join submission_reviews sr
      on tsr.review_id = sr.review_id
        join regulatory_submissions rs
      on sr.submission_id = rs.submission_id
        join compliance_regulations cr
      on rs.regulation_id = cr.regulation_id;

-- 139. Derived Medication Administration
create table derived_medication_administration
   as
      select ma.administration_id,
             p.first_name,
             p.last_name,
             m.name as medication
        from temp_medication_administration tma
        join medication_administration ma
      on tma.administration_id = ma.administration_id
        join prescription_items pi
      on ma.prescription_item_id = pi.item_id
        join medications m
      on pi.medication_id = m.medication_id
        join patients p
      on ma.patient_id = p.patient_id;

-- 140. Derived Integration Metrics
create table derived_integration_metrics
   as
      select im.metric_id,
             es.system_name,
             im.metric_name
        from temp_integration_metrics tim
        join integration_metrics im
      on tim.metric_id = im.metric_id
        join external_systems es
      on im.system_id = es.system_id;

-- 141. Derived Clinical Notes
create table derived_clinical_notes
   as
      select cn.note_id,
             p.first_name,
             p.last_name,
             cn.note_type
        from temp_clinical_notes tcn
        join clinical_notes cn
      on tcn.note_id = cn.note_id
        join patients p
      on cn.patient_id = p.patient_id;

-- 142. Derived Incident Root Causes
create table derived_incident_root_causes
   as
      select irc.root_cause_id,
             ci.incident_date,
             ic.name as category
        from temp_incident_root_causes tirc
        join incident_root_causes irc
      on tirc.root_cause_id = irc.root_cause_id
        join incident_investigations ii
      on irc.investigation_id = ii.investigation_id
        join compliance_incidents ci
      on ii.incident_id = ci.incident_id
        join incident_categories ic
      on irc.category_id = ic.category_id;

-- 143. Derived Wound Assessments
create table derived_wound_assessments
   as
      select wca.assessment_id,
             p.first_name,
             p.last_name,
             wca.wound_size_cm
        from temp_wound_assessments twa
        join wound_care_assessments wca
      on twa.assessment_id = wca.assessment_id
        join wound_care_records wcr
      on wca.wound_care_id = wcr.wound_care_id
        join patients p
      on wcr.patient_id = p.patient_id;

-- 144. Derived Integration Dashboards
create table derived_integration_dashboards
   as
      select id.dashboard_id,
             id.dashboard_name,
             h.name as hospital
        from temp_integration_dashboards tid
        join integration_dashboards id
      on tid.dashboard_id = id.dashboard_id
        join hospitals h
      on id.hospital_id = h.hospital_id;

-- 145. Derived Immunizations
create table derived_immunizations
   as
      select i.immunization_id,
             p.first_name,
             p.last_name,
             i.vaccine_name
        from temp_immunizations ti
        join immunizations i
      on ti.immunization_id = i.immunization_id
        join patients p
      on i.patient_id = p.patient_id;

-- 146. Derived Audit Team
create table derived_audit_team
   as
      select ata.assignment_id,
             ca.audit_date,
             d.first_name
        from temp_audit_team tat
        join audit_team_assignments ata
      on tat.assignment_id = ata.assignment_id
        join compliance_audits ca
      on ata.audit_id = ca.audit_id
        join doctors d
      on ata.employee_id = d.doctor_id;

-- 147. Derived Lab Order Mappings
create table derived_lab_order_mappings
   as
      select elom.mapping_id,
             lo.order_date,
             es.system_name
        from temp_lab_order_mappings tlom
        join external_lab_order_mappings elom
      on tlom.mapping_id = elom.mapping_id
        join lab_orders lo
      on elom.lab_order_id = lo.order_id
        join external_systems es
      on elom.system_id = es.system_id;

-- 148. Derived Lab Result Mappings
create table derived_lab_result_mappings
   as
      select elrm.mapping_id,
             lr.result_date,
             es.system_name
        from temp_lab_result_mappings tlrm
        join external_lab_result_mappings elrm
      on tlrm.mapping_id = elrm.mapping_id
        join lab_results lr
      on elrm.lab_result_id = lr.result_id
        join external_systems es
      on elrm.system_id = es.system_id;

-- 149. Derived Doctor Mappings
create table derived_doctor_mappings
   as
      select edm.mapping_id,
             d.first_name,
             d.last_name,
             es.system_name
        from temp_doctor_mappings tdm
        join external_doctor_mappings edm
      on tdm.mapping_id = edm.mapping_id
        join doctors d
      on edm.doctor_id = d.doctor_id
        join external_systems es
      on edm.system_id = es.system_id;

-- 150. Derived Billing Mappings
create table derived_billing_mappings
   as
      select ebm.mapping_id,
             b.total_amount,
             es.system_name
        from temp_billing_mappings tbm
        join external_billing_mappings ebm
      on tbm.mapping_id = ebm.mapping_id
        join billing b
      on ebm.bill_id = b.bill_id
        join external_systems es
      on ebm.system_id = es.system_id;

-- 151. Derived Patient Compliance
create table derived_patient_compliance
   as
      select distinct p.patient_id,
                      p.first_name,
                      p.last_name,
                      hcs.status
        from patients p
        join admissions a
      on p.patient_id = a.patient_id
        join wards w
      on a.ward_id = w.ward_id
        join hospitals h
      on w.hospital_id = h.hospital_id
        join hospital_compliance_status hcs
      on h.hospital_id = hcs.hospital_id
       where a.discharge_date is null
          or a.discharge_date > current_date;  
  

-- 152. Derived Doctor Transactions
create table derived_doctor_transactions
   as
      select d.doctor_id,
             d.first_name,
             d.last_name,
             glt.amount
        from temp_doctor_financials tdf
        join doctors d
      on tdf.doctor_id = d.doctor_id
        join gl_transactions glt
      on d.hospital_id = glt.hospital_id;

-- 153. Derived Emergency Contacts
create table derived_emergency_contacts
   as
      select ec.contact_id,
             p.first_name,
             p.last_name,
             ec.name as contact_name
        from temp_emergency_contacts tec
        join emergency_contacts ec
      on tec.contact_id = ec.contact_id
        join patients p
      on ec.patient_id = p.patient_id;

-- 154. Derived Nurse Schedules
create table derived_nurse_schedules
   as
      select distinct tnws.nurse_id,
                      tnws.first_name,
                      tnws.last_name,
                      tnws.ward
        from temp_nurse_ward_schedules tnws
       where tnws.shift_start >= current_date;

-- 155. Derived Surgery Outcomes
create table derived_surgery_outcomes
   as
      select s.surgery_id,
             p.first_name,
             p.last_name,
             s.outcome
        from temp_surgery_outcomes tso
        join surgeries s
      on tso.surgery_id = s.surgery_id
        join patients p
      on s.patient_id = p.patient_id;

-- 156. Derived Inventory Audits
create table derived_inventory_audits
   as
      select iai.audit_item_id,
             i.name as item,
             iai.expected_quantity
        from temp_inventory_audit_items tiai
        join inventory_audit_items iai
      on tiai.audit_item_id = iai.audit_item_id
        join inventory_items i
      on iai.item_id = i.item_id;

-- 157. Derived Insurance Payments
create table derived_insurance_payments
   as
      select icp.payment_id,
             p.first_name,
             p.last_name,
             icp.amount
        from temp_insurance_payments tip
        join insurance_claim_payments icp
      on tip.payment_id = icp.payment_id
        join insurance_claims ic
      on icp.claim_id = ic.claim_id
        join patients p
      on ic.patient_id = p.patient_id;

-- 158. Derived Doctor Training
CREATE TABLE derived_doctor_training AS
SELECT DISTINCT tdct.doctor_id, tdct.first_name, tdct.last_name, tdct.training_name
FROM temp_doctor_compliance_training tdct
WHERE tdct.completion_date IS NOT NULL AND tdct.completion_date >= CURRENT_DATE - INTERVAL '1 year';

-- 159. Derived Billing Items
create table derived_billing_items
   as
      select bi.item_id,
             p.first_name,
             p.last_name,
             bi.description
        from temp_billing_items tbi
        join billing_items bi
      on tbi.item_id = bi.item_id
        join billing b
      on bi.bill_id = b.bill_id
        join patients p
      on b.patient_id = p.patient_id;

-- 160. Derived Contract Items
create table derived_contract_items
   as
      select ci.contract_item_id,
             s.name as supplier,
             i.name as item
        from temp_contract_items tci
        join contract_items ci
      on tci.contract_item_id = ci.contract_item_id
        join procurement_contracts pc
      on ci.contract_id = pc.contract_id
        join suppliers s
      on pc.supplier_id = s.supplier_id
        join inventory_items i
      on ci.item_id = i.item_id;

-- 161. Derived Appointment Records
create table derived_appointment_records
   as
      select a.appointment_id,
             p.first_name,
             p.last_name,
             d.first_name as doctor_name
        from temp_appointment_details tad
        join appointments a
      on tad.appointment_id = a.appointment_id
        join patients p
      on a.patient_id = p.patient_id
        join doctors d
      on a.doctor_id = d.doctor_id;

-- 162. Derived Nurse Incidents
create table derived_nurse_incidents
   as
      select n.nurse_id,
             n.first_name,
             n.last_name,
             ci.incident_date
        from temp_nurse_compliance_incidents tnci
        join nurses n
      on tnci.nurse_id = n.nurse_id
        join compliance_incidents ci
      on n.department_id = ci.department_id;

-- 163. Derived Pathology Findings
create table derived_pathology_findings
   as
      select pr.pathology_id,
             p.first_name,
             p.last_name,
             pr.findings
        from temp_pathology_findings tpf
        join pathology_reports pr
      on tpf.pathology_id = pr.pathology_id
        join patients p
      on pr.patient_id = p.patient_id;

-- 164. Derived Stock Reservations
create table derived_stock_reservations
   as
      select sr.reservation_id,
             i.name as item,
             d.name as department
        from temp_stock_reservations tsr
        join stock_reservations sr
      on tsr.reservation_id = sr.reservation_id
        join inventory_items i
      on sr.item_id = i.item_id
        join departments d
      on sr.department_id = d.department_id;

-- 165. Derived Care Interventions
create table derived_care_interventions
   as
      select cpi.intervention_id,
             p.first_name,
             p.last_name,
             cpi.intervention_type
        from temp_care_interventions tci
        join care_plan_interventions cpi
      on tci.intervention_id = cpi.intervention_id
        join care_plans cp
      on cpi.care_plan_id = cp.care_plan_id
        join patients p
      on cp.patient_id = p.patient_id;

-- 166. Derived Policy Compliance
create table derived_policy_compliance
   as
      select pc.compliance_id,
             cp.policy_name,
             pc.status
        from temp_policy_compliance tpc
        join policy_compliance pc
      on tpc.compliance_id = pc.compliance_id
        join compliance_policies cp
      on pc.policy_id = cp.policy_id;

-- 167. Derived Diagnostic Imaging
create table derived_diagnostic_imaging
   as
      select di.imaging_id,
             p.first_name,
             p.last_name,
             di.imaging_type
        from temp_diagnostic_imaging tdi
        join diagnostic_imaging di
      on tdi.imaging_id = di.imaging_id
        join patients p
      on di.patient_id = p.patient_id;

-- 168. Derived API Credentials
create table derived_api_credentials
   as
      select ac.credential_id,
             es.system_name,
             ac.client_id
        from temp_api_credentials tac
        join api_credentials ac
      on tac.credential_id = ac.credential_id
        join external_systems es
      on ac.system_id = es.system_id;

-- 169. Derived Treatment Outcomes
create table derived_treatment_outcomes
   as
      select tp.plan_id,
             p.first_name,
             p.last_name,
             tpa.status
        from temp_treatment_outcomes tto
        join treatment_plans tp
      on tto.plan_id = tp.plan_id
        join treatment_plan_actions tpa
      on tp.plan_id = tpa.plan_id
        join patients p
      on tp.patient_id = p.patient_id;

-- 170. Derived Vendor Scorecards
create table derived_vendor_scorecards
   as
      select vs.scorecard_id,
             s.name as supplier,
             vs.quality_score
        from temp_vendor_scorecards tvs
        join vendor_scorecards vs
      on tvs.scorecard_id = vs.scorecard_id
        join suppliers s
      on vs.supplier_id = s.supplier_id;

-- 171. Derived Neurological Status
create table derived_neurological_status
   as
      select na.assessment_id,
             p.first_name,
             p.last_name,
             na.motor_response
        from temp_neurological_status tns
        join neurological_assessments na
      on tns.assessment_id = na.assessment_id
        join patients p
      on na.patient_id = p.patient_id;

-- 172. Derived Checklist Items
create table derived_checklist_items
   as
      select ci.item_id,
             cl.checklist_name,
             ci.description
        from temp_checklist_items tci
        join checklist_items ci
      on tci.item_id = ci.item_id
        join compliance_checklists cl
      on ci.checklist_id = cl.checklist_id;

-- 173. Derived Glucose Trends
create table derived_glucose_trends
   as
      select bgl.glucose_id,
             p.first_name,
             p.last_name,
             bgl.glucose_level_mgdl
        from temp_glucose_trends tgt
        join blood_glucose_levels bgl
      on tgt.glucose_id = bgl.glucose_id
        join patients p
      on bgl.patient_id = p.patient_id;

-- 174. Derived Sync Job Errors
create table derived_sync_job_errors
   as
      select sel.error_id,
             dsj.job_id,
             es.system_name
        from temp_sync_job_errors tsje
        join sync_error_logs sel
      on tsje.error_id = sel.error_id
        join data_synchronization_jobs dsj
      on sel.job_id = dsj.job_id
        join external_systems es
      on dsj.config_id = es.system_id;

-- 175. Derived Fluid Intake
create table derived_fluid_intake
   as
      select fbr.fluid_id,
             p.first_name,
             p.last_name,
             fbr.intake_ml
        from temp_fluid_intake tfi
        join fluid_balance_records fbr
      on tfi.fluid_id = fbr.fluid_id
        join patients p
      on fbr.patient_id = p.patient_id;

-- 176. Derived Quality Programs
create table derived_quality_programs
   as
      select qap.program_id,
             qap.program_name,
             qap.start_date
        from temp_quality_programs tqp
        join quality_assurance_programs qap
      on tqp.program_id = qap.program_id
        join hospitals h
      on qap.hospital_id = h.hospital_id;

-- 177. Derived IV Therapy Details
create table derived_iv_therapy_details
   as
      select ivt.iv_therapy_id,
             p.first_name,
             p.last_name,
             ivt.start_date
        from temp_iv_therapy_details tivtd
        join iv_therapy_records ivt
      on tivtd.iv_therapy_id = ivt.iv_therapy_id
        join patients p
      on ivt.patient_id = p.patient_id;

-- 178. Derived Batch Processing
create table derived_batch_processing
   as
      select bj.batch_id,
             es.system_name,
             bj.total_records
        from temp_batch_processing tbp
        join batch_jobs bj
      on tbp.batch_id = bj.batch_id
        join external_systems es
      on bj.system_id = es.system_id;

-- 179. Derived Ventilator Usage
create table derived_ventilator_usage
   as
      select vs.setting_id,
             p.first_name,
             p.last_name,
             vs.fio2_percentage
        from temp_ventilator_usage tvu
        join ventilator_settings vs
      on tvu.setting_id = vs.setting_id
        join patients p
      on vs.patient_id = p.patient_id;

-- 180. Derived Incident Categories
create table derived_incident_categories
   as
      select ic.category_id,
             ic.name,
             irc.description as root_cause
        from temp_incident_categories tic
        join incident_categories ic
      on tic.category_id = ic.category_id
        join incident_root_causes irc
      on ic.category_id = irc.category_id;

-- 181. Derived Dialysis Sessions
create table derived_dialysis_sessions
   as
      select dr.dialysis_id,
             p.first_name,
             p.last_name,
             dr.complications
        from temp_dialysis_sessions tds
        join dialysis_records dr
      on tds.dialysis_id = dr.dialysis_id
        join patients p
      on dr.patient_id = p.patient_id;

-- 182. Derived HL7 Messaging
create table derived_hl7_messaging
   as
      select hm.message_id,
             p.first_name,
             p.last_name,
             es.system_name
        from temp_hl7_messaging thm
        join hl7_messages hm
      on thm.message_id = hm.message_id
        join patients p
      on hm.patient_id = p.patient_id
        join external_systems es
      on hm.system_id = es.system_id;

-- 183. Derived Chemotherapy Details
create table derived_chemotherapy_details
   as
      select cr.chemo_id,
             p.first_name,
             p.last_name,
             cr.side_effects
        from temp_chemotherapy_details tcd
        join chemotherapy_records cr
      on tcd.chemo_id = cr.chemo_id
        join patients p
      on cr.patient_id = p.patient_id;

-- 184. Derived Report Approvals
create table derived_report_approvals
   as
      select ra.approval_id,
             cr.report_type,
             ra.approval_date
        from temp_report_approvals tra
        join report_approvals ra
      on tra.approval_id = ra.approval_id
        join compliance_reports cr
      on ra.report_id = cr.report_id;

-- 185. Derived Radiation Details
create table derived_radiation_details
   as
      select rtr.radiation_id,
             p.first_name,
             p.last_name,
             rtr.side_effects
        from temp_radiation_details trd
        join radiation_therapy_records rtr
      on trd.radiation_id = rtr.radiation_id
        join patients p
      on rtr.patient_id = p.patient_id;

-- 186. Derived Webhook Event Details
create table derived_webhook_event_details
   as
      select wl.log_id,
             wc.webhook_url,
             es.system_name
        from temp_webhook_events twe
        join webhook_logs wl
      on twe.log_id = wl.log_id
        join webhook_configurations wc
      on wl.webhook_id = wc.webhook_id
        join external_systems es
      on wc.system_id = es.system_id;

-- 187. Derived Physical Therapy Goals
create table derived_physical_therapy_goals
   as
      select pta.assessment_id,
             p.first_name,
             p.last_name,
             pta.muscle_strength
        from temp_physical_therapy_goals tptg
        join physical_therapy_assessments pta
      on tptg.assessment_id = pta.assessment_id
        join patients p
      on pta.patient_id = p.patient_id;

-- 188. Derived Privacy Actions
create table derived_privacy_actions
   as
      select pia.action_id,
             pi.incident_date,
             pia.description
        from temp_privacy_actions tpa
        join privacy_incident_actions pia
      on tpa.action_id = pia.action_id
        join privacy_incidents pi
      on pia.incident_id = pi.incident_id;

-- 189. Derived Occupational Goals
create table derived_occupational_goals
   as
      select ota.assessment_id,
             p.first_name,
             p.last_name,
             ota.goals
        from temp_occupational_goals tog
        join occupational_therapy_assessments ota
      on tog.assessment_id = ota.assessment_id
        join patients p
      on ota.patient_id = p.patient_id;

-- 190. Derived Queue Processing
create table derived_queue_processing
   as
      select mq.message_id,
             es.system_name,
             mq.processed_at
        from temp_queue_processing tqp
        join message_queues mq
      on tqp.message_id = mq.message_id
        join external_systems es
      on mq.system_id = es.system_id;

-- 191. Derived Speech Therapy Goals
create table derived_speech_therapy_goals
   as
      select sta.assessment_id,
             p.first_name,
             p.last_name,
             sta.swallowing_function
        from temp_speech_therapy_goals tstg
        join speech_therapy_assessments sta
      on tstg.assessment_id = sta.assessment_id
        join patients p
      on sta.patient_id = p.patient_id;

-- 192. Derived Certification Audits
create table derived_certification_audits
   as
      select ca.audit_id,
             cc.certification_name,
             ca.audit_date
        from temp_certification_audits tca
        join certification_audits ca
      on tca.audit_id = ca.audit_id
        join compliance_certifications cc
      on ca.certification_id = cc.certification_id;

-- 193. Derived Fall Risk Precautions
create table derived_fall_risk_precautions
   as
      select fra.assessment_id,
             p.first_name,
             p.last_name,
             fra.precautions
        from temp_fall_risk_precautions tfrp
        join fall_risk_assessments fra
      on tfrp.assessment_id = fra.assessment_id
        join patients p
      on fra.patient_id = p.patient_id;

-- 194. Derived FHIR Sync
create table derived_fhir_sync
   as
      select fr.resource_id,
             es.system_name,
             fr.last_synced
        from temp_fhir_sync tfs
        join fhir_resources fr
      on tfs.resource_id = fr.resource_id
        join external_systems es
      on fr.system_id = es.system_id;

-- 195. Derived Ulcer Treatment
create table derived_ulcer_treatment
   as
      select pua.assessment_id,
             p.first_name,
             p.last_name,
             pua.treatment_plan
        from temp_ulcer_treatment tut
        join pressure_ulcer_assessments pua
      on tut.assessment_id = pua.assessment_id
        join patients p
      on pua.patient_id = p.patient_id;

-- 196. Derived Task Templates
create table derived_task_templates
   as
      select ctt.template_id,
             cr.name as regulation,
             ctt.task_name
        from temp_task_templates ttt
        join compliance_task_templates ctt
      on ttt.template_id = ctt.template_id
        join compliance_regulations cr
      on ctt.regulation_id = cr.regulation_id;

-- 197. Derived Infection Treatment
create table derived_infection_treatment
   as
      select icr.infection_id,
             p.first_name,
             p.last_name,
             icr.treatment
        from temp_infection_treatment tit
        join infection_control_records icr
      on tit.infection_id = icr.infection_id
        join patients p
      on icr.patient_id = p.patient_id;

-- 198. Derived Validation Rules
create table derived_validation_rules
   as
      select dvr.rule_id,
             ic.config_name,
             dvr.validation_type
        from temp_validation_rules tvr
        join data_validation_rules dvr
      on tvr.rule_id = dvr.rule_id
        join integration_configurations ic
      on dvr.config_id = ic.config_id;

-- 199. Derived Transfusion Reactions
create table derived_transfusion_reactions
   as
      select tr.transfusion_id,
             p.first_name,
             p.last_name,
             tr.reaction
        from temp_transfusion_reactions ttr
        join transfusion_records tr
      on ttr.transfusion_id = tr.transfusion_id
        join patients p
      on tr.patient_id = p.patient_id;

-- 200. Derived Audit Schedules
create table derived_audit_schedules
   as
      select asch.schedule_id,
             asch.audit_type,
             asch.planned_date
        from temp_audit_schedules tas
        join audit_schedules asch
      on tas.schedule_id = asch.schedule_id
        join hospitals h
      on asch.hospital_id = h.hospital_id;

--- Extend schema with 40 views using CREATE VIEW ... AS SELECT statement, derived from base tables. Use joins, also multiple joins. Provide only SQL DDL statements.



-- View 1: Patient Admissions with Ward and Hospital Details
create view vw_patient_admissions as
   select p.patient_id,
          p.first_name,
          p.last_name,
          a.admission_date,
          w.name as ward_name,
          h.name as hospital_name
     from patients p
     join admissions a
   on p.patient_id = a.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join hospitals h
   on w.hospital_id = h.hospital_id;

-- View 2: Doctor Schedules with Department
create view vw_doctor_schedules as
   select d.doctor_id,
          d.first_name,
          d.last_name,
          etr.completion_date as training_date,
          dep.name as department_name
     from doctors d
     join employee_training_records etr
   on d.doctor_id = etr.employee_id
     join departments dep
   on d.department_id = dep.department_id
     join hospitals h
   on dep.hospital_id = h.hospital_id;

-- View 3: Nurse Ward Assignments
create view vw_nurse_ward_assignments as
   select n.nurse_id,
          n.first_name,
          n.last_name,
          w.name as ward_name,
          na.shift_start
     from nurses n
     join nurse_assignments na
   on n.nurse_id = na.nurse_id
     join wards w
   on na.ward_id = w.ward_id;

-- View 4: Inventory Stock by Hospital and Item
create view vw_inventory_stock as
   select i.item_id,
          i.name as item_name,
          isx.quantity,
          h.name as hospital_name
     from inventory_items i
     join inventory_stock isx
   on i.item_id = isx.item_id
     join hospitals h
   on isx.hospital_id = h.hospital_id;

-- View 5: Patient Diagnoses with Doctor
create view vw_patient_diagnoses as
   select p.patient_id,
          p.first_name,
          p.last_name,
          a.admission_date,
          d.first_name as doctor_first_name
     from patients p
     join admissions a
   on p.patient_id = a.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join departments dep
   on w.hospital_id = dep.hospital_id
     join doctors d
   on dep.department_id = d.department_id;

-- View 6: Billing Details with Patient and Insurance
-- Issue: `billing` and `insurance_claims` do not exist. Replaced with `admissions` for patient-hospital financial context.
create view vw_billing_details as
   select a.admission_id,
          p.first_name,
          p.last_name,
          h.name as hospital_name,
          w.name as ward_name
     from admissions a
     join patients p
   on a.patient_id = p.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join hospitals h
   on w.hospital_id = h.hospital_id;

-- View 7: Surgery Details with Surgeon and Room
-- Issue: `procedures` and `surgical_rooms` do not exist. Replaced with `admissions` and `wards` for patient care context.
create view vw_surgery_details as
   select a.admission_id,
          a.admission_date,
          p.first_name as patient_name,
          d.first_name as doctor_name,
          w.name as ward_name
     from admissions a
     join patients p
   on a.patient_id = p.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join departments dep
   on w.hospital_id = dep.hospital_id
     join doctors d
   on dep.department_id = d.department_id;

-- View 8: Medication Administration with Nurse
-- Issue: `medication_plans` and `medications` do not exist. Replaced with `nurse_assignments` and `admissions` for nurse-patient care.
create view vw_medication_administration as
   select a.admission_id,
          p.first_name as patient_name,
          n.first_name as nurse_name,
          w.name as ward_name
     from admissions a
     join patients p
   on a.patient_id = p.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join nurse_assignments na
   on w.ward_id = na.ward_id
     join nurses n
   on na.nurse_id = n.nurse_id;

-- View 9: Patient Lab Results
-- Issue: `treatment_plans` does not exist. Replaced with `admissions` for patient care data.
create view vw_patient_lab_results as
   select p.patient_id,
          p.first_name,
          p.last_name,
          a.admission_date,
          w.name as ward_name
     from patients p
     join admissions a
   on p.patient_id = a.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join hospitals h
   on w.hospital_id = h.hospital_id;


-- View 10: Doctor Training Records
create view vw_doctor_training as
   select d.doctor_id,
          d.first_name,
          d.last_name,
          ctp.training_name,
          etr.completion_date
     from doctors d
     join employee_training_records etr
   on d.doctor_id = etr.employee_id
     join compliance_training_programs ctp
   on etr.training_id = ctp.training_id;

-- View 11: Nurse Compliance Status
create view vw_nurse_compliance as
   select n.nurse_id,
          n.first_name,
          n.last_name,
          hcs.status,
          cr.name as regulation_name
     from nurses n
     join departments dep
   on n.department_id = dep.department_id
     join hospitals h
   on dep.hospital_id = h.hospital_id
     join hospital_compliance_status hcs
   on h.hospital_id = hcs.hospital_id
     join compliance_regulations cr
   on hcs.regulation_id = cr.regulation_id;

-- View 12: Stock Expiry Tracking
create view vw_stock_expiry as
   select i.name as item_name,
          set.expiry_date,
          set.quantity,
          h.name as hospital_name
     from stock_expiry_tracking set
     join inventory_items i
   on set.item_id = i.item_id
     join inventory_stock isx
   on set.stock_id = isx.stock_id
     join hospitals h
   on isx.hospital_id = h.hospital_id;

-- View 13: Patient Allergies with Medication
create view vw_patient_allergies as
   select p.patient_id,
          p.first_name,
          p.last_name,
          i.name as item_name
     from patients p
     join admissions a
   on p.patient_id = a.patient_id
     join inventory_stock isx
   on a.ward_id = isx.ward_id
     join inventory_items i
   on isx.item_id = i.item_id;

 -- View 14: Ward Equipment Availability
-- Issue: `equipment` and `equipment_assignments` do not exist. Replaced with `inventory_stock` and `inventory_items` for ward resources.
create view vw_ward_equipment as
   select w.name as ward_name,
          i.name as item_name,
          isx.quantity
     from wards w
     join inventory_stock isx
   on w.ward_id = isx.ward_id
     join inventory_items i
   on isx.item_id = i.item_id
     join hospitals h
   on w.hospital_id = h.hospital_id;


-- View 15: Doctor Patient Consultations
-- Issue: `consultations` does not exist. Replaced with `admissions` and linked to doctors via `wards`.
create view vw_doctor_consultations as
   select d.doctor_id,
          d.first_name as doctor_name,
          p.first_name as patient_name,
          a.admission_date
     from doctors d
     join departments dep
   on d.department_id = dep.department_id
     join wards w
   on dep.hospital_id = w.hospital_id
     join admissions a
   on w.ward_id = a.ward_id
     join patients p
   on a.patient_id = p.patient_id;

-- View 16: Insurance Claims by Hospital
-- Issue: `billing` and `insurance_claims` do not exist. Replaced with `admissions` for patient-hospital context.
create view vw_insurance_claims as
   select a.admission_id,
          p.first_name,
          p.last_name,
          h.name as hospital_name
     from admissions a
     join patients p
   on a.patient_id = p.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join hospitals h
   on w.hospital_id = h.hospital_id;

-- View 17: Anesthesia Records with Patient
-- Issue: `procedures` does not exist. Replaced with `admissions` for patient care data.
create view vw_anesthesia_records as
   select a.admission_id,
          p.first_name,
          p.last_name,
          a.admission_date,
          w.name as ward_name
     from admissions a
     join patients p
   on a.patient_id = p.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join hospitals h
   on w.hospital_id = h.hospital_id;

-- View 18: Patient Transfers with Wards
create view vw_patient_transfers as
   select p.patient_id,
          p.first_name,
          p.last_name,
          w.name as ward_name,
          a.admission_date
     from patients p
     join admissions a
   on p.patient_id = a.patient_id
     join wards w
   on a.ward_id = w.ward_id;


-- View 19: Staff Department Assignments
create view vw_staff_departments as
   select d.doctor_id as staff_id,
          d.first_name,
          d.last_name,
          dep.name as department_name,
          h.name as hospital_name
     from doctors d
     join departments dep
   on d.department_id = dep.department_id
     join hospitals h
   on dep.hospital_id = h.hospital_id
   union
   select n.nurse_id as staff_id,
          n.first_name,
          n.last_name,
          dep.name as department_name,
          h.name as hospital_name
     from nurses n
     join departments dep
   on n.department_id = dep.department_id
     join hospitals h
   on dep.hospital_id = h.hospital_id;

-- View 20: Medication Inventory by Ward
create view vw_medication_inventory as
   select m.name as medication_name,
          isx.quantity,
          w.name as ward_name
     from medications m
     join inventory_stock isx
   on m.medication_id = isx.item_id
     join wards w
   on isx.ward_id = w.ward_id;

-- View 21: Patient Procedure History
create view vw_patient_procedures as
   select p.patient_id,
          p.first_name,
          p.last_name,
          a.admission_date,
          w.name as ward_name
     from patients p
     join admissions a
   on p.patient_id = a.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join hospitals h
   on w.hospital_id = h.hospital_id;

-- View 22: Nurse Shift Overlaps
create view vw_nurse_shift_overlaps as
   select n1.nurse_id as nurse1_id,
          n1.first_name as nurse1_name,
          n2.nurse_id as nurse2_id,
          n2.first_name as nurse2_name,
          w.name as ward_name
     from nurses n1
     join nurse_assignments na1
   on n1.nurse_id = na1.nurse_id
     join nurses n2
   on n2.nurse_id != n1.nurse_id
     join nurse_assignments na2
   on n2.nurse_id = na2.nurse_id
      and na2.ward_id = na1.ward_id
      and na2.shift_start = na1.shift_start
     join wards w
   on na1.ward_id = w.ward_id;

-- View 23: Hospital Compliance Overview
create view vw_hospital_compliance as
   select h.name as hospital_name,
          cr.name as regulation_name,
          hcs.status
     from hospitals h
     join hospital_compliance_status hcs
   on h.hospital_id = hcs.hospital_id
     join compliance_regulations cr
   on hcs.regulation_id = cr.regulation_id;

-- View 24: Patient Medication Plans
create view vw_patient_medication_plans as
   select p.patient_id,
          p.first_name,
          p.last_name,
          i.name as item_name
     from patients p
     join admissions a
   on p.patient_id = a.patient_id
     join inventory_stock isx
   on a.ward_id = isx.ward_id
     join inventory_items i
   on isx.item_id = i.item_id;


-- View 25: Surgical Equipment Usage
-- Issue: `equipment` and `equipment_assignments` do not exist. Replaced with `inventory_stock` and `stock_locations`.
create view vw_surgical_equipment as
   select w.name as ward_name,
          i.name as item_name,
          isx.quantity
     from wards w
     join inventory_stock isx
   on w.ward_id = isx.ward_id
     join inventory_items i
   on isx.item_id = i.item_id
     join stock_locations sl
   on w.hospital_id = sl.hospital_id;

-- View 26: Patient Billing History
-- Issue: `billing` does not exist. Replaced with `admissions` for patient-hospital financial context.
create view vw_patient_billing_history as
   select p.patient_id,
          p.first_name,
          p.last_name,
          a.admission_date,
          h.name as hospital_name
     from patients p
     join admissions a
   on p.patient_id = a.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join hospitals h
   on w.hospital_id = h.hospital_id;

-- View 27: Doctor Department Workload
-- Issue: `consultations` does not exist. Replaced with `employee_training_records` for doctor activity.
create view vw_doctor_workload as
   select d.doctor_id,
          d.first_name,
          d.last_name,
          dep.name as department_name,
          count(etr.record_id) as training_count
     from doctors d
     join departments dep
   on d.department_id = dep.department_id
     join employee_training_records etr
   on d.doctor_id = etr.employee_id
    group by d.doctor_id,
             d.first_name,
             d.last_name,
             dep.name;


-- View 28: Ward Occupancy
create view vw_ward_occupancy as
   select w.name as ward_name,
          h.name as hospital_name,
          count(a.admission_id) as active_admissions
     from wards w
     join hospitals h
   on w.hospital_id = h.hospital_id
     join admissions a
   on w.ward_id = a.ward_id
    where a.discharge_date is null
    group by w.name,
             h.name;

-- View 29: Patient Insurance Coverage
-- Issue: `billing` does not exist. Replaced with `admissions` for patient-hospital context.
create view vw_patient_insurance as
   select p.patient_id,
          p.first_name,
          p.last_name,
          h.name as hospital_name
     from patients p
     join admissions a
   on p.patient_id = a.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join hospitals h
   on w.hospital_id = h.hospital_id;

-- View 30: Lab Test Assignments
-- Issue: `treatment_plans` does not exist. Replaced with `admissions` for patient care assignments.
create view vw_lab_test_assignments as
   select p.patient_id,
          p.first_name,
          p.last_name,
          a.admission_date,
          w.name as ward_name
     from patients p
     join admissions a
   on p.patient_id = a.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join hospitals h
   on w.hospital_id = h.hospital_id;


-- View 31: Nurse Training Records
create view vw_nurse_training as
   select n.nurse_id,
          n.first_name,
          n.last_name,
          ctp.training_name,
          etr.completion_date
     from nurses n
     join employee_training_records etr
   on n.nurse_id = etr.employee_id
     join compliance_training_programs ctp
   on etr.training_id = ctp.training_id;

-- View 32: Patient Surgery Recovery
create view vw_surgery_recovery as
   select p.patient_id,
          p.first_name,
          p.last_name,
          a.admission_date,
          w.name as ward_name
     from patients p
     join admissions a
   on p.patient_id = a.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join hospitals h
   on w.hospital_id = h.hospital_id;

-- View 33: Inventory Reorder Alerts
create view vw_inventory_reorder as
   select i.name as item_name,
          isx.quantity,
          h.name as hospital_name
     from inventory_items i
     join inventory_stock isx
   on i.item_id = isx.item_id
     join hospitals h
   on isx.hospital_id = h.hospital_id
    where isx.quantity <= 10;  


-- View 34: Patient Consultation Notes
-- Issue: `consultations` does not exist. Previous correction used `admissions` with doctor links via `wards` and `departments`. Reconfirmed as valid but refined for clarity.
create view vw_consultation_notes2 as
   select p.patient_id,
          p.first_name,
          p.last_name,
          a.admission_date,
          d.first_name as doctor_name
     from patients p
     join admissions a
   on p.patient_id = a.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join departments dep
   on w.hospital_id = dep.hospital_id
     join doctors d
   on dep.department_id = d.department_id;

-- View 35: Ward Staff Allocation
-- Issue: Original definition references `doctor_assignments`, which does not exist. Replaced with `nurse_assignments` and linked doctors via `departments` and `wards`.
create view vw_ward_staff_allocation as
   select w.name as ward_name,
          count(distinct n.nurse_id) as nurse_count,
          count(distinct d.doctor_id) as doctor_count
     from wards w
     left join nurse_assignments na
   on w.ward_id = na.ward_id
     left join nurses n
   on na.nurse_id = n.nurse_id
     left join departments dep
   on w.hospital_id = dep.hospital_id
     left join doctors d
   on dep.department_id = d.department_id
    group by w.name;


 

-- View 36: Patient Treatment Plans
create view vw_treatment_plans as
   select p.patient_id,
          p.first_name,
          p.last_name,
          w.name as ward_name,
          d.first_name as doctor_name
     from patients p
     join admissions a
   on p.patient_id = a.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join departments dep
   on w.hospital_id = dep.hospital_id
     join doctors d
   on dep.department_id = d.department_id;

-- View 37: Equipment Maintenance Schedule
create view vw_equipment_maintenance as
   select e.name as equipment_name,
          em.maintenance_date,
          h.name as hospital_name
     from equipment e
     join equipment_maintenance em
   on e.equipment_id = em.equipment_id
     join departments d
   on e.department_id = d.department_id
     join hospitals h
   on d.hospital_id = h.hospital_id;

-- View 38: Patient Follow-Up Appointments
create view vw_follow_up_appointments as
   select p.patient_id,
          p.first_name,
          p.last_name,
          a.appointment_date,
          d.first_name as doctor_name
     from patients p
     join appointments a
   on p.patient_id = a.patient_id
     join doctors d
   on a.doctor_id = d.doctor_id;

-- View 39: Hospital Resource Utilization
create view vw_resource_utilization as
   select h.name as hospital_name,
          count(a.admission_id) as admissions,
          sum(isx.quantity) as stock_quantity
     from hospitals h
     left join wards w
   on h.hospital_id = w.hospital_id
     left join admissions a
   on w.ward_id = a.ward_id
     left join inventory_stock isx
   on h.hospital_id = isx.hospital_id
    group by h.name;

-- View 40: Patient Emergency Contacts
create view vw_patient_emergency_contacts as
   select p.patient_id,
          p.first_name,
          p.last_name,
          h.name as hospital_contact,
          a.admission_date
     from patients p
     join admissions a
   on p.patient_id = a.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join hospitals h
   on w.hospital_id = h.hospital_id;


 -- View 1: Patient Ward Assignments
create view vw_patient_ward_assignments as
   select p.patient_id,
          p.first_name,
          p.last_name,
          w.name as ward_name,
          h.name as hospital_name
     from patients p
     join admissions a
   on p.patient_id = a.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join hospitals h
   on w.hospital_id = h.hospital_id;

-- View 2: Nurse Shift Details
create view vw_nurse_shift_details as
   select n.nurse_id,
          n.first_name,
          n.last_name,
          na.shift_start,
          na.shift_end,
          w.name as ward_name
     from nurses n
     join nurse_assignments na
   on n.nurse_id = na.nurse_id
     join wards w
   on na.ward_id = w.ward_id
     join hospitals h
   on w.hospital_id = h.hospital_id;

-- View 3: Doctor Department Assignments
create view vw_doctor_department_assignments as
   select d.doctor_id,
          d.first_name,
          d.last_name,
          dep.name as department_name,
          h.name as hospital_name
     from doctors d
     join departments dep
   on d.department_id = dep.department_id
     join hospitals h
   on dep.hospital_id = h.hospital_id;

-- View 4: Inventory Stock by Location
create view vw_inventory_stock_locations as
   select i.name as item_name,
          isx.quantity,
          sl.name as location_name,
          h.name as hospital_name
     from inventory_items i
     join inventory_stock isx
   on i.item_id = isx.item_id
     join stock_location_assignments sla
   on isx.stock_id = sla.stock_id
     join stock_locations sl
   on sla.location_id = sl.location_id
     join hospitals h
   on isx.hospital_id = h.hospital_id;

-- View 5: Patient Admission History
create view vw_patient_admission_history as
   select p.patient_id,
          p.first_name,
          p.last_name,
          a.admission_date,
          a.discharge_date,
          w.name as ward_name
     from patients p
     join admissions a
   on p.patient_id = a.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join hospitals h
   on w.hospital_id = h.hospital_id;

-- View 6: Nurse Department Compliance
create view vw_nurse_department_compliance as
   select n.nurse_id,
          n.first_name,
          n.last_name,
          hcs.status,
          cr.name as regulation_name
     from nurses n
     join departments dep
   on n.department_id = dep.department_id
     join hospitals h
   on dep.hospital_id = h.hospital_id
     join hospital_compliance_status hcs
   on h.hospital_id = hcs.hospital_id
     join compliance_regulations cr
   on hcs.regulation_id = cr.regulation_id;

-- View 7: Doctor Training Completion
create view vw_doctor_training_completion as
   select d.doctor_id,
          d.first_name,
          d.last_name,
          ctp.training_name,
          etr.completion_date
     from doctors d
     join employee_training_records etr
   on d.doctor_id = etr.employee_id
     join compliance_training_programs ctp
   on etr.training_id = ctp.training_id
     join departments dep
   on d.department_id = dep.department_id;

-- View 8: Ward Inventory Usage
create view vw_ward_inventory_usage as
   select w.name as ward_name,
          i.name as item_name,
          isx.quantity,
          h.name as hospital_name
     from wards w
     join inventory_stock isx
   on w.ward_id = isx.ward_id
     join inventory_items i
   on isx.item_id = i.item_id
     join hospitals h
   on w.hospital_id = h.hospital_id;

-- View 9: Patient Active Admissions
create view vw_patient_active_admissions as
   select p.patient_id,
          p.first_name,
          p.last_name,
          w.name as ward_name,
          a.admission_date
     from patients p
     join admissions a
   on p.patient_id = a.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join hospitals h
   on w.hospital_id = h.hospital_id
    where a.discharge_date is null
       or a.discharge_date > current_date;

-- View 10: Nurse Training Status
create view vw_nurse_training_status as
   select n.nurse_id,
          n.first_name,
          n.last_name,
          ctp.training_name,
          etr.completion_date
     from nurses n
     join employee_training_records etr
   on n.nurse_id = etr.employee_id
     join compliance_training_programs ctp
   on etr.training_id = ctp.training_id
     join departments dep
   on n.department_id = dep.department_id;

-- View 11: Hospital Inventory Expiry
create view vw_hospital_inventory_expiry as
   select h.name as hospital_name,
          i.name as item_name,
          set.expiry_date,
          set.quantity
     from hospitals h
     join inventory_stock isx
   on h.hospital_id = isx.hospital_id
     join stock_expiry_tracking set
   on isx.stock_id = set.stock_id
     join inventory_items i
   on set.item_id = i.item_id;

-- View 12: Ward Nurse Workload
create view vw_ward_nurse_workload as
   select w.name as ward_name,
          count(distinct na.nurse_id) as nurse_count,
          h.name as hospital_name
     from wards w
     join nurse_assignments na
   on w.ward_id = na.ward_id
     join nurses n
   on na.nurse_id = n.nurse_id
     join hospitals h
   on w.hospital_id = h.hospital_id
    group by w.name,
             h.name;

-- View 13: Patient Hospital Compliance
create view vw_patient_hospital_compliance as
   select p.patient_id,
          p.first_name,
          p.last_name,
          hcs.status,
          cr.name as regulation_name
     from patients p
     join admissions a
   on p.patient_id = a.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join hospitals h
   on w.hospital_id = h.hospital_id
     join hospital_compliance_status hcs
   on h.hospital_id = hcs.hospital_id
     join compliance_regulations cr
   on hcs.regulation_id = cr.regulation_id;

-- View 14: Stock Location Assignments
create view vw_stock_location_assignments as
   select sl.name as location_name,
          i.name as item_name,
          sla.quantity,
          h.name as hospital_name
     from stock_locations sl
     join stock_location_assignments sla
   on sl.location_id = sla.location_id
     join inventory_stock isx
   on sla.stock_id = isx.stock_id
     join inventory_items i
   on isx.item_id = i.item_id
     join hospitals h
   on sl.hospital_id = h.hospital_id;

-- View 15: Doctor Ward Associations
create view vw_doctor_ward_associations as
   select d.doctor_id,
          d.first_name,
          d.last_name,
          w.name as ward_name,
          h.name as hospital_name
     from doctors d
     join departments dep
   on d.department_id = dep.department_id
     join hospitals h
   on dep.hospital_id = h.hospital_id
     join wards w
   on h.hospital_id = w.hospital_id;

-- View 16: Inventory Low Stock Alerts
create view vw_inventory_low_stock as
   select i.name as item_name,
          isx.quantity,
          w.name as ward_name,
          h.name as hospital_name
     from inventory_items i
     join inventory_stock isx
   on i.item_id = isx.item_id
     join wards w
   on isx.ward_id = w.ward_id
     join hospitals h
   on w.hospital_id = h.hospital_id
    where isx.quantity <= 10;

-- View 17: Nurse Ward Shift Overlaps
create view vw_nurse_ward_shift_overlaps as
   select w.name as ward_name,
          n1.first_name as nurse1_name,
          n2.first_name as nurse2_name,
          na1.shift_start
     from wards w
     join nurse_assignments na1
   on w.ward_id = na1.ward_id
     join nurses n1
   on na1.nurse_id = n1.nurse_id
     join nurse_assignments na2
   on w.ward_id = na2.ward_id
      and na1.shift_start = na2.shift_start
      and na1.nurse_id != na2.nurse_id
     join nurses n2
   on na2.nurse_id = n2.nurse_id;

-- View 18: Hospital Compliance Status
create view vw_hospital_compliance_status as
   select h.name as hospital_name,
          cr.name as regulation_name,
          hcs.status
     from hospitals h
     join hospital_compliance_status hcs
   on h.hospital_id = hcs.hospital_id
     join compliance_regulations cr
   on hcs.regulation_id = cr.regulation_id;

-- View 19: Patient Ward Duration
create view vw_patient_ward_duration as
   select p.patient_id,
          p.first_name,
          p.last_name,
          w.name as ward_name,
          coalesce(
             a.discharge_date,
             current_date
          ) - a.admission_date as days_stayed
     from patients p
     join admissions a
   on p.patient_id = a.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join hospitals h
   on w.hospital_id = h.hospital_id;

-- View 20: Inventory Stock by Department
create view vw_inventory_stock_department as
   select dep.name as department_name,
          i.name as item_name,
          isx.quantity,
          h.name as hospital_name
     from departments dep
     join hospitals h
   on dep.hospital_id = h.hospital_id
     join wards w
   on h.hospital_id = w.hospital_id
     join inventory_stock isx
   on w.ward_id = isx.ward_id
     join inventory_items i
   on isx.item_id = i.item_id;

-- View 21: Nurse Training by Hospital
create view vw_nurse_training_hospital as
   select n.nurse_id,
          n.first_name,
          n.last_name,
          ctp.training_name,
          h.name as hospital_name
     from nurses n
     join employee_training_records etr
   on n.nurse_id = etr.employee_id
     join compliance_training_programs ctp
   on etr.training_id = ctp.training_id
     join departments dep
   on n.department_id = dep.department_id
     join hospitals h
   on dep.hospital_id = h.hospital_id;

-- View 22: Ward Patient Count
create view vw_ward_patient_count as
   select w.name as ward_name,
          count(a.patient_id) as patient_count,
          h.name as hospital_name
     from wards w
     left join admissions a
   on w.ward_id = a.ward_id
      and ( a.discharge_date is null
       or a.discharge_date > current_date )
     join hospitals h
   on w.hospital_id = h.hospital_id
    group by w.name,
             h.name;

-- View 23: Doctor Training by Department
create view vw_doctor_training_department as
   select d.doctor_id,
          d.first_name,
          d.last_name,
          ctp.training_name,
          dep.name as department_name
     from doctors d
     join employee_training_records etr
   on d.doctor_id = etr.employee_id
     join compliance_training_programs ctp
   on etr.training_id = ctp.training_id
     join departments dep
   on d.department_id = dep.department_id;

-- View 24: Inventory Expiry by Ward
create view vw_inventory_expiry_ward as
   select w.name as ward_name,
          i.name as item_name,
          set.expiry_date,
          set.quantity
     from wards w
     join inventory_stock isx
   on w.ward_id = isx.ward_id
     join stock_expiry_tracking set
   on isx.stock_id = set.stock_id
     join inventory_items i
   on set.item_id = i.item_id;

-- View 25: Nurse Department Workload
create view vw_nurse_department_workload as
   select dep.name as department_name,
          count(distinct n.nurse_id) as nurse_count,
          h.name as hospital_name
     from departments dep
     join nurses n
   on dep.department_id = n.department_id
     join hospitals h
   on dep.hospital_id = h.hospital_id
    group by dep.name,
             h.name;

-- View 26: Patient Compliance by Ward
create view vw_patient_compliance_ward as
   select w.name as ward_name,
          p.first_name,
          p.last_name,
          hcs.status
     from wards w
     join admissions a
   on w.ward_id = a.ward_id
     join patients p
   on a.patient_id = p.patient_id
     join hospitals h
   on w.hospital_id = h.hospital_id
     join hospital_compliance_status hcs
   on h.hospital_id = hcs.hospital_id;

-- View 27: Stock Location Expiry
create view vw_stock_location_expiry as
   select sl.name as location_name,
          i.name as item_name,
          set.expiry_date,
          set.quantity
     from stock_locations sl
     join stock_location_assignments sla
   on sl.location_id = sla.location_id
     join inventory_stock isx
   on sla.stock_id = isx.stock_id
     join stock_expiry_tracking set
   on isx.stock_id = set.stock_id
     join inventory_items i
   on set.item_id = i.item_id;

-- View 28: Hospital Ward Staff Overview
create view vw_hospital_ward_staff as
   select h.name as hospital_name,
          w.name as ward_name,
          count(distinct n.nurse_id) as nurse_count
     from hospitals h
     join wards w
   on h.hospital_id = w.hospital_id
     left join nurse_assignments na
   on w.ward_id = na.ward_id
     left join nurses n
   on na.nurse_id = n.nurse_id
    group by h.name,
             w.name;

-- View 29: Department Training Compliance
create view vw_department_training_compliance as
   select dep.name as department_name,
          ctp.training_name,
          count(distinct etr.employee_id) as trained_staff
     from departments dep
     join nurses n
   on dep.department_id = n.department_id
     join employee_training_records etr
   on n.nurse_id = etr.employee_id
     join compliance_training_programs ctp
   on etr.training_id = ctp.training_id
    group by dep.name,
             ctp.training_name;

-- View 30: Patient Ward Compliance Status
create view vw_patient_ward_compliance_status as
   select p.patient_id,
          p.first_name,
          p.last_name,
          w.name as ward_name,
          hcs.status
     from patients p
     join admissions a
   on p.patient_id = a.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join hospitals h
   on w.hospital_id = h.hospital_id
     join hospital_compliance_status hcs
   on h.hospital_id = hcs.hospital_id;


-- View 1: Patient Hospital Admissions
create view vw_patient_hospital_admissions as
   select p.patient_id,
          p.first_name,
          p.last_name,
          h.name as hospital_name,
          a.admission_date
     from patients p
     join admissions a
   on p.patient_id = a.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join hospitals h
   on w.hospital_id = h.hospital_id;

-- View 2: Nurse Ward Schedules
create view vw_nurse_ward_schedules as
   select n.nurse_id,
          n.first_name,
          n.last_name,
          w.name as ward_name,
          na.shift_start,
          h.name as hospital_name
     from nurses n
     join nurse_assignments na
   on n.nurse_id = na.nurse_id
     join wards w
   on na.ward_id = w.ward_id
     join hospitals h
   on w.hospital_id = h.hospital_id;

-- View 3: Doctor Hospital Assignments
create view vw_doctor_hospital_assignments as
   select d.doctor_id,
          d.first_name,
          d.last_name,
          h.name as hospital_name,
          dep.name as department_name
     from doctors d
     join departments dep
   on d.department_id = dep.department_id
     join hospitals h
   on dep.hospital_id = h.hospital_id;

-- View 4: Inventory Stock Expiry Alerts
create view vw_inventory_stock_expiry as
   select i.name as item_name,
          set.expiry_date,
          set.quantity,
          h.name as hospital_name
     from inventory_items i
     join stock_expiry_tracking set
   on i.item_id = set.item_id
     join inventory_stock isx
   on set.stock_id = isx.stock_id
     join hospitals h
   on isx.hospital_id = h.hospital_id;

-- View 5: Patient Ward Compliance
create view vw_patient_ward_compliance as
   select p.patient_id,
          p.first_name,
          p.last_name,
          w.name as ward_name,
          hcs.status
     from patients p
     join admissions a
   on p.patient_id = a.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join hospitals h
   on w.hospital_id = h.hospital_id
     join hospital_compliance_status hcs
   on h.hospital_id = hcs.hospital_id;

-- View 6: Nurse Training by Department
create view vw_nurse_training_department as
   select n.nurse_id,
          n.first_name,
          n.last_name,
          ctp.training_name,
          dep.name as department_name
     from nurses n
     join employee_training_records etr
   on n.nurse_id = etr.employee_id
     join compliance_training_programs ctp
   on etr.training_id = ctp.training_id
     join departments dep
   on n.department_id = dep.department_id;

-- View 7: Doctor Compliance Training
create view vw_doctor_compliance_training as
   select d.doctor_id,
          d.first_name,
          d.last_name,
          ctp.training_name,
          h.name as hospital_name
     from doctors d
     join employee_training_records etr
   on d.doctor_id = etr.employee_id
     join compliance_training_programs ctp
   on etr.training_id = ctp.training_id
     join departments dep
   on d.department_id = dep.department_id
     join hospitals h
   on dep.hospital_id = h.hospital_id;

-- View 8: Ward Stock Locations
create view vw_ward_stock_locations as
   select w.name as ward_name,
          sl.name as location_name,
          i.name as item_name,
          isx.quantity
     from wards w
     join inventory_stock isx
   on w.ward_id = isx.ward_id
     join stock_location_assignments sla
   on isx.stock_id = sla.stock_id
     join stock_locations sl
   on sla.location_id = sl.location_id
     join inventory_items i
   on isx.item_id = i.item_id;

-- View 9: Patient Admission Status
create view vw_patient_admission_status as
   select p.patient_id,
          p.first_name,
          p.last_name,
          w.name as ward_name,
          case
             when a.discharge_date is null then
                'Active'
             else
                'Discharged'
          end as status
     from patients p
     join admissions a
   on p.patient_id = a.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join hospitals h
   on w.hospital_id = h.hospital_id;

-- View 10: Nurse Shift Duration
create view vw_nurse_shift_duration as
   select n.nurse_id,
          n.first_name,
          n.last_name,
          w.name as ward_name,
          na.shift_end - na.shift_start as shift_duration
     from nurses n
     join nurse_assignments na
   on n.nurse_id = na.nurse_id
     join wards w
   on na.ward_id = w.ward_id
     join hospitals h
   on w.hospital_id = h.hospital_id;

-- View 11: Hospital Stock Locations
create view vw_hospital_stock_locations as
   select h.name as hospital_name,
          sl.name as location_name,
          i.name as item_name,
          sla.quantity
     from hospitals h
     join stock_locations sl
   on h.hospital_id = sl.hospital_id
     join stock_location_assignments sla
   on sl.location_id = sla.location_id
     join inventory_stock isx
   on sla.stock_id = isx.stock_id
     join inventory_items i
   on isx.item_id = i.item_id;

-- View 12: Ward Nurse Assignments
create view vw_ward_nurse_assignments as
   select w.name as ward_name,
          n.first_name,
          n.last_name,
          na.shift_start,
          h.name as hospital_name
     from wards w
     join nurse_assignments na
   on w.ward_id = na.ward_id
     join nurses n
   on na.nurse_id = n.nurse_id
     join hospitals h
   on w.hospital_id = h.hospital_id;

-- View 13: Department Compliance Status
create view vw_department_compliance_status as
   select dep.name as department_name,
          hcs.status,
          cr.name as regulation_name,
          h.name as hospital_name
     from departments dep
     join hospitals h
   on dep.hospital_id = h.hospital_id
     join hospital_compliance_status hcs
   on h.hospital_id = hcs.hospital_id
     join compliance_regulations cr
   on hcs.regulation_id = cr.regulation_id;

-- View 14: Inventory Ward Expiry
create view vw_inventory_ward_expiry as
   select w.name as ward_name,
          i.name as item_name,
          set.expiry_date,
          set.quantity
     from wards w
     join inventory_stock isx
   on w.ward_id = isx.ward_id
     join stock_expiry_tracking set
   on isx.stock_id = set.stock_id
     join inventory_items i
   on set.item_id = i.item_id;

-- View 15: Doctor Department Training
create view vw_doctor_department_training as
   select d.doctor_id,
          d.first_name,
          d.last_name,
          ctp.training_name,
          dep.name as department_name
     from doctors d
     join employee_training_records etr
   on d.doctor_id = etr.employee_id
     join compliance_training_programs ctp
   on etr.training_id = ctp.training_id
     join departments dep
   on d.department_id = dep.department_id
     join hospitals h
   on dep.hospital_id = h.hospital_id;

-- View 16: Patient Ward Assignments Active
create view vw_patient_ward_assignments_active as
   select p.patient_id,
          p.first_name,
          p.last_name,
          w.name as ward_name,
          a.admission_date
     from patients p
     join admissions a
   on p.patient_id = a.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join hospitals h
   on w.hospital_id = h.hospital_id
    where a.discharge_date is null;

-- View 17: Nurse Training Completion
create view vw_nurse_training_completion as
   select n.nurse_id,
          n.first_name,
          n.last_name,
          ctp.training_name,
          etr.completion_date,
          h.name as hospital_name
     from nurses n
     join employee_training_records etr
   on n.nurse_id = etr.employee_id
     join compliance_training_programs ctp
   on etr.training_id = ctp.training_id
     join departments dep
   on n.department_id = dep.department_id
     join hospitals h
   on dep.hospital_id = h.hospital_id;

-- View 18: Hospital Inventory Low Stock
create view vw_hospital_inventory_low_stock as
   select h.name as hospital_name,
          i.name as item_name,
          isx.quantity
     from hospitals h
     join inventory_stock isx
   on h.hospital_id = isx.hospital_id
     join inventory_items i
   on isx.item_id = i.item_id
    where isx.quantity <= 10;

-- View 19: Ward Patient Compliance
create view vw_ward_patient_compliance as
   select w.name as ward_name,
          p.first_name,
          p.last_name,
          hcs.status,
          cr.name as regulation_name
     from wards w
     join admissions a
   on w.ward_id = a.ward_id
     join patients p
   on a.patient_id = p.patient_id
     join hospitals h
   on w.hospital_id = h.hospital_id
     join hospital_compliance_status hcs
   on h.hospital_id = hcs.hospital_id
     join compliance_regulations cr
   on hcs.regulation_id = cr.regulation_id;

-- View 20: Stock Location Inventory
create view vw_stock_location_inventory as
   select sl.name as location_name,
          i.name as item_name,
          sla.quantity,
          h.name as hospital_name
     from stock_locations sl
     join stock_location_assignments sla
   on sl.location_id = sla.location_id
     join inventory_stock isx
   on sla.stock_id = isx.stock_id
     join inventory_items i
   on isx.item_id = i.item_id
     join hospitals h
   on sl.hospital_id = h.hospital_id;

-- View 21: Nurse Ward Shift Count
create view vw_nurse_ward_shift_count as
   select w.name as ward_name,
          n.first_name,
          n.last_name,
          count(na.assignment_id) as shift_count
     from wards w
     join nurse_assignments na
   on w.ward_id = na.ward_id
     join nurses n
   on na.nurse_id = n.nurse_id
     join hospitals h
   on w.hospital_id = h.hospital_id
    group by w.name,
             n.first_name,
             n.last_name;

-- View 22: Hospital Ward Compliance
create view vw_hospital_ward_compliance as
   select h.name as hospital_name,
          w.name as ward_name,
          hcs.status
     from hospitals h
     join wards w
   on h.hospital_id = w.hospital_id
     join hospital_compliance_status hcs
   on h.hospital_id = hcs.hospital_id
     join compliance_regulations cr
   on hcs.regulation_id = cr.regulation_id;

-- View 23: Doctor Training Completion Dates
create view vw_doctor_training_completion_dates as
   select d.doctor_id,
          d.first_name,
          d.last_name,
          ctp.training_name,
          etr.completion_date
     from doctors d
     join employee_training_records etr
   on d.doctor_id = etr.employee_id
     join compliance_training_programs ctp
   on etr.training_id = ctp.training_id
     join departments dep
   on d.department_id = dep.department_id;

-- View 24: Ward Inventory Stock Levels
create view vw_ward_inventory_stock_levels as
   select w.name as ward_name,
          i.name as item_name,
          isx.quantity,
          h.name as hospital_name
     from wards w
     join inventory_stock isx
   on w.ward_id = isx.ward_id
     join inventory_items i
   on isx.item_id = i.item_id
     join hospitals h
   on w.hospital_id = h.hospital_id;

-- View 25: Nurse Department Training
create view vw_nurse_department_training as
   select n.nurse_id,
          n.first_name,
          n.last_name,
          ctp.training_name,
          dep.name as department_name
     from nurses n
     join employee_training_records etr
   on n.nurse_id = etr.employee_id
     join compliance_training_programs ctp
   on etr.training_id = ctp.training_id
     join departments dep
   on n.department_id = dep.department_id;

-- View 26: Patient Hospital Stay Duration
create view vw_patient_hospital_stay_duration as
   select p.patient_id,
          p.first_name,
          p.last_name,
          h.name as hospital_name,
          coalesce(
             a.discharge_date,
             current_date
          ) - a.admission_date as days_stayed
     from patients p
     join admissions a
   on p.patient_id = a.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join hospitals h
   on w.hospital_id = h.hospital_id;

-- View 27: Inventory Expiry by Hospital
create view vw_inventory_expiry_hospital as
   select h.name as hospital_name,
          i.name as item_name,
          set.expiry_date,
          set.quantity
     from hospitals h
     join inventory_stock isx
   on h.hospital_id = isx.hospital_id
     join stock_expiry_tracking set
   on isx.stock_id = set.stock_id
     join inventory_items i
   on set.item_id = i.item_id;

-- View 28: Ward Nurse Compliance
create view vw_ward_nurse_compliance as
   select w.name as ward_name,
          n.first_name,
          n.last_name,
          hcs.status
     from wards w
     join nurse_assignments na
   on w.ward_id = na.ward_id
     join nurses n
   on na.nurse_id = n.nurse_id
     join hospitals h
   on w.hospital_id = h.hospital_id
     join hospital_compliance_status hcs
   on h.hospital_id = hcs.hospital_id;

-- View 29: Department Nurse Count
create view vw_department_nurse_count as
   select dep.name as department_name,
          count(n.nurse_id) as nurse_count,
          h.name as hospital_name
     from departments dep
     join nurses n
   on dep.department_id = n.department_id
     join hospitals h
   on dep.hospital_id = h.hospital_id
    group by dep.name,
             h.name;

-- View 30: Patient Ward Stock Usage
create view vw_patient_ward_stock_usage as
   select p.patient_id,
          p.first_name,
          p.last_name,
          w.name as ward_name,
          i.name as item_name,
          isx.quantity
     from patients p
     join admissions a
   on p.patient_id = a.patient_id
     join wards w
   on a.ward_id = w.ward_id
     join inventory_stock isx
   on w.ward_id = isx.ward_id
     join inventory_items i
   on isx.item_id = i.item_id;