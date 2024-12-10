# CAMS Inventories

## Introduction

The Copernicus Atmosphere Monitoring Service (CAMS) provides a suite of emission inventories and supporting datasets designed to improve our understanding of atmospheric composition and facilitate accurate air quality modeling, climate studies, and policy evaluations across Europe and beyond. Two key CAMS datasets form the backbone of the IEDD (Italian Emission Daily Dataset) construction:

1. **CAMS-REG-ANT**: A regional anthropogenic emission inventory for Europe.
2. **CAMS-REG-TEMPO**: A set of temporal profiles that allow the conversion of annual or monthly emission totals into finer temporal resolutions, up to daily and even hourly scales.

These CAMS inventories are the foundational layers upon which the IEDD is built. By leveraging the precise spatial resolution of CAMS-REG-ANT and the detailed temporal factors from CAMS-REG-TEMPO, the IEDD can achieve its objective of providing day-by-day emissions. This section delves into the structure, methodology, and relevance of these CAMS datasets.

## The Role of CAMS in Emission Inventories

CAMS, an integral component of the European Union’s Earth Observation program (Copernicus), supports policy makers, scientific communities, and stakeholders by supplying consistent and up-to-date information on atmospheric composition. CAMS integrates data from multiple sources, including official national inventories, global emission databases, and high-resolution proxies such as population density maps, satellite data, traffic counts, and meteorological observations. This integrative approach ensures that CAMS inventories can be used as a reference standard, offering harmonized and quality-controlled emission data.

### Advantages of CAMS Inventories

- **Harmonization Across Countries**: CAMS ensures consistency in emission reporting methodologies and data quality across European countries. This uniformity is crucial for transnational studies, regulatory compliance checks, and large-scale emission reduction strategies.
  
- **High Spatial Resolution**: While global datasets might provide emissions at coarse resolutions (e.g., 0.1° x 0.1° or even coarser), CAMS-REG-ANT refines this to a higher-resolution grid (0.05° x 0.1°), enabling localized emission hot-spots and gradients to be captured more accurately.

- **Multi-Pollutant, Multi-Sector Coverage**: CAMS inventories cover a range of pollutants (from classical air quality pollutants like NOx, SO2, PM, NMVOCs, NH3, and CO, to greenhouse gases like CH4 and CO2) and sectors, following established nomenclatures (e.g., the GNFR sector classification).

- **Regular Updates and Improvements**: CAMS inventories are periodically revised and improved as new data, methodologies, and proxies become available. This iterative enhancement ensures that users have access to the latest best estimates.

## CAMS-REG-ANT: The Core Annual Inventory

**CAMS-REG-ANT** (CAMS Regional Anthropogenic) is a detailed emission inventory for the European domain, developed and maintained by TNO and other partners under the CAMS framework. It provides annual gridded emissions of primary atmospheric pollutants and greenhouse gases, estimated at a high spatial resolution across Europe.

### Key Features of CAMS-REG-ANT

1. **Geographical Domain**:  
   CAMS-REG-ANT covers a broad European area extending beyond the EU’s borders, ensuring a comprehensive view of the continent’s emission landscape. Italy is fully captured within this domain, making it an ideal primary data source for constructing the IEDD.

2. **High Spatial Resolution**:  
   Data is presented on a 0.1° x 0.05° latitude-longitude grid. This resolution corresponds to roughly 6 km in central Europe, allowing for a detailed representation of emission patterns. Such spatial detail is essential for identifying emission sources in densely populated or industrialized regions like the Po Valley.

3. **Wide Temporal Coverage**:  
   CAMS-REG-ANT provides emissions from the early 2000s up to recent years (e.g., v5.1 covers 2000–2018, v6.1 extends to 2019–2020). For the IEDD, these data ensure a coherent and continuous time series spanning two decades.

4. **Sectoral and Pollutant Breakdowns**:  
   Emissions are categorized following the GNFR sectors (A to L), each representing a distinct cluster of activities (e.g., public power, industry, road transport, agriculture). Pollutants covered include NOx, SO2, NMVOCs, NH3, CO, PM10, PM2.5, and greenhouse gases. This granularity facilitates sector-specific analysis and enables targeted temporal disaggregation.

