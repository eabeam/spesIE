/*
Name: surveydata_full_clean
Date created: 14-06-2017
Created by: Guido Maschhaupt
Description: generates new variables and codes for other, specify variables
version: STATASE13

Date last modified: 02-04-2018
Last modified by: HLR

Uses:			surveydata_public.dta 			
Creates: 		surveydata_full_clean.dta" 

*/


***********
* STart initiatlize code here
***********


use "$usedata_analysis/surveydata_full_initialize.dta", clear

* Past work experience 
tab bsl_past_work_experience 

gen bsl_minstart = min(bsl_start_date_job_1_yyyy, bsl_start_date_job_2_yyyy, bsl_start_date_job_3_yyyy, bsl_start_date_job_4_yyyy)
label var bsl_minstart "[BL] Year R first started working" 

gen bsl__workany = bsl_past_work_experience == 1 | bsl_past_work_experience == 2
	replace bsl__workany = . if baseline == 0 | bsl_incomplete == 1
	replace bsl__workany = 0 if bsl_minstart == 2016		// recode as no work experience if it only started in 2016 

label var bsl_past_work_experience "[BL] Past work experience: No work, SPES work, nonSPES work"
label var bsl__workany "[BL] Work experience at baseline, 1/0" 
	
gen bsl__workspes = bsl_past_work_experience == 2
		replace bsl__workspes = . if baseline == 0 | bsl_incomplete == 1
		replace bsl__workspes = 0 if bsl_minstart == 2016 // recode as no work experience if it only started in 2016 

label var bsl__workspes "[BL] SPES work experience at baseline, 1/0" 

		
gen bsl__worknonspes = bsl_past_work_experience == 1
		replace bsl__worknonspes = . if baseline == 0 | bsl_incomplete == 1
		replace bsl__worknonspes = 0 if bsl_minstart == 2016 // recode as no work experience if it only started in 2016

label var bsl__worknonspes "[BL] nonSPES work experience at baseline, 1/0"

* gen informal/formal		
tab bsl_type_of_employer_1 
tab bsl_type_of_employer_2 
tab bsl_type_of_employer_3 
tab bsl_type_of_employer_4 


foreach type in private gov ngo selfbus famfarm fambus labor other{ 
	gen bsl__type_of_employer_`type' = 0
	replace bsl__type_of_employer_`type' = . if baseline == 0 | bsl_incomplete == 1
}

replace bsl__type_of_employer_private = 1 if bsl_type_of_employer_1 == 1 | bsl_type_of_employer_2 == 1 | bsl_type_of_employer_3 == 1 | bsl_type_of_employer_4 == 1
replace bsl__type_of_employer_gov = 1 if bsl_type_of_employer_1 == 2 | bsl_type_of_employer_2 == 2 | bsl_type_of_employer_3 == 2 | bsl_type_of_employer_4 == 2
replace bsl__type_of_employer_ngo = 1 if bsl_type_of_employer_1 == 3 | bsl_type_of_employer_2 == 3 | bsl_type_of_employer_3 == 3 | bsl_type_of_employer_4 == 3
replace bsl__type_of_employer_selfbus = 1 if bsl_type_of_employer_1 == 4 | bsl_type_of_employer_2 == 4 | bsl_type_of_employer_3 == 4 | bsl_type_of_employer_4 == 4
replace bsl__type_of_employer_famfarm = 1 if bsl_type_of_employer_1 == 5 | bsl_type_of_employer_2 == 5 | bsl_type_of_employer_3 == 5 | bsl_type_of_employer_4 == 5
replace bsl__type_of_employer_fambus = 1 if bsl_type_of_employer_1 == 6 | bsl_type_of_employer_2 == 6 | bsl_type_of_employer_3 == 6 | bsl_type_of_employer_4 == 6
replace bsl__type_of_employer_labor = 1 if bsl_type_of_employer_1 == 7 | bsl_type_of_employer_2 == 7 | bsl_type_of_employer_3 == 7 | bsl_type_of_employer_4 == 7
replace bsl__type_of_employer_other = 1 if bsl_type_of_employer_1 == -222 | bsl_type_of_employer_2 == -222 | bsl_type_of_employer_3 == -222 | bsl_type_of_employer_4 == -222


label var bsl__type_of_employer_private "[BL] Private employer experience at baseline, 1/0"
label var bsl__type_of_employer_gov "[BL] Govt employer experience at baseline, 1/0"
label var bsl__type_of_employer_ngo "[BL] NGO employer experience at baseline, 1/0"
label var bsl__type_of_employer_selfbus "[BL] Personal business experience at baseline, 1/0"
label var bsl__type_of_employer_famfarm "[BL] Family farm experience at baseline, 1/0"
label var bsl__type_of_employer_fambus "[BL] Family business experience at baseline, 1/0"
label var bsl__type_of_employer_labor "[BL] Farming/Labor (for others) experience at baseline, 1/0"
label var bsl__type_of_employer_other "[BL] Other employer experience at baseline, 1/0"


