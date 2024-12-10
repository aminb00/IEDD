# IEDD Scope

## Introduction

The **Italian Emission Daily Dataset (IEDD)** is a specialized emission data product designed to provide high-resolution, daily-level estimates of atmospheric pollutants across the Italian territory. While conventional emission inventories frequently operate at annual or monthly scales, the IEDD bridges a crucial data gap by delivering temporally granular insights—day-by-day emissions, differentiated across multiple sectors (e.g., power generation, industry, residential heating, transport, and agriculture), pollutants (e.g., NOx, SO2, NH3, NMVOCs, PM2.5, PM10, CO), and spatial cells of approximately 0.05° x 0.1° resolution. This enriched temporal and spatial detail makes the IEDD a valuable resource for atmospheric scientists, environmental policymakers, climate researchers, air quality modelers, public health experts, and any stakeholder interested in understanding or mitigating the impacts of air pollution in Italy.

The purpose of this document is to articulate the scope of the IEDD: its objectives, the rationale behind its creation, the scientific questions it aims to address, and how it complements or extends existing data resources. In doing so, we will highlight the central role of high-resolution temporal data in contemporary environmental research and policymaking.

## The Need for High-Resolution Daily Emission Data

Traditionally, emissions inventories—be they national, regional, or global—have been compiled at relatively coarse temporal resolutions. Annual or monthly totals are standard, as these scales align with policy reporting requirements (e.g., under the UNECE CLRTAP or the EU NECD), regulatory frameworks, and statistical data availability. However, such temporal aggregation masks the inherent variability in emissions driven by factors including:

- **Seasonal and Daily Patterns**: Emissions from residential heating spike during colder months, while road transport emissions exhibit pronounced weekday vs. weekend patterns and peak-hour traffic conditions.
- **Meteorological Influences**: Temperature and precipitation patterns influence agricultural emissions (e.g., fertilizer application leading to NH3 releases) and energy consumption for heating or cooling.
- **Socioeconomic Activities**: Industrial production often varies by day or season. Shipping and aviation might follow seasonal tourism cycles, and localized events (e.g., holidays, strikes, or short-term industrial shutdowns) can cause day-to-day changes.
  
Without a daily dataset, researchers and policymakers lack the granularity to model pollutant dispersion accurately on a short-term basis. For example, chemistry-transport models (CTMs) and air quality models like WRF-Chem, CMAQ, or CHIMERE benefit profoundly from temporally resolved emission inputs. Daily data enhances their capacity to simulate episodes of elevated pollution, such as winter smog events in the Po Valley, short-lived industrial plumes, or acute traffic congestion periods. This improved modeling fidelity is critical for designing timely and effective mitigation strategies.

## The IEDD’s Scientific and Policy Relevance

The IEDD stands at the intersection of science and policy. On the scientific front, it enables:

1. **Advanced Air Quality Modeling**: Daily emissions serve as a critical input to high-resolution 3D atmospheric models. These models, used by meteorological and environmental agencies, can now capture short-term pollution episodes more accurately, improving forecasts of peak concentrations of harmful pollutants such as PM2.5, PM10, or NO2.

2. **Climate and Weather Interactions**: Fine-scale temporal data allows for improved representation of short-term emission spikes in climate-related studies. Although climate is a long-term phenomenon, daily emission patterns influence the formation of short-lived climate forcers (e.g., black carbon, ozone precursors), potentially affecting local climate feedback loops.

3. **Public Health Studies**: Epidemiological research investigating the association between daily pollutant exposure and health outcomes (e.g., asthma attacks, hospital admissions for cardiovascular issues) can now rely on more precise emissions inputs. By correlating daily emissions with measured ambient concentrations, health impact assessments become more robust and accurate.

4. **Policy Evaluation and Scenario Testing**: Policymakers often need to assess the immediate impact of specific interventions—e.g., a low-emission zone in a city center, short-term traffic restrictions, or a temporary industrial shutdown. A daily emission dataset allows these actions to be evaluated on their intended temporal scale. Changes that happen rapidly (within days or weeks) can now be linked more directly to shifts in emissions data.

5. **Identification of Emission Hotspots and Temporal Peaks**: By examining day-to-day variations, it is possible to identify certain days or periods when emissions surge. For instance, peaks in NOx or PM2.5 emissions due to certain industrial processes or unexpected agricultural practices (like seasonal burning of residues) are easier to detect and address.

## Complementarity with Existing Inventories

While annual inventories like those provided by ISPRA (Istituto Superiore per la Protezione e la Ricerca Ambientale) or major international datasets (e.g., EDGAR, EMEP, CAMS-GLOB-ANT) are invaluable for long-term trend analysis and international reporting, they do not directly offer the fine temporal granularity required by advanced modeling tasks. The IEDD complements these existing resources by taking the annual data as a baseline and adding an essential temporal dimension.

This is achieved by leveraging the CAMS (Copernicus Atmosphere Monitoring Service) Regional Anthropogenic (CAMS-REG-ANT) inventory as a spatially detailed annual foundation, then applying temporal profiles from CAMS-REG-TEMPO to decompose annual totals into daily values. The outcome is not a replacement for the official inventories but a derivative product that enriches and extends their utility.

## Geographical Focus: Italy as a Case Study

