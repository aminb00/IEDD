# IEDD Methodology

## Introduction

The **Italian Emission Daily Dataset (IEDD)** is constructed through a well-defined methodology that combines annual gridded emission inventories, sector-specific temporal profiles, and robust data processing techniques. The underlying logic is to disaggregate annual emissions into daily values while maintaining internal consistency, sectoral detail, and alignment with established inventories (CAMS-REG-ANT) and temporal modulators (CAMS-REG-TEMPO).

This document details each step of the IEDD methodological framework, from data acquisition and filtering to the mathematical formulas and quality checks that ensure reliable and useful daily emission estimates. Our aim is to provide an academically rigorous, transparent, and reproducible methodology that researchers, policymakers, and other stakeholders can trust and build upon.

## Conceptual Overview

The construction of the IEDD follows a top-down temporal disaggregation approach:

1. **Start from Annual Data**: Use CAMS-REG-ANT as the baseline. These files contain annual mean emissions (in kg·m⁻²·s⁻¹) for each pollutant and sector over the entire European domain, including Italy, on a 0.05° x 0.1° grid.

2. **Apply Temporal Profiles**: Incorporate CAMS-REG-TEMPO (and where necessary, CAMS-REG-TEMPO v4.1 Simplified) profiles to break down annual totals into daily values. Temporal profiles capture monthly, weekly, and daily variations in emissions driven by seasonality, meteorology, socioeconomic patterns, and cultural habits.

3. **Consistency Checks**: Ensure that the sum of daily emissions over the year matches the original annual sum, preserving data integrity.

4. **Refine and Validate**: Check the dataset against known emission trends, external validation inventories, and expected patterns (e.g., higher residential heating emissions in winter).

This methodology ensures that the final IEDD respects the data’s original integrity while providing the additional time resolution needed for advanced applications.

## Data Inputs

### CAMS-REG-ANT Annual Emission Files

- **Pollutants**: NOx, SO2, NMVOC, NH3, CO, PM10, PM2.5.
- **Years**: 2000–2020 (combining CAMS-REG-ANT versions that cover this period).
- **Sectors (GNFR)**: A through L, each representing a distinct activity sector (e.g., energy, industry, transport, agriculture).
- **Format**: NetCDF files containing annual emission fields at each grid cell.

These files provide the bulk emission “budget” per year, sector, pollutant, and grid cell. The IEDD uses these totals as a starting point.

### CAMS-REG-TEMPO Temporal Profiles

- **Daily profiles**: Available for some sectors and pollutants, providing fine-grained day-to-day variation.
- **Monthly + Weekly profiles**: Used where daily profiles are missing. Monthly factors capture seasonal variations; weekly factors differentiate weekday/weekend behavior.
- **CAMS-REG-TEMPO v4.1 Simplified**: Provides climatological monthly and weekly factors at the country level, ensuring that all sectors and pollutants can be disaggregated into daily values even without detailed daily profiles.

These profiles are provided in NetCDF or CSV formats, depending on the version and complexity, and are then mapped onto the corresponding GNFR sectors and pollutants.

## Handling Different Levels of Temporal Detail

The IEDD methodology accommodates varying levels of temporal detail:

1. **Full Daily Profiles Available**:  
   For sectors where a daily factor \( W_{i,s,d} \) is provided (e.g., GNFR C for residential heating in some CAMS-REG-TEMPO versions), daily emissions are simply:
   \[
   E_{i,s,t} = E_{i,s,j} \times W_{i,s,d}
   \]
   Here:
   - \( E_{i,s,j} \): Annual emission for grid cell \( i \), sector \( s \), year \( j \).
   - \( W_{i,s,d} \): Daily fraction for day \( d \).

   Summing over all days:
   \[
   \sum_{d=1}^{D_j} E_{i,s,d} = E_{i,s,j} \quad \text{where } D_j \text{ is the number of days in year } j.
   \]

2. **Monthly and Weekly Profiles Only**:  
   When no daily profiles exist, emissions are first split into months and then days using a combination of monthly and weekly factors:
   \[
   E_{i,s,t} = E_{i,s,j} \times X_{i,s,j,m} \times Y_{s,d}
   \]
   Where:
   - \( X_{i,s,j,m} \): Monthly fraction for month \( m \) in year \( j \).
   - \( Y_{s,d} \): Weekly factor differentiating each day type (e.g., Monday vs. Sunday).
   
   Monthly factors sum to 1 across all 12 months, and weekly factors sum to 7 across the week, ensuring proper normalization.

