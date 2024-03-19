# Italian Emissions Daily Dataset (IEDD)

## Project Overview
The IEDDC project aims to construct a dataset representing daily emissions for Italian municipalities by leveraging the detailed data provided by the CAMSREG datasets and employing CAMS-TEMPO weight factors for temporal distribution.

### Background
- **CAMS-TEMPO**: A dataset that offers temporal profiles for global and European emissions, providing gridded monthly, daily, weekly, and hourly weight factors crucial for atmospheric chemistry modeling.

- **CAMS-REG**: A high-resolution European emission inventory for an 18-year time series (2000–2017) at 0.05° × 0.1° grid resolution, designed to support air quality modeling. This inventory encompasses key air pollutants and is based on officially reported emissions data, complemented by the GAINS model estimates.

## Methodology
1. **Annual Data Extraction**: Harvest yearly emissions data from the CAMS-REG dataset for Italy.

2. **Temporal Transformation**: Utilize CAMS-TEMPO to convert annual data points into daily emission estimates, reflecting fluctuations due to seasonal and other temporal factors.

3. **Municipality Data Integration**: Map daily emissions to the respective Italian municipalities, aligning the data with administrative boundaries for localized analysis.

4. **Dataset Compilation**: Assemble a structured dataset that encapsulates daily emission metrics per municipality, serving as a tool for environmental studies and policymaking.

## Repository Structure
- `/annual_camsreg_data`: Original annual datasets from CAMS-REG.
- `/daily_emissions`: Daily emissions data processed using CAMS-TEMPO.
- `/municipality_boundaries`: Geospatial data of Italian municipalities.
- `/transformation_scripts`: Scripts and methodologies for data processing.
- `/documentation`: Detailed explanations of CAMS-TEMPO, CAMS-REG, and data structure.

## Potential Applications
- Environmental Impact Assessments: Analyzing the

## Usage
The dataset constructed as part of this project can be utilized for various purposes, including but not limited to:
- **Environmental Impact Studies**: Assess the daily emissions impact on local and regional environments.
- **Policy Formulation**: Aid governmental bodies in crafting targeted environmental regulations and policies.
- **Public Awareness**: Increase public awareness about the environmental footprint of different municipalities.

## Contributing
We welcome contributions from the community. You can contribute by:
- Improving the existing scripts for data extraction and transformation.
- Enhancing the dataset with additional data points or integrating supplementary datasets.
- Reporting and fixing issues related to data accuracy and integrity.

## License
This project is licensed under the [MIT License](LICENSE).

## Contact
For any queries regarding the project, please reach out to [Project Maintainer's Email].

## Acknowledgements
- [Data Source Providers]
- [Contributors and Collaborators]
