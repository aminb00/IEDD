# 🛠️ **Methodology**

## 🌍 **Overview**

The methodology for constructing the **Italian Emission Daily Dataset (IEDD)** combines spatially detailed annual emissions data with high-resolution temporal profiles. This process involves three core steps:

1. 📥 **Annual Emissions Extraction**: Extracting gridded annual emissions data from the **CAMS-REG-ANT** dataset.
2. 🗓️ **Temporal Disaggregation**: Applying temporal profiles from **CAMS-REG-TEMPO** to distribute annual emissions across days.
3. 📍 **Geographic Alignment**: Mapping gridded emissions to Italian municipalities using **change of support** methods.

---

## 📜 **1. Annual Emissions Extraction**

Annual emissions (\(E_{i,s,j}\)) are retrieved for each grid cell (\(i\)), sector (\(s\)), and year (\(j\)) from the **CAMS-REG-ANT** dataset.

### 📋 **Key Formula**
\[
E_{i,s,j} = \text{Annual Emissions for grid cell } i, \text{ sector } s, \text{ year } j
\]

### 🔍 **Details**
- \(i\): Represents a grid cell at **0.05° × 0.1° resolution**.
- \(s\): Represents the **GNFR sector** (e.g., **transport**, **agriculture**, etc.).
- \(j\): Represents the **year** (2000–2020).

**Example:**
- \(i = (45.5^\circ N, 9.2^\circ E)\): Milan grid cell.
- \(s = F\): Road transport.
- \(j = 2020\): Year of emission.

---

## 🗓️ **2. Temporal Disaggregation**

The annual emissions (\(E_{i,s,j}\)) are converted into daily values (\(E_{i,s,t}\)) using the temporal profiles from **CAMS-REG-TEMPO**. Depending on the sector and pollutant, different cases apply.

### ✨ **Case 1: Daily Profiles Available**
When daily profiles (\(W_{i,s,d}\)) exist, the conversion is straightforward:
\[
E_{i,s,t} = E_{i,s,j} \cdot W_{i,s,d}
\]

**Where:**
- \(E_{i,s,t}\): Daily emissions for grid cell \(i\), sector \(s\), and day \(t\).
- \(W_{i,s,d}\): Daily temporal weight specific to the grid cell, sector, and day.

### 🧪 **Example**
- \(E_{i,s,j} = 100\): Annual emissions for NOx from road transport in grid cell \(i\).
- \(W_{i,s,d} = 0.0027\): Weight for Monday, January 1st.
- **Result**:
\[
E_{i,s,t} = 100 \cdot 0.0027 = 0.27 \, \text{kg/day}
\]

---

### ✨ **Case 2: Monthly and Weekly Profiles**
If daily profiles are unavailable, **monthly** (\(X_{i,s,j,m}\)) and **weekly** (\(Y_{s,d}\)) profiles are combined:
\[
E_{i,s,t} = E_{i,s,j} \cdot (X_{i,s,j,m} \cdot Y_{s,d})
\]

**Where:**
- \(m\): Month of the year (January = 1, December = 12).
- \(d\): Day of the week (Monday = 1, Sunday = 7).

---

### ✨ **Case 3: Simplified Temporal Profiles**
For sectors lacking detailed profiles, simplified factors (\(x_{s,m}\), \(y_{s,d}\)) are used:
\[
E_{i,s,t} = E_{i,s,j} \cdot (x_{s,m} \cdot y_{s,d})
\]

**Example:**
- \(x_{s,m} = 0.12\): Fraction for March.
- \(y_{s,d} = 0.15\): Weight for a weekday.
- \(E_{i,s,j} = 100\): Annual emissions.
\[
E_{i,s,t} = 100 \cdot (0.12 \cdot 0.15) = 1.8 \, \text{kg/day}
\]

---

## 🌎 **3. Geographic Alignment**

Annual emissions data from the **CAMS-REG-ANT** dataset is gridded, while the temporal disaggregation retains the grid-cell structure. To align this data with Italian municipalities, a **change of support** is performed.

### 📍 **Key Steps**
1. 🗺️ **Spatial Interpolation**: Reassign grid-cell emissions to municipal boundaries based on spatial overlap.
2. 🔍 **Preservation of Totals**: Ensure that the sum of emissions within the municipal boundaries matches the original grid totals.

### 🔧 **Challenges**
- **Spatial Consistency**: Matching grid cells with irregular municipal boundaries.
- **Accuracy**: Minimizing data distortion during interpolation.

---

## 🎯 **Final Output**

The final methodology results in:
1. **Daily Emissions Dataset**: Detailed emissions data for all GNFR sectors and pollutants across Italy, broken down by day and municipality.
2. **Scalable Framework**: Adaptable for future updates and integration with socio-economic datasets.
3. **Applications Ready**: A robust dataset for environmental modeling, public health research, and policy-making.



---

## 🎯 **Final Output**

The methodology produces:
1. Daily emissions data for all pollutants and sectors.
2. A seamless transition from grid-based emissions to municipality-based data.
3. A dataset ready for policy-making, environmental modeling, and academic research.
