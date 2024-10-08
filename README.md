# 🌍 **Italian Emissions Daily Dataset (IEDD)**

## 📜 **Project Overview**
The IEDD project aims to build a comprehensive dataset representing daily emissions in Italian municipalities. The dataset leverages detailed data from the CAMS-REG-ANT datasets and employs CAMS-REG-TEMPO weight factors for accurate temporal distribution.

### 🔍 **Background**
- **CAMS-REG-ANT**: 🌐 Annual emissions data covering key pollutants across Europe, such as **NOx, SO2, NH3, CO, PM10, PM2.5, CH4, NMVOCs,** and **CO2**. The spatial resolution is **0.05° x 0.1°**.
  
- **CAMS-REG-TEMPO**: 🗓️ Temporal profiles providing gridded monthly, daily, weekly, and hourly weight factors. These help distribute CAMS-REG-ANT data to offer a more granular temporal view, essential for accurate emissions modeling.

## 🛠️ **Methodology**
1. **Annual Data Extraction**: 📥 Extract yearly emissions data for Italy from the CAMS-REG-ANT dataset.
2. **Temporal Transformation**: 🗓️ Convert annual emissions to daily estimates using the CAMS-REG-TEMPO profiles. Each day reflects variations in monthly, weekly, and daily emissions patterns.
3. **Municipality Data Integration**: 🗺️ Match daily emissions to each Italian municipality's administrative boundaries for localized analysis.
4. **Dataset Compilation**: 📊 Compile the final dataset with daily emissions metrics per municipality, suitable for environmental studies and policymaking.

![Flow Chart of Methodology](IEDD_FlowChart_V1.png)

## 📑 **GNFR Sectors**
The GNFR (Gridded Nomenclature for Reporting) sectors categorize emissions by activity:

- **A Public Power and Heat Production**: 🔋 Emissions from public power, heat, and cogeneration plants.
- **B Industrial Combustion**: 🏭 Emissions from industrial manufacturing combustion.
- **C Other Stationary Combustion**: 🏠 Emissions not covered by public power or industrial combustion.
- **D Fugitive Emissions**: ⛽ From extraction and distribution of fuels.
- **E Solvent and Product Use**: 🧪 Solvents in processes and products.
- **F Road Transport**: 🚗 Road vehicle emissions.
- **G Shipping**: 🚢 Domestic and international shipping emissions.
- **H Aviation**: ✈️ National and international aviation emissions.
- **I Offroad Transport**: 🚜 Vehicles in agriculture and forestry.
- **J Waste Treatment and Disposal**: 🗑️ Emissions from waste processes.
- **K Agriculture**: 🌾 Agricultural production emissions.
- **L Other Agricultural Sources**: 🌳 Emissions not classified above.

## 📂 **Repository Structure**
- 📁 `/annual_camsreg_data`: CAMS-REG-ANT annual datasets.
- 📁 `/daily_emissions`: Daily emissions processed using CAMS-REG-TEMPO.
- 📁 `/municipality_boundaries`: Geospatial data of Italian municipalities.
- 📁 `/transformation_scripts`: Scripts and methodologies for data processing.
- 📁 `/documentation`: Detailed explanations of CAMS-REG-ANT, CAMS-REG-TEMPO, and data structure.

## 🏆 **Potential Applications**
- **Environmental Impact Assessments**: 🌿 Analyze daily emissions impacts on local/regional environments.
- **Policy Formulation**: 🏛️ Support policymakers in drafting environmental regulations.
- **Public Awareness**: 📢 Increase public awareness of emissions at the municipality level.

## ⚙️ **Usage**
The dataset can be used for environmental studies, policy development, and increasing public awareness. It offers comprehensive insights into temporal emission patterns.

## 📊 **2020 NH3 Emissions in Italy**
Here is the representation of the NH3 emissions in Italy for the year 2020. The map shows the spatial distribution of emissions, highlighting cells with higher concentrations.

![NH3 Emissions in Italy 2020](NH3_Emissions_Italy_HighRes.png)

# Main characteristics of the CAMS-REG-TEMPOv4.1 dataset

The following table provides an overview of the main characteristics of the CAMS-REG-TEMPOv4.1 dataset, reported by sector and temporal resolution (monthly, daily, weekly, hourly). These profiles are used to model emissions data by sector, pollutant, and spatial scale.