3. **Simplified Monthly and Weekly Profiles (CAMS-REG-TEMPO v4.1)**:  
   If the dataset only provides generalized (country-level, year-independent) monthly \( x_{s,m} \) and weekly \( y_{s,d} \) factors, daily emissions become:
   \[
   E_{i,s,t} = E_{i,s,j} \times x_{s,m} \times y_{s,d}
   \]

   Though less precise, this approach ensures temporal disaggregation for all sectors/pollutants, preventing data gaps.

In all cases, the methodology enforces that the products of the profiles sum to 1 over the entire year (considering the combination of monthly/weekly/daily factors), ensuring conservation of the annual total.

## Accounting for Leap Years and Calendar Variability

From 2000 to 2020, several leap years occur (2000, 2004, 2008, 2012, 2016, 2020). The IEDD methodology incorporates the correct number of days per year. Temporal profiles that provide daily factors are adjusted to 365 or 366 days accordingly. For monthly/weekly combinations, February’s length affects the daily distribution, ensuring that emissions on February 29 are properly accounted for in leap years.

The code implementation checks each year:
- If leap year: \( D_j = 366 \)
- Else: \( D_j = 365 \)

Then, it distributes annual emissions across these days following the defined profiles.

## Spatial Domain Clipping and Focus on Italy

The initial CAMS datasets cover a broader European domain. The IEDD extraction focuses solely on Italy. After reading the NetCDF files, a spatial subset operation is performed to select only those grid cells whose geographical coordinates lie within the Italian territory. This clipping reduces data volume and ensures that the final dataset pertains only to the region of interest.

**Note on Coastal and Maritime Areas**: Some emission sources related to shipping or offshore industries may appear in cells covering coastal waters. The IEDD includes these cells as they belong to the official spatial extent of Italy as defined by the inventory. Users can further mask or exclude these areas if they prefer to focus solely on terrestrial emissions.

## Data Integration Steps

### Step 1: Data Loading and Preprocessing

- **Annual Emissions (CAMS-REG-ANT)**: Each pollutant-year file is opened using a NetCDF reader. Variables for longitude and latitude are extracted, and indices corresponding to the Italian domain are identified. Emissions are read into a 3D or 4D array structure: (longitude, latitude, sector, time).

- **Temporal Profiles (CAMS-REG-TEMPO)**:  
  Profiles are loaded from their respective formats (NetCDF or CSV). They may come in a variety of forms:
  - Gridded daily arrays for certain sectors.
  - Monthly and weekly mean profiles stored as simple CSV files with country-level factors.

  The profiles are reshaped and indexed so that they can be easily matched to the sectors and pollutants in the annual emission arrays.

### Step 2: Matching Sectors and Pollutants

Both CAMS-REG-ANT and CAMS-REG-TEMPO adopt the GNFR sector classification and standardized pollutant naming. This ensures a straightforward alignment. For each pollutant \( P \) and sector \( S \):

1. Identify if a daily profile exists in CAMS-REG-TEMPO.
2. If not, check for monthly and weekly profiles.
3. If neither daily nor monthly/weekly profiles are pollutant-specific, apply the simplified monthly/weekly profiles from the v4.1 dataset.

This logical hierarchy guarantees that the best available temporal resolution is always used.

### Step 3: Temporal Disaggregation

After determining the appropriate temporal profiles, the code applies them year by year, sector by sector, pollutant by pollutant, and grid cell by grid cell:

1. **Extract Annual Emissions** \( E_{i,s,j} \)
2. **Calculate Daily Factors** according to the best available formula:
   - If daily profiles: \( W_{i,s,d} \)
   - Else monthly \((X_{i,s,j,m})\) and weekly \((Y_{s,d})\) or simplified \((x_{s,m}, y_{s,d})\)
3. **Compute Daily Emissions**:
   \[
   E_{i,s,t} = E_{i,s,j} \times \text{(appropriate temporal factor combination)}
   \]

This step generates a large 4D or 5D dataset that might be temporarily held in memory as arrays before final serialization to .rds or NetCDF files (depending on user requirements).

### Step 4: Aggregation Checks

To ensure no mass loss or gain during the temporal disaggregation:

- Sum daily emissions for each \( i,s,j \) over all days:
  \[
  \sum_{t=1}^{D_j} E_{i,s,t} \stackrel{?}{=} E_{i,s,j}
  \]

