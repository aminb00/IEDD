# IEDD Methodology

## Introduction

The **Italian Emission Daily Dataset (IEDD)** is constructed through a systematic methodology that starts from annual emission inventories and applies sector-specific temporal profiles to obtain daily estimates. By combining the annual baseline from CAMS-REG-ANT with temporal modulation from CAMS-REG-TEMPO, we achieve a consistent day-by-day breakdown of emissions. This approach ensures that the annual sums remain intact while revealing the temporal variability crucial for advanced atmospheric modeling, policy evaluation, and health impact studies.

This document outlines each step of the IEDD methodology, detailing data inputs, formulas, checks for consistency, and validation strategies.

## Conceptual Overview

1. **Annual Data Basis**: Begin with annual emissions from CAMS-REG-ANT, which provide total yearly pollutant loads at high spatial resolution.

2. **Temporal Disaggregation**: Use CAMS-REG-TEMPO and, if necessary, CAMS-REG-TEMPO v4.1 Simplified profiles to split these annual totals into daily values, capturing seasonal, weekly, and daily cycles.

3. **Integrity Checks**: Ensure that the sum of all daily values for a given year, pollutant, and sector returns to the original annual figure.

4. **Validation and Refinement**: Compare against known patterns, external inventories, and observed concentration data to confirm plausibility and identify improvements.

The end result is a daily emission dataset spanning 2000–2020, aligned with established European inventories.

## Data Inputs

### CAMS-REG-ANT Annual Emissions

- Pollutants: NOx, SO₂, NMVOC, NH₃, CO, PM₁₀, PM₂.₅.
- Years: 2000–2020.
- Sectors: GNFR A–L.
- Format: NetCDF files providing annual mean emission fields.

These files furnish the total annual emissions for each grid cell and sector, serving as the initial baseline.

### CAMS-REG-TEMPO Temporal Profiles

- **Daily Profiles**: If available, these provide $W_{i,s,d}$ factors for each day $d$.
- **Monthly + Weekly Profiles**: If daily profiles are missing, monthly ($X_{i,s,j,m}$) and weekly ($Y_{s,d}$) factors are used in combination.
- **Simplified Profiles (v4.1)**: If neither daily nor pollutant-specific monthly/weekly profiles are available, simplified monthly ($x_{s,m}$) and weekly ($y_{s,d}$) factors at country level are used.

Each scenario ensures that no sector-pollutant combination is left without a temporal breakdown.

## Handling Different Levels of Temporal Detail

We apply different formulas depending on data availability. Let $E_{i,s,j}$ represent the annual emission in grid cell $i$, sector $s$, for year $j$.

1. **Full Daily Profiles**:  
   If a daily profile $W_{i,s,d}$ is available for day $d$:
   $$E_{i,s,t} = E_{i,s,j} \times W_{i,s,d}$$
   
   Summing over all days $d=1$ to $D_j$ (where $D_j$ is the number of days in year $j$):
   $$\sum_{d=1}^{D_j} E_{i,s,d} = E_{i,s,j}.$$

2. **Monthly and Weekly Profiles Only**:  
   If no daily profiles exist, use monthly factors $X_{i,s,j,m}$ and weekly factors $Y_{s,d}$.  
   Let $m$ represent the month corresponding to day $t$. Then:
   $$E_{i,s,t} = E_{i,s,j} \times X_{i,s,j,m} \times Y_{s,d}.$$
   
   Monthly factors sum to 1 across the year, and weekly factors sum to 7 over the week.

3. **Simplified Monthly and Weekly Profiles**:  
   If only country-level, year-independent monthly ($x_{s,m}$) and weekly ($y_{s,d}$) factors exist:
   $$E_{i,s,t} = E_{i,s,j} \times x_{s,m} \times y_{s,d}.$$

In all cases, the chosen factors are normalized so that the daily values, when summed, reproduce the annual total.

## Accounting for Leap Years

Leap years have 366 days. If $j$ is a leap year:
- $D_j = 366$,
else
- $D_j = 365$.

