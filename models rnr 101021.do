**Imputation done**
**Average across 5 different imputed outputs***
generate citidmean = ((citid12 + citid38 + citid64 + citid90 + citid116)/5)
generate lag_pop_na_mean = ((lag_pop_na14 + lag_pop_na40 + lag_pop_na66 + lag_pop_na92 + lag_pop_na118)/5)
generate lag_tot_price_mean = ((lag_tot_price15 + lag_tot_price41 + lag_tot_price67 + lag_tot_price93 + lag_tot_price119)/5)
generate lnres_cust_mean = ((lnres_cust16 + lnres_cust42 + lnres_cust68 + lnres_cust94 + lnres_cust120)/5)
generate lntot_peak_mean = ((lntot_peak17 + lntot_peak43 + lntot_peak69 + lntot_peak95 + lntot_peak121)/5)
generate pct_ret_mean = ((pct_ret18 + pct_ret44 + pct_ret70 + pct_ret96 + pct_ret122)/5)
generate lnretsales_pc_mean = ((lnretsales_pc19 + lnretsales_pc45 + lnretsales_pc71 + lnretsales_pc97 + lnretsales_pc123)/5)
generate lncomsales_pc_mean = ((lncomsales_pc20 + lncomsales_pc46 + lncomsales_pc72 + lncomsales_pc98 + lncomsales_pc124)/5)
generate lnressales_pc_mean = ((lnressales_pc21 + lnressales_pc47 + lnressales_pc73 + lnressales_pc99 + lnressales_pc125)/5)
generate lnindsales_pc_mean = ((lnindsales_pc22 + lnindsales_pc48 + lnindsales_pc74 + lnindsales_pc100 + lnindsales_pc126)/5)
generate tot_peak_mean = ((tot_peak25 + tot_peak51 + tot_peak77 + tot_peak103 + tot_peak129)/5)
generate res_cust_mean = ((res_cust26 + res_cust52 + res_cust78 + res_cust104 + res_cust130)/5)


*Model building MW 
**Import dataset "Dataset_Imp_avg_020721"**
**descriptive statistics**
describe
summarize
tsset uid3 year
***************************************************************************
**change variable names and lables
label variable collab_length "length of deliberation"
rename collab_length delib_exp
label variable part_any ""
rename part_any reg_authority
label variable reg_authority "whether regulators approve utility plans"
label variable collab_any ""
rename collab_any deliberation
label variable formal_length "the years that the collaborative group has been in operation,but only for formal"
rename formal_length formal_exp
**********************************************
************change string variable to numeric variable 
encode state, gen(State)
***************************************
************R&R Rev3: include state professionalization variable as it may correlate with other governance variables (IV)**************manually coded in the excel spreadsheet
egen year_count=group(year) 
tsset uid3 year_count

*********************************************************************************************************
***********finalized model****************
***model1:mandate**************
generate delib_exp_mandate = (delib_exp * mandate)
asdoc xtscc lnretsales_pc_mean mandate stateprofessionalization reg_authority citidmean pipc13 lag_pop_na_mean lag_tot_price_mean lnres_cust_mean lntot_peak_mean pct_ret_mean $years, fe, save(Tab2) nest cnames(Total)
asdoc xtscc lnressales_pc_mean mandate stateprofessionalization reg_authority citidmean pipc13 lag_pop_na_mean lag_tot_price_mean lnres_cust_mean lntot_peak_mean pct_ret_mean $years, fe, save(Tab2) nest cnames(Residential)
asdoc xtscc lncomsales_pc_mean mandate stateprofessionalization reg_authority citidmean pipc13 lag_pop_na_mean lag_tot_price_mean lnres_cust_mean lntot_peak_mean pct_ret_mean $years, fe, save(Tab2) nest cnames(Commercial)
asdoc xtscc lnindsales_pc_mean mandate stateprofessionalization reg_authority citidmean pipc13 lag_pop_na_mean lag_tot_price_mean lnres_cust_mean lntot_peak_mean pct_ret_mean $years, fe, save(Tab2) nest cnames(Industrial)
*******************************************************
***deliberation***** only this one in the rnr*********************************
asdoc xtscc lnretsales_pc_mean delib_exp mandate delib_exp_mandate stateprofessionalization reg_authority citidmean pipc13 lag_pop_na_mean lag_tot_price_mean lnres_cust_mean lntot_peak_mean pct_ret_mean $years, fe, save(Tab3) nest cnames(Total)
asdoc xtscc lnressales_pc_mean delib_exp mandate delib_exp_mandate stateprofessionalization reg_authority citidmean pipc13 lag_pop_na_mean lag_tot_price_mean lnres_cust_mean lntot_peak_mean pct_ret_mean $years, fe, save(Tab3) nest cnames(Residential)
asdoc xtscc lncomsales_pc_mean delib_exp mandate delib_exp_mandate stateprofessionalization reg_authority citidmean pipc13 lag_pop_na_mean lag_tot_price_mean lnres_cust_mean lntot_peak_mean pct_ret_mean $years, fe, save(Tab3) nest cnames(Commercial)
asdoc xtscc lnindsales_pc_mean delib_exp mandate delib_exp_mandate stateprofessionalization reg_authority citidmean pipc13 lag_pop_na_mean lag_tot_price_mean lnres_cust_mean lntot_peak_mean pct_ret_mean $years, fe, save(Tab3) nest cnames(Industrial)