* replace if min = 2016 
foreach type in private gov ngo selfbus famfarm fambus labor other{ 
replace bsl__type_of_employer_`type' = 0 if bsl_minstart == 2016
}

gen bsl__type_of_employer_formal = 0
replace bsl__type_of_employer_formal = . if baseline == 0 | bsl_incomplete == 1
replace bsl__type_of_employer_formal = 1 if bsl__type_of_employer_private == 1 | bsl__type_of_employer_gov == 1 | bsl__type_of_employer_ngo == 1

label var bsl__type_of_employer_formal "[BL] Formal work experience, 1/0 (employment types: private, govt, ngo)"

gen bsl__type_of_employer_informal = 0
replace bsl__type_of_employer_informal = . if baseline == 0 | bsl_incomplete == 1
replace bsl__type_of_employer_informal = 1 if bsl__type_of_employer_selfbus == 1 |  bsl__type_of_employer_famfarm == 1 | bsl__type_of_employer_fambus == 1 | bsl__type_of_employer_labor == 1

label var bsl__type_of_employer_informal "[BL] Informal work experience, 1/0 (all other employment types)"


tab bsl__type_of_employer_formal
tab bsl__type_of_employer_informal

/* Region*/ 
assert bsl_region != ""
gen bsl_reg3 = bsl_region == "3" 
gen bsl_reg6 = bsl_region == "6"
gen bsl_reg7 = bsl_region == "7"
gen bsl_reg11 = bsl_region == "11"
gen bsl_regNCR = bsl_region == "NCR"

label var bsl_reg3 "[BB] Region 3 respondents"
label var bsl_reg6 "[BB] Region 6 respondents"
label var bsl_reg7 "[BB] Region 7 respondents"
label var bsl_reg11 "[BB] Region 11 respondents"
label var bsl_regNCR "[BB] Region NCR respondents"
 			
* Order
rename bsl_region region
label var respondent_id "Respondent ID" 
label var region "Region" 
label var randomization "Experimental sample, 1/0"
label var baseline "Supplemental questionnaire, 1/0" 
label var bsl_spesform "SPES Form 2 collected, 1/0" 
order respondent_id region id_peso scel randomization treatment baseline bsl_spesform 

		
label variable _edulvl "[Randomization education assignment 0 - HS 1 - College]" 
replace edu_lvl_fc3 =lower(edu_lvl_fc3)
destring age_fc3, replace
destring _edulvl_fc3, replace




*** Generate baseline variables of interest (_bb_*) ***


label define gender 1 "Male" 2 "Female", modify

gen _bb_female = 1 if regex(group,"F")
replace _bb_female = 0 if regex(group,"M")

replace _bb_female = 1 if bsl__gender == 2 & _bb_female == . 
replace _bb_female = 0 if bsl__gender == 1 & _bb_female == . 
label var _bb_female "[BB] Respondent is female 1/0"


*Age
recode bsl_age_new_start -1 = .
clonevar _bb_age = bsl_age_new_start
label var _bb_age "[BB] Age of applicant at start of SPES"



* Region
clonevar _bb_region = region
replace _bb_region = subinstr(_bb_region,"NCR","1",.)
destring _bb_region, replace
label var _bb_region "[BB] Region"

* OSY
gen _bb_osy = bsl__scholastic == 2
replace _bb_osy  = . if bsl__scholastic >= . 
label var _bb_osy "[BB] R is OSY, 1/0" 

*SPES Baby

gen _bb_spesbaby = bsl_spes_status == 1
replace _bb_spesbaby = . if bsl_spes_status == . 
label var _bb_spesbaby "[BB-rand] R is SPES baby, 1/0"




********************************
*	Baseline education level 
********************************

label variable _edulvl "[PESO lists] Randomization education assignment 0=HS; 1=College" // 4024 observations
replace edu_lvl_fc3 =lower(edu_lvl_fc3)
destring age_fc3, replace
destring _edulvl_fc3, replace


gen temp_hs = .
replace temp_hs = 1 if regexm(edu_lvl_fc3, "high") == 1
replace temp_hs = 1 if regexm(edu_lvl_fc3, "als") == 1
replace temp_hs = 1 if regexm(edu_lvl_fc3, "grade") == 1
replace temp_hs = 1 if regexm(edu_lvl_fc3, "garde") == 1
replace temp_hs = 1 if regexm(edu_lvl_fc3, "gr.") == 1
replace temp_hs = 1 if regexm(edu_lvl_fc3, "k-12") == 1
replace temp_hs = 1 if regexm(edu_lvl_fc3, "grdae") == 1
replace temp_hs = 1 if regexm(edu_lvl_fc3, "hs") == 1
replace temp_hs = 1 if regexm(edu_lvl_fc3, "secondary") == 1

replace temp_hs = 1 if edu_lvl_fc3 == "4th" & age_fc3 == 15
replace temp_hs = 1 if edu_lvl_fc3 == "4th" & age_fc3 == 16
replace temp_hs = 1 if edu_lvl_fc3 == "4th" & age_fc3 == 17
replace temp_hs = 1 if edu_lvl_fc3 == "4th" & age_fc3 == 18


replace temp_hs = 2 if regexm(edu_lvl_fc3, "hs. grad") == 1

*label var temp_hs "[BL] R is high school"

label define highschool 1 "High school" 2 "HS graduate"
label value temp_hs highschool




gen temp_col = .
replace temp_col = 1 if regexm(edu_lvl_fc3, "col") == 1
replace temp_col = 1 if regexm(edu_lvl_fc3, "cl") == 1
replace temp_col = 1 if _level_fc3 == "College"

replace temp_col = 1 if regexm(bsl_Status, "col") == 1
replace temp_col = 1 if edu_lvl_fc3 == "1st" & age_fc3 >= 15
replace temp_col = 1 if edu_lvl_fc3 == "ist" & age_fc3 >= 16
replace temp_col = 1 if edu_lvl_fc3 == "2nd" & age_fc3 >= 17
replace temp_col = 1 if edu_lvl_fc3 == "3rd" & age_fc3 >= 18
replace temp_col = 1 if edu_lvl_fc3 == "4th" & age_fc3 >= 19
replace temp_col = 1 if edu_lvl_fc3 == "4th year" & age_fc3 >= 19

replace temp_col = 1 if id_peso == 49 // Bataan R3 - P24 
replace temp_col = 1 if id_peso == 9 // Magalang Pampanga R3 - P11
replace temp_col = 1 if id_peso == 20 // San Luis Pampanga R3 - P14 
* replace temp_col = 1 if (id_peso == 86 | id_peso == 87) & age_fc3 >= 19 // R3 P 35 and R3 P36


replace temp_col = 1 if regexm(yearlevel_fc3, "1") == 1
replace temp_col = 1 if regexm(yearlevel_fc3, "2") == 1
replace temp_col = 1 if regexm(yearlevel_fc3, "3") == 1
replace temp_col = 1 if regexm(yearlevel_fc3, "4") == 1

replace temp_hs = 1 if regexm(yearlevel_fc3, "10") == 1
replace temp_col = . if temp_hs != .


*label var temp_col "[BL] R is college, 1/0"


gen temp_voc = .
replace temp_voc = 1 if regexm(edu_lvl_fc3, "voc") == 1
replace temp_voc = 1 if bsl_level_of_education_training == 2 & age_fc3 == 17 & edu_lvl_fc3 == "1st"
replace temp_voc = 1 if bsl_level_of_education_training == 2 & age_fc3 == 19 & edu_lvl_fc3 == "2nd"
replace temp_voc = 1 if bsl_level_of_education_training == 2 & age_fc3 == 24 & edu_lvl_fc3 == "1st"

*label var temp_voc "[BL] R is vocational, 1/0"



gen temp_osy = .
replace temp_osy = 1 if regexm(edu_lvl_fc3, "out of school") == 1
replace temp_osy = 1 if edu_lvl_fc3 == "out of school youth"

replace temp_osy = 1 if bsl_status == "osy"
replace temp_osy = 1 if bsl_Status == "osy"

gen temp_edulvl = .
replace temp_edulvl = 0 if temp_osy == 1
replace temp_edulvl = 0 if temp_hs == 1
replace temp_edulvl = 0 if temp_hs == 2
replace temp_edulvl = 1 if temp_voc == 1
replace temp_edulvl = 1 if temp_col == 1

replace temp_edulvl = _edulvl_fc3 if edu_lvl_fc3 == "*" & temp_edulvl == . // Panabo 25 instances only 3 have ages - 16, 19
replace temp_edulvl = _edulvl_fc3 if temp_edulvl == .

label define edulvl 0 "osy/highschool" 1 "votech/college" 
label value temp_edulvl edulvl

replace temp_col = 1 if regexm(course_fc3, "BS") == 1 & temp_edulvl == . 
replace temp_col = 1 if regexm(course_fc3, "Bach") == 1 & temp_edulvl == . 
replace temp_col = 1 if regexm(course_fc3, "BACH") == 1 & temp_edulvl == . 
replace temp_col = 1 if regexm(course_fc3, "BEED") == 1 & temp_edulvl == . 
replace temp_col = 1 if regexm(course_fc3, "AB E") == 1 & temp_edulvl == . 
replace temp_col = 1 if regexm(course_fc3, "BPE") == 1 & temp_edulvl == . 
replace temp_col = 1 if course_fc3 == "TOURISM" & temp_edulvl == . 
replace temp_col = 1 if regexm(course_fc3, "COMPUTER") == 1 & temp_edulvl == . 
replace temp_col = 1 if regexm(course_fc3, "Office") == 1 & temp_edulvl == . 
replace temp_col = 1 if regexm(course_fc3, "EDUCATION") == 1 & temp_edulvl == . 

replace temp_col = 1 if bsl_lvl_of_edu_train_other == "4th year college" & temp_edulv == .
replace temp_col = 1 if bsl_lvl_of_edu_train_other == "fourth year college" & temp_edulv == .
replace temp_col = 1 if bsl_lvl_of_edu_train_other == "2nd year college" & temp_edulv == .

replace temp_col = 1 if bsl_level_of_education_training == 3 & age_fc3 == 19 & temp_edulv == .


*re run replace
replace temp_edulvl = 0 if temp_osy == 1
replace temp_edulvl = 0 if temp_hs == 1
replace temp_edulvl = 0 if temp_hs == 2
replace temp_edulvl = 1 if temp_voc == 1
replace temp_edulvl = 1 if temp_col == 1

rename temp_edulvl _bb_edulvl
label var _bb_edulvl "[BB] R is in college or high school, 1/0"
label define edu 0 "high school 0" 1 "college 1"
label values _bb_edulvl edu

drop temp_osy temp_hs temp_voc temp_col


*** BASELINE WORK 
clonevar _bb_workany = bsl__workany
label var _bb_workany  "[BB] Any work experience, 1/0"

clonevar _bb_workformal = bsl__type_of_employer_formal
label var _bb_workformal  "[BB] Any work experience, formal, 1/0"

clonevar _bb_workinformal = bsl__type_of_employer_informal
label var _bb_workinformal  "[BB] Any work experience, informal, 1/0"

** Aspirations

* Expected Earnings
*	topcode unreasonably large values
clonevar _bb_lowestamount = bsl_lowest_amnt_pay_per_day_acc
replace _bb_lowestamount = 2500 if _bb_lowestamount > 2500 & _bb_lowestamount < .
label var _bb_lowestamount "[BB] Lowest daily wage amount R would accept (PHP)"


clonevar _bb_expected_earn = bsl_expected_earn
replace _bb_expected_earn = 2500 if _bb_expected_earn > 2500 & _bb_expected_earn < . 
label var _bb_expected_earn "[BB] Daily wage amount R expects to earn at first job after graudation"


* Expected tuition

clonevar _bb_expectedtuition =  bsl_expected_tuition_fees 
clonevar _bb_othereducationexp = bsl_other_education_expenses 

label var _bb_expectedtuition "[BB] Expected tuition fees for next academic year (PHP)"
label var _bb_othereducationexp "[BB] Other education expenses for next academic year (PHP)"






*** Baseline descriptive variables (_bd_*)

* Level of training next year
clonevar _leveleducation = bsl_level_of_education_training
clonevar _leveleducation_other = bsl_lvl_of_edu_train_other

label var _leveleducation "[BL] Level of education R plans to enroll next academic year"
label var _leveleducation_other "[BL] Other level of education R plans to enroll next academic year"

replace _leveleducation = 1 if regex(bsl_lvl_of_edu_train_other,"high.*school") |  regex(bsl_lvl_of_edu_train_other,"senior.*high") 
replace _leveleducation_other = "" if regex(bsl_lvl_of_edu_train_other,"high.*school") |  regex(bsl_lvl_of_edu_train_other,"senior.*high") 

replace _leveleducation = 1 if regex(bsl_lvl_of_edu_train_other,"grade") 
replace _leveleducation_other = "" if regex(bsl_lvl_of_edu_train_other,"grade") 
	
replace _leveleducation = 1 if regex(bsl_lvl_of_edu_train_other,"k.*12") 
replace _leveleducation_other = "" if regex(bsl_lvl_of_edu_train_other,"k.*12") 	

replace  _leveleducation = 3 if regex(bsl_lvl_of_edu_train_other,"college") | regex(bsl_lvl_of_edu_train_other,"uni") | regex(bsl_lvl_of_edu_train_other,"master")
replace _leveleducation_other = "" if regex(bsl_lvl_of_edu_train_other,"college") | regex(bsl_lvl_of_edu_train_other,"uni") | regex(bsl_lvl_of_edu_train_other,"master")
	
	
gen _bd_nextyr_hs =  _leveleducation == 1
gen _bd_nextyr_voc = _leveleducation == 2 
gen _bd_nextyr_col = _leveleducation == 3

label var _bd_nextyr_hs "[BD] Level next year = HS, 1/0"
label var _bd_nextyr_voc "[BD] Level next year = Vocational, 1/0"
label var _bd_nextyr_col "[BD] Level next year = College, 1/0"
	
foreach name in hs voc col {
	replace _bd_nextyr_`name' = . if _leveleducation >= .
	}
	
* Highest level plan to complete
gen _highestlevel = bsl_highest_lvl_edu_tr
gen _highestlevel_other = bsl_highest_lvl_edu_tr_other

label var _highestlevel "[BL] Highest level of education R expects to complete"
label var _highestlevel_other "[BL] Other highest level of education R expects to complete"
 
replace _highestlevel = 1 if regex(bsl_highest_lvl_edu_tr_other,"high.*school") & bsl_highest_lvl_edu_tr_other != "highschool teacher"
replace _highestlevel_other = "" if regex(bsl_highest_lvl_edu_tr_other,"high.*school") & bsl_highest_lvl_edu_tr_other != "highschool teacher"

replace _highestlevel = 1 if regex(bsl_highest_lvl_edu_tr_other,"senior high")
replace _highestlevel_other = "" if regex(bsl_highest_lvl_edu_tr_other,"senior high")

