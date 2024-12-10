# CAMS Inventories

## Introduction

The Copernicus Atmosphere Monitoring Service (CAMS) provides a suite of emission inventories and supporting datasets designed to improve our understanding of atmospheric composition and facilitate accurate air quality modeling, climate studies, and policy evaluations across Europe and beyond. Two key CAMS datasets form the backbone of the IEDD (Italian Emission Daily Dataset) construction:

1. **CAMS-REG-ANT**: A regional anthropogenic emission inventory for Europe.
2. **CAMS-REG-TEMPO**: A set of temporal profiles that allow the conversion of annual or monthly emission totals into finer temporal resolutions, including daily and even hourly scales.

These CAMS inventories are the foundational layers upon which the IEDD is built. By leveraging the precise spatial resolution of CAMS-REG-ANT and the detailed temporal factors from CAMS-REG-TEMPO, the IEDD can achieve its objective of providing day-by-day emissions. This document delves into the structure, methodology, and relevance of these CAMS datasets.

## The Role of CAMS in Emission Inventories

CAMS, an integral part of the European Union’s Copernicus program, supports policymakers, scientists, and other stakeholders by delivering consistent and up-to-date information on atmospheric composition. CAMS integrates data from multiple sources—official national inventories, global emission databases, and high-resolution proxies (e.g., population density, satellite data, traffic counts, meteorological observations)—to create harmonized, quality-controlled emission datasets.

### Advantages of CAMS Inventories

- **Harmonization Across Countries**: CAMS ensures that emission reporting is methodologically consistent across European countries. This uniformity enables effective transnational studies, regulatory compliance verifications, and coordinated emission reduction strategies.

- **High Spatial Resolution**: CAMS-REG-ANT provides emissions on a 0.05° x 0.1° grid, enabling the identification of localized hotspots and nuanced spatial gradients. This is a significant improvement over coarser global datasets.

- **Multi-Pollutant, Multi-Sector Coverage**: CAMS covers a wide range of pollutants (NOx, SO₂, PM, NMVOCs, NH₃, CO, and greenhouse gases like CH₄, CO₂) and sectors (GNFR A–L). This breadth ensures comprehensive analyses, from residential heating to heavy industry and agriculture.

- **Regular Updates and Improvements**: CAMS inventories are periodically revised. As new data, methods, and proxies arise, CAMS integrates them, ensuring users have access to the most refined estimates possible.

## CAMS-REG-ANT: The Core Annual Inventory

**CAMS-REG-ANT** is a detailed anthropogenic emission inventory for Europe. Developed by TNO and other CAMS partners, it provides annual gridded emissions of key pollutants at high resolution.

### Key Features of CAMS-REG-ANT

1. **Geographical Domain**:  
   Covers a broad European area, ensuring a pan-continental perspective. Italy falls fully within this domain, making CAMS-REG-ANT an ideal primary data source for the IEDD.

2. **High Spatial Resolution**:  
   With data at approximately 6 km resolution (0.05° x 0.1°), CAMS-REG-ANT captures fine spatial details. Such granularity is vital in regions like the Po Valley, where complex topography and meteorology influence pollution dispersion.

3. **Temporal Coverage**:  
   CAMS-REG-ANT provides a time series from the early 2000s to the near-present. For IEDD (2000–2020), it offers a coherent baseline spanning two decades.

4. **Sectoral and Pollutant Detail**:  
   Pollutants include NOx, SO₂, NMVOCs, NH₃, CO, PM₁₀, PM₂.₅, and greenhouse gases. Sectors follow the GNFR classification (A–L), representing distinct activity clusters. This granularity enables fine-tuned sector-specific temporal disaggregation.

5. **Methodological Underpinnings**:  
   CAMS-REG-ANT aligns top-down national inventories with bottom-up estimates. Where data are missing, models like IIASA’s GAINS or global inventories like EDGAR fill gaps. Spatial proxies (e.g., population maps, road networks) further distribute national totals onto grids.

### Importance for the IEDD

CAMS-REG-ANT’s annual emissions serve as the baseline for the IEDD. By starting with a trusted annual figure, the IEDD’s daily totals remain consistent with recognized standards. Summing all IEDD daily values over a year reproduces the CAMS-REG-ANT totals, ensuring credibility and comparability with other inventories.