***model2:deliberation********************8
asdoc xtscc lnretsales_pc delib_exp mandate delib_exp_mandate professionalization reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Total)
asdoc xtscc lnressales_pc delib_exp mandate delib_exp_mandate professionalization reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Residential)
asdoc xtscc lncomsales_pc delib_exp mandate delib_exp_mandate professionalization reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Commercial)
asdoc xtscc lnindsales_pc delib_exp mandate delib_exp_mandate professionalization reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Industrial)
**************************************************
***figure1. deliberation effect****
****total*****
xtreg lnretsales_pc_mean i.delib_exp i.mandate i.delib_exp#i.mandate stateprofessionalization reg_authority citidmean pipc13 lag_pop_na_mean lag_tot_price_mean lnres_cust_mean lntot_peak_mean pct_ret_mean $years, fe
margins, dydx(i.delib_exp) asbalanced emptycells(reweight) vsquish
marginsplot, yline(0) name (t)
****res******************
xtreg lnressales_pc_mean i.delib_exp##i.mandate stateprofessionalization reg_authority citidmean pipc13 lag_pop_na_mean lag_tot_price_mean lnres_cust_mean lntot_peak_mean pct_ret_mean $years, fe
margins, dydx(i.delib_exp) asbalanced emptycells(reweight) vsquish
marginsplot, yline(0) name (r)
***com************************8
xtreg lncomsales_pc_mean i.delib_exp##i.mandate stateprofessionalization reg_authority citidmean pipc13 lag_pop_na_mean lag_tot_price_mean lnres_cust_mean lntot_peak_mean pct_ret_mean $years, fe
margins, dydx(i.delib_exp) asbalanced emptycells(reweight) vsquish
marginsplot, yline(0) name (c)
***ind****
xtreg lnindsales_pc_mean i.delib_exp##i.mandate stateprofessionalization reg_authority citidmean pipc13 lag_pop_na_mean lag_tot_price_mean lnres_cust_mean lntot_peak_mean pct_ret_mean $years, fe
margins, dydx(i.delib_exp) asbalanced emptycells(reweight) vsquish
marginsplot, yline(0) name (i)
graph combine t r c i, col(2) row(2)
****compare xtscc and xtreg***
xtscc lnretsales_pc_mean i.delib_exp##i.mandate stateprofessionalization reg_authority citidmean pipc13 lag_pop_na_mean lag_tot_price_mean lnres_cust_mean lntot_peak_mean pct_ret_mean, fe
eststo m1
xtreg lnretsales_pc_mean i.delib_exp i.mandate i.delib_exp#i.mandate stateprofessionalization reg_authority citidmean pipc13 lag_pop_na_mean lag_tot_price_mean lnres_cust_mean lntot_peak_mean pct_ret_mean, fe
eststo m2
esttab m1 m2, se star(* .1 ** .05 *** .001)
*********************compare equitability of outcomes between MD and CT***********************
keep state_id24 uid3 year lnretsales_pc_mean lnressales_pc_mean lncomsales_pc_mean lnindsales_pc_mean
describe
tabulate state_id24
summarize lnretsales_pc_mean lnressales_pc_mean lncomsales_pc_mean lnindsales_pc_mean if state_id24 == 20
summarize lnretsales_pc_mean lnressales_pc_mean lncomsales_pc_mean lnindsales_pc_mean if state_id24 == 7
*************************************************************************
****************Compare reg between two states**************************
keep if state_id24 == 20
xtscc lnretsales_pc_mean 
xtscc lnretsales_pc_mean i.delib_exp##i.mandate stateprofessionalization reg_authority citidmean pipc13 lag_pop_na_mean lag_tot_price_mean lnres_cust_mean lntot_peak_mean pct_ret_mean, fe