replace _highestlevel  = 5  if regex(bsl_highest_lvl_edu_tr_other,"phd") |  regex(bsl_highest_lvl_edu_tr_other,"doctoral") 
replace _highestlevel_other = "" if regex(bsl_highest_lvl_edu_tr_other,"phd") |  regex(bsl_highest_lvl_edu_tr_other,"doctoral") 

replace _highestlevel  = 5  if regex(bsl_highest_lvl_edu_tr_other,"doctorate") |  regex(bsl_highest_lvl_edu_tr_other,"doctor") 
replace _highestlevel_other  = ""  if regex(bsl_highest_lvl_edu_tr_other,"doctorate") |  regex(bsl_highest_lvl_edu_tr_other,"doctor") 

replace _highestlevel  = 3  if regex(bsl_highest_lvl_edu_tr_other,"college grad") 
replace _highestlevel_other  = ""  if regex(bsl_highest_lvl_edu_tr_other,"college grad") 

replace _highestlevel = 5 if regex(bsl_highest_lvl_edu_tr_other,"master")
replace _highestlevel_other = "" if regex(bsl_highest_lvl_edu_tr_other,"master")


label define edu_highest 1 "High School" 2 "Vocational" 3 "College" 4 "Other, specify" 5 "Post College"
label values _highestlevel edu_highest

		
gen _bd_highest_hs = _highestlevel == 1
gen _bd_highest_voc = _highestlevel == 2 
gen _bd_highest_col = _highestlevel == 3
gen _bd_highest_postcollege = _highestlevel == 5
	
foreach name in hs voc col postcollege{
	replace _bd_highest_`name' = . if _highestlevel >= . 
	label var _bd_highest_`name' "[BD] Highest level of education R expects to complete, `name', 1/0"
}

clonevar _bd_asp_chancegrad_spes = bsl_chance_of_grad_if_spes
recode _bd_asp_chancegrad_spes 710 = . 

label var _bd_asp_chancegrad_spes "[BD] If selected for SPES what is the chance the R will graduate"

clonevar  _bd_asp_chancegrad_nspes =  bsl_chance_of_grad_if_not_spes

label var _bd_asp_chancegrad_nspes "[BD] If not selected for SPES what is the chance the R will graduate"



** Work Characteristics

