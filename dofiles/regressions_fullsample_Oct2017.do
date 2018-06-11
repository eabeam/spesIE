/*
Project: 		Impact Evaluation of the Special Program for Employment of Student (SPES)
Folder path: 	SPES IE Dataset\dofiles
File name: 		regressions_fullsample_Oct2017

Impact Evaluation of the Special Program for Employment of Student (SPES)
Innovations for Poverty Action 
Code developed by Emily Beam and Heather Richmond

Last Updated: 29 April 2018 by EB
Stata version 13.1
*/

*** IMPACT ANALYSIS ***

use "$usedata_analysis/surveydata_full_clean.dta", clear

global cov1 "_bb_female _bb_age _bb_spesbaby _bb_workany _bb_edulvl _bb_workformal _bb_workinformal _bb_lowestamount _f_bb_female _f_bb_age _f_bb_spesbaby _f_bb_workany _f_bb_workformal _f_bb_workinformal _f_bb_lowestamount "


*** EDUCATION ***
* Set locals
local depvar _eeo_enroll _eeo_grad_col _eeo_grad_hs _eeo_expect_grad_col _eeo_expect_grad_hs _eeo_enroll_nextyr _eeo_gwa_norm
local labels ""Currently Enrolled" "Graduated (Col)" "Graduated (HS)" "Expected graduate (Col)" "Expected graduate (HS)" "Enrolling next year""
local replace replace
local i = 1

* Export to Excel
foreach var in `depvar' {
	
	ivregress 2sls `var' (spes_2016 = treatment) $cov1 i.scel if treatment!=., robust
	local lab: word `i' of `labels'
	summ `var' if treatment==0
	outreg2 using "$tables_analysis/regressions_fullsample_edu.xls", `replace' keep(spes_2016) title("Education") ctitle("`lab'") nocons addtext("Stratification Cell FE", "Yes","Specification","LATE") addstat("Control Group Mean", r(mean)) auto(2) bracket
			local replace append
	
	
	local ++i
}
erase "$tables_analysis/regressions_fullsample_edu.txt"


*** WORK ***
* Set locals
local depvar _eeo_worknow _eeo_jobsearch _eeo_wage_monthly_now  _eeo_worksummer_any _eeo_worksummer_formal _eeo_worksummer_informal _eeo_workjuldec_any _eeo_workjuldec_formal _eeo_workjuldec_informal
local labels ""Currently working" "Currently looking" "Currently earning" "Any work (summer)"	"Formal work (summer)"	"Informal/unpaid work (summer)"	"Any work (juldec)"	"Formal work (juldec)" "Informal/unpaid work (juldec)""
local replace replace
local i = 1

* Export to Excel
foreach var in `depvar' {	
	qui ivregress 2sls `var' (spes_2016 = treatment) $cov1 i.scel if treatment!=., robust
	local lab: word `i' of `labels'
	summ `var' if treatment==0
	outreg2 using "$tables_analysis/regressions_fullsample_work.xls", `replace' keep(spes_2016) title("Work") ctitle("`lab'") nocons addtext("Stratification Cell FE", "Yes","Specification","LATE") addstat("Control Group Mean", r(mean)) auto(2) bracket
		local replace append	
	
	
		local ++i

}

erase "$tables_analysis/regressions_fullsample_work.txt"

*** WORK READINESS

* Set locals
local depvar ""_eeo_selfesteem_index" "_eeo_hardtasks_index" "_eeo_lifeskills_index" "_eeo_cps_index""
local labels ""Selfesteem_index" "Hard_tasks_index" "Life_skills_index" "CPS_index""
local replace replace
local i = 1

* Export to Excel
foreach var in `depvar' {
	
	ivregress 2sls `var' (spes_2016 = treatment) $cov1 i.scel if treatment!=., robust
	local lab: word `i' of `labels'
	summ `var' if treatment==0
	outreg2 using "$tables_analysis/regressions_fullsample_workreadinessindices.xls", `replace' keep(spes_2016) title("Work_readiness") ctitle("`lab'") nocons addtext("Stratification Cell FE", "Yes","Specification","LATE") addstat("Control Group Mean", r(mean)) auto(2) bracket
		local replace append	
	local ++i

}

erase "$tables_analysis/regressions_fullsample_workreadinessindices.txt"


*** ASPIRATIONS

* Set locals
local depvar "_eeo_edu_job_6mo_high _eeo_edu_job_wage_lowest _eeo_edu_job_wage_expect _eeo_edu_expect_highest_college _eeo_spes2017"
local labels ""Expect_find_job_6mo" "Lowest_accepted_wage" "Expected_wage" "Expected_highest_level_edu" "Expect_SPES2017""
local replace replace
local i = 1

* Export to Excel
foreach var in `depvar' {
	
	ivregress 2sls `var' (spes_2016 = treatment) $cov1 i.scel if treatment!=., robust
	local lab: word `i' of `labels'
	summ `var' if treatment==0
	outreg2 using "$tables_analysis/regressions_fullsample_aspirations.xls", `replace' keep(spes_2016) title("Aspirations") ctitle("`lab'") nocons addtext("Stratification Cell FE", "Yes","Specification","LATE") addstat("Control Group Mean", r(mean)) auto(2) bracket
			local replace append
	local ++i
}
erase "$tables_analysis/regressions_fullsample_aspirations.txt"


********Tasks - individual tasks regression ressults ****

* Set locals
ds _high_tasks*
local depvar "`r(varlist)'"
local labels ""Using Word" "Encoding" "Using Excel" "Using Powerpoint" "Photocopying" "Scanning" "Sorting" "Answering phones" "Bookkeeping" "Performing online searches" "Using e-mail""
local replace replace
local i = 1

* Export to Excel
foreach var in `depvar' {
	qui ivregress 2sls `var' (spes_2016 = treatment) $cov1 i.scel if treatment!=., robust
	local lab: word `i' of `labels'
	summ `var' if treatment==0
	outreg2 using "$tables_analysis/regressions_fullsample_workreadinesstasks.xls", `replace' keep(spes_2016) title("Experience with Work Tasks") ctitle("`lab'") nocons addtext("Stratification Cell FE", "Yes") addstat("Control Group Mean",r(mean)) auto(2) bracket
	local ++i
	local replace
}

erase "$tables_analysis/regressions_fullsample_workreadinesstasks.txt"



/* Differential attrition */ 


use "$usedata_analysis/surveydata_full_clean.dta", clear

global cov1 "_bb_female _bb_age _bb_spesbaby _bb_workany _bb_edulvl _bb_workformal _bb_workinformal _bb_lowestamount _f_bb_female _f_bb_age _f_bb_spesbaby _f_bb_workany _f_bb_workformal _f_bb_workinformal _f_bb_lowestamount "


foreach var in _bb_lowestamount _bb_expected_earn _bb_expectedtuition _bb_othereducationexp{
replace `var' = `var'/1000
sum `var'

}

gen attrit = 1 - endline
replace _f_bb_expectedtuition = 1 if _bb_expectedtuition == .
replace _f_bb_othereducationexp = 1 if _bb_othereducationexp == .
recode _bb_expectedtuition . = 0
recode _bb_othereducationexp . = 0

areg attrit treatment _bb* _f_bb* if randomization != . & endline_contacted == 1,absorb(scel)
testparm *
sum endline if endline_contacted
	outreg2 using "$tables_analysis/attrition.xls", replace title("Attrition") ctitle("Attrit") nocons addtext("Stratification Cell FE", "Yes","Specification","LATE") addstat("Control Group Mean", r(mean)) auto(2) bracket
