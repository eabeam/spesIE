# spesIE
Impact Evaluation of the Special Program for Employment of Students
readme.txt
**********************************************
Impact Evaluation of the Special Program for Employment of Student (SPES)
Innovations for Poverty Action 

PIs:
Emily Beam 
Nathanael Goldberg 
Leigh Linden
Stella Quimbo 

Documents prepared by Heather Richmond and Emily Beam 

For questions regarding data and documentation, contact Emily Beam at emily.beam@uvm.edu

Last Updated: 29 April 2018


**********************************************

This set of data files include the raw data produced from the baseline and endline surveys. Additionally, accompanying do-files generate the tables that are used in the final report

**********************************************

Instructions: 

1. In the master do-file (0 master_dofile_analysis.do) update the global pathways to reflect your local directories. 

2. Run the remaining commands within the master do-file to recreate the analysis. Note that  initalize.do generates surveydata_full_clean.dta, which is the main data file used in regressions. 


Packages: 

	 - outreg2 is required to output regression tables