In practice, floating-point arithmetic might cause negligible rounding differences. The code checks if the difference is within a tiny tolerance (e.g., \(10^{-12}\) in relative terms). If not, corrective normalization steps can be applied.

### Step 5: Data Formatting and Storage

Finally, the daily emissions are stored in a convenient format. We use .rds (R’s internal binary format) for memory efficiency and fast loading, but users are free to convert them into other formats (e.g., NetCDF) as needed. The final structure typically has dimensions:

- **Longitude**: ~119 values
- **Latitude**: ~232 values
- **Time**: 7,671 days (from Jan 1, 2000 to Dec 31, 2020)
- **Sectors**: Stored in separate files or combined arrays, depending on user preferences

Each pollutant’s dataset is subdivided by sector for flexibility. There is also a “sum” file that aggregates emissions across all sectors, providing total anthropogenic emissions per day, pollutant, and grid cell.

## Quality Assurance, Validation, and Sensitivity Analysis

### Internal Validation

1. **Temporal Sum Check**: The simplest validation is ensuring daily sums re-aggregate to the annual total. If the temporal profiles are correctly applied and normalized, this condition holds.

2. **Statistical Comparison with Original Data**: Mean, median, and total emissions are compared before and after temporal disaggregation. Although the temporal pattern changes, annual integrals should remain identical.

3. **Visual Inspection of Seasonal Patterns**: For example, NH3 emissions from agriculture should peak during the periods of fertilizer application. If daily data show unexpected peaks (e.g., high NH3 in winter without agricultural rationale), further investigation into the profiles or data processing steps is warranted.

### External Validation

The IEDD can be compared against:
- **National Inventories (ISPRA)**: While ISPRA’s official inventory is annual, comparing year-over-year trends ensures consistency in long-term patterns.
- **Independent Datasets (e.g., AGRIMONIA)**: Cross-referencing NH3 emissions with datasets derived from other global or regional inventories can identify systematic biases or deviations.
- **Concentration Observations and Modeling Outputs**: Although not a direct validation of emissions themselves, improved correlation between modelled and observed pollutant concentrations (after using IEDD data as input) suggests that the daily resolution is beneficial and realistic.

### Uncertainty Considerations

All emission inventories have uncertainties related to activity data, emission factors, spatial allocation proxies, and temporal profiling. The IEDD does not eliminate these uncertainties but distributes them across daily time steps. Users must keep in mind that:
- Uncertainties may be higher for specific sectors or pollutants lacking robust temporal profiles.
- The daily patterns are best estimates rather than direct measurements of emissions.

As methodological improvements, updated temporal profiles, or more refined sectoral data become available, future versions of the IEDD can incorporate these enhancements to reduce uncertainty.

## Computational Aspects

Handling large, multi-year, high-resolution datasets requires computational care:

- **Memory Management**: Large arrays are processed incrementally. The code may load one year, sector, and pollutant at a time.
- **Parallelization and Vectorization**: Where possible, vectorized operations or parallel loops speed up processing, essential when dealing with two decades of daily data (over 7,600 days).
- **Efficient Storage Formats**: Using compressed binary formats (e.g., RDS) reduces disk space and loading times, which is critical for a dataset that can reach tens of gigabytes.

## Reproducibility and Code Availability

The entire IEDD construction pipeline, including data reading, profile application, and final output creation, is documented in open-source R code available on GitHub. Comments, function documentation, and example scripts allow users to:
- Reproduce the dataset from the original CAMS data sources.
- Modify temporal profiles or include additional pollutants/sectors.
- Adapt the methodology to other regions or time periods.

The transparent, open-source nature of the code encourages collaboration, peer review, and iterative improvements. Researchers can modify parts of the code to test alternative temporal allocations, apply new proxies, or extend coverage beyond 2020.

## Future Methodological Enhancements

As data sources and methods improve, future methodological refinements may include:

1. **Real-Time Temporal Adjustments**: Incorporating near-real-time activity data (e.g., traffic counts from sensors, updated heating degree days) to produce more current daily estimates.
2. **Inclusion of Additional Pollutants**: Expanding the methodology to greenhouse gases (CH4, CO2) once daily temporal profiles become available.
3. **Data Assimilation Techniques**: Using atmospheric observations and inverse modeling to adjust daily patterns, reducing uncertainties in temporal allocation.
4. **Dynamic Sectoral Profiles**: Allowing for year-specific changes in temporal