/* Generate binary indicators for seven categories */ 
local i = 1
foreach workchar in always_on_time communicates_to_supervisors attentive_to_other_persons ///
					always_budget_my_allowance save_extra_money clothes_suit_the_occasion ///
					determined_to_finish_studies{
	gen _bd_agree_`i' = bsl_`workchar' == 4 | bsl_`workchar' == 5
	replace _bd_agree_`i' = . if bsl_`workchar' == . | bsl_`workchar' == 8

	label var _bd_agree_`i' "[BD] `workchar', agree or strongly agree, 1/0"
	
	local i = `i'+1
	}

	
 *PESO officer ranking as good/very good for each VF_QuesRank value

	local i = 1
	foreach workchar in communication_skills self_confidence professionalism abil_to_fllw_instr{
	
	gen _bd_good_`i' = bsl_`workchar' == 4 | bsl_`workchar' == 5
	replace _bd_good_`i' = . if bsl_`workchar' == . | bsl_`workchar' == 8
	label var _bd_good_`i' "[BD] `workchar', rated good/very good, 1/0"

		local i = `i'+1

	}

	/* Recode barriers to finish education */ 
local i = 1

foreach varname in  cannot_pay_for_tuition_fees need_care_home_family_me ///
					need_care_own_chldrn hard_to_commute_to_school hard_to_pass_courses{
gen _bd_barrier_`i' = bsl_`varname' == 4 | bsl_`varname' == 5
replace _bd_barrier_`i' = . if bsl_`varname' == 8 | bsl_`varname' >= .
label var _bd_barrier_`i' "[BD] Barrier to education is `varname', agree or strongly agree, 1/0"
local i = `i' + 1
}

* Municipality Class

rename muni_income_class _bd_muni_income_class
label var _bd_muni_income_class "[BD] Municipal/City income class" 


***********************************************
* Endline descriptive characteristics 

gen _eed_voterid =  additional_voterscard_required == 1
replace _eed_voterid = . if additional_voterscard_required >= .
label var _eed_voterid "[EED] R or parent voter id required, 1/0"

clonevar _eed_pregnant = additional_pregnant
label var _eed_pregnant "[EED] R is pregnant or has given birth"

clonevar _eed_4ps = additional_4ps
label var _eed_4ps "[EED] R or R's family is CCT (4Ps) beneficiary"


*** PPI SCORE ***		

/*
In PPI survey:
1. How many members does the household have?
	A. Eight or more			0
	B. Seven					2
	C. Six						6
	D. Five						11
	E. Four						15
	F. Three					21
	G. One or two				30
*/


recode 	additional_ppi_hh 300 = . 
gen _score_ppi_hh = additional_ppi_hh
replace _score_ppi_hh = 0 if additional_ppi_hh >= 8
replace _score_ppi_hh = 2 if additional_ppi_hh == 7
replace _score_ppi_hh = 6 if additional_ppi_hh == 6
replace _score_ppi_hh = 11 if additional_ppi_hh == 5
replace _score_ppi_hh = 15 if additional_ppi_hh == 4
replace _score_ppi_hh = 21 if additional_ppi_hh == 3
replace _score_ppi_hh = 30 if additional_ppi_hh == 1 |  additional_ppi_hh == 2

label var _score_ppi_hh "[Recoded for PPI score value] PPI score for # of household members"

/*
In PPI survey:
2. Are all household members ages 6 to 17 currently attending school?
	A. No						0
	B. Yes						1
	C. No one ages 6 to 17		2
*/

gen _score_ppi_school = additional_ppi_school
label var _score_ppi_school "[Recoded for PPI score value] PPI score for # of hh members ages 6-17 currently attending school"

*no changes needed

/* In PPI survey:
3. How many household members did any work for at least one hour in the past week?
	A. None						0
	B. One						2
	C. Two						7
	D. Three or more			12
*/

gen _score_ppi_work = additional_ppi_work
replace _score_ppi_work = 0 if additional_ppi_work == 0
replace _score_ppi_work = 2 if additional_ppi_work == 1
replace _score_ppi_work = 7 if additional_ppi_work == 2
replace _score_ppi_work = 12 if additional_ppi_work >= 3

label var _score_ppi_work "[Recoded for PPI score value] PPI score for # hh members who work at least 1hr in past week"



/* In PPI survey:
4. In their primary occupation or business in the past week, how many hh members were farmers, forestry workers, fishers, laborers, or unskilled workers?
	A. Three or more			0
	B. Two						4
	C. One						8
	D. None						12
*/

gen _score_ppi_informal = additional_ppi_informal
replace _score_ppi_informal = 0 if additional_ppi_informal >= 3 
replace _score_ppi_informal = 4 if additional_ppi_informal == 2
replace _score_ppi_informal = 8 if additional_ppi_informal == 1
replace _score_ppi_informal = 12 if additional_ppi_informal == 0

label var _score_ppi_informal "[Recoded for PPI score value] PPI score for # of hh members who worked in informal sector in the past week"


/*In PPI survey:
5. What is the highest grade completed by the female head/spouse?
	A. No grade completed, or elementary undergraduate		0
	B. No female head/spouse								2
	C. Elementary graduate, or high-school undergraduate	2
	D. High-school graduate									4
	E. College undergraduate, or higher						7
*/

gen _score_ppi_highestedu = additional_ppi_highestedu
replace _score_ppi_highestedu = 0 if additional_ppi_highestedu == 1
replace _score_ppi_highestedu = 2 if additional_ppi_highestedu == 6
replace _score_ppi_highestedu = 2 if additional_ppi_highestedu == 2
replace _score_ppi_highestedu = 4 if additional_ppi_highestedu == 3
replace _score_ppi_highestedu = 7 if additional_ppi_highestedu == 4 | additional_ppi_highestedu == 5

label var _score_ppi_highestedu "[Recoded for PPI score value] PPI score for highest grade complete by female head/spouse"


/* In PPI survey:
6. What type of construction materials are the outer walls made of?
	A. Salvaged/makeshift materials,											0
		mixed but predominantly salvaged materials, light materials
		(cogon, nipa, anahaw), or mixed but predominantly light materials

	B. Mixed but predominantly strong materials									2

	C. Strong materials															3
	(galvanized iron, aluminum, tile, concrete, brick, stone, wood, plywood, asbestos)
*/

gen _score_ppi_house = additional_ppi_house
replace _score_ppi_house = 0 if additional_ppi_house == 1
replace _score_ppi_house = 2 if additional_ppi_house == 2
replace _score_ppi_house = 3 if additional_ppi_house == 3

label var _score_ppi_house "[Recoded for PPI score value] PPI score for type of construction materials of house outer walls" 

/* In SPES Endline survey:
1	Salvaged/makeshift materials, mixed but predominantly salvaged materials, light materials (cogon, nipa, anahaw), or mixed but predominantly light materials
2	Mixed but predominantly strong materials
3	Strong materials (galvanized iron, aluminum, tile, concrete, brick, stone, wood, plywood, asbestos)
*/


/* In PPI survey:
7. Does the family own any sala sets?
	A. No				0
	B. Yes				3
*/

gen _score_ppi_salaset = additional_ppi_own_salaset
replace _score_ppi_salaset = 0 if additional_ppi_own_salaset == 0
replace _score_ppi_salaset = 3 if additional_ppi_own_salaset == 1

label var _score_ppi_salaset "[Recoded for PPI score value] PPI score for family owning sala set"


/* PPI survey:
8. Does the family own a refrigerator/freezer or a washing machine?
	A. No									0
	B. One or the other, but not both		6
	C. Both									12
*/

gen _score_ppi_ref_washer = .
replace _score_ppi_ref_washer = 0 if additional_ppi_own_ref == 0 & additional_ppi_own_washer == 0
replace _score_ppi_ref_washer = 6 if additional_ppi_own_ref == 0 & additional_ppi_own_washer == 1
replace _score_ppi_ref_washer = 6 if additional_ppi_own_ref == 1 & additional_ppi_own_washer == 0
replace _score_ppi_ref_washer = 12 if additional_ppi_own_ref == 1 & additional_ppi_own_washer == 1

label var _score_ppi_ref_washer "[Recoded for PPI score value] PPI score for family owning refrigerator, freezer, or both"


/* In PPI survey:
9. Does the family own a television set or a VTR/VHS/VCD/DVD player?
	A. No									0
	B. Only television						4
	C. VTR/VHS/VCD/DVD player				7
		(with or without TV)
*/

gen _score_ppi_tv_dvd = .
replace _score_ppi_tv_dvd = 0 if additional_ppi_own_tv == 0 & additional_ppi_own_dvd == 0
replace _score_ppi_tv_dvd = 4 if additional_ppi_own_tv == 1 & additional_ppi_own_dvd == 0
replace _score_ppi_tv_dvd = 0 if additional_ppi_own_dvd == 1

label var _score_ppi_tv_dvd "[Recoded for PPI score value] PPI score for famiy owning tv and/or player"


/* In PPI survey:
10. How many telephones/cellphones does the family own?
	A. None									0
	B. One									4
	C. Two									7
	D. Three or more						12
*/

gen _score_ppi_cellphone =  additional_ppi_own_cellphones
replace _score_ppi_cellphone = 0 if additional_ppi_own_cellphones == 0
replace _score_ppi_cellphone = 4 if additional_ppi_own_cellphones == 1
replace _score_ppi_cellphone = 7 if additional_ppi_own_cellphones == 2
replace _score_ppi_cellphone = 12 if additional_ppi_own_cellphones >= 3

label var _score_ppi_cellphone "[Recoded for PPI score value] PPI score for # of telephones/cellphones family owns"


order _score_ppi_hh- _score_ppi_cellphone, before (additional_4ps)

**** PPI TOTAL SCORE ****
gen _score_ppi_total = _score_ppi_hh + _score_ppi_school + _score_ppi_work + _score_ppi_informal + _score_ppi_highestedu + _score_ppi_house + _score_ppi_salaset + _score_ppi_ref_washer + _score_ppi_tv_dvd + _score_ppi_cellphone
label var _score_ppi_total "[EED] Total score in Progress out of Poverty index"






**** PPI INDICES	****
*Note: http://www.factfish.com/statistic-country/philippines/ppp%20conversion%20factor%2C%20gdp

** 1.90 dollars a day line
gen _190_likelihood = .
replace _190_likelihood = 100 if _score_ppi_total <= 9
replace _190_likelihood = 71.4 if _score_ppi_total >= 10 & _score_ppi_total <= 14
replace _190_likelihood = 56.5 if _score_ppi_total >= 15 & _score_ppi_total <= 19
replace _190_likelihood = 39.0 if _score_ppi_total >= 20 & _score_ppi_total <= 24
replace _190_likelihood = 23.4 if _score_ppi_total >= 25 & _score_ppi_total <= 29
replace _190_likelihood = 15.8 if _score_ppi_total >= 30 & _score_ppi_total <= 34
replace _190_likelihood = 08.2 if _score_ppi_total >= 35 & _score_ppi_total <= 39
replace _190_likelihood = 03.6 if _score_ppi_total >= 40 & _score_ppi_total <= 44
replace _190_likelihood = 01.8 if _score_ppi_total >= 45 & _score_ppi_total <= 49
replace _190_likelihood = 00.6 if _score_ppi_total >= 50 & _score_ppi_total <= 54
replace _190_likelihood = 00.1 if _score_ppi_total >= 55 & _score_ppi_total <= 59
replace _190_likelihood = 00.0 if _score_ppi_total >= 60


** 3.10 dollars a day line
gen _310_likelihood = .
replace _310_likelihood = 100 if _score_ppi_total <= 9
replace _310_likelihood = 96.6 if _score_ppi_total >= 10 & _score_ppi_total <= 14
replace _310_likelihood = 94.5 if _score_ppi_total >= 15 & _score_ppi_total <= 19
replace _310_likelihood = 88.4 if _score_ppi_total >= 20 & _score_ppi_total <= 24
replace _310_likelihood = 75.8 if _score_ppi_total >= 25 & _score_ppi_total <= 29
replace _310_likelihood = 62.9 if _score_ppi_total >= 30 & _score_ppi_total <= 34
replace _310_likelihood = 46.6 if _score_ppi_total >= 35 & _score_ppi_total <= 39
replace _310_likelihood = 29.1 if _score_ppi_total >= 40 & _score_ppi_total <= 44
replace _310_likelihood = 16.0 if _score_ppi_total >= 45 & _score_ppi_total <= 49
replace _310_likelihood = 08.5 if _score_ppi_total >= 50 & _score_ppi_total <= 54
replace _310_likelihood = 03.3 if _score_ppi_total >= 55 & _score_ppi_total <= 59
replace _310_likelihood = 01.8 if _score_ppi_total >= 60 & _score_ppi_total <= 64
replace _310_likelihood = 00.6 if _score_ppi_total >= 65 & _score_ppi_total <= 69
replace _310_likelihood = 00.1 if _score_ppi_total >= 70 & _score_ppi_total <= 79
replace _310_likelihood = 00.0 if _score_ppi_total >= 80

*** 100% of the 2009 Philippines poverty line at 47.53 pesos per day
gen _100_likelihood = .
replace _100_likelihood = 100 if _score_ppi_total <= 9
replace _100_likelihood = 91.8 if _score_ppi_total >= 10 & _score_ppi_total <= 14
replace _100_likelihood = 88.6 if _score_ppi_total >= 15 & _score_ppi_total <= 19
replace _100_likelihood = 79.4 if _score_ppi_total >= 20 & _score_ppi_total <= 24
replace _100_likelihood = 64.2 if _score_ppi_total >= 25 & _score_ppi_total <= 29
replace _100_likelihood = 49.9 if _score_ppi_total >= 30 & _score_ppi_total <= 34
replace _100_likelihood = 32.9 if _score_ppi_total >= 35 & _score_ppi_total <= 39
replace _100_likelihood = 18.9 if _score_ppi_total >= 40 & _score_ppi_total <= 44
replace _100_likelihood = 9.4 if _score_ppi_total >= 45 & _score_ppi_total <= 49
replace _100_likelihood = 5.0 if _score_ppi_total >= 50 & _score_ppi_total <= 54
replace _100_likelihood = 1.5 if _score_ppi_total >= 55 & _score_ppi_total <= 59
replace _100_likelihood = 0.8 if _score_ppi_total >= 60 & _score_ppi_total <= 64
replace _100_likelihood = 0.2 if _score_ppi_total >= 65 & _score_ppi_total <= 69
replace _100_likelihood = 0 if _score_ppi_total >= 70
replace _100_likelihood = . if _score_ppi_total==.


*** 150% of the 2009 Philippines poverty line at 47.53 pesos per day
gen _150_likelihood = .
replace _150_likelihood = 100 if _score_ppi_total <= 9
replace _150_likelihood = 99.1 if _score_ppi_total >= 10 & _score_ppi_total <= 14
replace _150_likelihood = 98.7 if _score_ppi_total >= 15 & _score_ppi_total <= 19
replace _150_likelihood = 97.4 if _score_ppi_total >= 20 & _score_ppi_total <= 24
replace _150_likelihood = 91.5 if _score_ppi_total >= 25 & _score_ppi_total <= 29
replace _150_likelihood = 85.2 if _score_ppi_total >= 30 & _score_ppi_total <= 34
replace _150_likelihood = 75.0 if _score_ppi_total >= 35 & _score_ppi_total <= 39
replace _150_likelihood = 58.3 if _score_ppi_total >= 40 & _score_ppi_total <= 44
replace _150_likelihood = 38.7 if _score_ppi_total >= 45 & _score_ppi_total <= 49
replace _150_likelihood = 24.1 if _score_ppi_total >= 50 & _score_ppi_total <= 54
replace _150_likelihood = 12.3 if _score_ppi_total >= 55 & _score_ppi_total <= 59
replace _150_likelihood = 6.0 if _score_ppi_total >= 60 & _score_ppi_total <= 64
replace _150_likelihood = 2.5 if _score_ppi_total >= 65 & _score_ppi_total <= 69
replace _150_likelihood = 0.8 if _score_ppi_total >= 70 & _score_ppi_total <= 74
replace _150_likelihood = 0.6 if _score_ppi_total >= 75 & _score_ppi_total <= 79
replace _150_likelihood = 0 if _score_ppi_total >= 80
replace _150_likelihood = . if _score_ppi_total==.


*** 200% of the 2009 Philippines poverty line at 47.53 pesos per day
gen _200_likelihood = .
replace _200_likelihood = 100 if _score_ppi_total <= 9
replace _200_likelihood = 99.9 if _score_ppi_total >= 10 & _score_ppi_total <= 14
replace _200_likelihood = 99.9 if _score_ppi_total >= 15 & _score_ppi_total <= 19
replace _200_likelihood = 99.4 if _score_ppi_total >= 20 & _score_ppi_total <= 24
replace _200_likelihood = 98.1 if _score_ppi_total >= 25 & _score_ppi_total <= 29
replace _200_likelihood = 95.9 if _score_ppi_total >= 30 & _score_ppi_total <= 34
replace _200_likelihood = 92.6 if _score_ppi_total >= 35 & _score_ppi_total <= 39
replace _200_likelihood = 81.5 if _score_ppi_total >= 40 & _score_ppi_total <= 44
replace _200_likelihood = 65.7 if _score_ppi_total >= 45 & _score_ppi_total <= 49
replace _200_likelihood = 51.2 if _score_ppi_total >= 50 & _score_ppi_total <= 54
replace _200_likelihood = 31.6 if _score_ppi_total >= 55 & _score_ppi_total <= 59
replace _200_likelihood = 18.2 if _score_ppi_total >= 60 & _score_ppi_total <= 64
replace _200_likelihood = 10.1 if _score_ppi_total >= 65 & _score_ppi_total <= 69
replace _200_likelihood = 3.8 if _score_ppi_total >= 70 & _score_ppi_total <= 74
replace _200_likelihood = 1.7 if _score_ppi_total >= 75 & _score_ppi_total <= 79
replace _200_likelihood = 0 if _score_ppi_total >= 80
replace _200_likelihood = . if _score_ppi_total==.

rename _190_likelihood _eed_190_likelihood
rename _310_likelihood _eed_310_likelihood
rename _100_likelihood _eed_100_likelihood
rename _150_likelihood _eed_150_likelihood
rename _200_likelihood _eed_200_likelihood

label var _eed_190_likelihood "[EED] Chance of being under 1.90 dollars a day poverty line"
label var _eed_310_likelihood "[EED] Chance of being under 3.10 dollars a day poverty line"
label var _eed_100_likelihood "[EED] Chance of being under 100% of 2009 national poverty line at P47.53/day"
label var _eed_150_likelihood "[EED] Chance of being under 150% of 2009 national poverty line at P47.53/day"
label var _eed_200_likelihood "[EED] Chance of being under 200% of 2009 national poverty line at P47.53/day"

gen _eed_100_likelihood_50 = 0
replace _eed_100_likelihood_50 = 1 if _eed_100_likelihood>50
replace _eed_100_likelihood_50 = . if _eed_100_likelihood >=.
gen _eed_150_likelihood_50 = 0
replace _eed_150_likelihood_50 = 1 if _eed_150_likelihood>50
replace _eed_150_likelihood_50 = . if _eed_150_likelihood >=.
gen _eed_200_likelihood_50 = 0
replace _eed_200_likelihood_50 = 1 if _eed_200_likelihood>50
replace _eed_200_likelihood_50 = . if _eed_200_likelihood >=.
label var _eed_100_likelihood_50 "[EED] 1/0 Over 50% chance of being under 100% of 2009 nat pov line at P47.53/day"
label var _eed_150_likelihood_50 "[EED] 1/0 Over 50% chance of being under 150% of 2009 nat pov line at P47.53/day"
label var _eed_200_likelihood_50 "[EED] 1/0 Over 50% chance of being under 200% of 2009 nat pov line at P47.53/day"




* Education expectations

clonevar _eeo_edu_highest = _edu_expect_highest
recode _eeo_edu_highest -222 = .
label var _eeo_edu_highest "[EEO] R's expected highest level of education"


clonevar _eeo_edu_job_6mo = edu_job_6mo
label var _eeo_edu_job_6mo "[EEO] How likely R thinks s/he would be employed within 6mos after graduation"

* Labor market expectations 

gen _eeo_edu_job_6mo_high = 1 if _eeo_edu_job_6mo == 4 | _eeo_edu_job_6mo == 5
replace _eeo_edu_job_6mo_high = 0 if _eeo_edu_job_6mo == 1 | _eeo_edu_job_6mo == 2 | _eeo_edu_job_6mo == 3
label var _eeo_edu_job_6mo_high "[EEO] R thinks Likely/Extremely Likely employed w/in 6mos after graduation, 1/0"

clonevar _eeo_edu_job_wage_lowest = edu_job_wage_lowest
label var _eeo_edu_job_wage_lowest "[EEO] Lowest amount of daily wage R would accept at first job after graduation" 

clonevar _eeo_edu_job_wage_expect = edu_job_wage_expect 
label var _eeo_edu_job_wage_expect "[EEO] Daily wage R expects to earn at the first job after graduation"


gen _eeo_edu_expect_highest_college = _edu_expect_highest >=4 & _edu_expect_highest != . 
replace _eeo_edu_expect_highest_college = . if _edu_expect_highest ==.	// Note that others are also omitted here.
label var _eeo_edu_expect_highest_college "[EEO] R expects to attain college or higher education level, 1/0"

***********************************************
* 	Endline outcomes 


/*Primary outcomes of interest:
 
1.	Education:
ŉShare of applicants enrolled in school
ŉShare graduated (from high school and from college)
ŉShare dropout
ŉGrade repetition
 Time to degree
ŉGrades (general weighted average).

*/ 

*	Share of applicants enrolled in school

clonevar _eeo_enroll = edu_now
label var _eeo_enroll "[EEO] R is enrolled in high school, college, or any vocational program" 

* out of school
gen _eeo_out_of_school=.
replace _eeo_out_of_school=0 if _eeo_enroll==1
replace _eeo_out_of_school=1 if _eeo_enroll==0
label var _eeo_out_of_school "[EEO] R is out of school youth, 1/0"

*ŉShare graduated (from high school and from college)

gen _eeo_grad_col = edu_no_highest_colgrad
	replace _eeo_grad_col = 0 if edu_now == 1
	replace _eeo_grad_col = 0 if edu_now == 0 & (edu_no_highest_level == 1 | edu_no_highest_level == 2 | edu_no_highest_level == 3)
	replace _eeo_grad_col = . if endline == 0 

	
gen _eeo_grad_hs = 1 if edu_level == 3 | edu_level == 4 // graduate if enrolled at vocational or college 
replace _eeo_grad_hs = 0 if (edu_level == 1 | edu_level == 2) & edu_now == 1
replace _eeo_grad_hs = 1 if edu_no_highest_level == 3 | edu_no_highest_level == 4
replace _eeo_grad_hs = 0 if edu_no_highest_hs < =3		// Finished grad 7, 8, 9
replace _eeo_grad_hs = 1 if edu_no_highest_hsgrad2 == 1			// Graduated during K10
replace _eeo_grad_hs = 0 if edu_no_highest_hsgrad2 == 2			// Finished 10, but in K12 regime 

	replace _eeo_grad_hs = . if endline == 0 

label var _eeo_grad_col "[EEO] R is college graduate, 1/0"
label var _eeo_grad_hs "[EEO] R is high-school graduate, 1/0"


* Share graduated or expect to graduate at end of the year 

gen _eeo_expect_grad_col = _eeo_grad_col
	replace _eeo_expect_grad_col = 1 if edu_level == 4 & edu_grad_yyyy == 1
	
gen _eeo_expect_grad_hs = _eeo_grad_hs 
	replace _eeo_expect_grad_hs = 1 if (edu_level == 1 | edu_level == 2) & edu_grad_yyyy == 1
	
label var _eeo_expect_grad_col "[EEO] R expects to finish college by 2017, 1/0"
label var _eeo_expect_grad_hs "[EEO] R expects to finish high school by 2017, 1/0"

* Share enrolling next year 

clonevar _eeo_enroll_nextyr = edu_nextyr
label var _eeo_enroll_nextyr "[EEO] R intends to enroll in high school, college, or vocational training"


** Schooltype
clonevar _eeo_edu_schooltype = _edu_schooltype
gen _eeo_edu_schtype_priv = _eeo_edu_schooltype == 2
replace _eeo_edu_schtype_priv = . if _eeo_edu_schooltype >=.

label var _eeo_edu_schooltype "[EEO] R's school is public, private, semi-private"
label var _eeo_edu_schtype_priv "[EEO] R attends a private school"


** Tuition fee
clonevar _eeo_edu_tuition = edu_tuition
clonevar _eeo_tuition_paid = edu_tuition_paid
replace _eeo_tuition_paid = _eeo_edu_tuition if _eeo_tuition_paid > _eeo_edu_tuition

label var _eeo_edu_tuition "[EEO] Tuition fee at R's school"
label var _eeo_tuition_paid "[EEO] Amount of tuition spent out of pocket by R and R's parents/siblings"

clonevar _eeo_famassit = edu_tuition_assist
clonevar _eeo_famassist_amt = edu_tuition_assist_amt
clonevar _eeo_tuition_scholarship = edu_tuition_scholar
gen _eeo_tuit_scholar_total = edu_tuition_scholar_amt1 + edu_tuition_scholar_amt2

label var _eeo_famassit "[EEO] R receives assistance from family besides parents/siblings"
label var _eeo_famassist_amt "[EEO] R's amount of assistance from family besides parents/siblings"
label var _eeo_tuition_scholarship "[EEO] Not including SPES or 4Ps, R receives scholarships/stipends for tuition"
label var _eeo_tuit_scholar_total "[EEO] R's total amount of scholarships"


* Grades

* Clean GWA 

recode edu_gwa .99 = .d
recode edu_gwa .97 = .r 
recode edu_gwa 175 = 1.75 		// verified by listening to ACR 

* Clear-cut cases 
gen scale_0_100 = edu_gwa if edu_gwa_scale5 == 0 & edu_gwa >=50 & edu_gwa <=100 
gen scale_1_5 = edu_gwa if edu_gwa_scale5 == 1 & edu_gwa >=1 & edu_gwa <=5 

* Use estimates when necessary 
replace scale_0_100 = edu_gwa_estimate if edu_gwa_scale5 == 0 & edu_gwa_estimate >=50 & edu_gwa_estimate <=100 & scale_0_100 == . 
replace scale_1_5 = edu_gwa_estimate if edu_gwa_scale5 == 1 & edu_gwa_estimate >=1 & edu_gwa_estimate <=5 & scale_1_5 == . 

* Assume that if reported as 50-100, that we should use the 50-100 
replace scale_0_100 = edu_gwa if  edu_gwa >=50 & edu_gwa <=100 


count  if scale_0 == . & scale_1 == . & edu_gwa <.		// 29 observations

* Assum e if all missing, that meant to code to approrpate scale 

replace scale_1_5 = edu_gwa if edu_gwa_scale5 == . & scale_0_100 == . & edu_gwa >=1 & edu_gwa <=5 & edu_gwa_scale  == . & edu_gwa_best == . 


* Case by case based on ACR 

replace scale_0_100 = 80 if respondent_id == "R01140445" 		//ACR: grading scale = 1-10; best = 10; gwa = 80% (R said the equivalent of 80% is '7')
replace scale_0_100 = 90.1 if respondent_id == "R11130311" 		//ACR: grading scale = 1-7; best = 1.0; gwa = 2.0 (90.1%))


* Convert those on a 0-4 GPA scale to a 0-100 scale <-- no, because a 2.0 GPA != 50% 

*replace scale_0_100 = edu_gwa/edu_gwa_scale if edu_gwa_scale == 4 & edu_gwa_best ==4 & edu_gwa <=4

count  if scale_0 == . & scale_1 == . & edu_gwa <.		// 29 observations

label var scale_1_5 "[EL] R's reported GWA using 1-5 scale (1 highest, 5 lowest)"
label var scale_0_100 "[EL] R's reported GWA using 0-100 scale (100 highest, 0 lowest)"


* Determine relevant education level 

gen _NT_edu = edu_level
replace _NT_edu = edu_no_highest_level if edu_level == .

* Recode to binary
recode _NT_edu (1 2 = 0) (3 4 = 1)

label var _NT_edu "High school or college, 1/0"

** One variable for education level

gen _eeo_edu_year = .
replace _eeo_edu_year = 1 if edu_hs==2
replace _eeo_edu_year = 2 if edu_hs==3
replace _eeo_edu_year = 3 if edu_hs==4
replace _eeo_edu_year = 4 if edu_hs==5
replace _eeo_edu_year = 5 if edu_hs==6
replace _eeo_edu_year = 6 if edu_col==1
replace _eeo_edu_year = 7 if edu_col==2
replace _eeo_edu_year = 8 if edu_col==3
replace _eeo_edu_year = 9 if edu_col==4
replace _eeo_edu_year = 10 if edu_col==5
replace _eeo_edu_year = 11 if _eeo_enroll==0
replace _eeo_edu_year = . if edu_hs==. & edu_col==. & _eeo_enroll==.

label var _eeo_edu_year "[EEO] Current education level and year"



* Reasons not enrolled in school 
* Note that 241 not enrolled. 

** Recode the reasons no
/*
0	Completed studies
1	Could not afford to continue
2	Needed to care for family
3	Difficult to commute
4	Hard to meet requirements/pass classes
5	Already working
6	Board Exam
7	OJT
8	Chaging course
9	Looking for work
11 	No longer want to study
12  pregnant
-222	Other, specify
-98	Refused
-97	Not applicable
*/ 

/* First code directly */ 
drop _edu_no_why*
forval i = 0/5{
gen temp_edu_no_why_`i' = regex(edu_no_why,"`i'") 
replace temp_edu_no_why_`i' = . if edu_no_why == ""
}
replace temp_edu_no_why_2 = 0 if regex(edu_no_why,"-222")	// no 2 -222 options


 forval i = 8/12{
 gen temp_edu_no_why_`i' = 0 if edu_no_why != ""
 } 
 
 gen temp_edu_no_why_222 = regex(edu_no_why,"-222")
