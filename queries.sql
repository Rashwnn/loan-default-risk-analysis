/* ============================================================
   Loan Default Risk Analysis - SQL Queries
   Dataset: Kaggle "Loan Default Prediction Dataset" (nikhil1e9)
   255,347 rows, 18 columns
   Tool: SQLite via DB Browser for SQLite
   ============================================================ */


/* ------------------------------------------------------------
   Question 1: How does default rate vary by credit score band?
   ------------------------------------------------------------ */
SELECT 
CASE
  WHEN CreditScore < 580 THEN 'Poor'
  WHEN CreditScore < 670 THEN 'Fair'
  WHEN CreditScore < 740 THEN 'Good'
  WHEN CreditScore < 800 THEN 'Very Good'
  ELSE 'Exceptional' 
END as credit_band,
COUNT(*) AS total_loans,
ROUND(AVG("Default") * 100, 2) as default_rate_pct
FROM loans
GROUP BY credit_band;


/* ------------------------------------------------------------
   Question 2: Which loan purposes carry the highest default risk?
   ------------------------------------------------------------ */
SELECT 
  LoanPurpose,
  COUNT(*) AS total_loans,
  ROUND(AVG("Default") * 100, 2) AS default_rate_pct
FROM loans
GROUP BY LoanPurpose;


/* ------------------------------------------------------------
   Question 3: Does DTI ratio meaningfully predict default,
   or is credit score a stronger signal?
   ------------------------------------------------------------ */
SELECT 
CASE 
  WHEN DTIRatio < 0.20 THEN 'Low'
  WHEN DTIRatio < 0.36 THEN 'Moderate'
  WHEN DTIRatio < 0.43 THEN 'High'
  ELSE 'Very High'
END as DTIRatio_band,
COUNT(*) as total_loans,
ROUND(AVG("Default") * 100, 2) as default_rate_pct
FROM loans
GROUP BY DTIRatio_band;


/* ------------------------------------------------------------
   Question 4: How does employment status affect default risk?
   ------------------------------------------------------------ */
SELECT 
  EmploymentType,
  COUNT(*) AS total_loans,
  ROUND(AVG("Default") * 100, 2) AS default_rate_pct
FROM loans
GROUP BY EmploymentType;


/* ------------------------------------------------------------
   Question 5: Does having a co-signer or mortgage actually
   reduce default risk?
   ------------------------------------------------------------ */
SELECT 
  HasCoSigner,
  COUNT(*) AS total_loans,
  ROUND(AVG("Default") * 100, 2) AS default_rate_pct
FROM loans
GROUP BY HasCoSigner;

SELECT 
  HasMortgage,
  COUNT(*) AS total_loans,
  ROUND(AVG("Default") * 100, 2) AS default_rate_pct
FROM loans
GROUP BY HasMortgage;


/* ------------------------------------------------------------
   Question 6: What is the relationship between interest rate
   and default? Are riskier loans priced correctly?
   ------------------------------------------------------------ */
SELECT 
CASE
  WHEN InterestRate < 8 THEN 'Low'
  WHEN InterestRate < 12 THEN 'Moderate'
  WHEN InterestRate < 16 THEN 'High'
  WHEN InterestRate < 20 THEN 'Very High'
  ELSE 'Extreme'
END as interest_band,
COUNT(*) AS total_loans,
ROUND(AVG("Default") * 100, 2) AS default_rate_pct,
ROUND(AVG(CreditScore), 0) AS avg_credit_score,
ROUND(AVG(DTIRatio), 2) AS avg_dti
FROM loans
GROUP BY interest_band;


/* ------------------------------------------------------------
   Question 7: If the lender declined loans below a certain risk
   threshold, how much default exposure would they avoid, and
   how many good loans would they lose in the process?
   ------------------------------------------------------------ */
SELECT 
COUNT(*) as total_risky_loans,
SUM(CASE WHEN "Default" = 1 THEN LoanAmount ELSE 0 END) as dollars_avoided_if_declined,
SUM(CASE WHEN "Default" = 0 THEN LoanAmount ELSE 0 END) as dollars_lost_by_declining_good_loans
FROM loans 
WHERE CreditScore < 580 AND DTIRatio >= 0.43;
