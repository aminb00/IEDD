# IEDD Methodology

## Introduction

The **Italian Emission Daily Dataset (IEDD)** is constructed through a well-defined methodology that combines annual gridded emission inventories, sector-specific temporal profiles, and robust data processing techniques. The core idea is to disaggregate annual emissions into daily values, while maintaining internal consistency, sectoral detail, and alignment with established inventories (CAMS-REG-ANT) and temporal profiles (CAMS-REG-TEMPO).

This document details each step of the IEDD methodological framework, from data acquisition and filtering to the mathematical formulas and quality checks that ensure reliable daily emission estimates. Our aim is to provide a rigorous, transparent, and reproducible methodology.

## Conceptual Overview

1. **Start from Annual Data**: Use CAMS-REG-ANT as the baseline. These files contain annual mean emissions for each pollutant and sector over Europe, including Italy, on a 0.05° x 0.1° grid.

2. **Apply Temporal Profiles**: Use CAMS-REG-TEMPO (and if needed, CAMS-REG-TEMPO v4.1 Simplified) to break down annual totals into daily values. These profiles capture monthly, weekly, and/or daily variations.

3. **Consistency Checks**: Ensure that summing the daily emissions over a year returns the original annual total.

4. **Refine and Validate**: Compare against known emission trends and external data.

This ensures the final IEDD respects original data integrity and adds valuable temporal resolution.

## Data Inputs

### CAMS-REG-ANT Annual Emission Files

- Pollutants: NOx, SO2, NMVOC, NH3, CO, PM10, PM2.5.
- Years: 2000–2020.
- Sectors: GNFR A–L.
- Format: NetCDF files (annual mean emissions at each grid cell).

These provide the base annual emission totals.

### CAMS-REG-TEMPO Temporal Profiles

- Daily profiles: Fine-grained, if available.
- Monthly + Weekly profiles: Used where daily profiles are not available.
- CAMS-REG-TEMPO v4.1 Simplified: Country-level monthly and weekly factors.

These profiles may be in NetCDF or CSV formats.

## Handling Different Levels of Temporal Detail

The IEDD uses different formulas depending on available temporal detail:

1. **Full Daily Profiles Available**:  
   If a daily factor W(i,s,d) exists for grid cell i, sector s, and day d:
   
   E(i,s,t) = E(i,s,j) * W(i,s,d)
   
   - E(i,s,j): Annual emission for grid cell i, sector s, year j.
   - W(i,s,d): Daily fraction for day d.

   Summation check: Σ over d=1 to D_j of E(i,s,d) = E(i,s,j), where D_j is the number of days in year j.

2. **Monthly and Weekly Profiles Only**:  
   If daily profiles are not available, combine monthly and weekly factors:
   
   E(i,s,t) = E(i,s,j) * X(i,s,j,m) * Y(s,d)
   
   - X(i,s,j,m): Monthly fraction for month m in year j.
   - Y(s,d): Weekly factor for day type d (e.g., Monday vs. Sunday).

   Monthly factors sum to 1 over the year; weekly factors sum to 7 over a week.

3. **Simplified Monthly and Weekly Profiles**:  
   If only country-level, year-independent monthly (x(s,m)) and weekly (y(s,d)) factors exist:
   
   E(i,s,t) = E(i,s,j) * x(s,m) * y(s,d)

In all cases, the products of these factors are normalized so that when summed over all time units (days in a year), they recreate the annual total.

## Accounting for Leap Years and Calendar Variability

Leap years (2000, 2004, 2008, 2012, 2016, 2020) have 366 days. The code checks each year:

- If leap year, D_j=366; else D_j=365.

For monthly/weekly combinations, the shorter or longer February affects the daily distribution. February 29 is accounted for in leap years.

## Spatial Domain Clipping and Focus on Italy

CAMS data cover Europe. We subset the domain to include only Italy’s territory, reducing data volume and ensuring relevance to the Italian domain.

Coastal and maritime areas may contain shipping-related emissions. They remain in the dataset. Users can mask them if needed.

## Data Integration Steps

### Step 1: Data Loading and Preprocessing

- Load annual emissions from CAMS-REG-ANT (NetCDF).
- Identify Italy’s grid indices (longitude, latitude).
- Load temporal profiles (CAMS-REG-TEMPO) from NetCDF or CSV.

### Step 2: Matching Sectors and Pollutants

CAMS uses GNFR sector codes and standard pollutant names. For each pollutant and sector, determine if daily, monthly+weekly, or simplified factors apply.

### Step 3: Temporal Disaggregation

After matching the best profiles:
- Extract E(i,s,j) from annual data.
- Compute daily factors using W(i,s,d), or X(i,s,j,m)*Y(s,d), or x(s,m)*y(s,d).
- Calculate E(i,s,t) accordingly.

The result is a multidimensional dataset with daily values.

### Step 4: Aggregation Checks

Check if Σ E(i,s,t) over all days t equals E(i,s,j). Allowing a tiny floating-point tolerance, if discrepancies appear, apply normalization.

### Step 5: Data Formatting and Storage

The output is stored as .rds files (or other formats), typically:
- Dimensions: lon ≈ 119, lat ≈ 232, time = 7,671 days (2000–2020).
- Separate files per pollutant and sector.
- A “sum” file with all sectors combined.

## Quality Assurance, Validation, and Sensitivity Analysis

### Internal Validation

1. Temporal sum check: Ensures no mass loss/gain.
2. Statistical comparison with original data.
3. Visual inspection of seasonal patterns (e.g., NH3 peaks in fertilizer application periods).

### External Validation

Compare IEDD with:
- National inventories (ISPRA).
- Independent datasets (e.g., AGRIMONIA).
- Modeled vs. observed pollutant concentrations.

If daily resolution improves correlation with observations, it suggests the temporal disaggregation is realistic.

### Uncertainty Considerations

All emission estimates have uncertainties:
- Uncertain activity data, emission factors, spatial proxies, temporal profiles.
- IEDD introduces no new uncertainties but redistributes existing ones across days.
- Future updates can reduce uncertainties by improving temporal profiles.

## Computational Aspects

Handling large data:
- Process year by year, sector by sector to manage memory.
- Utilize vectorized or parallel operations.
- Store data in compressed binary formats to save disk space.

## Reproducibility and Code Availability

The full pipeline (data reading, profile application, final output) is available as open-source R code on GitHub. Users can:
- Reproduce results from original CAMS data.
- Modify profiles or pollutants.
- Adapt to other regions or timeframes.

This openness encourages verification, improvements, and adaptation by the research community.

## Future Methodological Enhancements

Potential improvements:
1. Integrate near-real-time data (e.g., traffic counts) for current daily estimates.
2. Add CH4 and CO2 once suitable daily profiles exist.
3. Employ data assimilation techniques to refine daily patterns.
4. Introduce year-specific sectoral profiles for evolving emission behaviors.

## Conclusion

The IEDD methodology is a systematic approach to enrich annual emission inventories with daily temporal detail. By applying robust temporal profiles and ensuring consistency, we produce a dataset beneficial for modeling, policy analysis, and scientific research. As new data and methods emerge, the methodology can evolve, maintaining relevance and accuracy over time.