xtscc lnressales_pc_mean i.delib_exp##i.mandate stateprofessionalization reg_authority citidmean pipc13 lag_pop_na_mean lag_tot_price_mean lnres_cust_mean lntot_peak_mean pct_ret_mean, fe

xtscc lncomsales_pc_mean i.delib_exp##i.mandate stateprofessionalization reg_authority citidmean pipc13 lag_pop_na_mean lag_tot_price_mean lnres_cust_mean lntot_peak_mean pct_ret_mean, fe


xtscc lnindsales_pc_mean i.delib_exp##i.mandate stateprofessionalization reg_authority citidmean pipc13 lag_pop_na_mean lag_tot_price_mean lnres_cust_mean lntot_peak_mean pct_ret_mean, fe
*******************************************
keep if state_id24 == 7
xtscc lnretsales_pc_mean i.delib_exp##i.mandate stateprofessionalization reg_authority citidmean pipc13 lag_pop_na_mean lag_tot_price_mean lnres_cust_mean lntot_peak_mean pct_ret_mean, fe

xtscc lnressales_pc_mean i.delib_exp##i.mandate stateprofessionalization reg_authority citidmean pipc13 lag_pop_na_mean lag_tot_price_mean lnres_cust_mean lntot_peak_mean pct_ret_mean, fe

xtscc lncomsales_pc_mean i.delib_exp##i.mandate stateprofessionalization reg_authority citidmean pipc13 lag_pop_na_mean lag_tot_price_mean lnres_cust_mean lntot_peak_mean pct_ret_mean, fe


xtscc lnindsales_pc_mean i.delib_exp##i.mandate stateprofessionalization reg_authority citidmean pipc13 lag_pop_na_mean lag_tot_price_mean lnres_cust_mean lntot_peak_mean pct_ret_mean, fe
***********figure1****************************
****R&R sales model margnial effect************************
****************************************************************************
xtreg lnretsales_pc i.delib_exp i.mandate i.delib_exp##i.mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret professionalization $years, fe
*****************deliberation's average marginal effects******************************
******total********
margins, dydx(i.delib_exp) at(mandate = 0) asbalanced emptycells(reweight) vsquish
marginsplot, yline(0) name (t)
*****res****
xtreg lnressales_pc i.delib_exp i.mandate i.delib_exp##i.mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret professionalization $years, fe
margins, dydx(i.delib_exp) at(mandate = 0) asbalanced emptycells(reweight) vsquish
marginsplot, yline(0) name (r)
***com******
xtreg lncomsales_pc i.delib_exp i.mandate i.delib_exp##i.mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret professionalization $years, fe
margins, dydx(i.delib_exp) at(mandate = 0) asbalanced emptycells(reweight) vsquish
marginsplot, yline(0) name (c)
***ind*************
xtreg lnindsales_pc i.delib_exp i.mandate i.delib_exp##i.mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret professionalization $years, fe
margins, dydx(i.delib_exp) at(mandate = 0) asbalanced emptycells(reweight) vsquish
marginsplot, yline(0) name (i)

graph combine t r c i, col(2) row(2)

*************Figure2. effects of deliberation on enegy savings when mandate =1********************8
****tot*******************
xtreg lnretsales_pc i.delib_exp i.mandate i.delib_exp##i.mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret professionalization $years, fe
margins, dydx(i.delib_exp) at(mandate = 1) asbalanced emptycells(reweight) vsquish
marginsplot, yline(0) name (tt)
****res**********************
xtreg lnressales_pc i.delib_exp i.mandate i.delib_exp##i.mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret professionalization $years, fe
margins, dydx(i.delib_exp) at(mandate = 1) asbalanced emptycells(reweight) vsquish
marginsplot, yline(0) name (rr)
*********com********************
xtreg lncomsales_pc i.delib_exp i.mandate i.delib_exp##i.mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret professionalization $years, fe
margins, dydx(i.delib_exp) at(mandate = 1) asbalanced emptycells(reweight) vsquish
marginsplot, yline(0) name (cc)
*******ind**************
xtreg lnindsales_pc i.delib_exp i.mandate i.delib_exp##i.mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret professionalization $years, fe
margins, dydx(i.delib_exp) at(mandate = 1) asbalanced emptycells(reweight) vsquish
marginsplot, yline(0) name (ii)