replace temp_edu_no_why_222 = . if edu_no_why == ""

 /* Recode the others */ 
 
 
  
list edu_no_why temp_edu_no_why_1 temp_edu_no_why_222 edu_no_why_other if regexm(edu_no_why_other, "give way")==1 | regexm(edu_no_why_other, "financial")==1 | regexm(edu_no_why_other, "payment")==1 | regexm(edu_no_why_other, "ulila")==1
replace temp_edu_no_why_1=1 if regexm(edu_no_why_other, "give way")==1 | regexm(edu_no_why_other, "financial")==1 | regexm(edu_no_why_other, "payment")==1 | regexm(edu_no_why_other, "ulila")==1
replace temp_edu_no_why_222 = 0 if regexm(edu_no_why_other, "give way")==1 | regexm(edu_no_why_other, "financial")==1 | regexm(edu_no_why_other, "payment")==1 | regexm(edu_no_why_other, "ulila")==1


list edu_no_why temp_edu_no_why_2 temp_edu_no_why_222 edu_no_why_other if regexm(edu_no_why_other, "family")==1 | regexm(edu_no_why_other, "care")==1 | regexm(edu_no_why_other, "father")==1 | regexm(edu_no_why_other, "married")==1
 replace temp_edu_no_why_2 = 1 if regexm(edu_no_why_other, "family")==1 | regexm(edu_no_why_other, "care")==1 | regexm(edu_no_why_other, "father")==1 | regexm(edu_no_why_other, "married")==1
 replace temp_edu_no_why_222 = 0 if regexm(edu_no_why_other, "family")==1 | regexm(edu_no_why_other, "care")==1 | regexm(edu_no_why_other, "father")==1 | regexm(edu_no_why_other, "married")==1

 
