# 🌍 Italian Daily Geo-referenced Emissions through Inventories and Temporal Profiles

## 📜 Abstract
This study presents the development of the **Italian Emission Daily Dataset (IEDD)**, an advanced dataset providing high-resolution daily emission data for Italy from 2000 to 2020. Combining annual emissions from **CAMS-REG-ANT** and temporal profiles from **CAMS-REG-TEMPO**, the IEDD addresses the limitations of existing inventories, offering a valuable tool for air quality modeling, environmental policy analysis, and urban planning. The dataset captures sector-specific spatial and temporal emission dynamics, including transport, residential heating, and industrial processes.

## 🔍 Introduction
### Context
- Italy faces significant air pollution challenges, particularly in the **Po Valley**, one of the most densely populated and industrialized areas in Europe. The valley's unique topography and frequent thermal inversions exacerbate pollutant concentrations.
- Traditional emission datasets focus on annual or monthly resolutions, which fail to capture daily variability crucial for analyzing transport, heating, and industrial activities.

### Objective
The **IEDD** aims to provide high-resolution daily emission data to:
- Improve the accuracy of air quality and climate models.
- Support policy evaluations for short-term interventions (e.g., traffic restrictions or emission caps).
- Assist in urban planning by identifying pollution hotspots.

## 📑 Data Sources
### CAMS-REG-ANT
- **Annual Emissions Inventory**:
  - Covers pollutants: **NOx, SO2, NH3, CO, PM10, PM2.5, CH4, NMVOCs, CO2**.
  - Spatial resolution: **0.05° × 0.1° grid**.
  - Combines reported data and model estimates across sectors.

### CAMS-REG-TEMPO
- **Temporal Profiles**:
  - Captures daily, weekly, and seasonal emission patterns.
  - Accounts for meteorological, economic, and social activity variations.
  - Enables disaggregation of annual emissions into finer temporal scales.

## 🛠️ Methodology
The methodology integrates annual emissions from **CAMS-REG-ANT** with temporal profiles from **CAMS-REG-TEMPO** to compute daily emissions for each pollutant, sector, and grid cell.

### **1. Annual Emissions Extraction**
- **Data Selection**:
  - Used **CAMS-REG-ANT v5.1** for 2000–2018 and **v6.1** for 2019–2020.
- **Emission Formula**:
  Annual emissions (\(E_{i,s,j}\)) for grid cell \(i\), sector \(s\), and year \(j\) serve as the base input for daily calculations.

### **2. Temporal Disaggregation**
Temporal profiles are applied to convert annual emissions into daily values.

#### **Case 1: Daily Profiles Available**
- Direct application of daily factors (\(W_{i,s,d}\)):
  \[
  E_{i,s,t} = E_{i,s,j} \cdot W_{i,s,d}
  \]

#### **Case 2: Monthly and Weekly Profiles**
- Combined use of monthly (\(X_{i,s,j,m}\)) and weekly (\(Y_{s,d}\)) factors:
  \[
  E_{i,s,t} = E_{i,s,j} \cdot (X_{i,s,j,m} \cdot Y_{s,d})
  \]

#### **Case 3: Simplified Monthly and Weekly Profiles**
- For pollutants or sectors lacking detailed profiles, simplified factors (\(x_{s,m}\), \(y_{s,d}\)) are used:
  \[
  E_{i,s,t} = E_{i,s,j} \cdot (x_{s,m} \cdot y_{s,d})
  \]

### **3. Geographic Alignment**
- **Change of Support**: Gridded emissions (\(0.05° × 0.1°\)) are mapped to Italian municipal boundaries using spatial interpolation techniques.
- Allows localized analysis and integration with socio-economic datasets.

## 📊 Results
### **Dataset Features**
- **Temporal Resolution**: Daily emissions for 7671 days (2000–2020).
- **Spatial Coverage**: Entire Italian territory, aligned to municipality boundaries.
- **Pollutants**: NOx, SO2, NH3, CO, PM10, PM2.5, NMVOC, and more.

### **Validation**
- Compared with **AGRIMONIA** and **ISPRA** datasets.
- Key Findings:
  - **NOx**: Significant reductions from 2000 to 2020 due to stricter transport regulations.
  - **PM**: Residential heating remains a consistent contributor.

## 🌍 Visualizations
### **Heatmaps**
- **Monthly Trends**: Highlight seasonal variations for pollutants like NH3 and PM10.
- **Pollution Hotspots**: Po Valley consistently shows elevated concentrations.

### **Temporal Trends**
- Road transport emissions peak during weekdays.
- Winter months show higher residential heating emissions.

## 🏆 Applications
The IEDD dataset enables:
1. **Policy Analysis**:
   - Evaluate emission caps or traffic restrictions.
2. **Air Quality Modeling**:
   - Input for forecasting tools to predict pollution levels.
3. **Public Health Research**:
   - Correlate daily pollution with short-term health outcomes.
4. **Urban Planning**:
   - Identify hotspots and optimize infrastructure.

## 🚀 Future Work
- **Dataset Expansion**:
  - Include CH4 and CO2 with improved temporal profiles.
  - Extend coverage to 2022 using **CAMS-REG-TEMPO v4.1**.
- **Advanced Applications**:
  - Integrate socio-economic indicators (e.g., GDP, population density).
  - Enhance visualization tools for stakeholders.

## 🙌 Acknowledgments
- **Copernicus Atmosphere Monitoring Service** for data access.
- Academic advisors and collaborators for their guidance and support.

---

## 📂 View My Thesis
[Click here to view my uploaded thesis file.](INSERT_LINK_TO_YOUR_THESIS)