graph combine tt rr cc ii, col(2) row(2)

******************************************************************************


****Compare professionalization added model with Table 2 main model
****Table 2 model********
generate delib_exp_mandate = (delib_exp * mandate)
asdoc xtscc lnee_percust delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Total)
asdoc xtscc lnee_inc_respc delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Residential)
asdoc xtscc lnee_inc_compc delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Commercial)
asdoc xtscc lnee_inc_indpc delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Industrial)
********Table 2 + professionalization control ************************8
asdoc xtscc lnee_percust delib_exp mandate delib_exp_mandate Professionalization reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Total)
asdoc xtscc lnee_inc_respc delib_exp mandate delib_exp_mandate Professionalization reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Residential)
asdoc xtscc lnee_inc_compc delib_exp mandate delib_exp_mandate Professionalization reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Commercial)
asdoc xtscc lnee_inc_indpc delib_exp mandate delib_exp_mandate Professionalization reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Industrial)
*********************************************************************************************************
****R&R model: Models with state professionalization and retail sale DV
generate delib_exp_mandate = (delib_exp * mandate)
asdoc xtscc lnretsales_pc delib_exp mandate delib_exp_mandate professionalization reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Total)
asdoc xtscc lnressales_pc delib_exp mandate delib_exp_mandate professionalization reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Residential)
asdoc xtscc lncomsales_pc delib_exp mandate delib_exp_mandate professionalization reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Commercial)
asdoc xtscc lnindsales_pc delib_exp mandate delib_exp_mandate professionalization reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Industrial)

****R&R sales model margnial effect************************
****************************************************************************
xtreg lnretsales_pc i.delib_exp i.mandate i.delib_exp##i.mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret professionalization $years, fe
*****************deliberation's average marginal effects******************************
******total********
margins, dydx(i.delib_exp) at(mandate = 0) asbalanced emptycells(reweight) vsquish
marginsplot, saving(marginplot,replace) yline(0)
*****res****
xtreg lnressales_pc i.delib_exp i.mandate i.delib_exp##i.mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret professionalization $years, fe
margins, dydx(i.delib_exp) at(mandate = 0) asbalanced emptycells(reweight) vsquish
marginsplot, saving(marginplot,replace) yline(0)
***com******
xtreg lncomsales_pc i.delib_exp i.mandate i.delib_exp##i.mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret professionalization $years, fe
margins, dydx(i.delib_exp) at(mandate = 0) asbalanced emptycells(reweight) vsquish
marginsplot, saving(marginplot,replace) yline(0)
***ind*************
xtreg lnindsales_pc i.delib_exp i.mandate i.delib_exp##i.mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret professionalization $years, fe
margins, dydx(i.delib_exp) at(mandate = 0) asbalanced emptycells(reweight) vsquish
marginsplot, saving(marginplot,replace) yline(0)
margins, dydx(i.delib_exp) at(mandate = 1) asbalanced emptycells(reweight) vsquish
marginsplot, saving(marginplot,replace) yline(0)

********
xtscc lnindsales_pc i.delib_exp i.mandate i.delib_exp##i.mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret professionalization $years, fe

******************res, com, ind mandate******************************
xtscc lnressales_pc mandate professionalization reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret 
eststo m1
xtscc lncomsales_pc mandate professionalization reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret 
eststo m2
xtscc lnindsales_pc mandate professionalization reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret 
eststo m3
esttab m1 m2 m3, se star(* .1 ** .05 *** .001)
**************** add deliberation to above models*********************
xtscc lnressales_pc delib_exp mandate professionalization reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret 
eststo m1
xtscc lncomsales_pc delib_exp mandate professionalization reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret 
eststo m2
xtscc lnindsales_pc delib_exp mandate professionalization reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret 
eststo m3
esttab m1 m2 m3, se star(* .1 ** .05 *** .001)
**************************************add interaction******************************
xtscc lnressales_pc delib_exp mandate delib_exp_mandate professionalization reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe
eststo m1
xtscc lncomsales_pc delib_exp mandate delib_exp_mandate professionalization reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe 
eststo m2
xtscc lnindsales_pc delib_exp mandate delib_exp_mandate professionalization reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe 
eststo m3
esttab m1 m2 m3, se star(* .1 ** .05 *** .001)
****************************************************************