list edu_no_why temp_edu_no_why_4 temp_edu_no_why_222 edu_no_why_other if regexm(edu_no_why_other, "late")==1 | regexm(edu_no_why_other, "failed")==1 | regexm(edu_no_why_other, "requirements")==1 | regexm(edu_no_why_other, "expelled")==1 | regexm(edu_no_why_other, "dean")==1 | regexm(edu_no_why_other, "back subject")==1 
replace temp_edu_no_why_4=1 if regexm(edu_no_why_other, "late")==1 | regexm(edu_no_why_other, "failed")==1 | regexm(edu_no_why_other, "requirements")==1 | regexm(edu_no_why_other, "expelled")==1 | regexm(edu_no_why_other, "dean")==1 | regexm(edu_no_why_other, "back subject")==1 
replace temp_edu_no_why_222=0 if regexm(edu_no_why_other, "late")==1 | regexm(edu_no_why_other, "failed")==1 | regexm(edu_no_why_other, "requirements")==1 | regexm(edu_no_why_other, "expelled")==1 | regexm(edu_no_why_other, "dean")==1 | regexm(edu_no_why_other, "back subject")==1 


list edu_no_why temp_edu_no_why_1 temp_edu_no_why_5 temp_edu_no_why_222 edu_no_why_other if edu_no_why_other=="currently working"
replace temp_edu_no_why_5=1 if edu_no_why_other=="currently working"
replace temp_edu_no_why_222=0 if edu_no_why_other=="currently working"


list edu_no_why temp_edu_no_why_5 temp_edu_no_why_5 temp_edu_no_why_222 edu_no_why_other if regexm(edu_no_why_other, "job")==1 
replace temp_edu_no_why_5=1 if regexm(edu_no_why_other, "job")==1 
replace temp_edu_no_why_222 = 0 if regexm(edu_no_why_other, "job")==1 




list edu_no_why temp_edu_no_why_8 temp_edu_no_why_5 temp_edu_no_why_222 edu_no_why_other if regexm(edu_no_why_other, "transfer")==1 | regexm(edu_no_why_other, "shift")==1 | regexm(edu_no_why_other, "chang")==1 | regexm(edu_no_why_other, "london")==1
replace temp_edu_no_why_8=1 if regexm(edu_no_why_other, "transfer")==1 | regexm(edu_no_why_other, "shift")==1 | regexm(edu_no_why_other, "chang")==1 | regexm(edu_no_why_other, "london")==1
replace temp_edu_no_why_222 = 0 if regexm(edu_no_why_other, "transfer")==1 | regexm(edu_no_why_other, "shift")==1 | regexm(edu_no_why_other, "chang")==1 | regexm(edu_no_why_other, "london")==1



list edu_no_why temp_edu_no_why_9 temp_edu_no_why_5 temp_edu_no_why_222 edu_no_why_other if regexm(edu_no_why_other, "not interested")==1 | regexm(edu_no_why_other, "don't like")==1 | regexm(edu_no_why_other, "lazy")==1 | regexm(edu_no_why_other, "personal")==1
replace temp_edu_no_why_11=1 if regexm(edu_no_why_other, "not interested")==1  | regexm(edu_no_why_other, "lazy")==1 | regexm(edu_no_why_other, "personal")==1 | regexm(edu_no_why_other, "dont like")==1
replace temp_edu_no_why_222 = 0  if regexm(edu_no_why_other, "not interested")==1 | regexm(edu_no_why_other, "lazy")==1 | regexm(edu_no_why_other, "personal")==1 | regexm(edu_no_why_other, "dont like")==1




list edu_no_why  temp_edu_no_why_222 edu_no_why_other if regexm(edu_no_why_other, "pregna")==1| regexm(edu_no_why_other, "delivered")==1
replace temp_edu_no_why_12 = 1 if regexm(edu_no_why_other, "pregna")==1| regexm(edu_no_why_other, "delivered")==1
replace temp_edu_no_why_222 = 0 if regexm(edu_no_why_other, "pregna")==1| regexm(edu_no_why_other, "delivered")==1



gen temp_edu_no_why_other = edu_no_why_other 
replace temp_edu_no_why_other="" if temp_edu_no_why_222==0

rename temp_edu_no_why* _edu_no_why*

label var _edu_no_why_0 "[Recoded] Why not enrolled: Completed studies" 
label var _edu_no_why_1 "[Recoded] Why not enrolled: Financial problems" 
label var _edu_no_why_2 "[Recoded] Why not enrolled: Care for family" 
label var _edu_no_why_3 "[Recoded] Why not enrolled: Difficult to commute"
label var _edu_no_why_4 "[Recoded] Why not enrolled: Hard to meet requirements/pass classes"
label var _edu_no_why_5 "[Recoded] Why not enrolled: Already working/looking for work"
label var _edu_no_why_8 "[Recoded] Why not enrolled: Changing course"
label var _edu_no_why_11 "[Recoded] Why not enrolled: No longer want to study"
label var _edu_no_why_12 "[Recoded] Why not enrolled: Pregnant"

label var _edu_no_why_222 "[Recoded] Why not enrolled: Other"
label var _edu_no_why_other "[Recoded] Why not enrolled: Specifed other" 

drop _edu_no_why_9 _edu_no_why_10 
order _edu_no_why_0 _edu_no_why_1 _edu_no_why_2 _edu_no_why_3 _edu_no_why_4 _edu_no_why_5 _edu_no_why_8 _edu_no_why_11 _edu_no_why_12 _edu_no_why_222 _edu_no_why_other, after(edu_nextyr_no_why_other)



* One variable for completed education 

gen _eeo_edu_complete_year = _eeo_edu_year - 1 if _eeo_edu_year > 1 & _eeo_edu_year != 11

