# Italian Emissions Daily Dataset Project

## Project Overview
This project aims to construct a comprehensive dataset of daily emission figures for Italian municipalities. Starting from the CAMSREG annual datasets, which provide detailed emission data across various sectors, we employ the CAMSTEMPO approach to distill this information into a daily format. The ultimate goal is to integrate these transformed daily emissions data with the geographic layout of Italian municipalities, thereby producing a granular and dynamic environmental dataset.

## Data Sources
- **CAMSREG Datasets**: Provide annual emissions data across multiple sectors.
- **CAMSTEMPO**: A methodology used to convert annual data into daily emission estimates.

## Methodology
1. **Data Extraction**: We begin by extracting the annual emissions data from the CAMSREG datasets, which includes sector-wise and total emissions for the entire country.
   
2. **Data Transformation**: Utilizing the CAMSTEMPO approach, we then convert the annual figures into daily estimates. This involves disaggregating the yearly data, taking into account seasonal variations, and other temporal factors that affect emission levels.
   
3. **Data Integration**: The daily emissions data are then mapped to the Italian municipalities. This step involves creating a relational structure that connects emission figures with respective local administrative boundaries.

4. **Dataset Construction**: The final output is a structured dataset that offers daily emission insights for each municipality, ready to be used in various environmental analysis and policy-making processes.

## Repository Structure
- `/annual_data`: Contains the original CAMSREG datasets.
- `/daily_data`: Contains the transformed daily emissions data.
- `/municipality_data`: Contains the geographic and administrative data for Italian municipalities.
- `/scripts`: Contains all the scripts used for data extraction, transformation, and integration.
- `/docs`: Documentation related to the CAMSTEMPO methodology and data schema.

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
