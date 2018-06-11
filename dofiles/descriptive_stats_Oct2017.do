/*
Project: 		Impact Evaluation of the Special Program for Employment of Student (SPES)
Folder path: 	SPES IE Dataset\dofiles
File name: 		regressions_het_workreadiness

Impact Evaluation of the Special Program for Employment of Student (SPES)
Innovations for Poverty Action 
Code developed by Emily Beam and Heather Richmond

Last Updated: 06 June 2018 by EB
Stata version 13.1
*/

*** DESCRIPTIVE STATS ***
use "$usedata_analysis/surveydata_full_clean.dta", clear
version 13.1

****** Treatment/Control distribution - Table 3

tab region treatment if random

****** Reasons for Attrition - Table 6 
use "$usedata_analysis/surveydata_full_clean.dta", clear
keep if endline == 0 
decode call_record,gen(_attrit_temp)
tab _eeo_attrition ,sort

gen _eeo_attrit_group = "" 
	replace _eeo_attrit_group = "Respondent could not be reached" if _attrit_temp == "Answered, not respondent"
	replace _eeo_attrit_group = "Respondent could not be reached" if _attrit_temp == "Answered, wrong number"
	replace _eeo_attrit_group = "Respondent could not be reached" if _attrit_temp == "Incorrect number"
	replace _eeo_attrit_group = "Respondent could not be reached" if _attrit_temp == "No answer, call was busy"
	replace _eeo_attrit_group = "Respondent could not be reached" if _attrit_temp == "No answer, call was not answered/unattended/out of coverage area"
	replace _eeo_attrit_group = "Respondent could not be reached" if _attrit_temp == "Respondent cannot be reached, all contacts exhausted"
	
	replace _eeo_attrit_group = "Partial interview only" if _attrit_temp == "Interviewed partially"
	replace _eeo_attrit_group = "Partial interview only" if _attrit_temp == "Partial interview, respondent cannot be reached"
	
	replace _eeo_attrit_group = "Refused/hung up"  if _attrit_temp == "Answered, hung up" 
	replace _eeo_attrit_group = "Refused/hung up"  if _attrit_temp == "Partial interview, respondent refused to continue" 
	replace _eeo_attrit_group = "Refused/hung up"  if _attrit_temp == "Refused interview" 


	replace _eeo_attrit_group = "Interview scheduled, never re-contacted" if _attrit_temp == "Answered, not respondent, scheduled"
	replace _eeo_attrit_group = "Interview scheduled, never re-contacted" if _attrit_temp == "Interviewed scheduled"
	
collapse (count) baseline,by(_eeo_attrit_group) 
rename baseline N
export excel using "$tables_analysis/descriptive_stats2.xls", sheet(AttritReason) replace   firstrow(variables)


** Attrition - Table 7

use "$usedata_analysis/surveydata_full_clean.dta", clear

** Set up matrix
local row ""Baseline respondents" "Attempted to contact" "Response rate" "
local col ""Overall" " Not assigned SPES" "Assigned SPES" "P value" "Non experimental""
matrix P = J(3,5,.)
matrix rowname P = `row'
matrix colname P = `col'

local restrictions ""if baseline==1" "if treatment==0" "if treatment==1" "if baseline==1" "if randomization==0""

