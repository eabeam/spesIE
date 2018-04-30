/* Additional figures (incorporate later ) */ 


use "$usedata_analysis/surveydata_full_clean.dta", clear 



* Age
graph twoway histogram _bb_age if _bb_age > 0 & _bb_age <=25 , color( "71 159 218") lcolor(black) percent discrete xtitle("Age") ytitle("Percent of respondents") xlabel(15(1)25) gap(30)
	graph export "$figures/_bb_age.png",replace


*School type 

replace _eeo_edu_schooltype = 2 if _eeo_edu_schooltype == 4	// Replace state/interanational as private
graph twoway histogram _eeo_edu_schooltype , color( "71 159 218")discrete percent xtitle("") ytitle("Percent of respondents") color( "71 159 218") lcolor(black) xlabel(1 "Public" 2 "Private" 3 "Semi-private")  gap(50)
	graph export "$figures/_schooltype.png",replace



* Education tracks 
*Grade level 
gen edu_year_graph  = 1 if _eeo_edu_year >=1 & _eeo_edu_year <=3 
replace edu_year_graph = 2 if _eeo_edu_year == 4 | _eeo_edu_year == 5
replace edu_year_graph = 3 if _eeo_edu_year == 6
replace edu_year_graph = 4 if _eeo_edu_year == 7
replace edu_year_graph = 5 if _eeo_edu_year == 8 
replace edu_year_graph = 6 if _eeo_edu_year == 9 | _eeo_edu_year == 10 
replace edu_year_graph = 7 if _eeo_edu_year == 11

label def yeargraph 1 "Grade 10 or less"  2 "Grade 11"  3 "College, Year 1"  4 "College, Year 2"  5 "College, Year 3" 6 "College, Year 4+" 7 "Not enrolled"
label val edu_year_graph yeargraph 

* Generate condensed categories 

graph twoway histogram edu_year_graph , color( "71 159 218")discrete percent xtitle("") ytitle("Percent of respondents") color( "71 159 218") lcolor(black)   gap(50) xlabel( 1 "Grade 10 or less"  2 "Grade 11"  3 "College, Year 1"  4 "College, Year 2"  5 "College, Year 3" 6 "College, Year 4+" 7 "Not enrolled",angle( stdarrow ) labsize(small))
	graph export "$figures/_eduyear.png",replace


* Grade completed 




* Educatoin tracks 

graph twoway histogram edu_hs_track1 if edu_hs_track1 <=2 , color( "71 159 218") discrete percent xtitle("") ytitle("Percent of respondents") color( "71 159 218") lcolor(black) gap(50) xlabel(1 "Academic" 2 "TVET")
	graph export "$figures/_srhigh_track.png",replace


	

replace _eeo_edu_tuition = 40000 if _eeo_edu_tuition > 40000 & _eeo_edu_tuition != . 


* Make discrete 

graph twoway histogram _eeo_edu_tuition if _eeo_edu_tuition < 50000 & edu_level == 1,color( "71 159 218") lcolor(black) percent ylabel(0(10)60) yscale(r(0(10)60)) width(2500) xtitle("Pesos") ytitle("Percent of respondents")
	graph export "$figures/_eeo_edu_tuition_HS.png",replace
graph twoway histogram _eeo_edu_tuition if _eeo_edu_tuition < 50000 & edu_level == 4,color( "71 159 218") lcolor(black) percent ylabel(0(10)60)  yscale(r(0(10)60)) width(2500) xtitle("Pesos") ytitle("Percent of respondents")
	graph export "$figures/_eeo_edu_tuition_COL.png",replace


	
	sum _eeo_edu_spending if edu_level == 1,d
	sum _eeo_edu_spending if edu_level == 4,d

replace _eeo_edu_spending = 40000 if _eeo_edu_spending > 40000 & _eeo_edu_tuition != . 

graph twoway histogram _eeo_edu_spending if _eeo_edu_tuition < 50000 & edu_level == 1 ,color( "71 159 218") lcolor(black) percent ylabel(0(10)30) yscale(r(0(10)30)) width(5000) xtitle("Pesos") ytitle("Percent of respondents")
	graph export "$figures/_eeo_edu_spending_HS.png",replace

	
	
