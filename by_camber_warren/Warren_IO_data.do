
#delimit ;
version 8.0;
set more off;

*******************************************************************;
*** NOTE: FOR THIS CODE TO RUN, YOU MUST DOWNLOAD THE           ***;
*** CIVIL WAR DATA SEPARATELY, FROM THE WEBSITE REFERENCED      ***;
*** BELOW, PLACE IT IN THE SAME FOLDER AS THE UNZIPPED          ***;
*** REPLICATION ARCHIVE, AND THEN CHANGE THE DIRECTORY LOCATION ***;
*** IN THE NEXT LINE TO THE FOLDER HOLDING THE SAVED FILES      ***;
*******************************************************************;

cd "C:\Projects\Warren_IO_2014_rep\";

************************************;
*** LOAD SAMBANIS CIVIL WAR DATA ***;
*************************************;

use "SambanisJCR2004_replicationdataset.dta", clear;
*****************************************************;
*** Accessed 2/3/2013 at:                         ***;
*** http://pantheon.yale.edu/~ns237/civilwar.html ***;
*****************************************************;

*********************;
*** CORRECT TYPOS ***;
*********************;

replace cowcode = 345 if cowcode == 347;
replace cowcode = 365 if cowcode == 364;
replace cowcode = 580 if cowcode == 511;
replace cowcode = 530 if cowcode == 529;
replace cowcode = 816 if cowcode == 817;
replace cowcode = 816 if cowcode == 818;

gen atwarns_rev = atwarns;
replace atwarns_rev = 1 if cowcode == 710 & year == 1957;
replace atwarns_rev = 1 if cowcode == 710 & year == 1958;
replace atwarns_rev = 1 if cowcode == 710 & year == 1959;

gen warstnsb_rev = warstnsb;
replace warstnsb_rev = 0 if cowcode == 775 & year == 1952;

drop if atwarns_rev == .;

*****************************;
*** MERGE WITH MEDIA DATA ***;
*****************************;

joinby cowcode year using "Warren.MediaData.v1.dta", unmatched(master);

***********************************;
*** GENERATE DEPENDENT VARIABLE ***;
***********************************;

sort cowcode year;
gen onset =  warstnsb_rev;

***************************;
*** PEACE YEARS SPLINES ***;
***************************;

gen atwar = atwarns_rev;
btscs atwar year cowcode, gen(pcyrs) nspline(3);
rename _spline1 spline1;
rename _spline2 spline2;
rename _spline3 spline3;
**********************************************************;
*** BTSCS SOFTWARE                                     ***
*** Accessed at: http://www.prio.no/Data/Stata-Tools/  ***;
*** 5/30/2011                                          ***;
**********************************************************;


**************************************;
*** GENERATE INDEPENDENT VARIABLES ***;
**************************************;

gen deml =  pol2l1 + 11;
gen deml2 = deml * deml;
gen lpopl = lpopns1m;
gen mtn = mtnest;
gen lmtn = log(mtn + 0.1);
gen larea = log(area * 10000);
gen oil2l = oil2l1m;
gen lgdpl = log(gdpl1m);
gen ethfracl = ethfrac;
by cowcode: replace ethfracl = ethfrac[_n - 1] if ethfrac[_n - 1] != .;
gen relfracl = relfrac;
by cowcode: replace relfracl = relfrac[_n - 1] if relfrac[_n - 1] != .;

***********************************************************;
*** GENERATE MEDIA FREEDOM VARIABLE                     ***;
*** (combining scores from Van Belle and Freedom House) ***;
***********************************************************;

replace pf_vb = . if pf_vb > 4;
replace pf_fh = 2 if year >= 1993 & pf_fh <= 30 & pf_fh != . ;
replace pf_fh = 1 if year >= 1993 & pf_fh > 30 & pf_fh <= 60 & pf_fh != . ;
replace pf_fh = 0 if year >= 1993 & pf_fh > 60 & pf_fh != . ;
by cowcode: gen pfl_vb = pf_vb[_n-1];
by cowcode: gen pfl_fh = pf_fh[_n-1];
gen pfl_vb4 = 1 if pfl_vb != .;
replace pfl_vb4 = 0 if pfl_vb >= 4 & pfl_vb != .;
gen pfl_fh1 = 0 if pfl_fh != .;
replace pfl_fh1 = 1 if pfl_fh >= 1 & pfl_fh != .;
gen pfl = pfl_vb4;
replace pfl = pfl_fh1 if pfl_vb == .;

*************************************************************;
*** GENERATE DICHOTOMOUS VARIABLES BY SPLITTING AT MEDIAN ***;
*** (to be used later with the matching estimator)        ***;
*************************************************************;

egen m_p50 = pctile(mdi), p(50);
gen mdi_p50 = 0 if mdi != .;
replace mdi_p50 = 1 if mdi != . & mdi >= m_p50;

egen lg_p50 = pctile(lgdpl), p(50);
gen lgdpl_p50 = 0 if lgdpl != .;
replace lgdpl_p50 = 1 if lgdpl != . & lgdpl >= lg_p50;

**********************;
*** SAVE DATA FILE ***;
**********************;

keep cowcode country year onset atwar 
	mdi mdi_p50 newsli radioli tvli 
	lgdpl lgdpl_p50 telephli litli seduli pfl 
	larea lmtn lpopl oil2l 
	deml deml2 ethfracl relfracl 
	pcyrs spline1 spline2 spline3 ;
	
order cowcode country year onset atwar 
	mdi mdi_p50 newsli radioli tvli 
	lgdpl lgdpl_p50 telephli litli seduli pfl 
	larea lmtn lpopl oil2l 
	deml deml2 ethfracl relfracl 
	pcyrs spline1 spline2 spline3 ;
	
save "Warren_IO_reg_data.dta", replace;






