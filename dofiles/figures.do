/*
Project: 		Impact Evaluation of the Special Program for Employment of Student (SPES)
Folder path: 	SPES IE Dataset\dofiles
File name: 		figures.do

Impact Evaluation of the Special Program for Employment of Student (SPES)
Innovations for Poverty Action 

Code developed by Heather Richmond and Emily Beam 

Last Updated: 06 June 2018 by EB
Stata version 13.1


****************
This file generates Figures 3 - Figures 10 of the final report 

****************
*/




version 13.1



******************** 
* Figure 3 
* Age distribution
********************* 
use "$usedata_analysis/surveydata_full_clean.dta", clear 

graph twoway histogram _bb_age if _bb_age > 0 & _bb_age <=25 , color( "71 159 218") lcolor(black) percent discrete xtitle("Age") ytitle("Percent of respondents") xlabel(15(1)25) gap(30)
	graph export "$figures/_bb_age.png",replace


******************** 
* Figure 4 
* Grade level 
********************* 
use "$usedata_analysis/surveydata_full_clean.dta", clear 

gen edu_year_graph  = 0 if _eeo_edu_year >=1 & _eeo_edu_year <=2
replace edu_year_graph  = 1 if _eeo_edu_year == 3 
replace edu_year_graph = 2 if _eeo_edu_year == 4 | _eeo_edu_year == 5
replace edu_year_graph = 3 if _eeo_edu_year == 6
replace edu_year_graph = 4 if _eeo_edu_year == 7
replace edu_year_graph = 5 if _eeo_edu_year == 8 
replace edu_year_graph = 6 if _eeo_edu_year == 9 | _eeo_edu_year == 10 
replace edu_year_graph = 7 if _eeo_edu_year == 11

label def yeargraph 1 "Grade 8/9"  1 "Grade 10"  2 "Grade 11"  3 "College, Year 1"  4 "College, Year 2"  5 "College, Year 3" 6 "College, Year 4+" 7 "Not enrolled"
label val edu_year_graph yeargraph 

* Generate condensed categories 

graph twoway histogram edu_year_graph , color( "71 159 218")discrete percent xtitle("") ytitle("Percent of respondents") color( "71 159 218") lcolor(black)   gap(50) xlabel( 0 "Grade 8/9" 1 "Grade 10"  2 "Grade 11"  3 "College, Year 1"  4 "College, Year 2"  5 "College, Year 3" 6 "College, Year 4+" 7 "Not enrolled",angle( stdarrow ) labsize(small))
	graph export "$figures/_eduyear.png",replace






**** Figure 5 ************
** Year first enrolled
use "$usedata_analysis/surveydata_full_clean.dta", clear

collapse (count) n = baseline ,by(_eeo_spes_firstenrolled randomization) 
reshape wide n,i(_eeo_spes_firstenrolled) j(randomization)
rename n0 nonexp_n
rename n1 exp_n
drop if _eeo_spes_first == ""
sum nonexp_n 
gen nonexp_share = nonexp_n/`r(sum)'
sum exp_n
gen exp_share = exp_n/`r(sum)'
order _eeo_spes_first exp_share nonexp_share exp_n nonexp_n
export excel using "$figures/figures5-10.xls",sheet("fig5-enrolled") replace firstrow(variables)


**** Figure 6: Distribution of SPES duration, 2016 and 2017 beneficiaries  ************

use "$usedata_analysis/terminal_summary",clear

egen days_cat = cut(_nodays),at(0 20 25 30 40 50 100)
label def l_days 0 "<20" 20 "20-24" 25 "25-29" 30 "30-39" 40 "40-49" 50 "50+"
label val days_cat l_days 

collapse (sum) no_2016 no_2017 (mean) total*,by(days_cat)
gen rate_16 = no_2016/total_16
gen rate_17 = no_2017/total_17

export excel using "$figures/figures5-10.xls",sheet("fig6-duration") sheetmodify firstrow(variables)


**** Figure 7 ************
** Time to payment from employer and DOLE 
tempfile temp1

use "$usedata_analysis/surveydata_full_clean.dta", clear
collapse (count) n = baseline ,by(spes_payment_rcvd_employer) 
drop if spes_payment_rcvd_employer == . | spes_payment_rcvd_employer == .r
sum n 
rename n n_emp
gen share_emp = n_emp/`r(sum)'
rename spes_payment_rcvd_employer timetopay
save `temp1',replace 

use "$usedata_analysis/surveydata_full_clean.dta", clear
collapse (count) n = baseline ,by(spes_payment_rcvd_dole) 
drop if spes_payment_rcvd_dole == . | spes_payment_rcvd_dole == .r
sum n 
rename n n_dole
gen share_dole = n_dole/`r(sum)'
rename spes_payment_rcvd_dole timetopay

merge 1:1 timetopay using `temp1'
drop _merge
order timetopay share_emp share_dole n_emp n_dole 

export excel using "$figures/figures5-10.xls",sheet("fig7-timepay") sheetmodify  firstrow(variables)

**** Figure 8 ************
** How beneficiaries used funds

use "$usedata_analysis/surveydata_full_clean.dta", clear
putexcel set "$figures/figures5-10.xls", sheet(Fig8-Howspent) modify


putexcel A8 = ("Observations" )
count if spes_payment_spent != "" & spes_payment_spent != "98"