5. **Methodology**:  
   CAMS-REG-ANT combines top-down national inventories with bottom-up estimates. Each European country’s officially reported data (under NECD or CLRTAP frameworks) is used where possible. When national data are incomplete or missing, CAMS-REG-ANT adopts model estimates (e.g., from IIASA’s GAINS model) or international inventories (like EDGAR) to fill data gaps. The resulting dataset harmonizes multiple sources and applies spatial proxies (population density, road networks, industrial point sources, agricultural maps) to allocate national totals onto the grid.

### Importance for the IEDD

CAMS-REG-ANT’s annual gridded emissions serve as the “starting point” for IEDD computations. Without a reliable baseline of annual emissions, it would be impossible to derive daily values accurately. The IEDD uses CAMS-REG-ANT data as the integral input from which temporal profiles are applied, ensuring that the sum of the daily emissions over a year matches the original annual totals. This maintains consistency and comparability with other inventories and compliance requirements.

## CAMS-REG-TEMPO: Adding the Time Dimension

While CAMS-REG-ANT provides the “when” at an annual scale, the **CAMS-REG-TEMPO** dataset allows for breaking down these annual totals into seasonal, monthly, weekly, daily, or even hourly fractions. It accomplishes this through the provision of sector- and pollutant-specific temporal profiles.

### Characteristics of CAMS-REG-TEMPO

1. **Multi-Level Temporal Resolutions**:  
   CAMS-REG-TEMPO offers a hierarchy of temporal factors:
   - **Monthly profiles**: Capture seasonal changes, reflecting how emissions vary between winter and summer.
   - **Weekly profiles**: Differentiate between weekday and weekend patterns. For example, road transport might have distinct weekday vs. weekend traffic flows.
   - **Daily profiles**: For some sectors and pollutants, daily factors account for day-to-day variations influenced by local conditions or short-term socioeconomic events.
   - **Hourly profiles**: In certain cases, diurnal cycles are captured, essential for modeling daily pollution peaks (e.g., morning and evening rush hours in transport).

2. **Sector-Specific and Pollutant-Dependent**:  
   Different GNFR sectors show distinct temporal patterns. For instance, residential heating (sector C) emissions depend heavily on ambient temperature and thus vary by month and even day. Road transport (sector F) might have strong weekly and diurnal patterns. The temporal profiles in CAMS-REG-TEMPO often vary by pollutant as well—e.g., NMVOC might have distinct temporal signatures compared to NOx in the same sector due to differences in underlying emission processes (evaporative sources vs. combustion).

3. **Geographical Specificity**:  
   CAMS-REG-TEMPO provides profiles either at country level or at a gridded level, depending on the availability of data and complexity of the sector. For Italy, the dataset includes country-specific factors and, when available, grid-level patterns (e.g., daily variation in residential heating emissions tied to local climatic conditions). This geographical detail ensures that temporal disaggregation is not just generic but reflects local habits and climatic influences.

4. **Yearly Independence or Dependence**:  
   Some profiles are year-independent, representing a climatological or average pattern (e.g., “typical” monthly factors for residential heating). Others may vary year-by-year if historical data (e.g., annual HDD anomalies, industrial production indices) are included. For the IEDD construction, a combination of year-specific and climatological profiles ensures that long-term trends and year-to-year variability in activities are considered.

### The CAMS-REG-TEMPO v4.1 Simplified Profiles

In addition to the detailed V3.1 profiles, the IEDD project utilizes the **CAMS-REG-TEMPO v4.1 Simplified** dataset when no daily profiles are available for a given pollutant or sector. This simplified dataset:
- Provides monthly and weekly factors at a country level.
- Is year-independent, offering a stable reference for temporal splitting.
- Serves as a fallback method to ensure that all sectors and pollutants can at least be broken down to daily values using a combination of monthly and weekly scaling.

While these simplified factors may not capture year-specific peculiarities, they ensure that no sector or pollutant is left at a coarse temporal resolution.

### Importance for the IEDD

