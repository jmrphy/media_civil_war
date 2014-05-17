
#delimit ;
version 8.0;
set more off;

************************************************************************;
*** NOTE: FOR THIS CODE TO RUN, YOU MUST CHANGE THE DIRECTORY IN THE ***;
*** NEXT LINE TO THE LOCATION OF THE UNZIPPEDD REPLICATION ARCHIVE   ***;
************************************************************************;

cd "C:\Projects\Warren_IO_2014_rep\";

************************************;
*** LOAD SAMBANIS CIVIL WAR DATA ***;
*************************************;

use "Warren_IO_reg_data.dta", clear;

***************;
*** TABLE 1 ***;
***************;	

logit onset lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl pcyrs spline1 spline2 spline3, cluster(cowcode);
outreg2 using Warren.IO.table1.xls, dec(4) replace;

logit onset mdi larea lmtn lpopl oil2l deml deml2 ethfracl relfracl pcyrs spline1 spline2 spline3, cluster(cowcode);
outreg2 using Warren.IO.table1.xls, dec(4) ;

logit onset mdi lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl pcyrs spline1 spline2 spline3, cluster(cowcode);
outreg2 using Warren.IO.table1.xls, dec(4) ;

logit onset mdi lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl telephli pcyrs spline1 spline2 spline3, cluster(cowcode);
outreg2 using Warren.IO.table1.xls, dec(4) ;

logit onset mdi lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl litli pcyrs spline1 spline2 spline3, cluster(cowcode);
outreg2 using Warren.IO.table1.xls, dec(4) ;

logit onset mdi lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl seduli pcyrs spline1 spline2 spline3, cluster(cowcode);
outreg2 using Warren.IO.table1.xls, dec(4) ;

logit onset mdi lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl pfl pcyrs spline1 spline2 spline3, cluster(cowcode);
outreg2 using Warren.IO.table1.xls, dec(4) ;


***************************;
*** SUBSTANTIVE EFFECTS ***;
*** (Figure 2)          ***;
***************************;

estsimp logit onset mdi lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl pcyrs spline1 spline2 spline3, cluster(cowcode);
**********************************************************;
*** CLARIFY SOFTWARE                                   ***
*** Accessed at: http://gking.harvard.edu/clarify      ***;
*** 3/15/2010                                          ***;
**********************************************************;	

setx mean;
simqi, prval(1);

setx mdi p5;
simqi, prval(1);

setx mdi p95;
simqi, prval(1);

setx mean;
simqi, fd(prval(1)) changex(mdi p5 p95);
simqi, fd(prval(1)) changex(lpopl p5 p95);
simqi, fd(prval(1)) changex(deml 1 12 deml2 1 144);
simqi, fd(prval(1)) changex(relfracl p5 p95);
simqi, fd(prval(1)) changex(oil2l p5 p95);
simqi, fd(prval(1)) changex(lmtn p5 p95);


*********************;
*** SPLIT SAMPLES ***;
*********************;	

*********************;
*** PRESS FREEDOM ***;
*********************;	

logit onset mdi lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl pcyrs spline1 spline2 spline3 
if pfl == 1, score(pf_high_scr) ;
est store pf_high;

logit onset mdi lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl pcyrs spline1 spline2 spline3 
if pfl == 0, score(pf_low_scr) ;
est store pf_low;

suest pf_high pf_low, cluster(cowcode);
test [pf_high]mdi = [pf_low]mdi;

*****************;
*** DEMOCRACY ***;
*****************;

egen dem_mean = mean(deml);

logit onset mdi lgdpl larea lmtn lpopl oil2l ethfracl relfracl pcyrs spline1 spline2 spline3 
if deml > dem_mean, score(dem_mean_high_scr);
est store dem_high;

logit onset mdi lgdpl larea lmtn lpopl oil2l ethfracl relfracl pcyrs spline1 spline2 spline3 
if deml < dem_mean, score(dem_mean_low_scr);
est store dem_low;

suest dem_high dem_low, cluster(cowcode);
test [dem_high]mdi = [dem_low]mdi;

*****************;
*** ETHNICITY ***;
*****************;

egen eth_mean = mean(ethfracl);

logit onset mdi lgdpl larea lmtn lpopl oil2l deml deml2 relfracl pcyrs spline1 spline2 spline3 
if ethfracl > eth_mean, score(eth_high_scr);
est store eth_high;

logit onset mdi lgdpl larea lmtn lpopl oil2l deml deml2 relfracl pcyrs spline1 spline2 spline3 
if ethfracl < eth_mean, score(eth_low_scr);
est store eth_low;

suest eth_high eth_low, cluster(cowcode);
test [eth_high]mdi = [eth_low]mdi;

*****************;
*** RELIGION  ***;
*****************;

egen rel_mean = mean(relfracl);

logit onset mdi lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl pcyrs spline1 spline2 spline3 
if relfracl > rel_mean, score(rel_high_scr);
est store rel_high;

logit onset mdi lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl pcyrs spline1 spline2 spline3 
if relfracl < rel_mean, score(rel_low_scr);
est store rel_low;

suest rel_high rel_low, cluster(cowcode);
test [rel_high]mdi = [rel_low]mdi;


************************************;
*** APPENDIX: TABLE A            ***;
*** (alternative specifications) ***;
************************************;	

logit onset mdi lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl pcyrs spline1 spline2 spline3, cluster(cowcode);
outreg2 using Warren.IO.appendix_A.xls, dec(4) replace;

