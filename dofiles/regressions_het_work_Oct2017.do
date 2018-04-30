/*
Project: 		Impact Evaluation of the Special Program for Employment of Student (SPES)
Folder path: 	SPES IE Dataset\dofiles
File name: 		regressions_het_work_Oct2017

Impact Evaluation of the Special Program for Employment of Student (SPES)
Innovations for Poverty Action 
Code developed by Emily Beam and Heather Richmond

Last Updated: 29 April 2018 by EB
Stata version 13.1
*/

*** HETEROGENEITY EMPLOYMENT ***

use "$usedata_analysis/surveydata_full_clean.dta", clear


local group1 "Men" 
local group2 "Women" 
local group3 "HS" 
local group4 "College" 
local group5 "Low income" 
local group6 "High income" 


* Set locals
local depvar _eeo_worknow _eeo_jobsearch _eeo_wage_monthly_now  _eeo_worksummer_any _eeo_worksummer_formal _eeo_worksummer_informal _eeo_workjuldec_any _eeo_workjuldec_formal _eeo_workjuldec_informal
local labels ""Currently working" "Currently looking" "Currently earning" "Any work (summer)"	"Formal work (summer)"	"Informal/unpaid work (summer)"	"Any work (juldec)"	"Formal work (juldec)" "Informal/unpaid work (juldec)""
local replace replace
local i = 1


gen _f_NT_edu = _NT_edu == . 
recode _NT_edu . = 0

gen _f_eeo_faminc = _eeo_faminc == . 
recode _eeo_faminc . = 0

foreach interact in _bb_female _NT_edu _eeo_faminc {
gen spes_2016X`interact' = spes_2016*`interact'
gen `interact'xtreatment = `interact'*treatment

* Generate inteaction terms for each covariate 

ds $cov1 
foreach cov in `r(varlist)'{ 
gen `interact'X`cov' = `cov'*`interact'


}
	foreach var in `depvar' {
		xi:  ivregress 2sls  `var' (spes_2016 spes_2016X`interact' = treatment `interact'xtreatment) $cov1 `interact'X* i.scel if treatment!=. & _f`interact' == 0,  robust
		local lab: word `i' of `labels'
		summ `var' if treatment==0 
		outreg2 using "$tables_analysis/regressions_subgroups_employment.xls", `replace' keep(spes_2016 spes_2016X`interact')   title("Education") ctitle("`lab'") nocons addtext("Subgroup", "`group`j''", "Stratification Cell FE", "Yes") addstat("Control Group Mean", r(mean)) auto(2) bracket
		local replace
		local i = `i' + 1
	}
}



erase "$tables_analysis/regressions_subgroups_employment.txt"