Italy’s complex topography and varied climates offer a unique testbed for the application of daily emission data. From the industrialized Po Valley, where pollution episodes are frequent due to atmospheric stagnation, to the rural and agricultural southern regions, Italy exemplifies the diversity of emission sources and dynamics that daily data can help illuminate.

Key features making Italy an exemplary domain for the IEDD include:

- **The Po Valley Challenge**: This heavily industrialized and populated region often experiences episodes of severely degraded air quality due to meteorological conditions that trap pollutants. Daily emission data, combined with atmospheric models, can help disentangle the relative contributions of sectors (e.g., agriculture vs. transport vs. residential heating) on specific high-pollution days.

- **Coastal and Maritime Emissions**: Italy’s extensive coastline and maritime activities (shipping, ports) introduce additional complexity. Emissions from shipping can have strong daily and seasonal variability, influenced by trade cycles, holidays, or regional routing patterns. The IEDD can help isolate these maritime contributions day by day.

- **Seasonal Tourism and Agricultural Activities**: Areas with fluctuating tourist populations exhibit changing traffic and energy demands. Similarly, agricultural practices—fertilizer application, livestock management, field burning—may have strong daily signals that can impact ammonia and particulate emissions. 

By applying the IEDD in the Italian context, researchers and policymakers can derive lessons and methodologies transferable to other European regions or countries with similar environmental concerns.

## Emission Sources and Pollutants Included

The IEDD focuses on key anthropogenic emission sectors as defined by the GNFR (Gridding Nomenclature for Reporting) classification. This includes, but is not limited to, energy production, industrial processes, residential heating, transportation (road, shipping, aviation), off-road machinery, solvent usage, waste management, and agriculture (livestock, fertilizers). For each sector, annual emissions of various pollutants are reshaped into daily estimates:

- **Pollutants**: Nitrogen oxides (NOx), Sulfur dioxide (SO2), Carbon monoxide (CO), Non-methane volatile organic compounds (NMVOCs), Ammonia (NH3), and Particulate Matter (PM10, PM2.5).

While greenhouse gases like methane (CH4) and carbon dioxide (CO2) are not currently included due to insufficient daily profiling data, future expansions may incorporate them. This would enable the IEDD to support integrated studies of both air quality and climate pollutants.

## Temporal Scope and Resolution

The chosen temporal scope—2000 to 2020—reflects the availability of robust underlying data from CAMS-REG-ANT and CAMS-REG-TEMPO. This 20-year span covers major economic and policy shifts in Italy and Europe, including changes in vehicle technologies, fuel standards, industrial regulations, and energy production methods. With daily resolution, the dataset amounts to 7,671 time steps (days) per pollutant-sector combination, offering unprecedented detail for historical analysis.

The daily resolution ensures that transient phenomena, such as a cold spell in winter leading to a spike in residential heating emissions, or a short-term industrial shutdown reducing daily NOx output, are captured. These finer details are crucial for accurate model initialization, scenario evaluation, and the development of short-term intervention strategies.

## Intended Audience and Usage

The IEDD is an open-resource data product intended for a wide range of users:

- **Researchers** in atmospheric science, climate modeling, and environmental health will find the daily data beneficial for improving model accuracy, studying pollution episodes, and analyzing short-term exposures.
  
- **Policy Analysts and Government Agencies** can use the IEDD to evaluate the effectiveness of regulatory measures. For example, did restricting diesel vehicles in a certain city lead to a measurable day-to-day decrease in NOx or PM emissions?
  
- **Urban Planners and Environmental Consultants** may incorporate IEDD data into local-scale studies to identify emission hotspots and design infrastructure or planning policies that mitigate pollution at critical times of the day or year.

- **Non-Governmental Organizations (NGOs) and Advocacy Groups** focused on air quality and public health can leverage the dataset to support initiatives for cleaner air and to raise public awareness about when and where emissions peak.

## Beyond the IEDD: Opportunities and Extensions

While the IEDD is already a valuable resource, it opens the door to further developments:

1. **Future Temporal Extensions**: Incorporating data up to the present date or beyond 2020 will keep the dataset aligned with current conditions and emerging technologies, such as electric vehicle adoption or shifts in renewable energy penetration.
   
2. **Inclusion of Additional Pollutants**: Methane, CO2, black carbon, and other climate forcers could be added once reliable daily profiles are available. This would expand the IEDD’s relevance to climate policy and integrated assessment modeling.

3. **Higher Spatial Resolution**: If future emission inventories improve their spatial proxies and reach finer detail, the daily dataset could also scale down to an even more granular grid, enhancing urban and micro-environmental studies.

4. **Harmonization with Other Datasets**: Combining the IEDD with high-frequency atmospheric concentration measurements, satellite retrievals, or meteorological reanalysis data would allow for advanced data assimilation and inverse modeling studies, potentially improving emission estimates through top-down constraints.

## Conclusion

In essence, the IEDD is a stepping stone towards a new era of temporally resolved emission inventories. By delivering daily emissions over two decades, it provides a more nuanced understanding of pollution sources and their dynamics. This level of detail is increasingly important as societal and environmental challenges mount: we need timely, accurate emission data to design effective interventions, adapt to climatic changes, safeguard public health, and refine our scientific models.

With its focus on Italy—a region known for its diverse emission patterns, from industrial to agricultural and maritime activities—the IEDD stands as both a critical data product and a methodological blueprint. As the dataset evolves, it will likely serve as a benchmark for other regional efforts and inspire the creation of similarly detailed emission inventories worldwide.