| Sector   | Description                               | Monthly (Σ=12)                        | Daily (Σ=365/366)(1)                  | Weekly (Σ=7)                          | Hourly (Σ=24)                        |
|----------|-------------------------------------------|---------------------------------------|---------------------------------------|---------------------------------------|---------------------------------------|
| GNFR_A   | Public Power                               | Per country, pollutant                | -                                     | Per country, pollutant                | Per country, pollutant               |
| GNFR_B   | Industry                                   | Per country                           | -                                     | -                                     | Fixed(2)                             |
| GNFR_C   | Other stationary combustion                | Per grid cell, pollutant, year        | Per grid cell, pollutant, year        | Per pollutant                        | Per pollutant                        |
| GNFR_D   | Fugitive emissions                         | Fixed(2)                              | -                                     | Fixed(2)                              | Fixed(2)                             |
| GNFR_E   | Solvents                                   | Fixed(2)                              | -                                     | Fixed(2)                              | Fixed(2)                             |
| GNFR_F1  | Road transport exhaust gasoline            | Per year, grid cell for CO and NMVOC; per grid cell for others | -                                     | Per country, day type                 | Per country, day type                |
| GNFR_F2  | Road transport exhaust diesel              | Per year, grid cell for NOx; per grid cell for others | -                                     | Per country, day type                 | Per country, day type                |
| GNFR_F3  | Road transport exhaust LPG                 | Per grid cell                         | -                                     | -                                     | Per country, day type                |
| GNFR_F4  | Road transport non-exhaust (wear and evaporative) | Per grid cell                         | -                                     | -                                     | Fixed for NMVOC                      |
| GNFR_G   | Shipping                                   | Per sea region and pollutant          | -                                     | -                                     | Fixed(2)                             |
| GNFR_H   | Aviation                                   | Per country                           | -                                     | -                                     | Fixed, per pollutant                 |
| GNFR_I   | Off road transport                         | Fixed, per pollutant                  | -                                     | Fixed, per pollutant                  | Fixed, per pollutant                 |
| GNFR_J   | Waste management                           | Fixed(2)                              | -                                     | Fixed(2)                              | Fixed(2)                             |
| GNFR_K   | Agriculture (livestock)                    | Per grid cell, year for NH3 and NOx; fixed for NH3 and NOx | Per grid cell, year for NH3 and NOx   | -                                     | Fixed for pollutant                  |
| GNFR_L   | Agriculture (fertilizers, agricultural waste burning) | Per country for CH4, per grid cell for NH3, others(3) | Per grid cell, year for NH3           | -                                     | Fixed, per pollutant                 |

### Notes:
1. **Leap or non-leap years**: Daily profiles account for the leap year, adjusting the number of days accordingly.
2. **Fixed(2)**: Same profiles as those reported by the TNO dataset (Denier van der Gon et al., 2011).
3. **For CH4**: Same profiles as the ones reported by Crippa et al. (2020).

Source: CAMS261_2022SC1 – Product documentation.

## 🔄 **Change of Support**

The concept of **Change of Support** involves transforming data from one spatial resolution or support (such as a grid of cells) to another (such as administrative boundaries like municipalities). This process is essential when trying to associate gridded data (such as emissions or pollution data) with specific geographic regions that are used in administrative or policy-making contexts.

In this project, we will perform a **change of support** by transitioning data from grid cells (with a resolution of 0.05° x 0.1°) to the boundaries of Italian municipalities. This will allow us to analyze and visualize emissions at a local level, directly linked to municipalities, rather than using arbitrary grid cells.

Below, you can see the two types of spatial resolutions that we will be using in the transformation:

<div style="display: flex; justify-content: space-around;">
    <div style="text-align: center;">
        <img src="## 🔄 **Change of Support**

The concept of **Change of Support** involves transforming data from one spatial resolution or support (such as a grid of cells) to another (such as administrative boundaries like municipalities). This process is essential when trying to associate gridded data (such as emissions or pollution data) with specific geographic regions that are used in administrative or policy-making contexts.

In this project, we will perform a **change of support** by transitioning data from grid cells (with a resolution of 0.05° x 0.1°) to the boundaries of Italian municipalities. This will allow us to analyze and visualize emissions at a local level, directly linked to municipalities, rather than using arbitrary grid cells.

Below, you can see the two types of spatial resolutions that we will be using in the transformation:

<div style="display: flex; justify-content: space-around;">
    <div style="text-align: center;">
        <img src="2020NH3emissionsITALY.png" alt="Grid Cell Map" style="width: 45%;">
        <p>Grid Cell Data</p>
    </div>
    <div style="text-align: center;">
        <img src="ITA-Municipalities-MAP" alt="Municipality Map" style="width: 45%;">
        <p>Municipality Data</p>
    </div>
</div>
" alt="Grid Cell Map" style="width: 45%;">
        <p>Grid Cell Data</p>
    </div>
    <div style="text-align: center;">
        <img src="path_to_your_municipality_image" alt="Municipality Map" style="width: 45%;">
        <p>Municipality Data</p>
    </div>
</div>


## 🙌 **Contributing**
Contributions are welcome, such as:
- 🛠️ Improving data extraction/transformation scripts.
- 🔍 Enhancing the dataset with supplementary data.
- 🐞 Reporting and fixing issues with data accuracy.

## 📜 **License**
This project is licensed under the [MIT License](LICENSE).

## Contact
For any queries regarding the project, please reach out to [Project Maintainer's Email].

## Acknowledgements
- [Data Source Providers]
- [Contributors and Collaborators]
