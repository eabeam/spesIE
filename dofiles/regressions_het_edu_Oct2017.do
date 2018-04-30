*** HETEROGENEITY EDUCATION ***

use "$usedata_analysis/surveydata_full_clean.dta", clear

global cov1 "_bb_female _bb_age  _bb_workany _bb_workformal _bb_workinformal _bb_lowestamount _bb_edulvl _f_bb_female _f_bb_age  _f_bb_workany _f_bb_workformal _f_bb_workinformal _f_bb_lowestamount "





* Set locals
local depvar _eeo_enroll _eeo_grad_col _eeo_grad_hs _eeo_expect_grad_col _eeo_expect_grad_hs _eeo_enroll_nextyr _eeo_gwa_norm
local labels " "Currently Enrolled" "Graduated (Col)" "Graduated (HS)" "Expected graduate (Col)" "Expected graduate (HS)" "Enrolling next year" "
local replace replace
local i = 1


gen _f_NT_edu = _NT_edu == . 
recode _NT_edu . = 0

gen _f_eeo_faminc = _eeo_faminc == . 
recode _eeo_faminc . = 0

*foreach interact in _bb_female _NT_edu _eeo_faminc _bb_workany _bb_workformal highcomply{
foreach interact in _bb_female _NT_edu _eeo_faminc   {
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
		outreg2 using "$tables_analysis/regressions_subgroups_edu.xls", `replace' keep(spes_2016 spes_2016X`interact')   title("Education") ctitle("`lab'") nocons addtext("Subgroup", "`group`j''", "Stratification Cell FE", "Yes") addstat("Control Group Mean", r(mean)) auto(2) bracket
		local replace
		local i = `i' + 1
	}
}



