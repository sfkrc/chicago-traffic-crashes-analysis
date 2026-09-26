# Chicago Traffic Crash Severity Analysis

Analysis of 547,843 reported traffic crashes in Chicago from 2021 through 2025 to identify patterns and factors associated with severe crash outcomes.

A crash is classified as **severe** when the most severe injury is either **fatal** or **incapacitating**.

## Project Overview

**Research Question:**  
What factors are associated with severe traffic crashes in Chicago?

This project follows an end-to-end data analysis workflow using Python, SQL, exploratory data analysis, visualization, and statistical testing.

The analysis focuses on three main questions:

1. Which environmental and road conditions are associated with more severe crashes?
2. When are severe crashes most likely to occur?
3. Which reported contributing factors are most strongly associated with severe crashes?

## Analysis Workflow

### 1. Data Collection

Crash records were obtained from the City of Chicago Traffic Crashes dataset through the Socrata Open Data API.

The analysis focuses on crashes reported between **January 1, 2021 and December 31, 2025**.

The initial dataset contained:

- **549,109 crash records**
- **49 variables**

### 2. Data Cleaning

The data-cleaning process included:

- Converting dates and numeric variables to appropriate data types
- Reviewing missing values
- Validating injury-related fields
- Checking duplicate crash records
- Reviewing unusual values such as `POSTED_SPEED_LIMIT = 0`
- Evaluating `UNKNOWN`, `UNABLE TO DETERMINE`, and `NOT APPLICABLE` categories

After cleaning, the final analytical dataset contained:

**547,843 crashes**

### 3. Feature Engineering

Nineteen variables relevant to crash severity were selected for analysis.

A binary target variable, `SEVERE_CRASH`, was created:

- `1` = Fatal or incapacitating injury
- `0` = All other crash outcomes

The severe-crash definition was validated against the underlying injury-count fields before analysis.

### 4. Exploratory Data Analysis

Severe-crash rates were compared across:

- Weather conditions
- Lighting conditions
- Road surface conditions
- Road defects
- Hour of day
- Day of week
- Primary contributing cause

### 5. SQL Analysis

SQLite was used to reproduce and extend several key analytical comparisons.

The SQL analysis demonstrates:

- Aggregation
- `GROUP BY`
- `CASE`
- `WHERE`
- `HAVING`
- Common Table Expressions (CTEs)
- Window functions
- `RANK()`

### 6. Statistical Analysis

Chi-Square Tests of Independence were used to evaluate associations between crash severity and:

- Lighting condition
- Primary contributing cause

Cramér's V was calculated to measure the strength of these associations.

### 7. Visualization

Matplotlib was used to visualize major crash-severity patterns across lighting conditions, time of day, day of week, and contributing causes.

## Key Findings

- Severe crashes represented approximately **1.76%** of the 547,843 crashes analyzed.
- Crashes recorded under **darkness with a lighted road** had a severe-crash rate of approximately **2.71%**, compared with **1.51%** during daylight.
- Severe-crash rates were highest during late-night and early-morning hours. The highest observed rate occurred at **2:00 AM (3.39%)**.
- Weekend crashes had higher severe-crash rates than most weekdays. **Sunday had the highest rate at approximately 2.20%**, followed by **Saturday at 2.01%**.
- Among contributing-cause categories with substantial numbers of observations, **physical condition of the driver** had the highest severe-crash rate at approximately **10.51%**.
- Other notable contributing-cause categories included disregarding traffic signals, alcohol/drug influence, wrong-way driving, and erratic or reckless driving.
- Statistical testing found significant associations between crash severity and both **lighting condition** and **primary contributing cause** (`p < 0.001`).
- The corresponding Cramér's V values were **0.046** and **0.117**, indicating relatively weak overall associations.

These findings represent statistical associations in the observed crash data and should **not be interpreted as evidence of causation**.

## Tools & Technologies

| Category | Tools |
| --- | --- |
| Programming | Python |
| Data Collection | Requests, Socrata Open Data API |
| Data Analysis | Pandas, NumPy |
| SQL | SQLite |
| Statistics | SciPy |
| Visualization | Matplotlib |
| Development | Jupyter Notebook, VS Code |
| Version Control | Git, GitHub |

## Repository Structure

```text
chicago-traffic-crashes-analysis/
│
├── README.md
├── requirements.txt
├── .gitignore
│
├── notebooks/
│   └── 01_traffic_crash_analysis.ipynb
│
├── sql/
│   └── 01_crash_analysis.sql
│
└── data/
    └── README.md
```

Large raw and processed datasets are not stored in the repository.

## Data Source

This project uses publicly available crash records from the **City of Chicago Traffic Crashes – Crashes** dataset, accessed through the Chicago Data Portal and Socrata Open Data API.

The analysis covers reported traffic crashes from **January 1, 2021 through December 31, 2025**. The source dataset is maintained by the City of Chicago and is available under dataset ID `85ca-t3if`.

[City of Chicago Traffic Crashes Dataset](https://data.cityofchicago.org/Transportation/Traffic-Crashes-Crashes/85ca-t3if)

## Limitations

- The analysis is based on reported Chicago traffic crashes from 2021 through 2025 and may not generalize to other locations or periods.
- Some variables contain categories such as `UNKNOWN`, `UNABLE TO DETERMINE`, and `NOT APPLICABLE`, which limit interpretation. Approximately **5.99%** of lighting-condition records were classified as `UNKNOWN`.
- A small proportion of records had missing injury information and were excluded from the final analytical dataset.
- Contributing causes are based on recorded crash information and may not capture every factor involved in an incident.
- Severe crashes were relatively uncommon, representing approximately **1.76%** of analyzed crashes.
- Statistical associations identified in this analysis do not establish causation.

## How to Reproduce

Clone the repository:

```bash
git clone https://github.com/sfkrc/chicago-traffic-crashes-analysis.git
cd chicago-traffic-crashes-analysis
```

Install the required Python packages:

```bash
pip install -r requirements.txt
```

Launch Jupyter Notebook:

```bash
jupyter notebook notebooks/01_traffic_crash_analysis.ipynb
```

The raw dataset is not included in the repository due to its size. It can be obtained from the City of Chicago Open Data Portal using the dataset link above.

## Author

**Sefa Karaca**

Data Science | Machine Learning | Python | SQL

[LinkedIn](https://www.linkedin.com/in/sfkaraca/)
