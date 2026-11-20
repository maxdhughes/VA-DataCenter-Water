# VA Data Center Water Use (Withdrawals)

## Data
- data/03_Withdrawals.csv – DEQ Water Withdrawal Dashboard
  (https://datascience.deq.virginia.gov/Water-Withdrawals-View/)
  Units: million gallons per month. Reporting threshold: >10,000 gal/day.

## Scripts (run in order)
- 01_clean.R – renames columns, removes power records, labels missing use types,
  drops duplicate, reshapes to long -> data/withdrawals_clean.csv
- 02_explore.R – keyword search, data center county scan, Power Loft plots

## Outputs
- powerloft_monthly.png – monthly withdrawals 2012–2025
- powerloft_annual.png – annual totals 2012–2025
- powerloft_seasonal.png – average by month, 2018–2025

## Decisions
- Excluded hydroelectric, fossil, nuclear (non-comparable flows)
- 8 facilities with no use type labeled "Unknown"
- Portsmouth CEDS 200000066629 appears twice w/ uncorrelated series (both rows dropped)
- Keyword list is my own (not sourced) w/ whole-word matching
- Zeros kept as-is (meaning unconfirmed)

## Findings
- Only data center: Power Loft @ Innovation Data Center (Prince William,
  CEDS 200000899636, Industrial, self-supplied groundwater)
- DEQ has no data center use type
- Power Loft is classified as Industrial
- Withdrawals peaked in 2022 (39.5 MG), then declined steadily to 16.8 MG
  in 2025 (~57% lower)
  - All years have 12 months reported
- Seasonal: peak in July (~3.3 MG/month), low in Feb (~1.8 MG/month)
- Jan–Feb 2018 are zeros, followed by a step up to ~4.5 MG/month
- No other data centers self-report in Loudoun, Prince William, Fairfax,
  Stafford, Culpeper, or Henrico (likely on utility water)

## Questions
- What do zeros mean (Jan–Feb 2018)?
- Why did Power Loft use decline after 2022?
- How can we link data centers to utility withdrawals (PEC locations + EPA boundaries)