delib_exp_mandate

asdoc xtscc lncomsales_pc delib_exp mandate delib_exp_mandate professionalization reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Commercial)
asdoc xtscc lnindsales_pc delib_exp mandate delib_exp_mandate professionalization reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Industrial)










******************************Delib*mandate***********************************************************************
*************** 1) DV:lnee_pct***************************************************************************************
xtscc lnee_pct reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m1
xtscc lnee_pct reg_authority mandate delib_exp citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m2
generate delib_exp_mandate = (delib_exp * mandate)
xtscc lnee_pct reg_authority mandate delib_exp delib_exp_mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m3
esttab m1 m2 m3, se star(* .1 ** .05 *** .001)
***DV: by ratepayer classes
xtscc lnee_inc_respc reg_authority mandate delib_exp delib_exp_mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m4
xtscc lnee_inc_compc reg_authority mandate delib_exp delib_exp_mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m5
xtscc lnee_inc_indpc reg_authority mandate delib_exp delib_exp_mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m6
esttab m1 m2 m3 m4 m5 m6, se star(* .1 ** .05 *** .001)





**************Finalalized*****************************
*************************[Table1] descriptive statistics********************
sysuse auto
asdoc sum
*************************[Table2] *******************************************
generate delib_exp_mandate = (delib_exp * mandate)
asdoc xtscc lnee_percust delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Total)
asdoc xtscc lnee_inc_respc delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Residential)
asdoc xtscc lnee_inc_compc delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Commercial)
asdoc xtscc lnee_inc_indpc delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Industrial)
*************************[Figure 1]*******************************************
xtreg lnee_percust i.delib_exp i.mandate i.delib_exp##i.mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
margins delib_exp#mandate
marginsplot
*********************Total model**********************
xtreg lnee_percust i.delib_exp##i.mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
***********mandate=1, deliberation's marginal effects**********************
******************mandate's average marginal effects**********************************
margins, dydx(mandate) at(delib_exp = (0(1)16)) asbalanced emptycells(reweight) vsquish
*****************deliberation's average marginal effects******************************
margins, dydx(i.delib_exp) at(mandate = 0) asbalanced emptycells(reweight) vsquish
marginsplot, saving(marginplot,replace) yline(0)
margins, dydx(i.delib_exp) at(mandate = 1) asbalanced emptycells(reweight) vsquish
marginsplot, saving(marginplot,replace) yline(0)
*************************8residential model********************************8



marginas


xtscc lnee_percust delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
margins delib_exp_mandate
marginsplot
margins, at (delib_exp_mandate=(0(1)16))
marginsplot, recastci(rarea)
***************************************interpreting models for log-transformed outcomes***********https://www.stata.com/stata-news/news34-2/spotlight/****
************It is tempting to simply exponentiate the predictions to convert them back to wages, but the reverse transformation results in a biased prediction (see references Abrevaya [2002]; Cameron and Trivedi [2010]; Duan [1983]; Wooldridge [2010]).*********************
*****how to estimate unbiased predictions**********8
xtreg lnee_percust delib_exp mandate i.delib_exp##i.mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
predict lnee_percust_hat
generate ee_percust_hat = exp(lnee_percust_hat)*exp((e(rmse)^2)/2)
margins, expression(exp(predict(xb))*exp((e(rmse)^2)/2))
plot ee_percust_hat


***unbiased estimates and their standard errors***********************
gsem lnee_percust <- delib_exp mandate i.delib_exp##i.mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret
estat esize
margins, expression(exp(predict(esize))*exp((_b[/var(e.lnee_percust)]/2)))


********************************margin plot of formal * mandate *********************8
xtreg lnee_percust formal_exp mandate i.formal_exp##i.mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
margins formal_exp#mandate
marginsplot, yline(0)


