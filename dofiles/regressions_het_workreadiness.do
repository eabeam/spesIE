/*
Project: 		Impact Evaluation of the Special Program for Employment of Student (SPES)
Folder path: 	SPES IE Dataset\dofiles
File name: 		regressions_het_workreadiness

Impact Evaluation of the Special Program for Employment of Student (SPES)
Innovations for Poverty Action 
Code developed by Emily Beam and Heather Richmond

Last Updated: 29 April 2018 by EB
Stata version 13.1
*/

*** HETEROGENEITY WORK READINESS***


global cov1 "_bb_female _bb_age  _bb_workany _bb_workformal _bb_workinformal _bb_lowestamount _f_bb_female _f_bb_age  _f_bb_workany _f_bb_workformal _f_bb_workinformal _f_bb_lowestamount "



* Set locals
local depvar ""_eeo_selfesteem_index" "_eeo_hardtasks_index" "_eeo_lifeskills_index" "_eeo_cps_index""
local labels ""Selfesteem_index" "Hard_tasks_index" "Life_skills_index" "CPS_index""
local replace replace
local i = 1

set matsize 800



use "$usedata_analysis/surveydata_full_clean.dta", clear



local replace replace
* Loop over inteaction terms = i
foreach i in _bb_female _NT_edu _eeo_faminc {
	gen spes_2016X`i' = spes_2016*`i'
	gen treatmentX`i' = treatment*`i'
	di "interaction term `i'"

	
* Generate inteaction terms for each covariate 

ds $cov1 
foreach cov in `r(varlist)'{ 
gen `i'X`cov' = `cov'*`i'
} 

* Loop over dependent variables = j
local j = 1
	foreach var in `depvar' {
	
	di "dependent variable `j': `var'"

		qui xi: ivregress 2sls `var' (spes_2016 spes_2016X`i'  = treatment treatmentX`i') $cov1 `i'X* i.scel,robust
		local lab: word `j' of `labels'
		summ `var' if treatment==0 
		outreg2 using "$tables_analysis/regressions_subgroups_wrindices_int.xls", `replace' keep(spes_2016 spes_2016X`i') stats(coef se pval) title("Education") ctitle("`lab'") nocons addtext("Subgroup", "`i'", "Stratification Cell FE", "Yes") addstat("Control Group Mean", r(mean)) auto(2) bracket
		
		local replace "append"
		local j = `j' + 1

	}
	
	

}


