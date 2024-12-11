
# Documentation for `main.R`

## Introduction
This script performs a comprehensive workflow for extracting, processing, and aggregating data for the **CAMS-REG-ANT** and **CAMS-REG-TEMPO** projects. It handles operations on NetCDF files, generates daily temporal profiles, creates simplified daily data, and stacks yearly data for multiple pollutants and sectors.

---

## Requirements
- **Required R packages**:
  - `ncdf4`, `abind`, `ggplot2`, `reshape2`, `scales`
- **Input files**:
  - NetCDF files for CAMS-REG-ANT and CAMS-REG-TEMPO.
  - `lon_lat_idx.rds` for data indexing.
  - CSV files with simplified temporal profiles.
- **Auxiliary scripts**:
  - `Demo/Utils.R`
  - `Demo/Config.R`
  - Other source scripts in `Demo/`.

---

## Workflow

### **1. Load Packages**
The required R libraries are loaded to ensure the necessary functions are available for data processing and visualization.

---

### **2. Configuration and Utilities**
Configuration and utility scripts (`Config.R`, `Utils.R`) are sourced to define key settings and helper functions.

---

### **3. CAMS-REG-ANT Data Extraction**
This section processes yearly data for multiple pollutants from NetCDF files:

1. **Search and order NetCDF files**: Files are searched in the directory `Demo/Data/Raw/CAMS-REG-ANT/` and ordered by version numbers.
2. **Data extraction**: The function `add_new_years_data` is used to extract data for each pollutant.
3. **Matrix creation**: A 4D matrix is created using `build_yearly_matrix`.
4. **Save output**: Results are saved as `.rds` files.

#### **Input**:
- Directory: `Demo/Data/Raw/CAMS-REG-ANT`
- NetCDF files for pollutants.

#### **Output**:
- `.rds` files in `Demo/Data/Processed/ANT_data`.

---

### **4. CAMS-REG-TEMPO Profile Extraction**
Daily and monthly temporal profiles are processed from NetCDF files:

1. **Process profiles**: Profiles are extracted using the `process_profile` function.
2. **Save profiles**: Profiles are saved as `.rds` files.

#### **Input**:
- NetCDF files: Daily and monthly temporal weights.

#### **Output**:
- `.rds` files in `Demo/Data/Processed/TEMPO_data`.

---

### **5. Simplified Profile Creation**
Simplified temporal profiles are generated from CSV files:

1. **Read CSV files**: Monthly and weekly temporal factors are read.
2. **Generate profiles**: Profiles are created for pollutants using `SimpleProfilesCreation`.

#### **Input**:
- CSV files with simplified profiles.

#### **Output**:
- Profiles in `Demo/Data/Processed/TEMPO_data/SimplifiedDailyProfiles`.

---

### **6. Daily Data Calculation**
Yearly data is converted into daily data using two approaches:
1. **With `FD` profiles**: Combines yearly data with detailed temporal profiles.
2. **With simplified profiles**: Simplified profiles are applied to yearly data.

#### **Input**:
- Yearly data (`.rds`) and temporal profiles (`FD` or simplified).

#### **Output**:
- `.rds` files with daily data.

---

### **7. Daily Data Stacking**
1. **Stack daily data**: Combines daily data across all years for each sector and pollutant.
2. **Aggregate sectors**: Summarizes data across all sectors for each pollutant.

#### **Input**:
- Directory: `Demo/Data/Processed/DAILY_data`

#### **Output**:
- `.rds` files with aggregated daily data.

---

## Example Usage
To run the full workflow, ensure all required files and directories are in place, then execute:

```R
source("main.R")
```

---

## Future Improvements
- Add detailed logging for each step (using `cat` or packages like `logger`).
- Validate input files before starting the processing.
- Integrate automated tests for the main functions.

---

## File Structure
```
main.R
Demo/
├── Utils.R
├── Config.R
├── ExtractANT/
│   ├── DataExtraction.R
├── ExtractTEMPO/
│   ├── ProfilesExtraction.R
│   ├── ProfilesCreation.R
├── Computation/
│   ├── DailyPRF_fromFMFW.R
│   ├── CreateSIMPLEdailyProfile.R
│   ├── Compute.R
│   ├── ComputeSimple.R
│   ├── StackDailyData.R
Data/
├── Raw/
│   ├── CAMS-REG-ANT/
│   ├── CAMS-REG-TEMPO/
│       ├── Simplified/
├── Processed/
│   ├── ANT_data/
│   ├── TEMPO_data/
│   ├── DAILY_data/
```

---

## Contact
For questions or contributions, please contact the repository owner or refer to the contribution guidelines in `CONTRIBUTING.md`.

---

**Note**: This documentation assumes familiarity with R and NetCDF data formats. If you encounter issues, refer to the individual scripts or contact the repository maintainer.
