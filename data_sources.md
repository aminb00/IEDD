# 📑 **Data Sources**

## 🌍 **Overview**
The **Italian Emission Daily Dataset (IEDD)** leverages two primary data sources to construct a detailed and high-resolution daily emissions dataset for Italy:
1. **CAMS-REG-ANT**: Annual emission estimates gridded at a fine spatial resolution.
2. **CAMS-REG-TEMPO**: Temporal profiles that disaggregate annual emissions into daily estimates.

Together, these datasets form the backbone of the IEDD, ensuring spatial, temporal, and sectoral consistency in emissions data.

---

## 📜 **1. CAMS-REG-ANT Dataset**

The **CAMS-REG-ANT (Regional Anthropogenic Emissions)** dataset provides annual gridded emissions data for Europe. It is a cornerstone of the Copernicus Atmosphere Monitoring Service (CAMS) and offers a comprehensive overview of pollutant emissions across various sectors.

### ✨ **Key Features**
- **Pollutants Covered**: Includes **NOx**, **SO2**, **CO**, **PM10**, **PM2.5**, **NH3**, **NMVOCs**, and **CO2**.
- **Spatial Resolution**: 0.05° × 0.1°, providing fine-scale emissions data ideal for regional and local analysis.
- **Temporal Resolution**: Annual data from 2000 to 2020.
- **Sectoral Coverage**: Emissions are categorized according to the **GNFR (Gridded Nomenclature for Reporting)** sectors, including:
  - 🏭 **Industry**
  - 🚗 **Transport**
  - 🏠 **Residential Combustion**
  - 🌾 **Agriculture**
  - 🗑️ **Waste Management**

### 📊 **Data Construction**
The CAMS-REG-ANT dataset employs a **top-down methodology**, which means:
1. **National-Level Emissions**: Emissions are first estimated at the country level using official reports and inventories.
2. **Gridded Allocation**: Emissions are then distributed over a spatial grid using activity proxies, such as:
   - **Population density** (for residential emissions).
   - **Traffic data** (for transport emissions).
   - **Industrial site locations** (for industrial emissions).

This ensures that the gridded data align with reported totals while capturing spatial heterogeneity.

---

## 🗓️ **2. CAMS-REG-TEMPO Dataset**

The **CAMS-REG-TEMPO** dataset provides temporal profiles that describe how annual emissions vary across different time scales—monthly, weekly, daily, and hourly. These profiles are essential for transforming static annual emissions data into dynamic daily datasets.

### ✨ **Key Features**
- **Temporal Resolutions**:
  - **Monthly Profiles**: Capture seasonal variations in emissions (e.g., higher residential heating emissions in winter).
  - **Weekly Profiles**: Account for differences in activity levels on weekdays vs. weekends.
  - **Daily Profiles**: Reflect daily variations based on socio-economic and meteorological factors.
- **Sectoral Specificity**: Each sector (e.g., transport, agriculture) has a unique temporal profile that reflects its activity pattern.

### 🌱 **Temporal Variability in Agriculture**
For example:
- **NH3 Emissions from Agriculture**:
  - **Monthly Peaks**: Align with fertilizer application periods in spring and autumn.
  - **Daily Peaks**: Linked to livestock management and specific agricultural activities.

---

## 💡 **Why Use CAMS-REG-ANT and CAMS-REG-TEMPO?**

The integration of these datasets ensures:
- **High Spatial Resolution**: Gridded emissions down to 0.05° × 0.1° enable detailed analysis.
- **High Temporal Resolution**: Disaggregation into daily emissions captures short-term variability critical for modeling.
- **Sectoral Granularity**: Emissions are broken down by GNFR sectors, making the dataset adaptable to diverse applications.

---

## 🛠️ **Challenges in Using the Data**

1. **Handling Missing Data**: Some sectors and pollutants lack detailed profiles, requiring simplifications.
2. **Temporal Alignment**: Ensuring that temporal profiles accurately reflect activity patterns specific to Italy.
3. **Change of Support**: Mapping gridded data to municipality boundaries without losing spatial detail.

By addressing these challenges, the IEDD ensures robustness and reliability in its emissions estimates.