tsset, clear;
xtgee onset mdi lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl pcyrs spline1 spline2 spline3, 
family(binomial) link(logit) corr(ar1) i(cowcode) t(year) robust ;
outreg2 using Warren.IO.appendix_A.xls, dec(4) ;

relogit onset mdi lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl pcyrs spline1 spline2 spline3, cluster(cowcode);
outreg2 using Warren.IO.appendix_A.xls, dec(4) ;

tsset cowcode year;
xtlogit onset mdi lgdpl lpopl oil2l deml deml2 pcyrs spline1 spline2 spline3, fe;
outreg2 using Warren.IO.appendix_A.xls, dec(4) ;

************************************;
*** APPENDIX: TABLE B            ***;
*** (separate components of MDI) ***;
************************************;	

logit onset newsli lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl pcyrs spline1 spline2 spline3, cluster(cowcode);
outreg2 using Warren.IO.appendix_B.xls, dec(4) replace;

logit onset radioli lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl pcyrs spline1 spline2 spline3, cluster(cowcode);
outreg2 using Warren.IO.appendix_B.xls, dec(4) ;

logit onset tvli lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl pcyrs spline1 spline2 spline3, cluster(cowcode);
outreg2 using Warren.IO.appendix_B.xls, dec(4) ;


*********************************;
*** APPENDIX: TABLE C         ***;
*** (alternative lags of MDI) ***;
*********************************;

sort cowcode year;
by cowcode: gen mdi_l1 = mdi;
by cowcode: gen mdi_l2 = mdi[_n-1];
by cowcode: gen mdi_l3 = mdi[_n-2];
by cowcode: gen mdi_l4 = mdi[_n-3];
by cowcode: gen mdi_l5 = mdi[_n-4];
by cowcode: gen mdi_l6 = mdi[_n-5];
by cowcode: gen mdi_l7 = mdi[_n-6];
by cowcode: gen mdi_l8 = mdi[_n-7];
by cowcode: gen mdi_l9 = mdi[_n-8];
by cowcode: gen mdi_l10 = mdi[_n-9];

logit onset mdi_l1 lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl pcyrs spline1 spline2 spline3, cluster(cowcode);
outreg2 using Warren.IO.appendix_C.xls, dec(4) replace;

logit onset mdi_l2 lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl pcyrs spline1 spline2 spline3, cluster(cowcode);
outreg2 using Warren.IO.appendix_C.xls, dec(4) ;

logit onset mdi_l3 lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl pcyrs spline1 spline2 spline3, cluster(cowcode);
outreg2 using Warren.IO.appendix_C.xls, dec(4) ;

logit onset mdi_l4 lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl pcyrs spline1 spline2 spline3, cluster(cowcode);
outreg2 using Warren.IO.appendix_C.xls, dec(4) ;

logit onset mdi_l5 lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl pcyrs spline1 spline2 spline3, cluster(cowcode);
outreg2 using Warren.IO.appendix_C.xls, dec(4) ;

logit onset mdi_l6 lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl pcyrs spline1 spline2 spline3, cluster(cowcode);
outreg2 using Warren.IO.appendix_C.xls, dec(4) ;

logit onset mdi_l7 lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl pcyrs spline1 spline2 spline3, cluster(cowcode);
outreg2 using Warren.IO.appendix_C.xls, dec(4) ;

logit onset mdi_l8 lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl pcyrs spline1 spline2 spline3, cluster(cowcode);
outreg2 using Warren.IO.appendix_C.xls, dec(4) ;

logit onset mdi_l9 lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl pcyrs spline1 spline2 spline3, cluster(cowcode);
outreg2 using Warren.IO.appendix_C.xls, dec(4) ;

logit onset mdi_l10 lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl pcyrs spline1 spline2 spline3, cluster(cowcode);
outreg2 using Warren.IO.appendix_C.xls, dec(4) ;


******************;
*** ROC CURVES ***;
*** (Figure 3) ***;
******************;

logit onset lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl pcyrs spline1 spline2 spline3, cluster(cowcode);
predict pr1;

logit onset mdi larea lmtn lpopl oil2l deml deml2 ethfracl relfracl pcyrs spline1 spline2 spline3, cluster(cowcode);
predict pr2;

logit onset mdi lgdpl larea lmtn lpopl oil2l deml deml2 ethfracl relfracl pcyrs spline1 spline2 spline3, cluster(cowcode);
predict pr3;

roccomp onset pr1 pr2 pr3, 
graph scheme(sj) ysize(4) xsize(6.5) 
clcolor(gs0 gs7 gs11) 
clpattern(solid solid solid) 
clwidth(medium medium medium) 
msymbol(none none none) 
xtitle("False Positive Rate", size(large) margin(medium)) xlabel( , nogrid)  
ytitle("True Positive Rate", size(large) margin(medium)) ylabel( , nogrid) 
graphregion(fcolor(white) ifcolor(white) lcolor(white) ilcolor(white)) 
plotregion(fcolor(white) ifcolor(white) lcolor(white) ilcolor(white)) 
legend(order(1 2 3) cols(1) stack region(style(none)) symplacement(left) position(3) 
label(1 "(1) Controls + GDP") 
label(2 "(2) Controls + Media") 
label(3 "(3) Controls + GDP + Media"));

roccomp onset pr1 pr2;
roccomp onset pr1 pr3;
roccomp onset pr2 pr3;

*************************************************;
*** SAVE PREDICTIONS                          ***;
*** (to be used later with the IDI estimator) ***;
*************************************************;

keep onset pr1 pr2 pr3;
save "Warren_IO_predictions.dta", replace;