* Merge to grade 9 or less 
replace _eeo_edu_complete_year = 2 if _eeo_edu_year == 2 	| _eeo_edu_year == 1  // Currently in grade 8 | 9
replace _eeo_edu_complete_year = 2 if _eeo_edu_year == 11 & (edu_no_highest_hs <= 3) // last finished grade 7, 8, or 9

* Merge to grade 10 (or higher) 
replace _eeo_edu_complete_year = 3 if _eeo_edu_year == 6 | _eeo_edu_year ==  5	// bump to grade 10 if in year 1 college, grade 12
replace _eeo_edu_complete_year = 3 if _eeo_edu_year == 11 & (edu_no_highest_hs == 4) // OSY, last finished grade 10
replace _eeo_edu_complete_year = 3 if _eeo_edu_year == 11 & (edu_no_highest_hs == 5) // OSY, last finished grade 11
replace _eeo_edu_complete_year = 3 if edu_now == 1 &  edu_level == 3 & edu_tvet_no == 1  //Enrolled in vocatoinal, 1st course


* Make graduated college category (9), otherwise shift to 8 
replace _eeo_edu_complete_year = 8 if _eeo_edu_year == 10 // enrolled in year 5 college 
replace _eeo_edu_complete_year = 8 if _eeo_edu_year == 11 & _eeo_grad_col == 0 & edu_no_highest_col >=3 & edu_no_highest_col != . // enrolled in year 5 college 
replace _eeo_edu_complete_year = 9 if _eeo_grad_col == 1 // graduated college 

* Assign for out of school 

replace _eeo_edu_complete_year = 6 if _eeo_edu_year == 11 & (edu_no_highest_col == 1)   // Finished year 1
replace _eeo_edu_complete_year = 7 if _eeo_edu_year == 11 & (edu_no_highest_col == 2)


* TVET 
replace _eeo_edu_complete_year = 12 if edu_tvet_completed == 1 & _eeo_edu_year == 11
replace _eeo_edu_complete_year = 12 if edu_tvet_no >=2 & edu_tvet_no <=4 & edu_now == 1


#delimit ;
label define _eeo_edu_year
		1	"High school, Grade 8 or less"
		2	"High school, Grade 9"
		3	"High school, Grade 10"
		4   "High school, Grade 11"
		5	"High school, Grade 12"
		6	"College, 1st year"
		7	"College, 2nd year"
		8	"College, 3rd year"
		9	"College, 4th year"
		10	"College, 5th year"
		11	"Not currently enrolled"
		12	"TVET, graduated"
;

	#delimit ;
label define _eeo_edu_year2
		2	"High school, Grade 9 or less"
		3	"High school, Grade 10 or higher"
		6	"College, 1st year"
		7	"College, 2nd year"
		8	"College, 3rd year or higher"
		9	"College, graduated"
		12	"TVET, graduated"
;
#delimit cr

* Note that for _eeo_edu_year2, currently enrolled in grade 12 coded as in grade 10 

 label var _eeo_edu_complete_year "[EEO] Highest education level and year completed"

label values _eeo_edu_year _eeo_edu_year
label values _eeo_edu_complete_year _eeo_edu_year2

tabstat _eeo_enroll if randomization == 1 & endline == 1,by(_eeo_edu_complete_year) stat(mean sum count)
tabstat _eeo_enroll if randomization == 1 & endline == 1 & treatment == 0,by(_eeo_edu_complete_year) stat(mean sum count)
tabstat _eeo_enroll if randomization == 1 & endline == 1 & treatment == 1,by(_eeo_edu_complete_year) stat(mean sum count)

* Make direction the samel for 1-5 scale 

replace scale_1_5 = 6 - scale_1_5
replace scale_1_5 = 6 - scale_1_5
replace scale_1_5 = 6 - scale_1_5

* Normalize by scale and education level 

egen z_mean = mean(scale_0_100) if scale_0_100 != . & treatment == 0 ,by(_NT_edu) 
egen _z_mean = max(z_mean) if scale_0_100 != . ,by(_NT_edu)
egen z_sd = sd(scale_0_100) if scale_0_100 != . & treatment == 0  ,by(_NT_edu)
egen _z_sd = max(z_sd) if scale_0_100 != . ,by(_NT_edu)

egen z_mean15 = mean(scale_1_5) if scale_1_5 != . & treatment == 0 ,by(_NT_edu) 
egen _z_mean15 = max(z_mean15) if scale_1_5 != . ,by(_NT_edu)

egen z_sd15 = sd(scale_1_5) if scale_1_5 != . & treatment == 0  ,by(_NT_edu)
egen _z_sd15 = max(z_sd15) if scale_1_5 != . ,by(_NT_edu)

gen _eeo_gwa_norm = (scale_0_100 - _z_mean) / _z_sd if scale_0_100 != . 
replace _eeo_gwa_norm = (scale_1_5 - _z_mean15) / _z_sd15 if scale_1_5 != . 

drop z_mean* z_sd* 

label var _eeo_gwa_norm "[EEO] Grade weigthed average normalized by scale and education level"



*2.	Employment:

*Share currently employed private employer, government, ngo 

clonevar _eeo_worknow = work_now 

label var _eeo_worknow "[EEO] R currently employed by private employer, government, ngo"


* Share who worked over summer, besides SPES 

clonevar _eeo_worksummer_any = work_summer
label var _eeo_worksummer_any "[EEO] R worked summer, formal or informal (excl. unpaid)"	


* Share who worked over summer, formal, besides SPES 

gen _eeo_worksummer_formal = 1 if (work_summer_formal  == "1" | work_summer_formal == "2" | work_summer_formal == "3")
	replace _eeo_worksummer_formal  = 0 if work_summer == 0 
	replace _eeo_worksummer_formal  = 0 if work_summer_formal == "0" 
	
label var _eeo_worksummer_formal "[EEO] R worked summer, formal"	

* Share who worked over summer, informal
gen _eeo_worksummer_informal = 1 if work_summer_informal !=""
	replace _eeo_worksummer_informal  = 0 if work_summer == 0 
	replace _eeo_worksummer_informal  = 0 if work_summer_informal == "0"
	replace _eeo_worksummer_informal = 1 if work_summer_unpaid == 1
	
	label var _eeo_worksummer_informal "[EEO] R worked summer, informal or unpaid"	

	
* Share who worked July - Dec 2016, excluding summer/SPES 

clonevar _eeo_workjuldec_any = work_other
label var _eeo_workjuldec_any "[EEO] R worked Jul-Dec 2016, formal or informal (excl. unpaid)"	

* Share who worked over July - Dec 2016,, formal, besides SPES 

gen _eeo_workjuldec_formal = 1 if (work_other_formal  == "1" | work_other_formal == "2" | work_other_formal == "3")
	replace _eeo_workjuldec_formal  = 0 if work_other == 0 
	replace _eeo_workjuldec_formal  = 0 if work_other_formal == "0" 
	label var _eeo_workjuldec_formal "[EEO] R worked Jul-Dec 2016, formal"

	
* Share who worked over July - Dec 2016,, informal/unpaid
gen _eeo_workjuldec_informal = 1 if work_other_informal !=""
	replace _eeo_workjuldec_informal  = 0 if work_other == 0 
	replace _eeo_workjuldec_informal  = 0 if work_other_informal == "0" | work_other_informal =="-98"
	replace _eeo_workjuldec_informal = 1 if work_other_unpaid == 1
	label var _eeo_workjuldec_informal "[EEO] R worked Jul-Dec 2016, informal/unpaid"

* Share any work 

gen _eeo_work2016_any = _eeo_workjuldec_any  | _eeo_worksummer_any
replace _eeo_work2016_any = . if  _eeo_workjuldec_any ==. & _eeo_worksummer_any ==.

gen _eeo_work2016_formal = _eeo_workjuldec_formal | _eeo_worksummer_formal
replace _eeo_work2016_formal = . if  _eeo_workjuldec_formal ==. & _eeo_worksummer_formal ==.

gen _eeo_work2016_informal = _eeo_workjuldec_informal | _eeo_worksummer_informal
replace _eeo_work2016_informal = . if  _eeo_workjuldec_informal ==. & _eeo_worksummer_informal ==.

label var _eeo_work2016_any "[EEO] R worked summer or Jul-Dec 2016, formal/informal"
label var _eeo_work2016_formal "[EEO] R worked summer or Jul-Dec 2016, formal"
label var _eeo_work2016_informal "[EEO] R worked summer or Jul-Dec 2016, informal/unpaid"


*ŉShare currently looking for work
clonevar _eeo_jobsearch = jobsearch

label var _eeo_jobsearch "[EEO] R has looked for employment since June 2016"
 

*ŉDuration of job search, conditional on working now  (in days)

gen _eeo_jobsearch_duration = . 
	replace _eeo_jobsearch_duration = work_now_search_nu if work_now_search_days == 1 	// If reported in days 
	replace _eeo_jobsearch_duration = work_now_search_nu*7 if work_now_search_days == 2 	// If reported in weeks 
	replace _eeo_jobsearch_duration = work_now_search_nu*30 if work_now_search_days == 3 	// If reported in months 
	replace _eeo_jobsearch_duration = work_now_search_nu*365 if work_now_search_days == 3 	// If reported in years
	replace _eeo_jobsearch_duration = 1095 if _eeo_jobsearch_duration > 1095 & _eeo_jobsearch_duration !=.
	sum _eeo_jobsearch_duration		// Watch out for outliers!
	
label var _eeo_jobsearch_duration "[EEO] Duration in days of R job search, conditional on working now"

*** Type of SPES employer
gen _eeo_spes_privemp = spes_employer == 2
	replace _eeo_spes_privemp = . if spes_employer == . 
	
label var _eeo_spes_privemp "[EEO] R 2016 SPES employer is private, 1/0"

** Private/public PESO

bysort id_peso: egen _eeo_spes_empl_mean = mean(_eeo_spes_privemp)
assert _eeo_spes_empl_mean != . if randomization == 1 & endline == 1

gen _eeo_private = .
replace _eeo_private = 0 if _eeo_spes_empl_mean !=. & endline == 1
replace _eeo_private = 1 if _eeo_spes_empl_mean > 0.75  & endline == 1 