**************************Table2****************************************
generate formal_exp_mandate = (formal_exp * mandate)
asdoc xtscc lnee_percust formal_exp mandate formal_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, nest cnames(T)
asdoc xtscc lnee_inc_respc formal_exp mandate formal_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, nest cnames(R)
asdoc xtscc lnee_inc_compc formal_exp mandate formal_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, nest cnames(C)
asdoc xtscc lnee_inc_indpc formal_exp mandate formal_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, nest cnames(I)

******************compare xtscc and xtreg****************************
xtscc lnee_percust delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m1
xtreg lnee_percust delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m2
xtreg lnee_percust delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe vce(cluster state)
eststo m3
esttab m1 m2 m3, se star(* .1 ** .05 *** .001)
********************xtscc is justified given the data structure where we have a relatively little time effect and a stronger cross sectional dependence. DK estimation is adequate.*********************
***************tests if fixed or random effect
xtreg lnee_percust delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
estimates store fixed
xtreg lnee_percust delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, re
estimates store random
hausman fixed random
*********************************Testing if time fixed effects are needed:
help testparm
xtreg lnee_percust delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret i.year, re
testparm i.year
*******************************************************8
ssc install xttest3
xtreg lnee_percust delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
xttest3
***********************************

xtscc lnee_inc_respc delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Residential)
xtscc lnee_inc_compc delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Commercial)
xtscc lnee_inc_indpc delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Industrial)


************************work-in-progress*********margins*********************
****************************margins using xtreg and interaction effect ****************************************
xtreg lnee_inc_indpc delib_exp mandate i.delib_exp##i.mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
margins delib_exp mandate, post
margins delib_exp#mandate
marginsplot
marginsplot, recastci(rarea)
*********************Tables in the paper***********************************
**Table 2: Savings from state energy mandates by ratepayer type**
xtscc lnee_percust reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m1
xtscc lnee_inc_res reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m2
xtscc lnee_inc_com reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m3
xtscc lnee_inc_ind reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m4
esttab m1 m2 m3 m4, se star(* .1 ** .05 *** .001)
************Table 2 with sales data*****************
xtscc lnretsales_pc reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m1
xtscc lnressales_pc reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m2
xtscc lncomsales_pc reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m3
xtscc lnindsales_pc reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m4
esttab m1 m2 m3 m4, se star(* .1 ** .05 *** .001)
**********Table 3: Savings from PCG by ratepayer type*****************
xtscc lnee_percust delib_exp reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m1
xtscc lnee_inc_res delib_exp reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m2
xtscc lnee_inc_com delib_exp reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m3
xtscc lnee_inc_ind delib_exp reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m4
esttab m1 m2 m3 m4, se star(* .1 ** .05 *** .001)


************Table 3a: including interaction term delib_exp*mandate****
generate delib_exp_mandate = (delib_exp * mandate)
xtscc lnretsales_pc delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe
eststo m1
xtscc lnressales_pc delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe
eststo m2
xtscc lncomsales_pc delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe
eststo m3
xtscc lnindsales_pc delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe
eststo m4
esttab m1 m2 m3 m4, se star(* .1 ** .05 *** .001)
***********************
generate delib_exp_mandate = (delib_exp * mandate)
xtscc lnee_percust delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe
eststo m1
xtscc lnee_inc_respc delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe
eststo m2
xtscc lnee_inc_compc delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe
eststo m3
xtscc lnee_inc_indpc delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe
eststo m4
esttab m1 m2 m3 m4, se star(* .1 ** .05 *** .001)


xtscc lnee_percust deliberation mandate delib_mandate delib_exp reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe
eststo m1
xtscc lnee_inc_res deliberation mandate delib_mandate delib_exp reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe
eststo m2
xtscc lnee_inc_com deliberation mandate delib_mandate delib_exp reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe
eststo m3
xtscc lnee_inc_ind deliberation mandate delib_mandate delib_exp reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe
eststo m4
esttab m1 m2 m3 m4, se star(* .1 ** .05 *** .001)

***************Table3c:sensitivity analysese of table 3 models ************************************************
xtscc lnretsales_pc deliberation mandate delib_mandate delib_exp reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m1
xtscc lnressales_pc deliberation mandate delib_mandate delib_exp reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m2
xtscc lncomsales_pc deliberation mandate delib_mandate delib_exp reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m3
xtscc lnindsales_pc deliberation mandate delib_mandate delib_exp reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m4
esttab m1 m2 m3 m4, se star(* .1 ** .05 *** .001)