## CAMS-REG-TEMPO: Adding Temporal Detail

While CAMS-REG-ANT provides annual data, **CAMS-REG-TEMPO** introduces temporal profiles that refine these totals to monthly, weekly, daily, and even hourly resolutions.

### Characteristics of CAMS-REG-TEMPO

1. **Multi-Level Temporal Resolutions**:  
   - **Monthly profiles** capture seasonal shifts.  
   - **Weekly profiles** differentiate weekday/weekend activities.  
   - **Daily profiles** reflect day-to-day changes due to weather, events, or socioeconomic factors.  
   - **Hourly profiles** capture diurnal cycles (e.g., rush-hour peaks).

2. **Sector-Specific and Pollutant-Dependent**:  
   Sectors have unique temporal signatures. Residential heating is temperature-sensitive, agricultural emissions follow seasonal planting/harvesting cycles, and transport emissions show weekly or diurnal variability. Different pollutants in the same sector can vary in time due to different processes (e.g., evaporative NMVOC vs. combustion-related NOx).

3. **Geographic Specificity**:  
   Profiles can be country-level or gridded, ensuring that local habits (e.g., heating patterns in Northern vs. Southern Italy) are captured.

4. **Yearly Dependence or Independence**:  
   Some profiles are year-independent (climatological averages), while others adjust annually (e.g., accounting for unusually cold winters). For the IEDD, this flexibility ensures an accurate reflection of temporal emission patterns over two decades.

### CAMS-REG-TEMPO v4.1 Simplified Profiles

When detailed daily or pollutant-specific profiles are unavailable, **CAMS-REG-TEMPO v4.1 Simplified** provides monthly and weekly factors at a country level. Although less precise, they ensure that no pollutant or sector is left without temporal disaggregation, allowing at least a best-estimate daily series.

### Importance for the IEDD

CAMS-REG-TEMPO is the key to unlocking daily patterns from annual totals. By applying these profiles to CAMS-REG-ANT emissions, the IEDD produces daily estimates while preserving annual integrity. Whether using daily factors, monthly+weekly combinations, or simplified profiles, the final daily emissions remain faithful to the annual sums.

## Linking CAMS with Other Data

CAMS inventories integrate multiple layers of information:

- **National Inventories**: Form the backbone where available.  
- **Global Databases (EDGAR)**: Fill gaps outside Europe or where national data are lacking.  
- **Proxy Data and Models (GAINS, LandScan)**: Spatially distribute emissions and refine sectoral estimates.

This layered approach ensures that CAMS-REG-ANT and CAMS-REG-TEMPO rest on a robust, scientifically sound foundation. Continuous validation, updates, and improvements keep the data relevant and accurate.

## Quality Control, Uncertainty, and Documentation

CAMS follows strict QA/QC protocols:
- **Consistency Checks**: Ensuring grid totals align with national sums.  
- **Comparisons with Independent Data**: Aligning estimates with measurements or inverse modeling results.  
- **Uncertainty Quantification**: Recognizing that emission factors, proxies, and temporal assumptions introduce uncertainties. CAMS documentation addresses these, guiding users in data interpretation.

Comprehensive documentation accompanies each CAMS release, detailing sources, methods, and known limitations. This transparency helps IEDD users assess data quality and uncertainty.

## Relevance and Future Directions

As demands for finer resolution and near-real-time data grow, CAMS evolves:
- Future CAMS versions may incorporate real-time traffic data or satellite-derived NO₂ observations.
- Near-real-time estimates could support immediate policy responses.
- Emerging sectors (e.g., hydrogen production) may appear in future inventories.

For the IEDD, these advancements mean increasingly accurate and granular daily data, supporting timely, informed environmental decision-making.

## Conclusion

CAMS-REG-ANT and CAMS-REG-TEMPO are essential pillars of the IEDD, offering trusted annual baselines and sophisticated temporal profiles. By understanding the methodologies and strengths of these inventories, users of the IEDD can interpret daily emissions with confidence. As CAMS continues to refine its inventories, the IEDD stands to benefit, delivering ever more reliable and actionable data for air quality, climate, and policy applications.