* Baseline respondents
local i = 1
foreach res in `restrictions' {
	qui count `res'
	matrix P[1,`i']=r(N)
	qui count `res' & endline_contacted==1
	matrix P[2,`i']=r(N)
	qui sum endline `res'
	matrix P[3,`i']=r(mean)
	local ++i
}

matrix P[1,4]=.

qui areg endline treatment,absorb(scel) robust
qui test treatment == 0 
matrix P[3,4]=r(p)

* Export to Excel
putexcel set "$tables_analysis/descriptive_stats2.xls", sheet(Attrition) modify
putexcel A1=matrix (P, names) 
*Alt command for Stata 14+
*putexcel A1=matrix (P), names nformat(##.##) 





*** TAKE-UP ***

* Set up matrix
local row ""Overall" "Region III" "Region VI and VII" "Region XI" "NCR""
local col ""Enrolled_Control" "Not_Enrolled_Control" "Enrolled_Treatment" "Not_Enrolled_Treatment" "Non experimental""
matrix P = J(5,5,.)
matrix rowname P = `row'
matrix colname P = `col'

local regions 3 "6 | treatment ==0 & _bb_region==7" 11 1

* Control
local i = 2
foreach reg in `regions' {
	qui summ _eeo_spes2016 if treatment==0 & _bb_region==`reg'
	matrix P[`i',1]=r(mean)
	matrix P[`i',2]=(1-r(mean))
	local ++i
}
qui summ _eeo_spes2016 if treatment==0
matrix P[1,1]=r(mean)
matrix P[1,2]=(1-r(mean))

* Treatment
local i = 2
foreach reg in `regions' {
	qui summ _eeo_spes2016 if treatment==1 & _bb_region==`reg'
	matrix P[`i',3]=r(mean)
	matrix P[`i',4]=(1-r(mean))
	local ++i
}
qui summ _eeo_spes2016 if treatment==1
matrix P[1,3]=r(mean)
matrix P[1,4]=(1-r(mean))

* Non-experimental
local i = 2
foreach reg in `regions' {
	qui summ _eeo_spes2016 if endline==1 &  randomization==0 & _bb_region==`reg'
	matrix P[`i',5]=r(mean)
	local ++i
}
qui summ _eeo_spes2016 if endline ==1 & randomization==0
matrix P[1,5]=r(mean)


* Export to Excel
putexcel set "$tables_analysis/descriptive_stats2.xls", sheet(Take_up) modify
putexcel A1=matrix(P, names)
* Alt command for stata 14+
*putexcel A1=matrix(P), names nformat(.###) 



*** Tasks list

* Column 1:  
use "$usedata_analysis/surveydata_full_clean.dta", clear

collapse (count) endline, by(_spes_tasks1)
gsort -endline


use "$usedata_analysis/surveydata_full_clean.dta", clear

collapse (count) endline, by(_spes_tasks2)
gsort -endline
**********************
* Table 11 - time to payment, based on region 
use "$usedata_analysis/surveydata_full_clean.dta", clear

* Total
tab spes_payment_rcvd_employer 
tab spes_payment_rcvd_dole 

* Per region
tab spes_payment_rcvd_employer if _bb_region == 1 
tab spes_payment_rcvd_dole if _bb_region == 1 

tab spes_payment_rcvd_employer if _bb_region == 3
tab spes_payment_rcvd_dole if _bb_region == 3

tab spes_payment_rcvd_employer if _bb_region == 6 | _bb_region == 7
tab spes_payment_rcvd_dole if _bb_region == 6 | _bb_region == 7

tab spes_payment_rcvd_employer if _bb_region == 11 
tab spes_payment_rcvd_dole if _bb_region == 11

*** Payment spent on ******
count if regexm(spes_payment_spent,"1")
count if (regexm(spes_payment_spent,"2") & regexm(spes_payment_spent,"-222")==0) | spes_payment_spent == "2 -222"
count if regexm(spes_payment_spent,"3")
count if regexm(spes_payment_spent,"4")
count if regexm(spes_payment_spent,"5")

forval i = 1/5{
gen _spes_payment_spent_`i' = regexm(spes_payment_spent,"1")
replace _spes_payment_spent_`i' = . if spes_payment_spent == ""
}
tab spes_payment_spent //for amount of observations
tab spes_payment_spent if regexm(spes_payment_spent,"3") 	// Tab if already spent on education
count if regexm(spes_payment_spent,"3") & regexm(spes_payment_spent,"1") 	
count if regexm(spes_payment_spent,"3") & regexm(spes_payment_spent,"4") 	

**************
*** Descriptive stats edu
******	Tables 12 & 13

local row ""Currently enrolled" "Graduated college" "Graduated high school" "Expect to graduate college" "Expect to graduate high school" "Grades normalized" "Perc private school" "Amt of tuition" "Amt tuition paid out of pocket" "Total education spending" "Received from family" "Received from fam amt" "Scholarship" "Scholarship amt" "Observations""
local col ""All" "Experimental" "Non_Experimental" "High school" "College" "First_Time_SPES" "SPES_Baby" "No LGU influence" "LGU influence""
matrix Q = J(15,9,.)
matrix rowname Q = `row'
matrix colname Q = `col'

* Loop
local rand "& treatment!=. & endline == 1"
local conditions " "if endline==1" "if randomization==1 & treatment!=. & endline == 1" "if randomization==0 & endline==1" "if _NT_edu==0 `rand'" "if _NT_edu==1 `rand'" "if _eeo_spes_before==0 `rand'" "if _eeo_spes_before==1 `rand'" "if _lgu_influence==0 `rand'" "if _lgu_influence==1 `rand'""
local variables _eeo_enroll _eeo_grad_col _eeo_grad_hs _eeo_expect_grad_col _eeo_expect_grad_hs _eeo_gwa_norm _eeo_edu_schtype_priv _eeo_edu_tuition _eeo_tuition_paid _eeo_edu_spending _eeo_famassit _eeo_famassist_amt _eeo_tuition_scholarship _eeo_tuit_scholar_total
local j = 1
foreach cond in `conditions' {
	local i = 1
	foreach var in `variables' {
		qui summ `var' `cond'
		matrix Q[`i',`j']=r(mean)
		local ++i
	}
	local ++j
}
* Final row with number of observations
local i = 1
foreach cond in `conditions' {
	qui count `cond'
	matrix Q[15,`i']=r(N)
	local ++i
}
* Export to Excel
putexcel set "$tables_analysis/descriptive_stats2.xls", sheet(Desc_edu) modify
putexcel A1=matrix(Q, names)

*** Descriptive stats work


local row ""Currently working" "Currently looking for work" "Current earnings" "Any work summer 2016" "Formal work summer 2016" "Informal unpaid summer 2016" "Any work juldec" "Formal work juldec" "informal unpaid juldec" "Expect enroll 2017" "Observations""
local col ""All" "Experimental" "Non_Experimental" "High school" "College" "First_Time_SPES" "SPES_Baby" "No LGU influence" "LGU influence""
matrix Q = J(11,9,.)
matrix rowname Q = `row'
matrix colname Q = `col'

* Loop
local rand "& treatment!=."
local conditions " "if endline==1" "if randomization==1 & treatment!=." "if randomization==0 & endline==1" "if _NT_edu==0 `rand'" "if _NT_edu==1 `rand'" "if _eeo_spes_before==0 `rand'" "if _eeo_spes_before==1 `rand'" "if _lgu_influence==0 `rand'" "if _lgu_influence==1 `rand'""
local variables _eeo_worknow _eeo_jobsearch _eeo_wage_monthly_now _eeo_worksummer_any _eeo_worksummer_formal _eeo_worksummer_informal _eeo_workjuldec_any _eeo_workjuldec_formal _eeo_workjuldec_informal _eeo_enroll_nextyr
local j = 1
foreach cond in `conditions' {
	local i = 1
	foreach var in `variables' {
		qui summ `var' `cond'
		matrix Q[`i',`j']=r(mean)
		local ++i
	}
	local ++j
}
* Final row with number of observations
local i = 1
foreach cond in `conditions' {
	qui count `cond'
	matrix Q[11,`i']=r(N)
	local ++i
}
* Export to Excel
putexcel set "$tables_analysis/descriptive_stats2.xls", sheet(Desc_work) modify
putexcel A1=matrix(Q, names)


*** NON-NORMALIZED INDICES

** Self-esteem index

local selfesteem "dothingswell proud respect satisfied worth"
foreach var in `selfesteem' {

	gen _se_`var' = selfesteem_`var'
	recode _se_`var' (.b .r .n = .)
	assert _se_`var' > 0 
	
	* Fix reverse coding  coding
	if "`var'" == "dothingswell" |"`var'" == "proud" {
	replace _se_`var' = 6 - _se_`var'
	}
	
}
egen _eeo_selfesteem_index_nonnorm = rowmean(_se_*)

sum _eeo_selfesteem_index
label var _eeo_selfesteem_index_nonnorm "[EEO] Self-esteem index non-normalized"
drop _se_*

** Number of tasks with experience

egen _eeo_tasks_summation = rowtotal(_high_tasks_bookkeeping _high_tasks_email _high_tasks_encode _high_tasks_excel _high_tasks_onlinesearch _high_tasks_phone _high_tasks_photocopy _high_tasks_ppt _high_tasks_sort _high_tasks_scan _high_tasks_word)
replace _eeo_tasks_summation = . if tasks_encode==.

*** Life skills index
local skills "time communicate listen budget save attire determination"
foreach var in `skills' {
	gen _inli_`var' = lifeskills_`var'
	recode _inli_`var' (.b .r .n = .)
	assert _inli_`var' > 0
}

egen _eeo_lifeskills_index_nonnorm = rowmean(_inli_*)

label var _eeo_lifeskills_index_nonnorm "[EEO] Life skills index nonnormalized"
drop _inli_*	


*** CPS index
local cps "18_communication 5_conflict_mgmt 37_relating_w_others 43_organization 45_leadership"
foreach var in `cps' {
	gen _incps_`var' = cps_`var'
	recode _incps_`var' (.b .r .n = .)
	assert _incps_`var' > 0
	
	*Fix reverse coding
	if "`var'" == "18_communication" |"`var'" == "43_organization" {
	replace _incps_`var' = 6 - _incps_`var'
	}

}
egen _eeo_cps_index_nonnorm = rowmean(_incps_*)

label var _eeo_cps_index_nonnorm "[EEO] CPS index nonnormalized"
drop _incps_*	

** Descriptive stats non-normalized indices


local row ""Selfesteem" "Tasks s" "Life skills" "Workplace skills" "Observations""
local col ""All" "Experimental" "Non_Experimental" "High school" "College" "First_Time_SPES" "SPES_Baby""
matrix Q = J(5,7,.)
matrix rowname Q = `row'
matrix colname Q = `col'

* Loop
local rand "& treatment!=."
local conditions " "if endline ==1" "if randomization==1 & treatment!=." "if randomization==0 & endline==1" "if _NT_edu==0 `rand'" "if _NT_edu==1 `rand'" "if _eeo_spes_before==0 `rand'" "if _eeo_spes_before==1 `rand'""
local variables _eeo_selfesteem_index_nonnorm _eeo_tasks_summation _eeo_lifeskills_index_nonnorm _eeo_cps_index_nonnorm
local j = 1
foreach cond in `conditions' {
	local i = 1
	foreach var in `variables' {
		qui summ `var' `cond'
		matrix Q[`i',`j']=r(mean)
		local ++i
	}
	local ++j
}
* Final row with number of observations
local i = 1
foreach cond in `conditions' {
	qui count `cond'
	matrix Q[5,`i']=r(N)
	local ++i
}
* Export to Excel
putexcel set "$tables_analysis/descriptive_stats2.xls", sheet(Desc_indices_nonnorm) modify
putexcel A1=matrix(Q, names)

** Satisfaction

local row ""Currently enrolled" "Currently working" "Summer work non-SPES" "Worked July-December 2016" "Looked for job past year" "Graduated college" "Graduated high school" "Expect to graduate college" "Expect to graduate high school" "Had to show voter ID" "Pregnant" "4Ps beneficiary" "Plan to enroll in SPES" "Enrolled in SPES before" "High SPES satisfaction" "High SPES work satisfaction" "High PESO satisfaction" "100 line over 50" "150 line over 50" "200 line over 50" "Edu_expenses_total" "Helped_support_family" "Saved_for_future" "Paid_tuition_fee" "Personal_effects" "Extra_curricular_activities" "Not_yet_received_payment" "Self esteem index" "Hard tasks index" "Lifeskills index" "CPS index" "Expect find job in 6mo" "Lowest_accepted_wage" "Expected_wage" "Expect_finish_college" "Expect_SPES2017" "Enroll next year" "GWA" "Observations""
local col ""All" "Experimental" "Non_Experimental" "Control" "Treatment" "Region_3" "Region_6_7" "Region_11" "NCR" "First_Time_SPES" "SPES_Baby" "PESO_private" "PESO_nonprivate" "High school" "College" " 
matrix Q = J(39,16,.)
matrix rowname Q = `row'
matrix colname Q = `col'

* Loop
local rand "& treatment!=."
local conditions " "" "if randomization==1 & treatment!=." "if randomization==0 & endline==1" "if treatment==0" "if treatment==1" "if _bb_region==3" "if _bb_region==6| _bb_region==7" "if _bb_region==11" "if _bb_region==1" "if _eeo_spes_before==0 `rand' " "if _eeo_spes_before==1 `rand'" "if _eeo_private == 1 `rand'" "if _eeo_private == 0 `rand'" "if _NT_edu == 0   `rand'" "if _NT_edu == 1   `rand'" "
local variables _eeo_enroll _eeo_worknow _eeo_worksummer_any _eeo_workjuldec_any _eeo_jobsearch ///
_eeo_grad_col _eeo_grad_hs _eeo_expect_grad_col _eeo_expect_grad_hs ///
_eed_voterid _eed_pregnant _eed_4ps ///
_eeo_enroll_nextyr spes_before _eeo_spes_satisf_overall_high _eeo_spes_satisf_empl_high ///
_eeo_spes_satisf_peso_high _eed_100_likelihood_50 _eed_150_likelihood_50 _eed_200_likelihood_50 ///
_eeo_edu_spending _spes_payment_spent_1 _spes_payment_spent_2 _spes_payment_spent_3 ///
_spes_payment_spent_4 _spes_payment_spent_5  ///
_eeo_selfesteem_index _eeo_hardtasks_index _eeo_lifeskills_index _eeo_cps_index ///
_eeo_edu_job_6mo_high _eeo_edu_job_wage_lowest _eeo_edu_job_wage_expect _eeo_edu_expect_highest_college _eeo_spes2017 _eeo_enroll_nextyr _eeo_gwa_norm ///


local j = 1
foreach cond in `conditions' {
	local i = 1
	foreach var in `variables' {
		 summ `var' `cond'
		matrix Q[`i',`j']=r(mean)
		local ++i
	}
	local ++j
}

* Final row with number of observations
local i = 1
foreach cond in `conditions' {
	qui count `cond'
	matrix Q[39,`i']=r(N)
	local ++i
}
*/
* Export to Excel
putexcel set "$tables_analysis/descriptive_stats2.xls", sheet(End_descriptive) modify
putexcel A1=matrix(Q, names)

*** Other descriptive stats

local row ""4Ps" "Total PPI Score" "Pregnant" "Voter ID" "Observations""
local col ""All" "Experimental" "Non_Experimental" "High school" "College" "First_Time_SPES" "SPES_Baby""
matrix Q = J(5,7,.)
matrix rowname Q = `row'
matrix colname Q = `col'

* Loop
local rand "& treatment!=."
local conditions " "if endline ==1" "if randomization==1 & endline == 1 & treatment!=." "if randomization==0 & endline==1" "if _NT_edu==0 & endline == 1 `rand'" "if _NT_edu==1  & endline == 1 `rand'" "if _eeo_spes_before==0  & endline == 1 `rand'" "if _eeo_spes_before==1  & endline == 1 `rand'""
local variables _eed_4ps _score_ppi_total _eed_pregnant _eed_voterid

local j = 1
foreach cond in `conditions' {
	local i = 1
	foreach var in `variables' {
		qui summ `var' `cond'
		matrix Q[`i',`j']=r(mean)
		local ++i
	}
	local ++j
}
* Final row with number of observations
local i = 1
foreach cond in `conditions' {
	qui count `cond'
	matrix Q[5,`i']=r(N)
	local ++i
}
* Export to Excel
putexcel set "$tables_analysis/descriptive_stats2.xls", sheet(Desc_other) modify
putexcel A1=matrix(Q, names)

*** WHY NOT ENROLLED - Table 16 

local row ""Completed studies" "Could not afford" "Care for family" "Hard to meet req" "Already Working" "Changing studies"   "Don't want to" "Pregnancy" "Other" "Observations""
local col ""All"  "All"  "Control" "Control" "Treatment" "Treatment""
matrix Q = J(10,6,.)
matrix rowname Q = `row'
matrix colname Q = `col'

* Loop
local rand "& treatment!=."
local conditions " "if endline == 1"  "if treatment==0 & endline == 1" "if treatment==1 & endline == 1" "
local variables _edu_no_why_0 _edu_no_why_1 _edu_no_why_2 _edu_no_why_4 _edu_no_why_5  _edu_no_why_8  _edu_no_why_11 _edu_no_why_12 _edu_no_why_22
local j = 1
foreach cond in `conditions' {
	local i = 1
	foreach var in `variables' {
		qui summ `var' `cond'
		matrix Q[`i',`j']=r(mean)
		matrix Q[`i',`j'+1]=r(sum)
		local ++i
	}
	local ++j
	local ++j
}
* Final row with number of observations
local i = 2
foreach cond in `conditions' {
	 count `cond' & _eeo_enroll == 0
	matrix Q[10,`i']=r(N)
	local ++i
	local ++i
}
* Export to Excel
putexcel set "$tables_analysis/descriptive_stats2.xls", sheet(Why_not_enrolled) modify
putexcel A1=matrix(Q,names)
exit





**** Call attempts
use "$usedata_analysis/surveydata_full_clean.dta", clear // 
tab _ft_final_outcome_clean if endline_contacted==1 // find intensive follow-up and unreachables



*****  Descriptive statistics on job behavior  **********
use "$usedata_analysis/surveydata_full_clean.dta", clear

/*
worktype1	1	Private establishment
worktype1	2	Government/government corporation
worktype1	3	Non-governmental organization
worktype1	-222	Other, specify
worktype1	-98	Refused

*/

tab work_now if treatment != .
tabstat work_now if treatment != .,by(treatment)
tabstat work_now if treatment != .,by(spes_2016)

tab work_now_type if treatment == 0
tab work_now_type if treatment  == 1
tab work_now_type if treatment !=.
tab work_now_type if spes_2016 == 0 & treatment != .
tab work_now_type if spes_2016 == 1 & treatment != .

tabstat _eeo_enroll if treatment != .,by(work_now)
tabstat _eeo_enroll if spes_2016 == 0 & treatment != .,by(work_now)
tabstat _eeo_enroll if spes_2016 == 1 & treatment != .,by(work_now)
tabstat _eeo_enroll if treatment == 0 & treatment != .,by(work_now)
tabstat _eeo_enroll if treatment == 1 & treatment != .,by(work_now)

areg work_now treatment $cov1 if _eeo_enroll == 0,absorb(scell)
areg work_now treatment $cov1 if _eeo_enroll == 1,absorb(scell)

areg _eeo_enroll treatment $cov1 if work_now == 0,absorb(scell)
areg _eeo_enroll treatment $cov1 if work_now == 1,absorb(scell)


