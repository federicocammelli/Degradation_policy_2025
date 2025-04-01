
	clear
	set more off


	*study window
	global studywindow "YEAR>2010 & YEAR<2020"

	*tvar
	global tvar "l"

	*defvar
	global defvar "jrc_defrate"

	*degvar
	global degvar "jrc_degrate"

	*wvar 
	global wvar "mforestY_cal"
	global wvar2 "mforestY_cal2"
	
	*effects placebo
	global effects "5"
	global placebo "5"
	global placebo2 "2"



    * controls
	global control_lag1 "lTAC_Cp75dist_nw  lpa_per lzn_fines lSpriority_muni    lsoy50fix   yspei_mean  lcatvalue_ha  lsoyvalue_ha  "
		global control_lag2 "   yspei_mean     "


	**********************
	*****G4_____________
	**********************

***base and LUT	

forvalue i=1/2{

	clear mata
	mat EFF= J(1000,100,0)
	clear
use "C:\Users\fcammelli\Documents\Mshare2paper_RDNrun\data\a291024_postlut.dta"
	cd `"C:\Users\fcammelli\Documents\Mshare2paper_RDNrun\analysis_jrc_2024\results_spei\G4"'
	 xtset

	  gen G4_50=0
	 replace G4_50=1 if G4_Cp75dist_nw>  .3387604  // median if sum G4_Cp75dist_nw if YEAR>2009 & YEAR<2019, d
	 gen lG4_50=l.G4_50
	  gen G4_0=0
	 replace G4_0=1 if G4_Cp75dist_nw> 0
	  gen lG4_0=l.G4_0
	  gen G4_75=0
	 replace G4_75=1 if G4_Cp75dist_nw>   .5450495   // 75 pct if sum G4_Cp75dist_nw if YEAR>2009 & YEAR<2019, d
	 replace G4_75=. if G4_Cp75dist_nw<   .5450495  & G4_Cp75dist_nw>  .3387604
	 gen lG4_75=l.G4_75
	 

	
	keep if ${studywindow}


	bysort CODE: egen mforestY_cal=mean(tot_for2)
	bysort CODE: egen mforestY_cal2=mean(jrc_forest)




	 
	 ****************
	 *******Base
	 ****************
** deforestation
	 did_multiplegt_dyn  ${defvar}  CODE YEAR ${tvar}G4_0   ,   placebo(${placebo})  effects(${effects})       cluster(CODE)       weight(${wvar})  controls(${control_lag`i'} )   graphoptions(  title(LG4_on_def_0) xtitle(.) yline(0, lw(thin) ) xline(-1, lcolor(yellow)) graphregion(color(white)) ylabel(,  labsize(tiny) tlength(tiny)) xlabel(, labsize(tiny) tlength(tiny))  note(,size(vsmall))  legend(off) ) 
	 event_plot e(estimates)#e(variances),  graph_opt(xtitle("")  title("G4_0 on deforestation", size(vsmall)) xlabel(-${placebo}(1)${effects})   xline(-0.5, lcolor(gs8) lpattern(dash)) yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ylabel(, angle(horizontal))) stub_lag(Effect_#) stub_lead(Placebo_#) together  plottype(scatter) ciplottype(rcap) 
	gr save G4l1, replace
	
	mat EFF[4,1]= e(p_jointplacebo)
	mat EFF[4,2]=e(Av_tot_effect) 
	mat EFF[4,3]=2*(normal(-(abs(e(Av_tot_effect)/e(se_avg_total_effect)))))


	 did_multiplegt_dyn  ${defvar}  CODE YEAR ${tvar}G4_50  ,    placebo(${placebo})  effects(${effects}) cluster(CODE)    weight(${wvar})   controls(${control_lag`i'} ) graphoptions(  title(LG4_on_def_50) xtitle(.) yline(0, lw(thin) ) xline(-1, lcolor(yellow)) graphregion(color(white)) ylabel(,  labsize(tiny) tlength(tiny)) xlabel(, labsize(tiny) tlength(tiny))  note(,size(vsmall))  legend(off) ) 
	 event_plot e(estimates)#e(variances),  graph_opt(xtitle("")  title("G4_50 on deforestation", size(vsmall)) xlabel(-${placebo}(1)${effects})   xline(-0.5, lcolor(gs8) lpattern(dash)) yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ylabel(, angle(horizontal))) stub_lag(Effect_#) stub_lead(Placebo_#) together  plottype(scatter) ciplottype(rcap) 
	gr save G4l2, replace
	
	 
	mat EFF[4,4]= e(p_jointplacebo)
	mat EFF[4,5]=e(Av_tot_effect) 
	mat EFF[4,6]=2*(normal(-(abs(e(Av_tot_effect)/e(se_avg_total_effect)))))

	

	 did_multiplegt_dyn  ${defvar}   CODE YEAR ${tvar}G4_75  ,   placebo(${placebo2})  effects(${effects})     cluster(CODE)        weight(${wvar})  controls(${control_lag`i'} ) graphoptions(  title(LG4_on_def_75) xtitle(.) yline(0, lw(thin) ) xline(-1, lcolor(yellow)) graphregion(color(white)) ylabel(,  labsize(tiny) tlength(tiny)) xlabel(, labsize(tiny) tlength(tiny))  note(,size(vsmall))  legend(off) ) 
	 event_plot e(estimates)#e(variances),  graph_opt(xtitle("")  title("G4_75 on deforestation", size(vsmall)) xlabel(-${placebo}(1)${effects})   xline(-0.5, lcolor(gs8) lpattern(dash)) yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ylabel(, angle(horizontal))) stub_lag(Effect_#) stub_lead(Placebo_#) together  plottype(scatter) ciplottype(rcap) 
	gr save G4l3, replace

	
	mat EFF[4,7]= e(p_jointplacebo)
	mat EFF[4,8]=e(Av_tot_effect) 
	mat EFF[4,9]=2*(normal(-(abs(e(Av_tot_effect)/e(se_avg_total_effect)))))


	 

	
	***************degradation

	 did_multiplegt_dyn  ${degvar} CODE YEAR ${tvar}G4_0      ,   placebo(${placebo})  effects(${effects})       cluster(CODE)        weight(${wvar2})  controls(${control_lag`i'} )  graphoptions(  title(LG4_on_deg_0) xtitle(.) yline(0, lw(thin) ) xline(-1, lcolor(yellow)) graphregion(color(white)) ylabel(,  labsize(tiny) tlength(tiny)) xlabel(, labsize(tiny) tlength(tiny))  note(,size(vsmall))  legend(off) ) 
	 event_plot e(estimates)#e(variances),  graph_opt(xtitle("")  title("G4_0 on degradation", size(vsmall)) xlabel(-${placebo}(1)${effects})   xline(-0.5, lcolor(gs8) lpattern(dash)) yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ylabel(, angle(horizontal))) stub_lag(Effect_#) stub_lead(Placebo_#) together  plottype(scatter) ciplottype(rcap) 
	gr save G4l4, replace

	mat EFF[5,1]= e(p_jointplacebo)
	mat EFF[5,2]=e(Av_tot_effect) 
	mat EFF[5,3]=2*(normal(-(abs(e(Av_tot_effect)/e(se_avg_total_effect)))))


	 did_multiplegt_dyn  ${degvar} CODE YEAR ${tvar}G4_50     ,   placebo(${placebo})  effects(${effects})       cluster(CODE)        weight(${wvar2})  controls(${control_lag`i'} )   graphoptions(  title(LG4_on_deg_50) xtitle(.) yline(0, lw(thin) ) xline(-1, lcolor(yellow)) graphregion(color(white)) ylabel(,  labsize(tiny) tlength(tiny)) xlabel(, labsize(tiny) tlength(tiny))  note(,size(vsmall))  legend(off) ) 
	 event_plot e(estimates)#e(variances),  graph_opt(xtitle("")  title("G4_50 on degradation", size(vsmall)) xlabel(-${placebo}(1)${effects})   xline(-0.5, lcolor(gs8) lpattern(dash)) yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ylabel(, angle(horizontal))) stub_lag(Effect_#) stub_lead(Placebo_#) together  plottype(scatter) ciplottype(rcap) 
	gr save G4l5, replace
	
	
	mat EFF[5,4]= e(p_jointplacebo)
	mat EFF[5,5]=e(Av_tot_effect) 
	mat EFF[5,6]=2*(normal(-(abs(e(Av_tot_effect)/e(se_avg_total_effect)))))


	 did_multiplegt_dyn  ${degvar} CODE YEAR ${tvar}G4_75      ,   placebo(${placebo2})  effects(${effects})       cluster(CODE)        weight(${wvar2})  controls(${control_lag`i'} ) graphoptions(  title(LG4_on_deg_75) xtitle(.) yline(0, lw(thin) ) xline(-1, lcolor(yellow)) graphregion(color(white)) ylabel(,  labsize(tiny) tlength(tiny)) xlabel(, labsize(tiny) tlength(tiny))  note(,size(vsmall))  legend(off) ) 
	 event_plot e(estimates)#e(variances),  graph_opt(xtitle("")  title("G4_75 on degradation", size(vsmall)) xlabel(-${placebo}(1)${effects})   xline(-0.5, lcolor(gs8) lpattern(dash)) yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ylabel(, angle(horizontal))) stub_lag(Effect_#) stub_lead(Placebo_#) together  plottype(scatter) ciplottype(rcap) 
	gr save G4l6, replace
	
	mat EFF[5,7]= e(p_jointplacebo)
	mat EFF[5,8]=e(Av_tot_effect) 
	mat EFF[5,9]=2*(normal(-(abs(e(Av_tot_effect)/e(se_avg_total_effect)))))
	 


	 
	**************degradation controlling for deforestation

	 did_multiplegt_dyn  ${degvar} CODE YEAR ${tvar}G4_0  ,   placebo(${placebo})  effects(${effects})       cluster(CODE)       weight(${wvar2})   controls(${control_lag`i'} ${defvar} ) graphoptions(  title(LG4_on_degCdef_0) xtitle(.) yline(0, lw(thin) ) xline(-1, lcolor(yellow)) graphregion(color(white)) ylabel(,  labsize(tiny) tlength(tiny)) xlabel(, labsize(tiny) tlength(tiny))  note(,size(vsmall))  legend(off) ) 
	 event_plot e(estimates)#e(variances),  graph_opt(xtitle("")  title("G4_0 on degradation net of deforestation", size(vsmall)) xlabel(-${placebo}(1)${effects})   xline(-0.5, lcolor(gs8) lpattern(dash)) yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ylabel(, angle(horizontal))) stub_lag(Effect_#) stub_lead(Placebo_#) together  plottype(scatter) ciplottype(rcap) 
		gr save G4l7, replace
	
	mat EFF[6,1]= e(p_jointplacebo)
	mat EFF[6,2]=e(Av_tot_effect) 
	mat EFF[6,3]=2*(normal(-(abs(e(Av_tot_effect)/e(se_avg_total_effect)))))


	 did_multiplegt_dyn  ${degvar} CODE YEAR ${tvar}G4_50    ,   placebo(${placebo})  effects(${effects})       cluster(CODE)        weight(${wvar2})  controls(${control_lag`i'} ${defvar} ) graphoptions(  title(LG4_on_degCdef_50) xtitle(.) yline(0, lw(thin) ) xline(-1, lcolor(yellow)) graphregion(color(white)) ylabel(,  labsize(tiny) tlength(tiny)) xlabel(, labsize(tiny) tlength(tiny))  note(,size(vsmall))  legend(off) ) 
	 event_plot e(estimates)#e(variances),  graph_opt(xtitle("")  title("G4_50 on degradation net of deforestation", size(vsmall)) xlabel(-${placebo}(1)${effects})   xline(-0.5, lcolor(gs8) lpattern(dash)) yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ylabel(, angle(horizontal))) stub_lag(Effect_#) stub_lead(Placebo_#) together  plottype(scatter) ciplottype(rcap) 
		gr save G4l8, replace
	
	mat EFF[6,4]= e(p_jointplacebo)
	mat EFF[6,5]=e(Av_tot_effect) 
	mat EFF[6,6]=2*(normal(-(abs(e(Av_tot_effect)/e(se_avg_total_effect)))))


	 did_multiplegt_dyn  ${degvar} CODE YEAR ${tvar}G4_75   ,   placebo(${placebo2})  effects(${effects})       cluster(CODE)        weight(${wvar2})  controls(${control_lag`i'} ${defvar} ) graphoptions(  title(LG4_on_degCdef_75) xtitle(.) yline(0, lw(thin) ) xline(-1, lcolor(yellow)) graphregion(color(white)) ylabel(,  labsize(tiny) tlength(tiny)) xlabel(, labsize(tiny) tlength(tiny))  note(,size(vsmall))  legend(off) ) 
	 event_plot e(estimates)#e(variances),  graph_opt(xtitle("")  title("G4_75 on degradation net of deforestation", size(vsmall)) xlabel(-${placebo}(1)${effects})   xline(-0.5, lcolor(gs8) lpattern(dash)) yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ylabel(, angle(horizontal))) stub_lag(Effect_#) stub_lead(Placebo_#) together  plottype(scatter) ciplottype(rcap) 
		gr save G4l9, replace
	
	mat EFF[6,7]= e(p_jointplacebo)
	mat EFF[6,8]=e(Av_tot_effect) 
	mat EFF[6,9]=2*(normal(-(abs(e(Av_tot_effect)/e(se_avg_total_effect)))))





	 gr combine G4l1.gph G4l2.gph G4l3.gph G4l4.gph G4l5.gph G4l6.gph G4l7.gph G4l8.gph G4l9.gph, graphregion(color(white)) 
	 graph export "...\G4\lagged G4_v2_`i'_${effects}.emf", as(emf) name("Graph") replace



	 
*******************************************
	*********LAND USE NON PARAMETRIC TRENDS
*******************************************
	 **************** Deforestation

	 did_multiplegt_dyn  ${defvar}   CODE YEAR ${tvar}G4_0   ,   placebo(${placebo})  effects(${effects})       cluster(CODE)        weight(${wvar})  controls(${control_lag`i'}  )   trends_nonparam(share_agropec_10)   graphoptions(  title(LG4_on_def_0) xtitle(.) yline(0, lw(thin) ) xline(-1, lcolor(yellow)) graphregion(color(white)) ylabel(,  labsize(tiny) tlength(tiny)) xlabel(, labsize(tiny) tlength(tiny))  note(,size(vsmall))  legend(off) ) 
	 event_plot e(estimates)#e(variances),  graph_opt(xtitle("")  title("G4_0 on deforestation", size(vsmall)) xlabel(-${placebo}(1)${effects})   xline(-0.5, lcolor(gs8) lpattern(dash)) yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ylabel(, angle(horizontal))) stub_lag(Effect_#) stub_lead(Placebo_#) together  plottype(scatter) ciplottype(rcap) 
		gr save G4l1, replace
	
	mat EFF[11,1]= e(p_jointplacebo)
	mat EFF[11,2]=e(Av_tot_effect) 
	mat EFF[11,3]=2*(normal(-(abs(e(Av_tot_effect)/e(se_avg_total_effect)))))


	 did_multiplegt_dyn  ${defvar}  CODE YEAR ${tvar}G4_50   ,   placebo(${placebo})  effects(${effects})       cluster(CODE)        weight(${wvar})  controls(${control_lag`i'}  )     trends_nonparam(share_agropec_10)    graphoptions(  title(LG4_on_def_50) xtitle(.) yline(0, lw(thin) ) xline(-1, lcolor(yellow)) graphregion(color(white)) ylabel(,  labsize(tiny) tlength(tiny)) xlabel(, labsize(tiny) tlength(tiny))  note(,size(vsmall))  legend(off) )    
	 event_plot e(estimates)#e(variances),  graph_opt(xtitle("")  title("G4_50 on deforestation", size(vsmall)) xlabel(-${placebo}(1)${effects})   xline(-0.5, lcolor(gs8) lpattern(dash)) yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ylabel(, angle(horizontal))) stub_lag(Effect_#) stub_lead(Placebo_#) together  plottype(scatter) ciplottype(rcap) 
		gr save G4l2, replace
	
	mat EFF[11,4]= e(p_jointplacebo)
	mat EFF[11,5]=e(Av_tot_effect) 
	mat EFF[11,6]=2*(normal(-(abs(e(Av_tot_effect)/e(se_avg_total_effect)))))


	 did_multiplegt_dyn  ${defvar}  CODE YEAR ${tvar}G4_75    ,   placebo(${placebo2})  effects(${effects})       cluster(CODE)        weight(${wvar})  controls(${control_lag`i'}  )      trends_nonparam(share_agropec_10)   graphoptions(  title(LG4_on_def_75) xtitle(.) yline(0, lw(thin) ) xline(-1, lcolor(yellow)) graphregion(color(white)) ylabel(,  labsize(tiny) tlength(tiny)) xlabel(, labsize(tiny) tlength(tiny))  note(,size(vsmall))  legend(off) )     
	 event_plot e(estimates)#e(variances),  graph_opt(xtitle("")  title("G4_75 on deforestation", size(vsmall)) xlabel(-${placebo}(1)${effects})   xline(-0.5, lcolor(gs8) lpattern(dash)) yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ylabel(, angle(horizontal))) stub_lag(Effect_#) stub_lead(Placebo_#) together  plottype(scatter) ciplottype(rcap) 
	mat EFF[11,7]= e(p_jointplacebo)
	mat EFF[11,8]=e(Av_tot_effect) 
	mat EFF[11,9]=2*(normal(-(abs(e(Av_tot_effect)/e(se_avg_total_effect)))))
	 	gr save G4l3, replace
	



	****************degradation

	 did_multiplegt_dyn  ${degvar} CODE YEAR ${tvar}G4_0   ,   placebo(${placebo})  effects(${effects})       cluster(CODE)       weight(${wvar2})   controls(${control_lag`i'}  )   trends_nonparam(share_agropec_10)    graphoptions(  title(LG4_on_deg_0) xtitle(.) yline(0, lw(thin) ) xline(-1, lcolor(yellow)) graphregion(color(white)) ylabel(,  labsize(tiny) tlength(tiny)) xlabel(, labsize(tiny) tlength(tiny))  note(,size(vsmall))  legend(off) )    
	 event_plot e(estimates)#e(variances),  graph_opt(xtitle("")  title("G4_0 on degradation", size(vsmall)) xlabel(-${placebo}(1)${effects})   xline(-0.5, lcolor(gs8) lpattern(dash)) yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ylabel(, angle(horizontal))) stub_lag(Effect_#) stub_lead(Placebo_#) together  plottype(scatter) ciplottype(rcap)
	 	gr save G4l4, replace
	
	mat EFF[12,1]= e(p_jointplacebo)
	mat EFF[12,2]=e(Av_tot_effect) 
	mat EFF[12,3]=2*(normal(-(abs(e(Av_tot_effect)/e(se_avg_total_effect)))))


	 did_multiplegt_dyn  ${degvar} CODE YEAR ${tvar}G4_50    ,   placebo(${placebo})  effects(${effects})       cluster(CODE)       weight(${wvar2})   controls(${control_lag`i'}  )    trends_nonparam(share_agropec_10)   graphoptions(  title(LG4_on_deg_50) xtitle(.) yline(0, lw(thin) ) xline(-1, lcolor(yellow)) graphregion(color(white)) ylabel(,  labsize(tiny) tlength(tiny)) xlabel(, labsize(tiny) tlength(tiny))  note(,size(vsmall))  legend(off) )      
	 event_plot e(estimates)#e(variances),  graph_opt(xtitle("")  title("G4_50 on degradation", size(vsmall)) xlabel(-${placebo}(1)${effects})   xline(-0.5, lcolor(gs8) lpattern(dash)) yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ylabel(, angle(horizontal))) stub_lag(Effect_#) stub_lead(Placebo_#) together  plottype(scatter) ciplottype(rcap)
	 	gr save G4l5, replace
	
	mat EFF[12,4]= e(p_jointplacebo)
	mat EFF[12,5]=e(Av_tot_effect) 
	mat EFF[12,6]=2*(normal(-(abs(e(Av_tot_effect)/e(se_avg_total_effect)))))


	 did_multiplegt_dyn  ${degvar} CODE YEAR ${tvar}G4_75     ,   placebo(${placebo2})  effects(${effects})       cluster(CODE)        weight(${wvar2})  controls(${control_lag`i'}  )     trends_nonparam(share_agropec_10) graphoptions(  title(LG4_on_deg_75) xtitle(.) yline(0, lw(thin) ) xline(-1, lcolor(yellow)) graphregion(color(white)) ylabel(,  labsize(tiny) tlength(tiny)) xlabel(, labsize(tiny) tlength(tiny))  note(,size(vsmall))  legend(off) )        
	 event_plot e(estimates)#e(variances),  graph_opt(xtitle("")  title("G4_75 on degradation", size(vsmall)) xlabel(-${placebo}(1)${effects})   xline(-0.5, lcolor(gs8) lpattern(dash)) yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ylabel(, angle(horizontal))) stub_lag(Effect_#) stub_lead(Placebo_#) together  plottype(scatter) ciplottype(rcap)
	 	gr save G4l6, replace
	
	mat EFF[12,7]= e(p_jointplacebo)
	mat EFF[12,8]=e(Av_tot_effect) 
	mat EFF[12,9]=2*(normal(-(abs(e(Av_tot_effect)/e(se_avg_total_effect)))))
	 

	 
	**************degradation controlling for deforestation


	 did_multiplegt_dyn  ${degvar} CODE YEAR ${tvar}G4_0 ,   placebo(${placebo})  effects(${effects})       cluster(CODE)       weight(${wvar2})   controls(${control_lag`i'}  ${defvar} )    trends_nonparam(share_agropec_10) graphoptions(  title(LG4_on_degCdef_0) xtitle(.) yline(0, lw(thin) ) xline(-1, lcolor(yellow)) graphregion(color(white)) ylabel(,  labsize(tiny) tlength(tiny)) xlabel(, labsize(tiny) tlength(tiny))  note(,size(vsmall))  legend(off) )  
	 event_plot e(estimates)#e(variances),  graph_opt(xtitle("")  title("G4_0 on degradation net of deforestation", size(vsmall)) xlabel(-${placebo}(1)${effects})   xline(-0.5, lcolor(gs8) lpattern(dash)) yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ylabel(, angle(horizontal))) stub_lag(Effect_#) stub_lead(Placebo_#) together  plottype(scatter) ciplottype(rcap)
	 	gr save G4l7, replace
	
	mat EFF[13,1]= e(p_jointplacebo)
	mat EFF[13,2]=e(Av_tot_effect) 
	mat EFF[13,3]=2*(normal(-(abs(e(Av_tot_effect)/e(se_avg_total_effect)))))


	 did_multiplegt_dyn  ${degvar} CODE YEAR ${tvar}G4_50  ,   placebo(${placebo})  effects(${effects})       cluster(CODE)       weight(${wvar2})   controls(${control_lag`i'}  ${defvar} )    trends_nonparam(share_agropec_10) graphoptions(  title(LG4_on_degCdef_50) xtitle(.) yline(0, lw(thin) ) xline(-1, lcolor(yellow)) graphregion(color(white)) ylabel(,  labsize(tiny) tlength(tiny)) xlabel(, labsize(tiny) tlength(tiny))  note(,size(vsmall))  legend(off) ) 
	 event_plot e(estimates)#e(variances),  graph_opt(xtitle("")  title("G4_50 on degradation net of deforestation", size(vsmall)) xlabel(-${placebo}(1)${effects})   xline(-0.5, lcolor(gs8) lpattern(dash)) yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ylabel(, angle(horizontal))) stub_lag(Effect_#) stub_lead(Placebo_#) together  plottype(scatter) ciplottype(rcap)
	 	gr save G4l8, replace
	
	mat EFF[13,4]= e(p_jointplacebo)
	mat EFF[13,5]=e(Av_tot_effect) 
	mat EFF[13,6]=2*(normal(-(abs(e(Av_tot_effect)/e(se_avg_total_effect)))))


	 did_multiplegt_dyn  ${degvar} CODE YEAR ${tvar}G4_75  ,   placebo(${placebo2})  effects(${effects})       cluster(CODE)        weight(${wvar2})  controls(${control_lag`i'}  ${defvar} )       trends_nonparam(share_agropec_10)      graphoptions(  title(LG4_on_degCdef_75) xtitle(.) yline(0, lw(thin) ) xline(-1, lcolor(yellow)) graphregion(color(white)) ylabel(,  labsize(tiny) tlength(tiny)) xlabel(, labsize(tiny) tlength(tiny))  note(,size(vsmall))  legend(off) ) 
	 event_plot e(estimates)#e(variances),  graph_opt(xtitle("")  title("G4_75 on degradation net of deforestation", size(vsmall)) xlabel(-${placebo}(1)${effects})   xline(-0.5, lcolor(gs8) lpattern(dash)) yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ylabel(, angle(horizontal))) stub_lag(Effect_#) stub_lead(Placebo_#) together  plottype(scatter) ciplottype(rcap)
	 	gr save G4l9, replace
	
	mat EFF[13,7]= e(p_jointplacebo)
	mat EFF[13,8]=e(Av_tot_effect) 
	mat EFF[13,9]=2*(normal(-(abs(e(Av_tot_effect)/e(se_avg_total_effect)))))





	

	gr combine G4l1.gph G4l2.gph G4l3.gph G4l4.gph G4l5.gph G4l6.gph G4l7.gph G4l8.gph G4l9.gph, graphregion(color(white)) 
	 graph export "...\G4\lagged G4_v2_lufe_`i'_${effects}.emf", as(emf) name("Graph") replace


	putexcel set "...\G4\G4_`i'_${effects}.xlsx", sheet("didm") replace
	putexcel A1=matrix(EFF)
	 
	 
	 }
