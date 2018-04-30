/*
Project: 		Impact Evaluation of the Special Program for Employment of Student (SPES)
Folder path: 	SPES IE Dataset\dofiles
File name: 		Balance

Impact Evaluation of the Special Program for Employment of Student (SPES)
Innovations for Poverty Action 
Code developed by Emily Beam and Heather Richmond

Last Updated: 04 June 2017 by EB
Stata version 13.1
*/ 

*** BALANCE TABLES ***

use "$usedata_analysis/surveydata_for_balance.dta", clear 



* Identify covariates for balance tests 

global balance "_bb_female _bb_edulvl _bb_age  _bb_workany _bb_workformal _bb_workinformal _bb_lowestamount _bb_expected_earn _bb_expectedtuition _bb_othereducationexp"

* Gender 
*	Use primary gender variable from stratification


* Redo the balance variables 

drop _bb_osy _bb_spesbaby








* Restrict to experimental sample 
drop if treatment == . 



* Flag all variables 

foreach var in $balance  bsl_reg3 bsl_reg6 bsl_reg7 bsl_reg11 bsl_regNCR{
gen _flag`var' = `var' == . 
recode `var' (. .b = 0 )
} 


tempfile tempdata 
save `tempdata',replace
ds ${balance},not( varl "*Age*") varwidth(30)


local balance_noage "`r(varlist)'" 

di "`balance_noage'"

use `tempdata', clear

foreach var of varlist $balance bsl_reg3 bsl_reg6 bsl_reg7 bsl_reg11 bsl_regNCR {
di in red "using `var'"
use `tempdata', clear

collapse (mean) mean = `var' (sd) sd = `var' (count) count = `var' if _flag`var' == 0 , by(treatment)
gen str30 var = "`var'"

tempfile temp`var'
di "saving `temp`var''"
save `temp`var'', replace 

}


use `temp_bb_age', clear
di in red "`balance_noage'"

foreach var in `balance_noage' bsl_reg3 bsl_reg6 bsl_reg7 bsl_reg11 bsl_regNCR{
append using `temp`var''
}

order var
list
egen id = seq(),by(treatment)
reshape wide mean sd count,i(id) j(treatment)


tempfile means
save `means',replace

* Implement the t-tests 



use `tempdata',clear   
cd "$tables_analysis"
*log using "regoutput $ST $RES $MM.log",replace
foreach var in $balance{

* Skip those we stratify on directly (bb_spesbaby & bb_group_female) and those that were part of form 2 (bb_osy) 
if "`var'" != "_bb_spesbaby" & "`var'" != "_bb_group_female"{
areg `var' treatment if _flag`var' == 0 , absorb(scel) robust

testparm treatment
gen Fstat_`var' = `r(F)'
gen pval_`var' = `r(p)'
}
}


* Reshape so in form similar to means & sds 

collapse (mean) pval* Fstat*
gen id = 1
reshape long Fstat_ pval_,i(id) j(var) string
drop id 
rename Fstat_ Fstat
rename pval_ pval 

tempfile ttest
save `ttest',replace 

use `means',clear 
merge 1:1 var using `ttest'

outsheet using "$tables_analysis/balance_means.xls",replace

* Run ttest 

use `tempdata',clear
*drop *_bb_spesbaby
*drop *_bb_spesbaby


areg treatment $balance _flag*,absorb(scel) robust

testparm $balance





* Overall descriptive statistics 

tempfile tempdata 
save `tempdata',replace
ds ${balance},not( varl "*Age*") varwidth(30)


local balance_noage "`r(varlist)'" 

di "`balance_noage'"

use `tempdata', clear

foreach var of varlist $balance{
di in red "using `var'"
use `tempdata', clear

collapse (mean) mean = `var' (sd) sd = `var' (count) count = `var' if _flag`var' == 0
gen str30 var = "`var'"

tempfile temp`var'
di "saving `temp`var''"
save `temp`var'', replace 

}


use `temp_bb_age', clear
di in red "`balance_noage'"

foreach var in `balance_noage'{
append using `temp`var''
}

order var
list
egen id = seq()
*reshape wide mean sd count,i(id) j(treatment)


outsheet using "$tables_analysis/descriptive.xls",replace