CAMS-REG-TEMPO is the “time key” that unlocks the transition from annual data to daily data. By applying these temporal profiles to the annual CAMS-REG-ANT grids, the IEDD can produce daily emissions. The process respects the sum-check: summing all daily emissions over a year returns the original annual total, ensuring consistency and no artificial inflation or deflation of yearly emissions.

For example:
- For sectors with daily profiles (like residential heating), the IEDD applies a grid cell-specific daily factor \( W_{i,s,d} \) directly to the annual emission to get daily emissions.
- For sectors where only monthly and weekly factors are available, daily emissions are computed as:
  \[
  E_{i,s,t} = E_{i,s,j} \times X_{i,s,j,m} \times Y_{s,d}
  \]
  where \(X_{i,s,j,m}\) is the monthly factor and \(Y_{s,d}\) is the weekly factor for day \(d\).
- If only simplified monthly and weekly profiles exist (from v4.1 Simplified), the daily emissions become:
  \[
  E_{i,s,t} = E_{i,s,j} \times x_{s,m} \times y_{s,d}
  \]

This flexibility ensures that even in the absence of perfect daily detail, a best-estimate daily value can be constructed.

## Linking CAMS Inventories with National and International Data

CAMS inventories are not developed in isolation. They rely heavily on:
- **National Inventories**: Each European country reports emissions to international bodies. CAMS uses these official data as primary inputs where available.
- **Global Inventories**: For regions or sectors not well covered by national reporting, CAMS may refer to EDGAR or other global datasets to fill gaps, ensuring no missing data regions within the European domain.
- **Proxy Data and Models**: Population density grids, road network maps, industrial point source databases, and models like IIASA’s GAINS supplement the top-down data from countries to improve spatial and sectoral detail.

This layered approach ensures that CAMS-REG-ANT and CAMS-REG-TEMPO are built on a robust and scientifically sound foundation. They are continuously validated, updated, and improved as new data and methodologies become available.

## Quality Control, Uncertainties, and Documentation

CAMS emission products, including CAMS-REG-ANT and CAMS-REG-TEMPO, undergo rigorous quality assurance and quality control (QA/QC) procedures:
- **Consistency Checks**: Ensuring that sum of emissions for all grid cells matches the national total and that sector shares align with reported statistics.
- **Comparisons with Independent Data**: Cross-referencing with in-situ measurements, remote sensing observations, and inverse modeling results to identify systematic biases or discrepancies.
- **Uncertainty Quantification**: Emissions are estimates and often come with uncertainties related to emission factors, activity data accuracy, spatial proxies, and temporal assumptions. CAMS documentation acknowledges these uncertainties, providing users with context and guiding caution in interpretation.

Extensive documentation is provided for each CAMS release, detailing the methodologies, data sources, proxy usage, and any known limitations. This transparency helps users of the IEDD to understand the underlying data’s reliability and constraints.

## Relevance and Future Directions

The ongoing improvements in CAMS inventories, both in terms of spatial detail and temporal resolution, align well with emerging needs in the scientific and policy communities. As modeling systems become more sophisticated and computational power increases, the appetite for finer spatial and temporal emission data grows. CAMS stands ready to incorporate new data streams—such as satellite-based NO2 observations—to refine top-down estimates and better represent daily emission cycles.

Future directions for CAMS may involve:
- Incorporating more dynamic temporal proxies (e.g., real-time traffic data).
- Regularly updating the inventories to near-real-time estimates for certain sectors.
- Integrating pollutant-specific climate forcers and focusing on emerging sectors (e.g., hydrogen production emissions, new industrial processes).

For the IEDD, these future CAMS enhancements could mean even more accurate and granular daily data, enabling near-real-time policy responsiveness and improved environmental decision-making.

## Conclusion

CAMS-REG-ANT and CAMS-REG-TEMPO form the crucial backbone that supports the creation of the IEDD. They supply the accurate annual baseline and the flexible temporal factors needed to convert coarse temporal data into daily emission estimates. Understanding the methodologies, strengths, and inherent assumptions within these CAMS inventories is key to interpreting the IEDD results confidently. As CAMS continues to evolve and improve, users can expect the IEDD and similar daily emission datasets to keep pace, providing ever more reliable data for air quality modeling, climate assessments, and policy analyses.