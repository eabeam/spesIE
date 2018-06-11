# SPES IE

**********************************************
Impact Evaluation of the Special Program for Employment of Student (SPES)
Innovations for Poverty Action 

PIs:
Emily Beam 
Nathanael Goldberg 
Leigh Linden
Stella Quimbo 

Documents prepared by Heather Richmond and Emily Beam 

For questions regarding data and documentation, contact Emily Beam at emily.beam@uvm.edu

Last Updated: **11 June 2018**


**********************************************

This set of data files include the raw data produced from the baseline and endline surveys. Additionally, accompanying do-files generate the tables that are used in the final report

**********************************************

## Instructions: 

1.Unzip the [surveydata_full_initialize.dta.zip](../usedata/surveydata_full_initialize.dta.zip) in the [usedata](../usedata) folder. 
1. In the master do-file (`0 master_dofile_analysis.do) update the global pathways to reflect your local directories. 
1. Ensure required packages are installed.
1. Run the remaining commands within the master do-file to recreate the analysis. Note that [initalize.do](../dofiles/initalize.do) generates surveydata_full_clean.dta, which is the main data file used in regressions. 

## Included Data (`usedata`)
 1. `surveydata_full_initialize.dta` : This is the cleaned, merged, baseline and endline data set 
 1. `terminal_summary.dta`: Terminal report data needed for Figure 6, final report.
 1. [SPESBenefsandBudget.pdf](../documents/SPESBenfsandBudget.pdf): This is the data for Figure 11, final report. 
 
## Packages: 

 - `outreg2` is required to output regression tables

## Replication Details

| Table | Details |Do-files | Output
|--------|--      |-------| ---|
| Table 1 | Timeline | N/A | N/A|
| Table 2 | PESO distribution | N/A | N/A|
| Table 3 | Treat/control distribution | `descriptive_stats_Oct2017`| Results window|
| Table 4 | Balance | `Balance.do` |`balance_means.xls`|
| Table 5 | Data collected | N/A | N/A|
| Table 6 | Reasons for attrition | `descriptive_stats_Oct2017`|`descriptive_stats2.xls/AttritReason`|
| Table 7 | Endline attrition |`descriptive_stats_Oct2017`|`descriptive_stats2.xls/attrition`|
| Table 8 | Attrition predictors | `regressions_fullsample_Oct2017`|`attrition.xls`|
| Table 9 | SPES Take-up |`descriptive_stats_Oct2017`|`descriptive_stats2.xls/Take_up`|
| Table 10 | Distribution of tasks | `descriptive_stats_Oct2017`| Results window|
| Table 11 | Time to payment | `descriptive_stats_Oct2017.do`|Results window|
| Table 12 |Educ characteristics, sample type |`descriptive_stats_Oct2017`|`descriptive_stats2.xls/Desc_edu`| 
| Table 13 | Educ characteristics, ed/SPES|`descriptive_stats_Oct2017`|`descriptive_stats2.xls/Desc_edu`|
| Table 14 | Educ. outcomes|`regressions_fullsample_Oct2017` | `regressions_fullsample_edu.xls`|
| Table 15| Educ. outcomes, heterog.| `regressions_het_edu_Oct2017`| `regressions_subgroups_edu.xls`|
| Table 16 |Reasons not enrolled | `descriptive_stats_Oct2017`|`descriptive_stats2.xls/Why_not_enrolled`|
| Table 17 | Work task outcomes|`regressions_fullsample_Oct2017`  | `regressions_fullsample_workreadinesstasks.xls`|
| Table 18 | Work readiness outcomes|`regressions_fullsample_Oct2017`  | `regressions_fullsample_workreadinessindices.xls`|
| Table 19| Aspirations outcomes | `regressions_fullsample_Oct2017` | `regressions_fullsample_aspirations.xls`|
| Table 20 | Current emp. outcomes | `regressions_fullsample_Oct2017` | `regressions_fullsample_work.xls`|
| Table 21 | Past emp. outcomes | `regressions_fullsample_Oct2017` | `regressions_fullsample_work.xls`|
| Table 22 | Emp. outcomes, heterog.| `regressions_het_work_Oct2017`| `regressions_subgroups_employment.xls`|
| Table 23 | Income and desc. stat.|`descriptive_stats_Oct2017`|`descriptive_stats2.xls/Desc_other`|

| Figure | Details |Do-files | Output
|--------|--      |-------| ---- | 
| Fig. 1 | Timeline | N/A| N/A|
| Fig. 2 | Map | N/A | N/A |
|Fig. 3 |Age distribution |  `figures.do` | `figures/_bb_age.png`|
|Fig. 4| Grade level|  `figures.do` | `figures/_eduyear.png`|
|Fig. 5 -  10| |  `figures.do` | `figures/figures3-10.xls`|
| Fig. 11| SPES budget and beneficiaries | `Documents/SPES Benefs and Budget` | N/A|

\\
