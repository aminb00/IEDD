# 🛠️ **Methodology**

## 🌍 **Overview**

The methodology for constructing the **Italian Emission Daily Dataset (IEDD)** combines spatially detailed annual emissions data with high-resolution temporal profiles. This process involves three key steps:
1. Extracting annual emissions data from the **CAMS-REG-ANT** dataset.
2. Applying temporal disaggregation using profiles from **CAMS-REG-TEMPO**.
3. Mapping emissions to Italian municipalities through a **change of support** procedure.

---

## 📜 **1. Annual Emissions Extraction**

Annual emissions (\(E_{i,s,j}\)) are extracted for each grid cell (\(i\)), sector (\(s\)), and year (\(j\)) from the **CAMS-REG-ANT** dataset.

### 📋 **Key Formula**:
\[
E_{i,s,j} = \text{Annual Emissions for grid cell } i, \text{ sector } s, \text{ year } j
\]

### 🔍 **Details**:
- \(i\): Represents a grid cell at 0.05° × 0.1° resolution.
- \(s\): Represents the GNFR sector (e.g., transport, agriculture).
- \(j\): Represents the year (2000–2020).

---

## 🗓️ **2. Temporal Disaggregation**

The annual emissions are converted into daily values using temporal profiles from **CAMS-REG-TEMPO**.

### ✨ **Case 1: Daily Profiles Available**
When detailed daily profiles (\(W_{i,s,d}\)) exist, the formula is:
\[
E_{i,s,t} = E_{i,s,j} \cdot W_{i,s,d}
\]
Where:
- \(E_{i,s,t}\): Daily emissions for grid cell \(i\), sector \(s\), and day \(t\).
- \(W_{i,s,d}\): Daily temporal weight.

### ✨ **Case 2: Monthly and Weekly Profiles**
For sectors with monthly (\(X_{i,s,j,m}\)) and weekly (\(Y_{s,d}\)) profiles:
\[
E_{i,s,t} = E_{i,s,j} \cdot (X_{i,s,j,m} \cdot Y_{s,d})
\]
Where:
- \(m\): Month index (1–12).
- \(d\): Day of the week (Monday–Sunday).

### ✨ **Case 3: Simplified Temporal Profiles**
For missing temporal data, simplified factors (\(x_{s,m}\), \(y_{s,d}\)) are used:
\[
E_{i,s,t} = E_{i,s,j} \cdot (x_{s,m} \cdot y_{s,d})
\]

---

## 🌎 **3. Geographic Alignment**

### 📍 **Change of Support**
The gridded emissions (\(0.05° × 0.1°\)) are mapped to Italian municipalities using interpolation techniques.

### 🔧 **Challenges**:
- Ensuring consistency between grid cells and municipal boundaries.
- Preserving the spatial detail of the original data during transformation.

---

## 🎯 **Final Output**

The methodology produces:
1. Daily emissions data for all pollutants and sectors.
2. A seamless transition from grid-based emissions to municipality-based data.
3. A dataset ready for policy-making, environmental modeling, and academic research.
