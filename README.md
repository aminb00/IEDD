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

## 📊 **Interactive Map of Italy's Municipalities**

Here is an interactive map of Italy, with its municipalities:

<div id="map" style="height: 600px;"></div>
<script>
    var map = L.map('map').setView([41.9028, 12.4964], 5); // Center the map on Italy

    // Add OpenStreetMap tiles
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);

    // Add GeoJSON layer for Italy's municipalities
    var geojsonLayer = new L.GeoJSON.AJAX("path_to_your_geojson_file.geojson"); // Add your own GeoJSON file path here
    geojsonLayer.addTo(map);
</script>


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