For monthly/weekly distributions, February’s length changes, ensuring that emissions on February 29 are included in leap years.

## Spatial Domain Clipping to Italy

CAMS data cover Europe. We subset the grid to extract only the cells representing Italy. Coastal and maritime cells within Italy’s boundaries remain, reflecting maritime-related emissions. Users can later mask these if desired.

## Data Integration Steps

1. **Loading Annual Data**:  
   Read the CAMS-REG-ANT NetCDF files for each pollutant and year. Identify indices corresponding to Italy and store the annual emission arrays.

2. **Loading Temporal Profiles**:  
   Depending on availability, read daily (W), monthly (X), weekly (Y), or simplified (x, y) profiles. These may come from NetCDF or CSV files.

3. **Matching Sectors and Pollutants**:  
   Align sector (GNFR categories) and pollutant codes. Determine which type of profile applies.

4. **Temporal Disaggregation**:  
   For each grid cell $i$, sector $s$, year $j$, and day $t$ (or $d$):
   - If daily profiles exist: use $W_{i,s,d}$.
   - Else, use $X_{i,s,j,m} \times Y_{s,d}$ or $x_{s,m} \times y_{s,d}$.

   Compute $E_{i,s,t}$ accordingly.

5. **Aggregation Check**:  
   Verify that $\sum_{t=1}^{D_j} E_{i,s,t} \approx E_{i,s,j}$. Allow tiny floating-point tolerances. If needed, apply minor normalization to ensure perfect mass balance.

6. **Data Formatting and Storage**:  
   Store daily emission arrays in `.rds` or other preferred formats. Typically:
   - Longitude dimension: ~119 points
   - Latitude dimension: ~232 points
   - Time dimension: 7,671 days (2000–2020)
   
   Save separate files for each pollutant and sector, and a "sum" file that aggregates all sectors.

## Quality Assurance, Validation, and Sensitivity

### Internal Validation

- **Temporal Sum Check**: Confirm no artificial emission gain or loss by verifying annual sums.
- **Statistical Comparison**: Compare mean and median emissions before and after temporal disaggregation.
- **Seasonal Patterns**: Check if known seasonal behaviors (e.g., NH₃ peaks during fertilizer application) are reflected.

### External Validation

- Compare with national inventories (e.g., ISPRA) to check long-term trends.
- Cross-reference with independent datasets like AGRIMONIA for pollutant-specific checks.
- Evaluate if using IEDD as input in atmospheric models improves correlation with observed pollutant concentrations.

### Uncertainty Considerations

All emission inventories carry uncertainties in activity data, emission factors, and spatial/temporal allocations. The IEDD does not eliminate these uncertainties but distributes them across days. Future improvements could refine temporal profiles or use data assimilation techniques to minimize uncertainty.

## Computational Aspects

Handling large datasets (20 years x daily x multiple pollutants and sectors) requires careful memory management:

- Process data year by year, sector by sector.
- Use vectorization or parallelization to expedite calculations.
- Employ compressed binary formats for storage to reduce disk space usage.

## Reproducibility and Code Availability

The entire code pipeline is available open-source, encouraging verification, reuse, and adaptation. Users can:

- Reproduce the dataset from CAMS sources.
- Modify profiles or pollutants.
- Extend coverage beyond 2020 or apply the methodology to other regions.

## Future Methodological Enhancements

Potential improvements include:

- Integrating near-real-time activity data (e.g., traffic, power load) for more current daily estimates.
- Adding CH₄ and CO₂ once robust daily profiles are available.
- Implementing data assimilation from atmospheric measurements to refine temporal patterns.
- Using year-specific temporal profiles to reflect evolving socioeconomic conditions.

## Conclusion

The IEDD methodology transforms annual emission inventories into a daily-level dataset without sacrificing overall consistency. By applying sector-specific temporal profiles, we reveal the short-term emission dynamics essential for detailed atmospheric modeling, targeted policy analysis, and public health studies. As new data and techniques emerge, the methodology can evolve, further enhancing the IEDD’s accuracy, usefulness, and impact.