putexcel D8 = (`r(N)')
* Recode other as 9 to avoid confusion
replace spes_payment_spent  = subinstr(spes_payment_spent,"-222","9",.)


foreach i of numlist 1/5 9{
gen _spes_payment_spent_`i' = regexm(spes_payment_spent,"`i'")
replace _spes_payment_spent_`i' = . if spes_payment_spent == ""
}
/*
1	Helped support family
2	Saved for the future
3	Paid tuition fee/schooling expenses
4	Bought personal effects
5	Paid for extra-curricular activities
*/ 

label var _spes_payment_spent_1 "Helped support family" 
label var _spes_payment_spent_2 "Saved for the future" 
label var _spes_payment_spent_3 "Paid tuition fee/schooling expenses" 
label var _spes_payment_spent_4 "Bought personal effects" 
label var _spes_payment_spent_5 "Paid for extra-curricular activities" 
label var _spes_payment_spent_9 "Other" 

collapse (mean) _spes_payment* (sum) n_1 = _spes_payment_spent_1 n_2 = _spes_payment_spent_2 n_3 = _spes_payment_spent_3 n_4 = _spes_payment_spent_4 n_5 = _spes_payment_spent_5  n_9 = _spes_payment_spent_9
gen id = 1
reshape long _spes_payment_spent_ n_,i(id) j(reason)
drop id
label  def _l_reason 1 "Helped support family" 2	"Saved for the future" 3	"Paid tuition fee/schooling expenses" 4	"Bought personal effects" 5	"Paid for extra-curricular activities" 9 "Other"
label val reason _l_reason 
decode reason,gen(_reason)
levelsof _reason, local(rlabels)
mkmat reason _spes_payment_spent n_, matrix(A)



gsort -_spes_payment_spent

putexcel A1=matrix(A, names)

putexcel A9=("Reasons")
sum n_ 

putexcel D9=(`r(sum)' )


**** Figure 9 ************
** Satisfaction
tempfile temp1 temp2

use "$usedata_analysis/surveydata_full_clean.dta", clear
collapse (count) n = baseline ,by(spes_satisfaction_employment) 
drop if mi( spes_satisfaction_employment ) 
sum n 
rename n n_emp
gen share_emp = n_emp/`r(sum)'
rename spes_satisfaction_employment satisf
save `temp1',replace 

use "$usedata_analysis/surveydata_full_clean.dta", clear
collapse (count) n = baseline ,by(spes_satisfaction_overall) 
drop if mi( spes_satisfaction_overall ) 
sum n 
rename n n_overall
gen share_overall = n_overall/`r(sum)'
rename spes_satisfaction_overall satisf
save `temp2',replace 

use "$usedata_analysis/surveydata_full_clean.dta", clear
collapse (count) n = baseline ,by(spes_satisfaction_peso) 
drop if mi( spes_satisfaction_peso ) 
sum n 
rename n n_peso
gen share_peso = n_peso/`r(sum)'
rename spes_satisfaction_peso satisf

merge 1:1 satisf using `temp1'
drop _merge
merge 1:1 satisf using `temp2'
drop _merge



order satisf share_peso share_overall share_emp

export excel using "$figures/figures5-10.xls",sheet("fig9-satisf") sheetmodify  firstrow(variables)



**** Figure 10 ************
** Enrollment rates, by completed grade level  (as of baseline)  

use "$usedata_analysis/surveydata_full_clean.dta", clear 
keep if randomization == 1
tab _eeo_edu_complete_year if randomization == 1


local row ""   High school, Grade 9 or less " "High school, Grade 10 or higher " "College, 1st year  " " College, 2nd year " " College, year 3+ " "College/TVET graduate" "
local col ""N, overall" "N, control" "N, treatment" "Enroll, overall" "Enroll, control" "Enroll, treatment" "Rate, overall" "Rate, control" "Rate, treatment" "SE, overall" "SE, control" "SE, treatment"" 
matrix Q = J(7,12,.)
matrix rowname Q = `row'
matrix colname Q = `col'

local i = 1
levelsof _eeo_edu_com
foreach value in `r(levels)'{
count if _eeo_edu_com == `value'
matrix Q[`i',1]=r(N)
count if _eeo_edu_com == `value' & treatment == 0
matrix Q[`i',2]=r(N)
count if _eeo_edu_com == `value' & treatment == 1
matrix Q[`i',3]=r(N)

count if _eeo_edu_com == `value' & _eeo_enroll == 1
matrix Q[`i',4]=r(N)
count if _eeo_edu_com == `value' & treatment == 0 & _eeo_enroll == 1
matrix Q[`i',5]=r(N)
count if _eeo_edu_com == `value' & treatment == 1 & _eeo_enroll == 1
matrix Q[`i',6]=r(N)

sum _eeo_enroll if _eeo_edu_com == `value' 
matrix Q[`i',7]=`r(mean)'
local se = (`r(mean)'*(1-`r(mean)'))/sqrt(`r(N)')
matrix Q[`i',10]=`se'

sum _eeo_enroll if _eeo_edu_com == `value' & treatment == 0 
matrix Q[`i',8]=`r(mean)'
local se = (`r(mean)'*(1-`r(mean)'))/sqrt(`r(N)')
matrix Q[`i',11]=`se'

sum _eeo_enroll if _eeo_edu_com == `value' & treatment == 1 
matrix Q[`i',9]=`r(mean)'
local se = (`r(mean)'*(1-`r(mean)'))/sqrt(`r(N)')
matrix Q[`i',12]=`se'

local ++i
}

putexcel set "$figures/figures5-10.xls", sheet(Fig10-enroll) modify
putexcel A1=matrix(Q, names)