graph twoway histogram _eeo_edu_spending if _eeo_edu_tuition < 50000 & edu_level == 4,color( "71 159 218")  lcolor(black) percent ylabel(0(10)30) yscale(r(0(10)30)) width(5000) xtitle("Pesos") ytitle("Percent of respondents")
	graph export "$figures/_eeo_edu_spending_COL.png",replace
	
	
tab edu_tuition_assist
areg edu_tuition_assist treatment $cov1 if _bb_edulvl == 1,absorb(scell) r

* Scholarships 
tabstat edu_tuition_scholar if endline == 1 ,by(edu_level)   // 53%    - 50% HS, 56% college 

gen _eeo_edu_scholar = edu_tuition_scholar_amt1 + edu_tuition_scholar_amt2
	replace _eeo_edu_scholar = 50000 if _eeo_edu_scholar > 50000 & _eeo_edu_scholar != . 
graph twoway histogram _eeo_edu_scholar if _eeo_edu_scholar < 50000 & edu_level == 1 ,color( "71 159 218") lcolor(black) percent ylabel(0(10)40) yscale(r(0(10)40)) width(5000) xtitle("Pesos") ytitle("Percent of respondents")
	graph export "$figures/_eeo_edu_scholar_HS.png",replace

	
	
graph twoway histogram _eeo_edu_scholar if _eeo_edu_scholar < 50000 & edu_level == 4,color( "71 159 218")  lcolor(black) percent ylabel(0(10)40) yscale(r(0(10)40)) width(5000) xtitle("Pesos") ytitle("Percent of respondents")
	graph export "$figures/_eeo_edu_scholar_COL.png",replace
	
	
* Assistance from family 
tabstat edu_tuition_assist if endline == 1,by(edu_level)		// 31%.  27% HS, 33% college 

clonevar _eeo_edu_famhelp =  edu_tuition_assist_amt

	replace _eeo_edu_famhelp = 30000 if _eeo_edu_famhelp > 40000 & _eeo_edu_famhelp != . 

graph twoway histogram _eeo_edu_famhelp if _eeo_edu_famhelp < 30000 & edu_level == 1 ,color( "71 159 218") lcolor(black) percent ylabel(0(10)50) yscale(r(0(10)50)) width(2500) xtitle("Pesos") ytitle("Percent of respondents")
	graph export "$figures/_eeo_edu_famhelp_HS.png",replace

	
	
graph twoway histogram _eeo_edu_famhelp if _eeo_edu_famhelp < 30000 & edu_level == 4,color( "71 159 218")  lcolor(black) percent ylabel(0(10)50) yscale(r(0(10)50)) width(2500) xtitle("Pesos") ytitle("Percent of respondents")
	graph export "$figures/_eeo_edu_famhelp_COL.png",replace
	
	
	

* Median spes payment = XXX


* Additional data on rates of public school enrollment 

graph twoway histogram _eeo_edu_schooltype if  edu_level == 1,frac discrete
graph twoway histogram _eeo_edu_schooltype if  edu_level == 4,frac discrete

/* Dont use this */ 
 cumul _eeo_edu_spending if edu_level == 4, gen(cum_eeo_edu_spending)
line cum_eeo_edu_spending _eeo_edu_spending, sort


gen _eeo_work_now_position = upper(work_now_position)

tab _eeo_work_now_position if regex(_eeo_work_now_position,"SALE")
replace _eeo_work_now_position = "SALES" if regex(_eeo_work_now_position,"SALES")
tab _eeo_work_now_position if regex(_eeo_work_now_position,"STUDEN")
replace _eeo_work_now_position = "STUDENT ASSISTANT"  if regex(_eeo_work_now_position,"STUDEN")
tab _eeo_work_now_position if regex(_eeo_work_now_position,"CREW")
replace _eeo_work_now_position = "SERVICE CREW" if regex(_eeo_work_now_position,"CREW") // Note that I include Production crew - double check 

tab _eeo_work_now_position if regex(_eeo_work_now_position,"WAIT")
replace _eeo_work_now_position = "WAITER" if regex(_eeo_work_now_position,"WAIT")