label var _eeo_private "[EEO]Share of Rs with 2016 SPES employer private or public, 1/0" 
 

/*  Secondary outcomes of interest:
 
3.	Income:
SPES earnings
*/ 
*Self-reported individual income.

clonevar _eeo_wage_monthly_now = work_now_wage_monthly
label var _eeo_wage_monthly_now "[EEO] Self-reported monthly individual income"

gen _eeo_faminc = 0
qui sum _score_ppi_total, detail
replace _eeo_faminc = 1 if _score_ppi_total > r(p50)
replace _eeo_faminc = . if _score_ppi_total >= . 

label var _eeo_faminc "[EEO] R PPI score in top 50 percentile"

*4.	Consumption:
*Education spending
clonevar _eeo_edu_spending = edu_expenses_total
label var _eeo_edu_spending "[EEO] R's estimated out of pocket spending on other edu expenses for SY2016-2017"
*make note -books/uniforms/fees/supplies/allowance-

egen _eeo_edu_spending2 = rowtotal(edu_expenses_book edu_expenses_uniform edu_expenses_fee edu_expenses_supply edu_expenses_allowance edu_expenses_other)
replace _eeo_edu_spending = _eeo_edu_spending2 if _eeo_edu_spending == .
replace _eeo_edu_spending= . if edu_expenses_total == . & _eeo_edu_spending2 == 0
drop _eeo_edu_spending2

*Non-education spending.

** No var 


*5.	Employability:

* Work tasks 

ds tasks* 
gen _eeo_task_sum = 0 if endline
foreach task in `r(varlist)' {
gen _high_`task' = 1 if `task' == 3 | `task' == 4
replace _high_`task' = 0 if `task' == 1 | `task' == 2 
replace _eeo_task_sum = _eeo_task_sum + _high_`task'
}

label var _eeo_task_sum "[EEO] Sum of R's work tasks score, using high or low scores"
 
label var _high_tasks_word "[EEO] R's experience with MS word high or low, 1/0"
label var _high_tasks_encode "[EEO] R's experience with encoding high or low, 1/0"
label var _high_tasks_excel "[EEO] R's experience with MS excel high or low, 1/0"
label var _high_tasks_ppt "[EEO] R's experience with MS powerpoint high or low, 1/0"
label var _high_tasks_photocopy "[EEO] R's experience with photocopying high or low, 1/0"
label var _high_tasks_scan "[EEO] R's experience with scanning high or low, 1/0"
label var _high_tasks_sort "[EEO] R's experience with sorting/organizing high or low, 1/0"
label var _high_tasks_phone "[EEO] R's experience with answering phones high or low, 1/0"
label var _high_tasks_bookkeeping "[EEO] R's experience with bookkeeping high or low, 1/0"
label var _high_tasks_onlinesearch "[EEO] R's experience with online searches high or low, 1/0"
label var _high_tasks_email "[EEO] R's experience with email high or low, 1/0"



***** INDICES *****


** Self-esteem index

* fix reverse coding 

local selfesteem "dothingswell proud respect satisfied worth"
foreach var in `selfesteem' {

	gen _se_`var' = selfesteem_`var'
	recode _se_`var' (.b .r .n = .)
	assert _se_`var' > 0 
	
	* Fix reverse coding  coding
	if "`var'" == "dothingswell" |"`var'" == "proud" {
	replace _se_`var' = 6 - _se_`var'
	}
	
	gen z_`var' = .
	qui summ _se_`var' if treatment==0
	replace z_`var' = (_se_`var'-r(mean))/r(sd)
}
egen _eeo_selfesteem_index = rowmean(z_*)
qui summ _eeo_selfesteem_index if treatment == 0 
replace _eeo_selfesteem_index = (_eeo_selfesteem_index - r(mean))/r(sd)



sum _eeo_selfesteem_index
label var _eeo_selfesteem_index "[EEO] Self-esteem index (sd from ctrl mean)"
drop z_* _se_*

** Hard tasks index
local tasks "word encode excel ppt photocopy scan sort phone bookkeeping onlinesearch email"
foreach var in `tasks' {
	gen _inta_`var' = tasks_`var'
	recode _inta_`var' (.b .r .n = .)
	assert _inta_`var' > 0
	
	gen z_`var' = .
	qui summ _inta_`var' if treatment==0
	replace z_`var' = (_inta_`var'-r(mean))/r(sd)
}
egen _eeo_hardtasks_index = rowmean(z_*)
qui summ _eeo_hardtasks_index if treatment == 0 
replace _eeo_hardtasks_index = (_eeo_hardtasks_index - r(mean))/r(sd)

label var _eeo_hardtasks_index "[EEO] Hard tasks index (sd from ctrl mean)"
drop z_* _inta_*

*** Life skills index
local skills "time communicate listen budget save attire determination"
foreach var in `skills' {
	gen _inli_`var' = lifeskills_`var'
	recode _inli_`var' (.b .r .n = .)
	assert _inli_`var' > 0
	
	gen z_`var' = .
	qui summ _inli_`var' if treatment==0
	replace z_`var' = (_inli_`var'-r(mean))/r(sd)
}
egen _eeo_lifeskills_index = rowmean(z_*)
qui summ _eeo_lifeskills_index if treatment == 0 
replace _eeo_lifeskills_index = (_eeo_lifeskills_index - r(mean))/r(sd)

label var _eeo_lifeskills_index "[EEO] Life skills index (sd from ctrl mean)"
drop z_* _inli_*	


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
	
	gen z_`var' = .
	qui summ _incps_`var' if treatment==0
	replace z_`var' = (_incps_`var'-r(mean))/r(sd)
}
egen _eeo_cps_index = rowmean(z_*)
qui summ _eeo_cps_index if treatment == 0 
replace _eeo_cps_index = (_eeo_cps_index - r(mean))/r(sd)

label var _eeo_cps_index "[EEO] CPS index (sd from ctrl mean)"
drop z_* _incps_*	

*Labor market perception 


** Satisfaction rates, binary
gen _eeo_spes_satisf_overall_high = .
replace _eeo_spes_satisf_overall_high = 0 if spes_satisfaction_overall!=.
replace _eeo_spes_satisf_overall_high = 1 if spes_satisfaction_overall == 4 | spes_satisfaction_overall == 5
label var _eeo_spes_satisf_overall_high "[EEO] High overall satisfaction level with SPES, 1/0"

gen _eeo_spes_satisf_empl_high = .
replace _eeo_spes_satisf_empl_high = 0 if spes_satisfaction_employment!=.
replace _eeo_spes_satisf_empl_high = 1 if spes_satisfaction_employment == 4 | spes_satisfaction_employment == 5
label var _eeo_spes_satisf_empl_high "[EEO] High satisfaction level with type of employment/tasks, 1/0"

gen _eeo_spes_satisf_peso_high = .
replace _eeo_spes_satisf_peso_high = 0 if spes_satisfaction_peso!=.
replace _eeo_spes_satisf_peso_high = 1 if spes_satisfaction_peso == 4 | spes_satisfaction_peso == 5
label var _eeo_spes_satisf_peso_high "[EEO] High satisfaction level with service of PESO, 1/0"



*********	* Other

* Other employment assistance
gen _eeo_assistancework = 1 if assistance_work == "1" | assistance_work == "2"
replace _eeo_assistancework = 0 if assistance_work == "4"
label var _eeo_assistancework "[EEO] R received any other employment assistance, 2016" 

* SPES beneficiary in 2016
clonevar _eeo_spes2016 = spes_2016
label var _eeo_spes2016 "[EEO] R was SPES beneficiary in 2016"

* # times participated in spes 

clonevar _eeo_spesno_2016 = spes_notimes 
replace _eeo_spesno_2016 = . if _eeo_spesno_2016 > 3
label var _eeo_spesno_2016 "[EEO] Number of times R was SPES beneficiary in 2016"

* SPES beneficiary before 2016
clonevar _eeo_spes_before = spes_before
label var _eeo_spes_before "[EEO] R was SPES beneficiary before 2016"

** year first enrolled in spes
clonevar _eeo_spes_firstenrolled = spes_1styr
replace _eeo_spes_firstenrolled = "" if spes_1styr == "2016"
replace _eeo_spes_firstenrolled = "2016" if _eeo_spes2016 == 1 & _eeo_spes_before == 0
replace _eeo_spes_firstenrolled = "Never" if _eeo_spes2016 == 0 & _eeo_spes_before == 0
replace _eeo_spes_firstenrolled = "2012 and earlier" if _eeo_spes_firstenrolled == "2012" | _eeo_spes_firstenrolled == "2011" | _eeo_spes_firstenrolled == "2010" | _eeo_spes_firstenrolled == "2009" | _eeo_spes_firstenrolled == "2008"
label var _eeo_spes_firstenrolled "[EEO] Year R first became SPES beneficiary"

* Apply for SPES 2017 

clonevar _eeo_spes2017 = spes_2017
label var _eeo_spes2017 "[EEO] R intends to apply for SPES in 2017"


* Voting 

clonevar _eeo_voting = additional_vote
label var _eeo_voting "[EEO] R voted in May 2016 election"



tempfile t0
save `t0',replace
 
* Save file for baseline (without flags) 

keep  baseline respondent_id region id_peso endline_contact endline scell randomization treatment baseline _bb* _bd* bsl_reg3 bsl_reg6 bsl_reg7 bsl_reg11 bsl_regNCR
qui compress
saveold "$usedata_analysis/surveydata_for_balance.dta", replace 



***********************************************************
*	Generate missing flags for baseline covariates * 
***********************************************************

use `t0',clear 

ds _bb* _bd*
foreach var in `r(varlist)'{

gen _f`var' = `var' >= . 
recode `var' . = 0 if _f`var' == 1
recode `var' .b = 0 if _f`var' == 1
} 



 
 
order baseline respondent_id region id_peso endline_contact endline scell randomization treatment baseline _bb* _bd* _eed* _eeo* _f_b*
qui compress
saveold "$usedata_analysis/surveydata_full_clean.dta", replace 

