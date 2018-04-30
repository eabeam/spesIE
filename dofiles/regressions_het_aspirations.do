*** HETEROGENEITY EDUCATION ***


* Set locals
local depvar "_eeo_edu_job_6mo_high _eeo_edu_job_wage_lowest _eeo_edu_job_wage_expect _eeo_edu_expect_highest_college _eeo_spes2017"
local labels ""Expect_find_job_6mo" "Lowest_accepted_wage" "Expected_wage" "Expected_highest_level_edu" "Expect_SPES2017""
local replace replace

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

		*xi: areg `var' treatment i.treatment*`i' $cov1 if treatment!=. , absorb(scell) robust
		qui xi: ivregress 2sls `var' (spes_2016 spes_2016X`i'  = treatment treatmentX`i') $cov1 `i'X* i.scel,robust
		local lab: word `j' of `labels'
		summ `var' if treatment==0 
		outreg2 using "$tables_analysis/regressions_subgroups_asp_int.xls", `replace' keep(spes_2016 spes_2016X`i') stats(coef se pval) title("Education") ctitle("`lab'") nocons addtext("Subgroup", "`i'", "Stratification Cell FE", "Yes") addstat("Control Group Mean", r(mean)) auto(2) noparen
		
		local replace "append"
		local j = `j' + 1

	}
	
}

erase "$tables_analysis/regressions_subgroups_asp_int.txt"

