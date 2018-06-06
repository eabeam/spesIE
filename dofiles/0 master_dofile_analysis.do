/*
Project: 		Impact Evaluation of the Special Program for Employment of Student (SPES)
Folder path: 	SPES IE Dataset\dofiles
File name: 		0_master dofile_analysis

Impact Evaluation of the Special Program for Employment of Student (SPES)
Innovations for Poverty Action 

PIs:
Emily Beam 
Nathanael Goldberg 
Leigh Linden
Stella Quimbo 

Code developed by Heather Richmond and Emily Beam 

Last Updated: 06 June 2018 by EB
Stata version 13.1
*/

*** Master do-file for Analysis & Results

*	Set global pathways

*   [Add your drive/pathway]/SPES IE Dataset"

global path "/Users/emilybeam/Box Sync/SPES_IE_June2018/SPES IE Dataset"
*global path "X:/Box/IPA_PHL_Projects/SPES_DOLE/SPES IE Dataset"

* Relative paths 
global usedata_analysis "$path/usedata"
global dofiles "$path/dofiles"
global tables_analysis "$path/tables"
global figures "$path/figures"
global output "$path/output"
version 13.1
capture log close


log using "$output/SPES_log.log",replace

** Analysis preparation
include "$dofiles/initialize.do"							// Save surveydata_full_clean.dta
															// Save surveydata_for_balance.dta


** Descriptive statistics
include "$dofiles/Balance.do"								// Create balance table 
include "$dofiles/descriptive_stats_Oct2017.do"				// Save descriptive_stats.xls


** Regressions
include "$dofiles/regressions_fullsample_Oct2017.do"		// Save regressions_fullsample_edu.xls
															// Save regressions_fullsample_aspirations.xls
															// Save regressions_fullsample_lifeskills.xls
															// Save regressions_fullsample_work.xls
															// Save regressions_fullsample_workreadinessindices.xls
															// Save regressions_fullsample_workreadinesstasks.xls

include "$dofiles/regressions_het_edu_Oct2017.do"			// Save regressions_subgroups_edu.xls
															// Save regressions_subgroups_edu_int.xls

include "$dofiles/regressions_het_work_Oct2017.do"			// Save regressions_subgroups_employment.xls
															// Save regressions_subgroups_emp_int.xls
															
include "$dofiles/regressions_het_aspirations.do"			// Save regressions_subgroups_aspirations.xls
															// Save regressions_subgroups_asp_int.xls
include "$dofiles/regressions_het_workreadiness.do"			// Save regressions_subgroups_wrindices.xls
															// Save regressions_subgroups_wrindices_int.xls
 

** Figures
include "$dofiles/figures.do"

log close 