***********************Table 3d
************Table 3 including interaction term delib_exp*mandate****
generate delib_mandate = (deliberation * mandate)
xtscc lnee_percust deliberation mandate delib_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe
eststo m1
xtscc lnee_inc_res deliberation mandate delib_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe
eststo m2
xtscc lnee_inc_com deliberation mandate delib_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe
eststo m3
xtscc lnee_inc_ind deliberation mandate delib_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe
eststo m4
esttab m1 m2 m3 m4, se star(* .1 ** .05 *** .001)
***********************
***************Table3c:sensitivity analysese of table 3 models ************************************************
xtscc lnretsales_pc delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m1
xtscc lnressales_pc delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m2
xtscc lncomsales_pc delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m3
xtscc lnindsales_pc delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m4
esttab m1 m2 m3 m4, se star(* .1 ** .05 *** .001)



**************Table 4: Savings from PCG by ratepayer type (Formality)*********
xtscc lnee_percust formal_exp reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m1
xtscc lnee_inc_res formal_exp reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m2
xtscc lnee_inc_com formal_exp reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m3
xtscc lnee_inc_ind delib_exp formal_exp reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m4
esttab m1 m2 m3 m4, se star(* .1 ** .05 *** .001)
************Table 4a: Formal*mandate****************************************
generate int_formal_mandate = (formal_exp * mandate)
xtscc lnee_percust formal_exp mandate int_formal_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe
eststo m1
xtscc lnee_inc_respc formal_exp mandate int_formal_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe
eststo m2
xtscc lnee_inc_compc formal_exp mandate int_formal_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe
eststo m3
xtscc lnee_inc_indpc formal_exp mandate int_formal_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe
eststo m4
esttab m1 m2 m3 m4, se star(* .1 ** .05 *** .001)

**********************************
xtscc lnretsales_pc formal_exp mandate int_formal_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe
eststo m1
xtscc lnressales_pc formal_exp mandate int_formal_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe
eststo m2
xtscc lncomsales_pc formal_exp mandate int_formal_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe
eststo m3
xtscc lnindsales_pc formal_exp mandate int_formal_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret, fe
eststo m4
esttab m1 m2 m3 m4, se star(* .1 ** .05 *** .001)





**************Table 5: Sensitivity analysis- effects of pcg on retail sales*********
xtscc lnretsales_pc delib_exp reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m1
xtscc lnressales_pc delib_exp reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m2
xtscc lncomsales_pc delib_exp reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m3
xtscc lnindsales_pc delib_exp reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m4
esttab m1 m2 m3 m4, se star(* .1 ** .05 *** .001)
***************Table 6: Sensitivity analysis – effects of formal PCG on retail sales*****************************
xtscc lnretsales_pc formal_exp reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m1
xtscc lnressales_pc formal_exp reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m2
xtscc lncomsales_pc formal_exp reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m3
xtscc lnindsales_pc formal_exp reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m4
esttab m1 m2 m3 m4, se star(* .1 ** .05 *** .001)
*************************************************************
****create dummy variables******
tabulate state_id, generate(st)
xtscc lnee_pct reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret st1 st2 st3 st4 st5, fe
eststo m1
****models 020721****
******************************Delib*mandate***********************************************************************
*************** 1) DV:lnee_pct***************************************************************************************
xtscc lnee_pct reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m1
xtscc lnee_pct reg_authority mandate delib_exp citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m2
generate delib_exp_mandate = (delib_exp * mandate)
xtscc lnee_pct reg_authority mandate delib_exp delib_exp_mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m3
esttab m1 m2 m3, se star(* .1 ** .05 *** .001)
***DV: by ratepayer classes
xtscc lnee_inc_respc reg_authority mandate delib_exp delib_exp_mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m4
xtscc lnee_inc_compc reg_authority mandate delib_exp delib_exp_mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m5
xtscc lnee_inc_indpc reg_authority mandate delib_exp delib_exp_mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m6
esttab m1 m2 m3 m4 m5 m6, se star(* .1 ** .05 *** .001)
******************2) DV:retail sales********************************************************************************* 
xtscc lnretsales_pc reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m1
xtscc lnretsales_pc reg_authority mandate delib_exp citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m2
xtscc lnretsales_pc reg_authority mandate delib_exp delib_exp_mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m3
esttab m1 m2 m3, se star(* .1 ** .05 *** .001)
***DV: by ratepayer classes
xtscc lnressales_pc reg_authority mandate delib_exp delib_exp_mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m4
xtscc lncomsales_pc reg_authority mandate delib_exp delib_exp_mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m5
xtscc lnindsales_pc reg_authority mandate delib_exp delib_exp_mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m6
esttab m1 m2 m3 m4 m5 m6, se star(* .1 ** .05 *** .001)
***********************************formal*mandate*************************************************************
***********************1)DV:lnee_pct***************************************************************************************
xtscc lnee_pct reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m1
xtscc lnee_pct reg_authority mandate formal_exp citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m2
generate formal_exp_mandate = (formal_exp * mandate)
xtscc lnee_pct reg_authority mandate formal_exp formal_exp_mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m3
esttab m1 m2 m3, se star(* .1 ** .05 *** .001)
***DV: by ratepayer classes
xtscc lnee_inc_respc reg_authority mandate formal_exp formal_exp_mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m4
xtscc lnee_inc_compc reg_authority mandate formal_exp formal_exp_mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m5
xtscc lnee_inc_indpc reg_authority mandate formal_exp formal_exp_mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m6
esttab m1 m2 m3 m4 m5 m6, se star(* .1 ** .05 *** .001)
**********************2)DV: retails sales*********************************************************************************
xtscc lnretsales_pc reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m1
xtscc lnretsales_pc reg_authority mandate formal_exp citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m2
xtscc lnretsales_pc reg_authority mandate formal_exp formal_exp_mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m3
esttab m1 m2 m3, se star(* .1 ** .05 *** .001)
***DV: by ratepayer classes
xtscc lnressales_pc reg_authority mandate formal_exp formal_exp_mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m4
xtscc lncomsales_pc reg_authority mandate formal_exp formal_exp_mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m5
xtscc lnindsales_pc reg_authority mandate formal_exp formal_exp_mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m6
esttab m1 m2 m3 m4 m5 m6, se star(* .1 ** .05 *** .001)
***********************************************************************************************************************
gen lagg_tot_price = lag_tot_price[_n-1]
xtscc lnee_pct reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m1
xtscc lnee_pct reg_authority mandate citid pipc lag_lag_pop_na lag_lag_tot_price lnres_cust lntot_peak pct_ret $years, fe
eststo m2
*******************************************************************************************************************************************8
**********professional table*****************************************************************************
***ssc install asdoc*****install asdoc*********************************************
**********Table1***************energy saving DV & deliberation*************************
asdoc xtscc lnee_pct reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe save(aa) nest cnames(Total) stat(r2_a)
asdoc xtscc lnee_inc_respc reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe save (EE) nest cnames(residential) 
asdoc xtscc lnee_inc_compc reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe nest save (EE) cnames(commercial) 
asdoc xtscc lnee_inc_indpc reg_authority mandate citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe nest save (EE) cnames(industrial)




LA_dv_dummy=(0) incomp=(1) (mean)exclpop unoper=(0) polity=(0) (mean)gdp_ln (mean)pop_ln rebst=(-1) (mean)duration_ln (mean)btldeath_ln Med_Count=(0) gen_dummy=(0))

asdoc xtscc lnee_inc_respc delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Residential)
asdoc xtscc lnee_inc_compc delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Commercial)
asdoc xtscc lnee_inc_indpc delib_exp mandate delib_exp_mandate reg_authority citid pipc lag_pop_na lag_tot_price lnres_cust lntot_peak pct_ret $years, fe, save(Tab1) nest cnames(Industrial)
margins formal_exp#mandate, asbalanced
 
****************lag****************
Create lag (or lead) variables using subscripts.
        . gen lag1 = x[_n-1]
        . gen lag2 = x[_n-2]
        . gen lead1 = x[_n+1]
You can create lag (or lead) variables for different subgroups using the by prefix. For example,
        . sort state year 
        . by state: gen lag1 = x[_n-1]
If there are gaps in your records and you only want to lag successive years, you can specify
        . sort state year
        . by state: gen lag1 = x[_n-1] if year==year[_n-1]+1
See [D] egen for details on creating variables of moving averages.