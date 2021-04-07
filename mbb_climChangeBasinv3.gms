*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
$ontext
   Basin Integrated Model (residential + ag)

   Name      :   mbb_climChangBasin.gms
   Purpose   :   Integrated Model (SWAT + Ag) (PMP)
   Author    :   R Ponce, F Fernandez, E Arias (alias el prince)
   Date      :   06.08.19
   Since     :   January 2011
   CalledBy  :

   Notes     :

$offtext
$onmulti;
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*                         INCLUDE SETS AND BASE DATA                           *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
$include basedata\load_baseData.gms
;
parameter test; test=sum(c,tland(c));

*~~~~~~~~~~~~~~~~~~~~~~~~ BASEYEAR DATA    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*   ---- definition of current activities in each IS
map_cas(c,a,s)= yes$X0(c,a,s);

*   ---- calibration parameters
$gdxin basedata\cparBasinV3.gdx
$load  cpar
$gdxin

ALPHA(c,a,s)$map_cas(c,a,s)= cpar(c,a,s,'alpha','w_e');
BETA(c,a,s)$map_cas(c,a,s) = cpar(c,a,s,'beta','w_e');

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*            PMP MODEL                                                        *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
$include 'b1_coreModelBasinv3.gms'
;

* consider only potential activities
X.fx(c,a,s)$(not map_cas(c,a,s)) = 0;


* bounds on variables
PS.fx(a) = ps0(a)  ;
RW_price.fx(c) = RW_price0(c);
PV.lo(c) = 1;
RW.lo(c)=1;
RW_cc.lo(c)=1;

parameter Comm_Report       'Land Allocated per activity and System:Commune Level'
          Basin_Report       'Land Allocated per activity and System:Basin Level'
          res_totAreaComm   'Total Land Allocated per System: Commune Level'
          res_totAreaReg    'Total Land Allocated per System: Regional Level'
          res_prodComm      'Production per activty: Commune Level'
          res_prodCommagg   'Production per activty type: Commune Level'
          res_prodReg       'Production per activty: Regional Level'
          res_prodRegagg    'Production per activty type: Regional Level'
          LabReportComm     'Labor demand per activity (workers/year): Commune Level'
          LabReportReg      'Labor demand per activity (workers/year): Regional Level'
          LabReportCommagg  'Labor demand per agg activity (workers/year): Commune Level'
          LabReportRegagg   'Labor demand per agg activity (workers/year): Regional Level'
          AvCosts           'Costs per activity MM$'
          totincome         'total income MM$'
          totincomeDiff_pct  'total income diff sim and BL %'
          totsurplus        'total surplus MM$'
          totsurplusDiff_pct 'total surplus diff sim and BL %'
          totCS             'total consumer surplus MM$'
          totCSDiff_pct     'total consumer surplus diff sim and BL %'
          Income_Comm       'Income level by commune MM$'
          Income_CommDiff   'Income level by commune MM$ sim and BL'
          Income_CommDiff_pct 'Income level by commune % sim and BL'
          Cons_Surplus      'consumer surplus by commune MM$'
          Cons_SurplusDiff  'consumer surplus Difference MM$ btwn simulation and BL'
          Cons_SurplusDiff_pct 'consumer surplus Difference % btwn simulation and BL'
          Income_Commagg    'Aggregated Income level by commune MM$'
          Income_Reg        'Income Level by Region MM$'
          Income_Regagg     'Aggregated Income level by Region MM$'
          Income_Act        'net income by activity MM$'
          Income_ActDiff    'Difference in net income by activity MM$ Simulation and BL'
          Income_ActDiff_pct'Difference in net income by activity % Simulation and BL'
          Income_Act_Comm    'net income by activity and commune MM$'
          Income_Act_CommDiff 'Difference in net income by activity and commune MM$ Simulation and BL'
          Income_Act_CommDiff_pct 'Difference btwn net income by activity and commune % Simulation and BL'
          Income_Act_CommSys   'net income by activity, commune, and system MM$'
          Cost                 'cost per activity (MM$/ha)'
          Income_Act_Reg     'Net income by activity and region MM$'
          GM_act            'Gross Margin by activity and system MM$'
          Water_endw        'Water endowment (River)Mm3 (DW0)'
          Water_Avlble      'Water Available in each commmune Mm3 (DW0 + WNU)'
          AgWateract        'Water used fir*x '
          AgWateractDiff      'Water used by activity diff wrt BL (Mm3) '
          AgWateractDiff_pct  'Water used by activity diff wrt BL (%) '
          Ag_WaterUse2       'FW4.L'
          AgWaterDiff       'Differences btwn (Mm3) simulation and BL'
          AgWaterDiff_pct    'Differences btwn (%) simulation and BL'
          Res_WaterUse1      "Res water use RW.l(c)*12*households(c)"
          Res_WaterUse2      "FW3.L"
          Res_WaterUseDiff   'FW3.L Differences btwn simulation and BL (m3) '
          Res_WaterUseDiff_pct'FW3.L Differences btwn simulation and BL (%) '
          ResWater            'Residential water demand (m3)RW.L'
          ResWaterDiff        'RW.L Differences (m3) btwn simulation and BL'
          ResWaterDiff_pct     'RW.L Differences (%) btwn simulation and BL'
          ResWaterCC            'Residential water demand (m3)RW_CC.L'
          ResWaterDiffCC        'RW_CC.L Differences (m3) btwn simulation and BL'
          ResWaterDiffCC_pct     'RW_CC.L Differences (%) btwn simulation and BL'
          ChangeRW              'RW.L-RW_CC.L Differences (m3)'
          ChangeRW_pct           'RW.L-RW_CC.L Differences (%)'
          totwateruse1       'Ag_WaterUse1 + ResWater1'
          totwateruse2       'FW2.L'
          totwateruse2Diff_pct 'Difference in total water use FW2.L % sim and BL'
          WaterNU          'Water not used (WNU2.l)MM3'
          wprice             'water price (FW4)'
          AgWat0           'Agricultural Water use X0'
          ResWat0            'Residential Water Use RW0'
          RWAlpha              'Residential water demand constant term'
          HouseholdCS         "CS Household level"
          Pvirtual            "Virtual price"
;

Comm_report(c,a,s,'x0') = X0(c,a,s);
AgWat0(c) = sum(a$map_cas(c,a,'irr'), fir(c,a,'irr')*X0(c,a,'irr')) ;
ResWat0(c) = RW0_agg(c);

model PMP_we_0 PMP model/
   CoreModel
   e_ts
   e_totcs
   e_CS
   e_RW
   e_RW_cc
   e_RWAlpha
   e_RWP
   e_PV
   e_cost_NLP

 /;

option limrow  =  10;
solve PMP_we_0 using nlp maximizing TS;



*****main indications of model pefomance:land calibration(X) and Res demand Calibration(RW)******
Comm_report(c,a,s,'BL')  = X.l(c,a,s);
Comm_report(c,a,s,'diff_X0-BL') = Comm_report(c,a,s,'x0')- Comm_report(c,a,s,'BL');
Comm_report(c,'area',s,'BL')  = sum(a,X.l(c,a,s));
Comm_report(c,'area','total','BL') = sum((a,s),X.l(c,a,s));
Comm_report(c,'iarea','irr','BL') =   IL.l(c);

Basin_report('irr','BL') = sum ((c,a),X.l(c,a,'irr'));


ResWater (c,'BL') = RW.L(c);
ResWaterDiff (c, 'BL') =   ResWater (c,'BL')- RW0(c);
ResWaterDiff_pct (c, 'BL')=   [[ResWater (c,'BL')- RW0(c)]/RW0(c)]*100;

ResWaterCC (c,'BL') = RW_CC.L(c);
ResWaterDiffCC (c, 'BL') =   ResWaterCC (c,'BL')- ResWater (c,'BL');
ResWaterDiffCC_pct (c, 'BL')=   [[ResWaterCC (c,'BL')- ResWater (c,'BL')]/ResWater (c,'BL')]*100;

ChangeRW (c,'BL') = ResWater (c,'BL')- ResWaterCC (c,'BL');
ChangeRW_pct(c,'BL') = [ResWater (c,'BL')- ResWaterCC (c,'BL')]/ResWater (c,'BL');

AgWateract (c,a,'irr','BL') = fir(c,a,'irr')*X.l(c,a,'irr');

*Ag_WaterUse1 (c,'BL') = sum(a$map_cas(c,a,'irr'), fir(c,a,'irr')*X.l(c,a,'irr'))  ;
Ag_WaterUse2 (c,'BL') =  FW4.l(c);
*AgWaterDiff (c, 'BL') = Ag_WaterUse1 (c,'BL') -  Ag_WaterUse2 (c,'BL');
*AgWaterDiff_pct (c, 'BL') = [[Ag_WaterUse2 (c,'BL')- Ag_WaterUse1 (c,'BL')]/Ag_WaterUse1 (c,'BL')]*100;
*Res_WaterUse1 (c,'BL') =  RW.l(c)*12*households(c);
Res_WaterUse2 (c,'BL') =  FW3.l(c);
*Res_WaterUse3 (c,'BL') =  Res_WaterUse1 (c,'BL') - Res_WaterUse2 (c,'BL');
totwateruse2 (c,'BL') = FW2.l(c);

totincome('BL')= z.l;
totCS('BL')= TCS.l;
totsurplus('BL') = TS.L;

Income_Comm(c,'BL') = Zc.l(c);
Cons_Surplus(c,'BL') = CS.l(c);

parameter TSc;
TSc(c,'BL')= Zc.l(c) + CS.l(c);


Cons_SurplusDiff(c,'BL') = Cons_Surplus(c,'BL')-CS0(c);


WaterNU(c,'BL')= WNU2.l(c);

Income_Act(a,'BL') = sum((c,s), yld(c,a,s)*ps0(a)*X.l(c,a,s)) - sum((c,s), AC.l(c,a,s)*X.l(c,a,s));
Income_Act_Comm(c,a,'BL')= sum(s,yld(c,a,s)*ps0(a)*X.l(c,a,s)) - sum(s,AC.l(c,a,s)*X.l(c,a,s));
Income_Act_CommSys(c,a,s,'BL')= (yld(c,a,s)*ps0(a)*X.l(c,a,s)) - (AC.l(c,a,s)*X.l(c,a,s));
Cost(c,a,s,'BL') = AC.L(C,a,s);
display Comm_report, ResWaterDiff_pct, Cons_SurplusDiff;
*$exit;


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*             Climate Change scenario 1: new temperature                       *
*                                                                              *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*



parameter temp_ori    ;

temp_ori(c) = temp(c);

temp(c) = temp_ori(c) * (1.09);


solve PMP_we_0 using nlp maximizing TS;

Comm_report(c,a,s,'CC1')  = X.l(c,a,s);
Comm_report(c,a,s,'diff_CC1-BL') = Comm_report(c,a,s,'CC1') - Comm_report(c,a,s,'BL');
Comm_report(c,'area',s,'CC1')  = sum(a,X.l(c,a,s));
Comm_report(c,'area','total','CC1') = sum((a,s),X.l(c,a,s));
Comm_report(c,'iarea','irr','CC1') =   IL.l(c);
Comm_report(c,'iarea','irr','diff_CC1-BL%') =
                                 [[Comm_report(c,'iarea','irr','CC1')-Comm_report(c,'iarea','irr','BL')]/Comm_report(c,'iarea','irr','BL')]*100;

Basin_report('irr','CC1') = sum ((c,a),X.l(c,a,'irr'));

ResWater (c,'CC1') = RW.L(c);
ResWaterDiff (c, 'CC1') =   ResWater (c,'CC1')- ResWater (c,'BL');
ResWaterDiff_pct (c, 'CC1')=   [[ResWater (c,'CC1')- ResWater (c,'BL')]/ResWater (c,'BL')]*100;

ResWaterCC (c,'CC1') = RW_CC.L(c);
ResWaterDiffCC (c, 'CC1') =   ResWaterCC (c,'CC1')- ResWaterCC (c,'BL');
ResWaterDiffCC_pct (c, 'CC1')=   [[ResWaterCC (c,'CC1')- ResWaterCC (c,'BL')]/ResWaterCC (c,'BL')]*100;

ChangeRW (c,'CC1') = ResWater (c,'CC1')- ResWaterCC (c,'CC1');
ChangeRW_pct(c,'CC1') = [ResWater (c,'CC1')- ResWaterCC (c,'CC1')]/ResWater (c,'CC1');

AgWateract (c,a,'irr','CC1') = fir(c,a,'irr')*X.l(c,a,'irr');
AgWateractDiff (c,a,'irr','CC1') =AgWateract (c,a,'irr','CC1') - AgWateract (c,a,'irr','BL') ;
AgWateractDiff_pct (c,a,'irr','CC1')$(AgWateract (c,a,'irr','BL') gt 0) =
                                                     (AgWateract (c,a,'irr','CC1') - AgWateract (c,a,'irr','BL'))/AgWateract (c,a,'irr','BL') ;

*Ag_WaterUse1 (c,'BL') = sum(a$map_cas(c,a,'irr'), fir(c,a,'irr')*X.l(c,a,'irr'))  ;
Ag_WaterUse2 (c,'CC1') =  FW4.l(c);
AgWaterDiff (c, 'CC1') = Ag_WaterUse2 (c,'CC1') - Ag_WaterUse2 (c,'BL');
AgWaterDiff_pct (c, 'CC1') = [[Ag_WaterUse2 (c,'CC1') - Ag_WaterUse2 (c,'BL')]/Ag_WaterUse2 (c,'BL')]*100;

*Res_WaterUse1 (c,'BL') =  RW.l(c)*12*households(c);
Res_WaterUse2 (c,'CC1') =  FW3.l(c);
Res_WaterUseDiff (c,'CC1') =  Res_WaterUse2 (c,'CC1')- Res_WaterUse2 (c,'BL') ;
Res_WaterUseDiff_pct (c,'CC1') =  [[Res_WaterUse2 (c,'CC1')- Res_WaterUse2 (c,'BL')]/Res_WaterUse2 (c,'BL')]*100 ;
totwateruse2 (c,'CC1') = FW2.l(c);
totwateruse2Diff_pct (c,'CC1') = [[totwateruse2 (c,'CC1') - totwateruse2 (c,'BL')]/totwateruse2 (c,'BL')]*100;

totincome('CC1')= z.l;
totincomeDiff_pct('CC1') = [[totincome('CC1')-totincome('BL')]/totincome('BL')]*100;
totCS('CC1')= TCS.l;
totCSDiff_pct('CC1')= [[totCS('CC1')- totCS('BL')]/totCS('BL')]*100; ;
totsurplus('CC1') = TS.L;
totsurplusDiff_pct('CC1') = [[totsurplus('CC1')- totsurplus('BL')]/totsurplus('BL')]*100;

TSc(c,'CC1')= Zc.l(c) + CS.l(c);

Income_Comm(c,'CC1') = Zc.l(c);
Income_CommDiff (c,'CC1') = Income_Comm(c,'CC1')-Income_Comm(c,'BL') ;
Income_CommDiff_pct(c,'CC1')= [[Income_Comm(c,'CC1')-Income_Comm(c,'BL')]/Income_Comm(c,'BL')]*100 ;
Cons_Surplus(c,'CC1') = CS.l(c);
Cons_SurplusDiff(c,'CC1') = Cons_Surplus(c,'CC1')-Cons_Surplus(c,'BL');
Cons_SurplusDiff_pct(c,'CC1') = [[Cons_Surplus(c,'CC1')-Cons_Surplus(c,'BL')]/Cons_Surplus(c,'BL')]*100;


WaterNU(c,'CC1')= WNU2.l(c);

Income_Act(a,'CC1') = sum((c,s), yld(c,a,s)*ps0(a)*X.l(c,a,s)) - sum((c,s), AC.l(c,a,s)*X.l(c,a,s));
Income_ActDiff(a,'CC1') = Income_Act(a,'CC1') - Income_Act(a,'BL');
Income_ActDiff_pct(a,'CC1')$(Income_Act(a,'BL') gt 0) = [[Income_Act(a,'CC1') - Income_Act(a,'BL')]/Income_Act(a,'BL')]*100;

Income_Act_Comm(c,a,'CC1')= sum(s,yld(c,a,s)*ps0(a)*X.l(c,a,s)) - sum(s,AC.l(c,a,s)*X.l(c,a,s));
Income_Act_CommDiff(c,a,'CC1')= Income_Act_Comm(c,a,'CC1')-Income_Act_Comm(c,a,'BL') ;
Income_Act_CommDiff_pct(c,a,'CC1')$(Income_Act_Comm(c,a,'BL') gt 0) = [[Income_Act_Comm(c,a,'CC1')-Income_Act_Comm(c,a,'BL')]/Income_Act_Comm(c,a,'BL')]*100 ;
Cost(c,a,s,'CC1') = AC.L(C,a,s);
Income_Act_CommSys(c,a,s,'CC1')= (yld(c,a,s)*ps0(a)*Comm_report(c,a,s,'CC1')) - (Cost(c,a,s,'CC1')*X.l(c,a,s));

display Comm_report,Basin_report, ResWater,ResWaterDiff,ResWaterDiff_pct,ResWaterCC,ResWaterDiffCC,ResWaterDiffCC_pct,ChangeRW, ChangeRW_pct,AgWateract,AgWateractDiff
AgWateractDiff_pct, Ag_WaterUse2,  AgWaterDiff,AgWaterDiff_pct, Res_WaterUse2, Res_WaterUseDiff,Res_WaterUseDiff_pct, totwateruse2, totwateruse2Diff_pct,totincome,
totincomeDiff_pct,totCS,totCSDiff_pct,totsurplus,totsurplusDiff_pct,Income_Comm,Income_CommDiff,Income_CommDiff_pct,Cons_Surplus,Cons_SurplusDiff,
Cons_SurplusDiff_pct, WaterNU,Income_Act,Income_ActDiff,Income_ActDiff_pct,Income_Act_Comm,Income_Act_CommDiff,Income_Act_CommDiff_pct, Cost, Income_Act_CommSys     ;
option decimals=8;
*$exit;



*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*             Climate Change scenario 2: new temperature, new DW               *
*                                                                              *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*

parameter DW0_Initial;

DW0_Initial(c) = DW0(C);

DW0(C) = DWCh(c);


solve PMP_we_0 using nlp maximizing TS;

*$exit;

Comm_report(c,a,s,'CC2')  = X.l(c,a,s);
Comm_report(c,a,s,'diff_CC2-BL') = Comm_report(c,a,s,'CC2') - Comm_report(c,a,s,'BL');
Comm_report(c,'area',s,'CC2')  = sum(a,X.l(c,a,s));
Comm_report(c,'area','total','CC2') = sum((a,s),X.l(c,a,s));
Comm_report(c,'iarea','irr','CC2') =   IL.l(c);
Comm_report(c,'iarea','irr','diff_CC2-BL%') =
                                 [[Comm_report(c,'iarea','irr','CC2')-Comm_report(c,'iarea','irr','BL')]/Comm_report(c,'iarea','irr','BL')]*100;

Basin_report('irr','CC2') = sum ((c,a),X.l(c,a,'irr'));

ResWater (c,'CC2') = RW.L(c);
ResWaterDiff (c, 'CC2') =   ResWater (c,'CC2')- ResWater (c,'BL');
ResWaterDiff_pct (c, 'CC2')=   [[ResWater (c,'CC2')- ResWater (c,'BL')]/ResWater (c,'BL')]*100;

ResWaterCC (c,'CC2') = RW_CC.L(c);
ResWaterDiffCC (c, 'CC2') =   ResWaterCC (c,'CC2')- ResWaterCC (c,'BL');
ResWaterDiffCC_pct (c, 'CC2')=   [[ResWaterCC (c,'CC2')- ResWaterCC (c,'BL')]/ResWaterCC (c,'BL')]*100;

ChangeRW (c,'CC2') = ResWater (c,'CC2')- ResWaterCC (c,'CC2');
ChangeRW_pct(c,'CC2') = [ResWater (c,'CC2')- ResWaterCC (c,'CC2')]/ResWater (c,'CC2');

AgWateract (c,a,'irr','CC2') = fir(c,a,'irr')*X.l(c,a,'irr');
AgWateractDiff (c,a,'irr','CC2') =AgWateract (c,a,'irr','CC2') - AgWateract (c,a,'irr','BL') ;
AgWateractDiff_pct (c,a,'irr','CC2')$(AgWateract (c,a,'irr','BL') gt 0) =
                                                     (AgWateract (c,a,'irr','CC2') - AgWateract (c,a,'irr','BL'))/AgWateract (c,a,'irr','BL') ;

*Ag_WaterUse1 (c,'BL') = sum(a$map_cas(c,a,'irr'), fir(c,a,'irr')*X.l(c,a,'irr'))  ;
Ag_WaterUse2 (c,'CC2') =  FW4.l(c);
AgWaterDiff (c, 'CC2') = Ag_WaterUse2 (c,'CC2') - Ag_WaterUse2 (c,'BL');
AgWaterDiff_pct (c, 'CC2') = [[Ag_WaterUse2 (c,'CC2') - Ag_WaterUse2 (c,'BL')]/Ag_WaterUse2 (c,'BL')]*100;

*Res_WaterUse1 (c,'BL') =  RW.l(c)*12*households(c);

Res_WaterUse2 (c,'CC2') =  FW3.l(c);
Res_WaterUseDiff (c,'CC2') =  Res_WaterUse2 (c,'CC2')- Res_WaterUse2 (c,'BL') ;
Res_WaterUseDiff_pct (c,'CC2') =  [[Res_WaterUse2 (c,'CC2')- Res_WaterUse2 (c,'BL')]/Res_WaterUse2 (c,'BL')]*100 ;
totwateruse2 (c,'CC2') = FW2.l(c);
totwateruse2Diff_pct (c,'CC2') = [[totwateruse2 (c,'CC2') - totwateruse2 (c,'BL')]/totwateruse2 (c,'BL')]*100;

totincome('CC2')= z.l;
totincomeDiff_pct('CC2') = [[totincome('CC2')-totincome('BL')]/totincome('BL')]*100;
totCS('CC2')= TCS.l;
totCSDiff_pct('CC2')= [[totCS('CC2')- totCS('BL')]/totCS('BL')]*100; ;
totsurplus('CC2') = TS.L;
totsurplusDiff_pct('CC2') = [[totsurplus('CC2')- totsurplus('BL')]/totsurplus('BL')]*100;

Income_Comm(c,'CC2') = Zc.l(c);
Income_CommDiff (c,'CC2') = Income_Comm(c,'CC2')-Income_Comm(c,'BL') ;
Income_CommDiff_pct(c,'CC2')= [[Income_Comm(c,'CC2')-Income_Comm(c,'BL')]/Income_Comm(c,'BL')]*100 ;
Cons_Surplus(c,'CC2') = CS.l(c);
Cons_SurplusDiff(c,'CC2') = Cons_Surplus(c,'CC2')-Cons_Surplus(c,'BL');
Cons_SurplusDiff_pct(c,'CC2') = [[Cons_Surplus(c,'CC2')-Cons_Surplus(c,'BL')]/Cons_Surplus(c,'BL')]*100;

TSc(c,'CC2')= Zc.l(c) + CS.l(c);


WaterNU(c,'CC2')= WNU2.l(c);

Income_Act(a,'CC2') = sum((c,s), yld(c,a,s)*ps0(a)*X.l(c,a,s)) - sum((c,s), AC.l(c,a,s)*X.l(c,a,s));
Income_ActDiff(a,'CC2') = Income_Act(a,'CC2') - Income_Act(a,'BL');
Income_ActDiff_pct(a,'CC2')$(Income_Act(a,'BL') gt 0) = [[Income_Act(a,'CC2') - Income_Act(a,'BL')]/Income_Act(a,'BL')]*100;

Income_Act_Comm(c,a,'CC2')= sum(s,yld(c,a,s)*ps0(a)*X.l(c,a,s)) - sum(s,AC.l(c,a,s)*X.l(c,a,s));
Income_Act_CommDiff(c,a,'CC2')= Income_Act_Comm(c,a,'CC2')-Income_Act_Comm(c,a,'BL') ;
Income_Act_CommDiff_pct(c,a,'CC2')$(Income_Act_Comm(c,a,'BL') gt 0) = [[Income_Act_Comm(c,a,'CC2')-Income_Act_Comm(c,a,'BL')]/Income_Act_Comm(c,a,'BL')]*100 ;
Cost(c,a,s,'CC2') = AC.L(C,a,s);
Income_Act_CommSys(c,a,s,'CC2')= (yld(c,a,s)*ps0(a)*Comm_report(c,a,s,'CC2')) - (Cost(c,a,s,'CC2')*X.l(c,a,s));

display Comm_report,Basin_report, ResWater,ResWaterDiff,ResWaterDiff_pct,ResWaterCC,ResWaterDiffCC,ResWaterDiffCC_pct,ChangeRW, ChangeRW_pct,AgWateract,AgWateractDiff
AgWateractDiff_pct, Ag_WaterUse2,  AgWaterDiff,AgWaterDiff_pct, Res_WaterUse2, Res_WaterUseDiff,Res_WaterUseDiff_pct, totwateruse2, totwateruse2Diff_pct,totincome,
totincomeDiff_pct,totCS,totCSDiff_pct,totsurplus,totsurplusDiff_pct,Income_Comm,Income_CommDiff,Income_CommDiff_pct,Cons_Surplus,Cons_SurplusDiff,
Cons_SurplusDiff_pct, WaterNU,Income_Act,Income_ActDiff,Income_ActDiff_pct,Income_Act_Comm,Income_Act_CommDiff,Income_Act_CommDiff_pct, Cost, Income_Act_CommSys     ;
option decimals=8;

*$exit;
*$offtext;

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*             Climate Change scenario 3: new temperature, new DW and  New yield*
*                                                                              *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*

*Based on Ponce 2017
parameter yield_ori;

yield_ori(c,a,s)=yld(c,a,s);

yld(c,a,'dry')= yield_ori(c,a,'dry')*(0.9);
yld(c,a,'irr')= yield_ori(c,a,'irr')*(0.95);


solve PMP_we_0 using nlp maximizing TS;


Comm_report(c,a,s,'CC3')  = X.l(c,a,s);
Comm_report(c,a,s,'diff_CC3-BL') = Comm_report(c,a,s,'CC3') - Comm_report(c,a,s,'BL');
Comm_report(c,'area',s,'CC3')  = sum(a,X.l(c,a,s));
Comm_report(c,'area','total','CC3') = sum((a,s),X.l(c,a,s));
Comm_report(c,'iarea','irr','CC3') =   IL.l(c);
Comm_report(c,'iarea','irr','diff_CC3-BL%') =
                                 [[Comm_report(c,'iarea','irr','CC3')-Comm_report(c,'iarea','irr','BL')]/Comm_report(c,'iarea','irr','BL')]*100;

Basin_report('irr','CC3') = sum ((c,a),X.l(c,a,'irr'));

ResWater (c,'CC3') = RW.L(c);
ResWaterDiff (c, 'CC3') =   ResWater (c,'CC3')- ResWater (c,'BL');
ResWaterDiff_pct (c, 'CC3')=   [[ResWater (c,'CC3')- ResWater (c,'BL')]/ResWater (c,'BL')]*100;

ResWaterCC (c,'CC3') = RW_CC.L(c);
ResWaterDiffCC (c, 'CC3') =   ResWaterCC (c,'CC3')- ResWaterCC (c,'BL');
ResWaterDiffCC_pct (c, 'CC3')=   [[ResWaterCC (c,'CC3')- ResWaterCC (c,'BL')]/ResWaterCC (c,'BL')]*100;

Pvirtual (c,'CC3')= PV.l(c);

ChangeRW (c,'CC3') = ResWater (c,'CC1')- ResWaterCC (c,'CC3');
ChangeRW_pct(c,'CC3') = [ResWater (c,'CC1')- ResWaterCC (c,'CC3')]/ResWater (c,'CC1');

AgWateract (c,a,'irr','CC3') = fir(c,a,'irr')*X.l(c,a,'irr');
AgWateractDiff (c,a,'irr','CC3') =AgWateract (c,a,'irr','CC3') - AgWateract (c,a,'irr','BL') ;
AgWateractDiff_pct (c,a,'irr','CC3')$(AgWateract (c,a,'irr','BL') gt 0) =
                                                     (AgWateract (c,a,'irr','CC3') - AgWateract (c,a,'irr','BL'))/AgWateract (c,a,'irr','BL') ;


*Ag_WaterUse1 (c,'BL') = sum(a$map_cas(c,a,'irr'), fir(c,a,'irr')*X.l(c,a,'irr'))  ;
Ag_WaterUse2 (c,'CC3') =  FW4.l(c);
AgWaterDiff (c, 'CC3') = Ag_WaterUse2 (c,'CC3') - Ag_WaterUse2 (c,'BL');
AgWaterDiff_pct (c, 'CC3') = [[Ag_WaterUse2 (c,'CC3') - Ag_WaterUse2 (c,'BL')]/Ag_WaterUse2 (c,'BL')]*100;

*Res_WaterUse1 (c,'BL') =  RW.l(c)*12*households(c);
Res_WaterUse2 (c,'CC3') =  FW3.l(c);
Res_WaterUseDiff (c,'CC3') =  Res_WaterUse2 (c,'CC3')- Res_WaterUse2 (c,'BL') ;
Res_WaterUseDiff_pct (c,'CC3') =  [[Res_WaterUse2 (c,'CC3')- Res_WaterUse2 (c,'BL')]/Res_WaterUse2 (c,'BL')]*100 ;
totwateruse2 (c,'CC3') = FW2.l(c);
totwateruse2Diff_pct (c,'CC3') = [[totwateruse2 (c,'CC3') - totwateruse2 (c,'BL')]/totwateruse2 (c,'BL')]*100;

totincome('CC3')= z.l;
totincomeDiff_pct('CC3') = [[totincome('CC3')-totincome('BL')]/totincome('BL')]*100;
totCS('CC3')= TCS.l;
totCSDiff_pct('CC3')= [[totCS('CC3')- totCS('BL')]/totCS('BL')]*100; ;
totsurplus('CC3') = TS.L;
totsurplusDiff_pct('CC3') = [[totsurplus('CC3')- totsurplus('BL')]/totsurplus('BL')]*100;

Income_Comm(c,'CC3') = Zc.l(c);
Income_CommDiff (c,'CC3') = Income_Comm(c,'CC3')-Income_Comm(c,'BL') ;
Income_CommDiff_pct(c,'CC3')= [[Income_Comm(c,'CC3')-Income_Comm(c,'BL')]/Income_Comm(c,'BL')]*100 ;
Cons_Surplus(c,'CC3') = CS.l(c);
Cons_SurplusDiff(c,'CC3') = Cons_Surplus(c,'CC3')-Cons_Surplus(c,'BL');
Cons_SurplusDiff_pct(c,'CC3') = [[Cons_Surplus(c,'CC3')-Cons_Surplus(c,'BL')]/Cons_Surplus(c,'BL')]*100;

TSc(c,'CC3')= Zc.l(c) + CS.l(c);

WaterNU(c,'CC3')= WNU2.l(c);

Income_Act(a,'CC3') = sum((c,s), yld(c,a,s)*ps0(a)*X.l(c,a,s)) - sum((c,s), AC.l(c,a,s)*X.l(c,a,s));
Income_ActDiff(a,'CC3') = Income_Act(a,'CC3') - Income_Act(a,'BL');

Income_ActDiff_pct(a,'CC3')$(Income_Act(a,'BL') gt 0) = [[Income_Act(a,'CC3') - Income_Act(a,'BL')]/Income_Act(a,'BL')]*100;

Income_Act_Comm(c,a,'CC3')= sum(s,yld(c,a,s)*ps0(a)*X.l(c,a,s)) - sum(s,AC.l(c,a,s)*X.l(c,a,s));
Income_Act_CommDiff(c,a,'CC3')= Income_Act_Comm(c,a,'CC3')-Income_Act_Comm(c,a,'BL') ;
Income_Act_CommDiff_pct(c,a,'CC3')$(Income_Act_Comm(c,a,'BL') gt 0) = [[Income_Act_Comm(c,a,'CC3')-Income_Act_Comm(c,a,'BL')]/Income_Act_Comm(c,a,'BL')]*100 ;
Cost(c,a,s,'CC3') = AC.L(C,a,s);
Income_Act_CommSys(c,a,s,'CC3')= (yld(c,a,s)*ps0(a)*Comm_report(c,a,s,'CC3')) - (Cost(c,a,s,'CC3')*X.l(c,a,s));

display Comm_report,Basin_report, ResWater,ResWaterDiff,ResWaterDiff_pct,ResWaterCC,ResWaterDiffCC,ResWaterDiffCC_pct,ChangeRW, ChangeRW_pct,AgWateract,AgWateractDiff
AgWateractDiff_pct, Ag_WaterUse2,  AgWaterDiff,AgWaterDiff_pct, Res_WaterUse2, Res_WaterUseDiff,Res_WaterUseDiff_pct, totwateruse2, totwateruse2Diff_pct,totincome,
totincomeDiff_pct,totCS,totCSDiff_pct,totsurplus,totsurplusDiff_pct,Income_Comm,Income_CommDiff,Income_CommDiff_pct,Cons_Surplus,Cons_SurplusDiff,
Cons_SurplusDiff_pct, WaterNU,Income_Act,Income_ActDiff,Income_ActDiff_pct,Income_Act_Comm,Income_Act_CommDiff,Income_Act_CommDiff_pct, Cost, Income_Act_CommSys     ;
option decimals=8;

*$exit;



*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*             Climate Change scenario 4: new temperature, new DW, New yield    *
*            and new households                                                *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*

parameter   households_ori;

households_ori(c) = households(c);
households(c) = households_ori(c)*(1.13043);



solve PMP_we_0 using nlp maximizing TS;


Comm_report(c,a,s,'CC4')  = X.l(c,a,s);
Comm_report(c,a,s,'diff_CC4-BL') = Comm_report(c,a,s,'CC4') - Comm_report(c,a,s,'BL');
Comm_report(c,'area',s,'CC4')  = sum(a,X.l(c,a,s));
Comm_report(c,'area','total','CC4') = sum((a,s),X.l(c,a,s));
Comm_report(c,'iarea','irr','CC4') =   IL.l(c);
Comm_report(c,'iarea','irr','diff_CC4-BL%') =
                                 [[Comm_report(c,'iarea','irr','CC4')-Comm_report(c,'iarea','irr','BL')]/Comm_report(c,'iarea','irr','BL')]*100;

Basin_report('irr','CC4') = sum ((c,a),X.l(c,a,'irr'));

ResWater (c,'CC4') = RW.L(c);
ResWaterDiff (c, 'CC4') =   ResWater (c,'CC4')- ResWater (c,'BL');
ResWaterDiff_pct (c, 'CC4')=   [[ResWater (c,'CC4')- ResWater (c,'BL')]/ResWater (c,'BL')]*100;

ResWaterCC (c,'CC4') = RW_CC.L(c);
ResWaterDiffCC (c, 'CC4') =   ResWaterCC (c,'CC4')- ResWaterCC (c,'BL');
ResWaterDiffCC_pct (c, 'CC4')=   [[ResWaterCC (c,'CC4')- ResWaterCC (c,'BL')]/ResWaterCC (c,'BL')]*100;

Pvirtual (c,'CC4')= PV.l(c);

ChangeRW (c,'CC4') = ResWater (c,'CC1')- ResWaterCC (c,'CC4');
ChangeRW_pct(c,'CC4') = [ResWater (c,'CC1')- ResWaterCC (c,'CC4')]/ResWater (c,'CC1');

AgWateract (c,a,'irr','CC4') = fir(c,a,'irr')*X.l(c,a,'irr');
AgWateractDiff (c,a,'irr','CC4') =AgWateract (c,a,'irr','CC4') - AgWateract (c,a,'irr','BL') ;
AgWateractDiff_pct (c,a,'irr','CC4')$(AgWateract (c,a,'irr','BL') gt 0) =
                                                     (AgWateract (c,a,'irr','CC4') - AgWateract (c,a,'irr','BL'))/AgWateract (c,a,'irr','BL') ;


*Ag_WaterUse1 (c,'BL') = sum(a$map_cas(c,a,'irr'), fir(c,a,'irr')*X.l(c,a,'irr'))  ;
Ag_WaterUse2 (c,'CC4') =  FW4.l(c);
AgWaterDiff (c, 'CC4') = Ag_WaterUse2 (c,'CC4') - Ag_WaterUse2 (c,'BL');
AgWaterDiff_pct (c, 'CC4') = [[Ag_WaterUse2 (c,'CC4') - Ag_WaterUse2 (c,'BL')]/Ag_WaterUse2 (c,'BL')]*100;

*Res_WaterUse1 (c,'BL') =  RW.l(c)*12*households(c);
Res_WaterUse2 (c,'CC4') =  FW3.l(c);
Res_WaterUseDiff (c,'CC4') =  Res_WaterUse2 (c,'CC4')- Res_WaterUse2 (c,'BL') ;
Res_WaterUseDiff_pct (c,'CC4') =  [[Res_WaterUse2 (c,'CC4')- Res_WaterUse2 (c,'BL')]/Res_WaterUse2 (c,'BL')]*100 ;
totwateruse2 (c,'CC4') = FW2.l(c);
totwateruse2Diff_pct (c,'CC4') = [[totwateruse2 (c,'CC4') - totwateruse2 (c,'BL')]/totwateruse2 (c,'BL')]*100;

totincome('CC4')= z.l;
totincomeDiff_pct('CC4') = [[totincome('CC4')-totincome('BL')]/totincome('BL')]*100;
totCS('CC4')= TCS.l;
totCSDiff_pct('CC4')= [[totCS('CC4')- totCS('BL')]/totCS('BL')]*100; ;
totsurplus('CC4') = TS.L;
totsurplusDiff_pct('CC4') = [[totsurplus('CC4')- totsurplus('BL')]/totsurplus('BL')]*100;

Income_Comm(c,'CC4') = Zc.l(c);
Income_CommDiff (c,'CC4') = Income_Comm(c,'CC4')-Income_Comm(c,'BL') ;
Income_CommDiff_pct(c,'CC4')= [[Income_Comm(c,'CC4')-Income_Comm(c,'BL')]/Income_Comm(c,'BL')]*100 ;
Cons_Surplus(c,'CC4') = CS.l(c);
Cons_SurplusDiff(c,'CC4') = Cons_Surplus(c,'CC4')-Cons_Surplus(c,'BL');
Cons_SurplusDiff_pct(c,'CC4') = [[Cons_Surplus(c,'CC4')-Cons_Surplus(c,'BL')]/Cons_Surplus(c,'BL')]*100;

TSc(c,'CC4')= Zc.l(c) + CS.l(c);


WaterNU(c,'CC4')= WNU2.l(c);

Income_Act(a,'CC4') = sum((c,s), yld(c,a,s)*ps0(a)*X.l(c,a,s)) - sum((c,s), AC.l(c,a,s)*X.l(c,a,s));
Income_ActDiff(a,'CC4') = Income_Act(a,'CC4') - Income_Act(a,'BL');
Income_ActDiff_pct(a,'CC4')$(Income_Act(a,'BL') gt 0) = [[Income_Act(a,'CC4') - Income_Act(a,'BL')]/Income_Act(a,'BL')]*100;

Income_Act_Comm(c,a,'CC4')= sum(s,yld(c,a,s)*ps0(a)*X.l(c,a,s)) - sum(s,AC.l(c,a,s)*X.l(c,a,s));
Income_Act_CommDiff(c,a,'CC4')= Income_Act_Comm(c,a,'CC4')-Income_Act_Comm(c,a,'BL') ;
Income_Act_CommDiff_pct(c,a,'CC4')$(Income_Act_Comm(c,a,'BL') gt 0) = [[Income_Act_Comm(c,a,'CC4')-Income_Act_Comm(c,a,'BL')]/Income_Act_Comm(c,a,'BL')]*100 ;
Cost(c,a,s,'CC4') = AC.L(C,a,s);
Income_Act_CommSys(c,a,s,'CC4')= (yld(c,a,s)*ps0(a)*Comm_report(c,a,s,'CC4')) - (Cost(c,a,s,'CC4')*X.l(c,a,s));

display Comm_report,Basin_report, ResWater,ResWaterDiff,ResWaterDiff_pct,ResWaterCC,ResWaterDiffCC,ResWaterDiffCC_pct,ChangeRW, ChangeRW_pct,AgWateract,AgWateractDiff
AgWateractDiff_pct, Ag_WaterUse2,  AgWaterDiff,AgWaterDiff_pct, Res_WaterUse2, Res_WaterUseDiff,Res_WaterUseDiff_pct, totwateruse2, totwateruse2Diff_pct,totincome,
totincomeDiff_pct,totCS,totCSDiff_pct,totsurplus,totsurplusDiff_pct,Income_Comm,Income_CommDiff,Income_CommDiff_pct,Cons_Surplus,Cons_SurplusDiff,
Cons_SurplusDiff_pct, WaterNU,Income_Act,Income_ActDiff,Income_ActDiff_pct,Income_Act_Comm,Income_Act_CommDiff,Income_Act_CommDiff_pct, Cost, Income_Act_CommSys     ;
option decimals=8;
*$exit;




*$ontext;

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*             Climate Change scenario 5: new temperature, New yield            *
*            and new households                                                *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*

DW0(C) = DW0_Initial(c);


solve PMP_we_0 using nlp maximizing TS;


Comm_report(c,a,s,'CC5')  = X.l(c,a,s);

Comm_report(c,a,s,'diff_CC5-BL') = Comm_report(c,a,s,'CC5') - Comm_report(c,a,s,'BL');

Comm_report(c,'area',s,'CC5')  = sum(a,X.l(c,a,s));
Comm_report(c,'area','total','CC5') = sum((a,s),X.l(c,a,s));

Comm_report(c,'iarea','irr','CC5') =   IL.l(c);

Comm_report(c,'iarea','irr','diff_CC5-BL%') =
                                 [[Comm_report(c,'iarea','irr','CC5')-Comm_report(c,'iarea','irr','BL')]/Comm_report(c,'iarea','irr','BL')]*100;

Basin_report('irr','CC5') = sum ((c,a),X.l(c,a,'irr'));

ResWater (c,'CC5') = RW.L(c);
ResWaterDiff (c, 'CC5') =   ResWater (c,'CC5')- ResWater (c,'BL');
ResWaterDiff_pct (c, 'CC5')=   [[ResWater (c,'CC5')- ResWater (c,'BL')]/ResWater (c,'BL')]*100;

ResWaterCC (c,'CC5') = RW_CC.L(c);
ResWaterDiffCC (c, 'CC5') =   ResWaterCC (c,'CC5')- ResWaterCC (c,'BL');
ResWaterDiffCC_pct (c, 'CC5')=   [[ResWaterCC (c,'CC5')- ResWaterCC (c,'BL')]/ResWaterCC (c,'BL')]*100;

Pvirtual (c,'CC5')= PV.l(c);

ChangeRW (c,'CC5') = ResWater (c,'CC5')- ResWaterCC (c,'CC5');
ChangeRW_pct(c,'CC5') = [ResWater (c,'CC5')- ResWaterCC (c,'CC5')]/ResWater (c,'CC1');

AgWateract (c,a,'irr','CC5') = fir(c,a,'irr')*X.l(c,a,'irr');
AgWateractDiff (c,a,'irr','CC5') =AgWateract (c,a,'irr','CC5') - AgWateract (c,a,'irr','BL') ;
AgWateractDiff_pct (c,a,'irr','CC5')$(AgWateract (c,a,'irr','BL') gt 0) =
                                                     (AgWateract (c,a,'irr','CC5') - AgWateract (c,a,'irr','BL'))/AgWateract (c,a,'irr','BL') ;


*Ag_WaterUse1 (c,'BL') = sum(a$map_cas(c,a,'irr'), fir(c,a,'irr')*X.l(c,a,'irr'))  ;
Ag_WaterUse2 (c,'CC5') =  FW4.l(c);
AgWaterDiff (c, 'CC5') = Ag_WaterUse2 (c,'CC5') - Ag_WaterUse2 (c,'BL');
AgWaterDiff_pct (c, 'CC5') = [[Ag_WaterUse2 (c,'CC5') - Ag_WaterUse2 (c,'BL')]/Ag_WaterUse2 (c,'BL')]*100;

*Res_WaterUse1 (c,'BL') =  RW.l(c)*12*households(c);
Res_WaterUse2 (c,'CC5') =  FW3.l(c);
Res_WaterUseDiff (c,'CC5') =  Res_WaterUse2 (c,'CC5')- Res_WaterUse2 (c,'BL') ;
Res_WaterUseDiff_pct (c,'CC5') =  [[Res_WaterUse2 (c,'CC5')- Res_WaterUse2 (c,'BL')]/Res_WaterUse2 (c,'BL')]*100 ;
totwateruse2 (c,'CC5') = FW2.l(c);
totwateruse2Diff_pct (c,'CC5') = [[totwateruse2 (c,'CC5') - totwateruse2 (c,'BL')]/totwateruse2 (c,'BL')]*100;

totincome('CC5')= z.l;
totincomeDiff_pct('CC5') = [[totincome('CC5')-totincome('BL')]/totincome('BL')]*100;
totCS('CC5')= TCS.l;
totCSDiff_pct('CC5')= [[totCS('CC5')- totCS('BL')]/totCS('BL')]*100; ;
totsurplus('CC5') = TS.L;
totsurplusDiff_pct('CC5') = [[totsurplus('CC5')- totsurplus('BL')]/totsurplus('BL')]*100;

Income_Comm(c,'CC5') = Zc.l(c);
Income_CommDiff (c,'CC5') = Income_Comm(c,'CC5')-Income_Comm(c,'BL') ;
Income_CommDiff_pct(c,'CC5')= [[Income_Comm(c,'CC5')-Income_Comm(c,'BL')]/Income_Comm(c,'BL')]*100 ;
Cons_Surplus(c,'CC5') = CS.l(c);
Cons_SurplusDiff(c,'CC5') = Cons_Surplus(c,'CC5')-Cons_Surplus(c,'BL');
Cons_SurplusDiff_pct(c,'CC5') = [[Cons_Surplus(c,'CC5')-Cons_Surplus(c,'BL')]/Cons_Surplus(c,'BL')]*100;

TSc(c,'CC5')= Zc.l(c) + CS.l(c);


WaterNU(c,'CC5')= WNU2.l(c);

Income_Act(a,'CC5') = sum((c,s), yld(c,a,s)*ps0(a)*X.l(c,a,s)) - sum((c,s), AC.l(c,a,s)*X.l(c,a,s));
Income_ActDiff(a,'CC5') = Income_Act(a,'CC5') - Income_Act(a,'BL');
Income_ActDiff_pct(a,'CC5')$(Income_Act(a,'BL') gt 0) = [[Income_Act(a,'CC5') - Income_Act(a,'BL')]/Income_Act(a,'BL')]*100;

Income_Act_Comm(c,a,'CC5')= sum(s,yld(c,a,s)*ps0(a)*X.l(c,a,s)) - sum(s,AC.l(c,a,s)*X.l(c,a,s));
Income_Act_CommDiff(c,a,'CC5')= Income_Act_Comm(c,a,'CC5')-Income_Act_Comm(c,a,'BL') ;
Income_Act_CommDiff_pct(c,a,'CC5')$(Income_Act_Comm(c,a,'BL') gt 0) = [[Income_Act_Comm(c,a,'CC5')-Income_Act_Comm(c,a,'BL')]/Income_Act_Comm(c,a,'BL')]*100 ;
Cost(c,a,s,'CC5') = AC.L(C,a,s);
Income_Act_CommSys(c,a,s,'CC5')= (yld(c,a,s)*ps0(a)*Comm_report(c,a,s,'CC5')) - (Cost(c,a,s,'CC5')*X.l(c,a,s));

*$offtext;

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*             Climate Change scenario 6: new temperature, New yield            *
*            and new households, DWE1                                                *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*




DW0(C)= DWE1(c);

solve PMP_we_0 using nlp maximizing TS;

*$exit;

Income_Comm(c,'E1') = Zc.l(c);
Cons_Surplus(c,'E1') = CS.l(c);
TSc(c,'E1')= Zc.l(c) + CS.l(c);









*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*             Climate Change scenario 7: new temperature, New yield            *
*            and new households, DWE2                                                *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
DW0(C) =  DWE2(C);


*W0_a(c) = W0_a(c)*E2(c) ;
*W0_r(c) = W0_r(c)*E2(c);


solve PMP_we_0 using nlp maximizing TS;


Income_Comm(c,'E2') = Zc.l(c);
Cons_Surplus(c,'E2') = CS.l(c);
TSc(c,'E2')= Zc.l(c) + CS.l(c);


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*             Climate Change scenario 8: new temperature, New yield            *
*            and new households, DWE3                                                *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
DW0(C) =  DWE3(C);


solve PMP_we_0 using nlp maximizing TS;

Income_Comm(c,'E3') = Zc.l(c);
Cons_Surplus(c,'E3') = CS.l(c);
TSc(c,'E3')= Zc.l(c) + CS.l(c);


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*             Climate Change scenario 9: new temperature, New yield            *
*            and new households, DWE4                                                *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
DW0(C) = DWE4(C);

solve PMP_we_0 using nlp maximizing TS;

Income_Comm(c,'E4') = Zc.l(c);
Cons_Surplus(c,'E4') = CS.l(c);
TSc(c,'E4')= Zc.l(c) + CS.l(c);

parameter ingresocomuna;

ingresocomuna(c,a,s,'E4') =  yld(c,a,s)*ps0(a)*X.l(c,a,s)  - AC.l(c,a,s)*X.l(c,a,s) ;


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*             Climate Change scenario 10: new temperature, New yield            *
*            and new households, DWE6                                                *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
DW0(C) =  DWE6(C);

solve PMP_we_0 using nlp maximizing TS;

Income_Comm(c,'E6') = Zc.l(c);
Cons_Surplus(c,'E6') = CS.l(c);
TSc(c,'E6')= Zc.l(c) + CS.l(c);


ingresocomuna(c,a,s,'E6') =  yld(c,a,s)*ps0(a)*X.l(c,a,s)  - AC.l(c,a,s)*X.l(c,a,s) ;


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*             Climate Change scenario 11: new temperature, New yield            *
*            and new households, DWE7                                                *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
DW0(C) =  DWE7(C);

solve PMP_we_0 using nlp maximizing TS;

Income_Comm(c,'E7') = Zc.l(c);
Cons_Surplus(c,'E7') = CS.l(c);
TSc(c,'E7')= Zc.l(c) + CS.l(c);


ingresocomuna(c,a,s,'E7') =  yld(c,a,s)*ps0(a)*X.l(c,a,s)  - AC.l(c,a,s)*X.l(c,a,s) ;

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*             Climate Change scenario 12: new temperature, New yield            *
*            and new households, DWE8                                                *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
DW0(C) =  DWE8(C);


solve PMP_we_0 using nlp maximizing TS;

Income_Comm(c,'E8') = Zc.l(c);
Cons_Surplus(c,'E8') = CS.l(c);
TSc(c,'E8')= Zc.l(c) + CS.l(c);


ingresocomuna(c,a,s,'E8') =  yld(c,a,s)*ps0(a)*X.l(c,a,s)  - AC.l(c,a,s)*X.l(c,a,s) ;


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*             Climate Change scenario 13: new temperature, New yield            *
*            and new households, DWE9                                                *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
DW0(C) =  DWE9(C);



solve PMP_we_0 using nlp maximizing TS;
*$exit;


Income_Comm(c,'E9') = Zc.l(c);
Cons_Surplus(c,'E9') = CS.l(c);
TSc(c,'E9')= Zc.l(c) + CS.l(c);


ingresocomuna(c,a,s,'E9') =  yld(c,a,s)*ps0(a)*X.l(c,a,s)  - AC.l(c,a,s)*X.l(c,a,s) ;



display TSc, Cons_Surplus, Income_Comm, ingresocomuna;





*$exit;

*$exit;


$ontext
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*             Climate Change scenario 5: original temp, new DW, New yield    *
*            and new households, fixed RWCC to BL                                                *
*                                                                              *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*

temp(c) = temp_ori(c) * (1);

households(c) = households_ori(c)*(1.13043);

RW_cc.fx(c) = ResWaterCC (c,'BL');

solve PMP_we_0 using nlp maximizing TS;

Comm_report(c,a,s,'CC5')  = X.l(c,a,s);
Comm_report(c,a,s,'diff_CC5-BL') = Comm_report(c,a,s,'CC5') - Comm_report(c,a,s,'BL');
Comm_report(c,'area',s,'CC5')  = sum(a,X.l(c,a,s));
Comm_report(c,'area','total','CC5') = sum((a,s),X.l(c,a,s));
Comm_report(c,'iarea','irr','CC5') =   IL.l(c);
Comm_report(c,'iarea','irr','diff_CC5-BL%') =
                                 [[Comm_report(c,'iarea','irr','CC5')-Comm_report(c,'iarea','irr','BL')]/Comm_report(c,'iarea','irr','BL')]*100;

Basin_report('irr','CC5') = sum ((c,a),X.l(c,a,'irr'));

ResWater (c,'CC5') = RW.L(c);
ResWaterDiff (c, 'CC5') =   ResWater (c,'CC5')- ResWater (c,'BL');
ResWaterDiff_pct (c, 'CC5')=   [[ResWater (c,'CC5')- ResWater (c,'BL')]/ResWater (c,'BL')]*100;

ResWaterCC (c,'CC5') = RW_CC.L(c);
ResWaterDiffCC (c, 'CC5') =   ResWaterCC (c,'CC5')- ResWaterCC (c,'BL');
ResWaterDiffCC_pct (c, 'CC5')=   [[ResWaterCC (c,'CC5')- ResWaterCC (c,'BL')]/ResWaterCC (c,'BL')]*100;

ChangeRW (c,'CC5') = ResWater (c,'CC5')- ResWaterCC (c,'CC5');
ChangeRW_pct(c,'CC5') = [ResWater (c,'CC5')- ResWaterCC (c,'CC5')]/ResWater (c,'CC5');

AgWateract (c,a,'irr','CC5') = fir(c,a,'irr')*X.l(c,a,'irr');
AgWateractDiff (c,a,'irr','CC5') =AgWateract (c,a,'irr','CC5') - AgWateract (c,a,'irr','BL') ;
AgWateractDiff_pct (c,a,'irr','CC5')$(AgWateract (c,a,'irr','BL') gt 0) =
                                                     (AgWateract (c,a,'irr','CC5') - AgWateract (c,a,'irr','BL'))/AgWateract (c,a,'irr','BL') ;

*Ag_WaterUse1 (c,'BL') = sum(a$map_cas(c,a,'irr'), fir(c,a,'irr')*X.l(c,a,'irr'))  ;
Ag_WaterUse2 (c,'CC5') =  FW4.l(c);
AgWaterDiff (c, 'CC5') = Ag_WaterUse2 (c,'CC5') - Ag_WaterUse2 (c,'BL');
AgWaterDiff_pct (c, 'CC5') = [[Ag_WaterUse2 (c,'CC5') - Ag_WaterUse2 (c,'BL')]/Ag_WaterUse2 (c,'BL')]*100;

*Res_WaterUse1 (c,'BL') =  RW.l(c)*12*households(c);
Res_WaterUse2 (c,'CC5') =  FW3.l(c);
Res_WaterUseDiff (c,'CC5') =  Res_WaterUse2 (c,'CC5')- Res_WaterUse2 (c,'BL') ;
Res_WaterUseDiff_pct (c,'CC5') =  [[Res_WaterUse2 (c,'CC5')- Res_WaterUse2 (c,'BL')]/Res_WaterUse2 (c,'BL')]*100 ;
totwateruse2 (c,'CC5') = FW2.l(c);
totwateruse2Diff_pct (c,'CC5') = [[totwateruse2 (c,'CC5') - totwateruse2 (c,'BL')]/totwateruse2 (c,'BL')]*100;

totincome('CC5')= z.l;
totincomeDiff_pct('CC5') = [[totincome('CC5')-totincome('BL')]/totincome('BL')]*100;
totCS('CC5')= TCS.l;
totCSDiff_pct('CC5')= [[totCS('CC5')- totCS('BL')]/totCS('BL')]*100; ;
totsurplus('CC5') = TS.L;
totsurplusDiff_pct('CC5') = [[totsurplus('CC5')- totsurplus('BL')]/totsurplus('BL')]*100;

Income_Comm(c,'CC5') = Zc.l(c);
Income_CommDiff (c,'CC5') = Income_Comm(c,'CC5')-Income_Comm(c,'BL') ;
Income_CommDiff_pct(c,'CC5')= [[Income_Comm(c,'CC5')-Income_Comm(c,'BL')]/Income_Comm(c,'BL')]*100 ;
Cons_Surplus(c,'CC5') = CS.l(c);
Cons_SurplusDiff(c,'CC5') = Cons_Surplus(c,'CC5')-Cons_Surplus(c,'BL');
Cons_SurplusDiff_pct(c,'CC5') = [[Cons_Surplus(c,'CC5')-Cons_Surplus(c,'BL')]/Cons_Surplus(c,'BL')]*100;


WaterNU(c,'CC5')= WNU2.l(c);

Income_Act(a,'CC5') = sum((c,s), yld(c,a,s)*ps0(a)*X.l(c,a,s)) - sum((c,s), AC.l(c,a,s)*X.l(c,a,s));
Income_ActDiff(a,'CC5') = Income_Act(a,'CC5') - Income_Act(a,'BL');
Income_ActDiff_pct(a,'CC5')$(Income_Act(a,'BL') gt 0) = [[Income_Act(a,'CC5') - Income_Act(a,'BL')]/Income_Act(a,'BL')]*100;

Income_Act_Comm(c,a,'CC5')= sum(s,yld(c,a,s)*ps0(a)*X.l(c,a,s)) - sum(s,AC.l(c,a,s)*X.l(c,a,s));
Income_Act_CommDiff(c,a,'CC5')= Income_Act_Comm(c,a,'CC5')-Income_Act_Comm(c,a,'BL') ;
Income_Act_CommDiff_pct(c,a,'CC5')$(Income_Act_Comm(c,a,'BL') gt 0) = [[Income_Act_Comm(c,a,'CC5')-Income_Act_Comm(c,a,'BL')]/Income_Act_Comm(c,a,'BL')]*100 ;


display Comm_report,Basin_report, ResWater,ResWaterDiff,ResWaterDiff_pct,ResWaterCC,ResWaterDiffCC,ResWaterDiffCC_pct,ChangeRW, ChangeRW_pct,AgWateract,AgWateractDiff
AgWateractDiff_pct, Ag_WaterUse2,  AgWaterDiff,AgWaterDiff_pct, Res_WaterUse2, Res_WaterUseDiff,Res_WaterUseDiff_pct, totwateruse2, totwateruse2Diff_pct,totincome,
totincomeDiff_pct,totCS,totCSDiff_pct,totsurplus,totsurplusDiff_pct,Income_Comm,Income_CommDiff,Income_CommDiff_pct,Cons_Surplus,Cons_SurplusDiff,
Cons_SurplusDiff_pct, WaterNU,Income_Act,Income_ActDiff,Income_ActDiff_pct,Income_Act_Comm,Income_Act_CommDiff,Income_Act_CommDiff_pct   ;
option decimals=8;
}$exit;
$offtext
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*             Policy Scenario 1 and Climate Change scenario 4                  *
*             Increase in agricultural conveyance efficiency of 15%    *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*

DW0(C) = DWCh(C);

parameter phda_ori;

phda_ori(c)=p_hda(c);

p_hda(c)= phda_ori(c)*(1.15);

solve PMP_we_0 using nlp maximizing TS;


Comm_report(c,a,s,'PS1')  = X.l(c,a,s);
Comm_report(c,a,s,'diff_PS1-CC4') = Comm_report(c,a,s,'PS1') - Comm_report(c,a,s,'CC4');
Comm_report(c,'area',s,'PS1')  = sum(a,X.l(c,a,s));
Comm_report(c,'area','total','PS1') = sum((a,s),X.l(c,a,s));
Comm_report(c,'iarea','irr','PS1') =   IL.l(c);
Comm_report(c,'iarea','irr','diff_PS1-CC4%') =
                                 [[Comm_report(c,'iarea','irr','PS1')-Comm_report(c,'iarea','irr','CC4')]/Comm_report(c,'iarea','irr','CC4')]*100;

Basin_report('irr','PS1') = sum ((c,a),X.l(c,a,'irr'));

ResWater (c,'PS1') = RW.L(c);
ResWaterDiff (c, 'PS1') =   ResWater (c,'PS1')- ResWater (c,'CC4');
ResWaterDiff_pct (c, 'PS1')=   [[ResWater (c,'PS1')- ResWater (c,'CC4')]/ResWater (c,'CC4')]*100;

ResWaterCC (c,'PS1') = RW_CC.L(c);
ResWaterDiffCC (c, 'PS1') =   ResWaterCC (c,'PS1')- ResWaterCC (c,'CC4');
ResWaterDiffCC_pct (c, 'PS1')=   [[ResWaterCC (c,'PS1')- ResWaterCC (c,'CC4')]/ResWaterCC (c,'CC4')]*100;

ChangeRW (c,'PS1') = ResWater (c,'PS1')- ResWaterCC (c,'PS1');
ChangeRW_pct(c,'PS1') = [ResWater (c,'PS1')- ResWaterCC (c,'PS1')]/ResWater (c,'PS1');

AgWateract (c,a,'irr','PS1') = fir(c,a,'irr')*X.l(c,a,'irr');
AgWateractDiff (c,a,'irr','PS1') =AgWateract (c,a,'irr','PS1') - AgWateract (c,a,'irr','CC4') ;
AgWateractDiff_pct (c,a,'irr','PS1')$(AgWateract (c,a,'irr','CC4') gt 0) =
                                                     (AgWateract (c,a,'irr','PS1') - AgWateract (c,a,'irr','CC4'))/AgWateract (c,a,'irr','CC4') ;


*Ag_WaterUse1 (c,'BL') = sum(a$map_cas(c,a,'irr'), fir(c,a,'irr')*X.l(c,a,'irr'))  ;
Ag_WaterUse2 (c,'PS1') =  FW4.l(c);
AgWaterDiff (c, 'PS1') = Ag_WaterUse2 (c,'PS1') - Ag_WaterUse2 (c,'CC4');
AgWaterDiff_pct (c, 'PS1') = [[Ag_WaterUse2 (c,'PS1') - Ag_WaterUse2 (c,'CC4')]/Ag_WaterUse2 (c,'CC4')]*100;

*Res_WaterUse1 (c,'BL') =  RW.l(c)*12*households(c);
Res_WaterUse2 (c,'PS1') =  FW3.l(c);
Res_WaterUseDiff (c,'PS1') =  Res_WaterUse2 (c,'PS1')- Res_WaterUse2 (c,'CC4') ;
Res_WaterUseDiff_pct (c,'PS1') =  [[Res_WaterUse2 (c,'PS1')- Res_WaterUse2 (c,'CC4')]/Res_WaterUse2 (c,'CC4')]*100 ;
totwateruse2 (c,'PS1') = FW2.l(c);
totwateruse2Diff_pct (c,'PS1') = [[totwateruse2 (c,'PS1') - totwateruse2 (c,'CC4')]/totwateruse2 (c,'CC4')]*100;

totincome('PS1')= z.l;
totincomeDiff_pct('PS1') = [[totincome('PS1')-totincome('CC4')]/totincome('CC4')]*100;
totCS('PS1')= TCS.l;
totCSDiff_pct('PS1')= [[totCS('PS1')- totCS('CC4')]/totCS('CC4')]*100; ;
totsurplus('PS1') = TS.L;
totsurplusDiff_pct('PS1') = [[totsurplus('CC4')- totsurplus('CC4')]/totsurplus('CC4')]*100;

Income_Comm(c,'PS1') = Zc.l(c);
Income_CommDiff (c,'PS1') = Income_Comm(c,'PS1')-Income_Comm(c,'CC4') ;
Income_CommDiff_pct(c,'PS1')= [[Income_Comm(c,'PS1')-Income_Comm(c,'CC4')]/Income_Comm(c,'CC4')]*100 ;
Cons_Surplus(c,'PS1') = CS.l(c);
Cons_SurplusDiff(c,'PS1') = Cons_Surplus(c,'PS1')-Cons_Surplus(c,'CC4');
Cons_SurplusDiff_pct(c,'PS1') = [[Cons_Surplus(c,'PS1')-Cons_Surplus(c,'CC4')]/Cons_Surplus(c,'CC4')]*100;


WaterNU(c,'PS1')= WNU2.l(c);

Income_Act(a,'PS1') = sum((c,s), yld(c,a,s)*ps0(a)*X.l(c,a,s)) - sum((c,s), AC.l(c,a,s)*X.l(c,a,s));
Income_ActDiff(a,'PS1') = Income_Act(a,'PS1') - Income_Act(a,'CC4');
Income_ActDiff_pct(a,'PS1')$(Income_Act(a,'CC4') gt 0) = [[Income_Act(a,'PS1') - Income_Act(a,'CC4')]/Income_Act(a,'CC4')]*100;

Income_Act_Comm(c,a,'PS1')= sum(s,yld(c,a,s)*ps0(a)*X.l(c,a,s)) - sum(s,AC.l(c,a,s)*X.l(c,a,s));
Income_Act_CommDiff(c,a,'PS1')= Income_Act_Comm(c,a,'PS1')-Income_Act_Comm(c,a,'CC4') ;
Income_Act_CommDiff_pct(c,a,'PS1')$(Income_Act_Comm(c,a,'CC4') gt 0) = [[Income_Act_Comm(c,a,'PS1')-Income_Act_Comm(c,a,'CC4')]/Income_Act_Comm(c,a,'CC4')]*100 ;
Cost(c,a,s,'PS1') = AC.L(C,a,s);
Income_Act_CommSys(c,a,s,'PS1')= (yld(c,a,s)*ps0(a)*Comm_report(c,a,s,'PS1')) - (Cost(c,a,s,'PS1')*X.l(c,a,s));
TSc(c,'PS1')= Zc.l(c) + CS.l(c);



display Comm_report,Basin_report, ResWater,ResWaterDiff,ResWaterDiff_pct,ResWaterCC,ResWaterDiffCC,ResWaterDiffCC_pct,ChangeRW, ChangeRW_pct,AgWateract,AgWateractDiff
AgWateractDiff_pct, Ag_WaterUse2,  AgWaterDiff,AgWaterDiff_pct, Res_WaterUse2, Res_WaterUseDiff,Res_WaterUseDiff_pct, totwateruse2, totwateruse2Diff_pct,totincome,
totincomeDiff_pct,totCS,totCSDiff_pct,totsurplus,totsurplusDiff_pct,Income_Comm,Income_CommDiff,Income_CommDiff_pct,Cons_Surplus,Cons_SurplusDiff,
Cons_SurplusDiff_pct, WaterNU,Income_Act,Income_ActDiff,Income_ActDiff_pct,Income_Act_Comm,Income_Act_CommDiff,Income_Act_CommDiff_pct, Cost, Income_Act_CommSys     ;
option decimals=8;

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*             Policy Scenario 2 and Climate Change scenario 4                  *
*             Increase in residential conveyance efficiency of 10%    *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*

p_hda(c)= phda_ori(c)*(1);

parameter phdr_ori;

phdr_ori(c)=p_hdr(c);

p_hdr(c)= phdr_ori(c)*(1.1);

solve PMP_we_0 using nlp maximizing TS;


Comm_report(c,a,s,'PS2')  = X.l(c,a,s);
Comm_report(c,a,s,'diff_PS2-CC4') = Comm_report(c,a,s,'PS2') - Comm_report(c,a,s,'CC4');
Comm_report(c,'area',s,'PS2')  = sum(a,X.l(c,a,s));
Comm_report(c,'area','total','PS2') = sum((a,s),X.l(c,a,s));
Comm_report(c,'iarea','irr','PS2') =   IL.l(c);
Comm_report(c,'iarea','irr','diff_PS2-CC4%') =
                                 [[Comm_report(c,'iarea','irr','PS2')-Comm_report(c,'iarea','irr','CC4')]/Comm_report(c,'iarea','irr','CC4')]*100;

Basin_report('irr','PS2') = sum ((c,a),X.l(c,a,'irr'));

ResWater (c,'PS2') = RW.L(c);
ResWaterDiff (c, 'PS2') =   ResWater (c,'PS2')- ResWater (c,'CC4');
ResWaterDiff_pct (c, 'PS2')=   [[ResWater (c,'PS2')- ResWater (c,'CC4')]/ResWater (c,'CC4')]*100;

ResWaterCC (c,'PS2') = RW_CC.L(c);
ResWaterDiffCC (c, 'PS2') =   ResWaterCC (c,'PS2')- ResWaterCC (c,'CC4');
ResWaterDiffCC_pct (c, 'PS2')=   [[ResWaterCC (c,'PS2')- ResWaterCC (c,'CC4')]/ResWaterCC (c,'CC4')]*100;

ChangeRW (c,'PS2') = ResWater (c,'PS2')- ResWaterCC (c,'PS2');
ChangeRW_pct(c,'PS2') = [ResWater (c,'PS2')- ResWaterCC (c,'PS2')]/ResWater (c,'PS2');

AgWateract (c,a,'irr','PS2') = fir(c,a,'irr')*X.l(c,a,'irr');
AgWateractDiff (c,a,'irr','PS2') =AgWateract (c,a,'irr','PS2') - AgWateract (c,a,'irr','CC4') ;
AgWateractDiff_pct (c,a,'irr','PS2')$(AgWateract (c,a,'irr','CC4') gt 0) =
                                                     (AgWateract (c,a,'irr','PS2') - AgWateract (c,a,'irr','CC4'))/AgWateract (c,a,'irr','CC4') ;


*Ag_WaterUse1 (c,'BL') = sum(a$map_cas(c,a,'irr'), fir(c,a,'irr')*X.l(c,a,'irr'))  ;
Ag_WaterUse2 (c,'PS2') =  FW4.l(c);
AgWaterDiff (c, 'PS2') = Ag_WaterUse2 (c,'PS2') - Ag_WaterUse2 (c,'CC4');
AgWaterDiff_pct (c, 'PS2') = [[Ag_WaterUse2 (c,'PS2') - Ag_WaterUse2 (c,'CC4')]/Ag_WaterUse2 (c,'CC4')]*100;

*Res_WaterUse1 (c,'BL') =  RW.l(c)*12*households(c);
Res_WaterUse2 (c,'PS2') =  FW3.l(c);
Res_WaterUseDiff (c,'PS2') =  Res_WaterUse2 (c,'PS2')- Res_WaterUse2 (c,'CC4') ;
Res_WaterUseDiff_pct (c,'PS2') =  [[Res_WaterUse2 (c,'PS2')- Res_WaterUse2 (c,'CC4')]/Res_WaterUse2 (c,'CC4')]*100 ;
totwateruse2 (c,'PS2') = FW2.l(c);
totwateruse2Diff_pct (c,'PS2') = [[totwateruse2 (c,'PS2') - totwateruse2 (c,'CC4')]/totwateruse2 (c,'CC4')]*100;

totincome('PS2')= z.l;
totincomeDiff_pct('PS2') = [[totincome('PS2')-totincome('CC4')]/totincome('CC4')]*100;
totCS('PS2')= TCS.l;
totCSDiff_pct('PS2')= [[totCS('PS2')- totCS('CC4')]/totCS('CC4')]*100; ;
totsurplus('PS2') = TS.L;
totsurplusDiff_pct('PS2') = [[totsurplus('CC4')- totsurplus('CC4')]/totsurplus('CC4')]*100;

Income_Comm(c,'PS2') = Zc.l(c);
Income_CommDiff (c,'PS2') = Income_Comm(c,'PS2')-Income_Comm(c,'CC4') ;
Income_CommDiff_pct(c,'PS2')= [[Income_Comm(c,'PS2')-Income_Comm(c,'CC4')]/Income_Comm(c,'CC4')]*100 ;
Cons_Surplus(c,'PS2') = CS.l(c);
Cons_SurplusDiff(c,'PS2') = Cons_Surplus(c,'PS2')-Cons_Surplus(c,'CC4');
Cons_SurplusDiff_pct(c,'PS2') = [[Cons_Surplus(c,'PS2')-Cons_Surplus(c,'CC4')]/Cons_Surplus(c,'CC4')]*100;
TSc(c,'PS2')= Zc.l(c) + CS.l(c);




WaterNU(c,'PS2')= WNU2.l(c);

Income_Act(a,'PS2') = sum((c,s), yld(c,a,s)*ps0(a)*X.l(c,a,s)) - sum((c,s), AC.l(c,a,s)*X.l(c,a,s));
Income_ActDiff(a,'PS2') = Income_Act(a,'PS2') - Income_Act(a,'CC4');
Income_ActDiff_pct(a,'PS2')$(Income_Act(a,'CC4') gt 0) = [[Income_Act(a,'PS2') - Income_Act(a,'CC4')]/Income_Act(a,'CC4')]*100;

Income_Act_Comm(c,a,'PS2')= sum(s,yld(c,a,s)*ps0(a)*X.l(c,a,s)) - sum(s,AC.l(c,a,s)*X.l(c,a,s));
Income_Act_CommDiff(c,a,'PS2')= Income_Act_Comm(c,a,'PS2')-Income_Act_Comm(c,a,'CC4') ;
Income_Act_CommDiff_pct(c,a,'PS2')$(Income_Act_Comm(c,a,'CC4') gt 0) = [[Income_Act_Comm(c,a,'PS2')-Income_Act_Comm(c,a,'CC4')]/Income_Act_Comm(c,a,'CC4')]*100 ;
Cost(c,a,s,'PS2') = AC.L(C,a,s);
Income_Act_CommSys(c,a,s,'PS2')= (yld(c,a,s)*ps0(a)*Comm_report(c,a,s,'PS2')) - (Cost(c,a,s,'PS2')*X.l(c,a,s));

display Comm_report,Basin_report, ResWater,ResWaterDiff,ResWaterDiff_pct,ResWaterCC,ResWaterDiffCC,ResWaterDiffCC_pct,ChangeRW, ChangeRW_pct,AgWateract,AgWateractDiff
AgWateractDiff_pct, Ag_WaterUse2,  AgWaterDiff,AgWaterDiff_pct, Res_WaterUse2, Res_WaterUseDiff,Res_WaterUseDiff_pct, totwateruse2, totwateruse2Diff_pct,totincome,
totincomeDiff_pct,totCS,totCSDiff_pct,totsurplus,totsurplusDiff_pct,Income_Comm,Income_CommDiff,Income_CommDiff_pct,Cons_Surplus,Cons_SurplusDiff,
Cons_SurplusDiff_pct, WaterNU,Income_Act,Income_ActDiff,Income_ActDiff_pct,Income_Act_Comm,Income_Act_CommDiff,Income_Act_CommDiff_pct, Cost, Income_Act_CommSys     ;
option decimals=8;


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*             Policy Scenario 3 and Climate Change scenario 4                  *
*             Increase in Hdr (10%) and Hda (15%)                                    *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*

p_hda(c)= phda_ori(c)*(1.15);

solve PMP_we_0 using nlp maximizing TS;


Comm_report(c,a,s,'PS3')  = X.l(c,a,s);
Comm_report(c,a,s,'diff_PS3-CC4') = Comm_report(c,a,s,'PS3') - Comm_report(c,a,s,'CC4');
Comm_report(c,'area',s,'PS3')  = sum(a,X.l(c,a,s));
Comm_report(c,'area','total','PS3') = sum((a,s),X.l(c,a,s));
Comm_report(c,'iarea','irr','PS3') =   IL.l(c);
Comm_report(c,'iarea','irr','diff_PS3-CC4%') =
                                 [[Comm_report(c,'iarea','irr','PS3')-Comm_report(c,'iarea','irr','CC4')]/Comm_report(c,'iarea','irr','CC4')]*100;

Basin_report('irr','PS3') = sum ((c,a),X.l(c,a,'irr'));

ResWater (c,'PS3') = RW.L(c);
ResWaterDiff (c, 'PS3') =   ResWater (c,'PS3')- ResWater (c,'CC4');
ResWaterDiff_pct (c, 'PS3')=   [[ResWater (c,'PS3')- ResWater (c,'CC4')]/ResWater (c,'CC4')]*100;

ResWaterCC (c,'PS3') = RW_CC.L(c);
ResWaterDiffCC (c, 'PS3') =   ResWaterCC (c,'PS3')- ResWaterCC (c,'CC4');
ResWaterDiffCC_pct (c, 'PS3')=   [[ResWaterCC (c,'PS3')- ResWaterCC (c,'CC4')]/ResWaterCC (c,'CC4')]*100;

ChangeRW (c,'PS3') = ResWater (c,'PS3')- ResWaterCC (c,'PS3');
ChangeRW_pct(c,'PS3') = [ResWater (c,'PS3')- ResWaterCC (c,'PS3')]/ResWater (c,'PS3');

AgWateract (c,a,'irr','PS3') = fir(c,a,'irr')*X.l(c,a,'irr');
AgWateractDiff (c,a,'irr','PS3') =AgWateract (c,a,'irr','PS3') - AgWateract (c,a,'irr','CC4') ;
AgWateractDiff_pct (c,a,'irr','PS3')$(AgWateract (c,a,'irr','CC4') gt 0) =
                                                     (AgWateract (c,a,'irr','PS3') - AgWateract (c,a,'irr','CC4'))/AgWateract (c,a,'irr','CC4') ;


*Ag_WaterUse1 (c,'BL') = sum(a$map_cas(c,a,'irr'), fir(c,a,'irr')*X.l(c,a,'irr'))  ;
Ag_WaterUse2 (c,'PS3') =  FW4.l(c);
AgWaterDiff (c, 'PS3') = Ag_WaterUse2 (c,'PS3') - Ag_WaterUse2 (c,'CC4');
AgWaterDiff_pct (c, 'PS3') = [[Ag_WaterUse2 (c,'PS3') - Ag_WaterUse2 (c,'CC4')]/Ag_WaterUse2 (c,'CC4')]*100;

*Res_WaterUse1 (c,'BL') =  RW.l(c)*12*households(c);
Res_WaterUse2 (c,'PS3') =  FW3.l(c);
Res_WaterUseDiff (c,'PS3') =  Res_WaterUse2 (c,'PS3')- Res_WaterUse2 (c,'CC4') ;
Res_WaterUseDiff_pct (c,'PS3') =  [[Res_WaterUse2 (c,'PS3')- Res_WaterUse2 (c,'CC4')]/Res_WaterUse2 (c,'CC4')]*100 ;
totwateruse2 (c,'PS3') = FW2.l(c);
totwateruse2Diff_pct (c,'PS3') = [[totwateruse2 (c,'PS3') - totwateruse2 (c,'CC4')]/totwateruse2 (c,'CC4')]*100;

totincome('PS3')= z.l;
totincomeDiff_pct('PS3') = [[totincome('PS3')-totincome('CC4')]/totincome('CC4')]*100;
totCS('PS3')= TCS.l;
totCSDiff_pct('PS3')= [[totCS('PS3')- totCS('CC4')]/totCS('CC4')]*100; ;
totsurplus('PS3') = TS.L;
totsurplusDiff_pct('PS3') = [[totsurplus('CC4')- totsurplus('CC4')]/totsurplus('CC4')]*100;

Income_Comm(c,'PS3') = Zc.l(c);
Income_CommDiff (c,'PS3') = Income_Comm(c,'PS3')-Income_Comm(c,'CC4') ;
Income_CommDiff_pct(c,'PS3')= [[Income_Comm(c,'PS3')-Income_Comm(c,'CC4')]/Income_Comm(c,'CC4')]*100 ;
Cons_Surplus(c,'PS3') = CS.l(c);
Cons_SurplusDiff(c,'PS3') = Cons_Surplus(c,'PS3')-Cons_Surplus(c,'CC4');
Cons_SurplusDiff_pct(c,'PS3') = [[Cons_Surplus(c,'PS3')-Cons_Surplus(c,'CC4')]/Cons_Surplus(c,'CC4')]*100;

TSc(c,'PS3')= Zc.l(c) + CS.l(c);



WaterNU(c,'PS3')= WNU2.l(c);

Income_Act(a,'PS3') = sum((c,s), yld(c,a,s)*ps0(a)*X.l(c,a,s)) - sum((c,s), AC.l(c,a,s)*X.l(c,a,s));
Income_ActDiff(a,'PS3') = Income_Act(a,'PS3') - Income_Act(a,'CC4');
Income_ActDiff_pct(a,'PS3')$(Income_Act(a,'CC4') gt 0) = [[Income_Act(a,'PS3') - Income_Act(a,'CC4')]/Income_Act(a,'CC4')]*100;

Income_Act_Comm(c,a,'PS3')= sum(s,yld(c,a,s)*ps0(a)*X.l(c,a,s)) - sum(s,AC.l(c,a,s)*X.l(c,a,s));
Income_Act_CommDiff(c,a,'PS3')= Income_Act_Comm(c,a,'PS3')-Income_Act_Comm(c,a,'CC4') ;
Income_Act_CommDiff_pct(c,a,'PS3')$(Income_Act_Comm(c,a,'CC4') gt 0) = [[Income_Act_Comm(c,a,'PS3')-Income_Act_Comm(c,a,'CC4')]/Income_Act_Comm(c,a,'CC4')]*100 ;
Cost(c,a,s,'PS3') = AC.L(C,a,s);
Income_Act_CommSys(c,a,s,'PS3')= (yld(c,a,s)*ps0(a)*Comm_report(c,a,s,'PS3')) - (Cost(c,a,s,'PS3')*X.l(c,a,s));

display Comm_report,Basin_report, ResWater,ResWaterDiff,ResWaterDiff_pct,ResWaterCC,ResWaterDiffCC,ResWaterDiffCC_pct,ChangeRW, ChangeRW_pct,AgWateract,AgWateractDiff
AgWateractDiff_pct, Ag_WaterUse2,  AgWaterDiff,AgWaterDiff_pct, Res_WaterUse2, Res_WaterUseDiff,Res_WaterUseDiff_pct, totwateruse2, totwateruse2Diff_pct,totincome,
totincomeDiff_pct,totCS,totCSDiff_pct,totsurplus,totsurplusDiff_pct,Income_Comm,Income_CommDiff,Income_CommDiff_pct,Cons_Surplus,Cons_SurplusDiff,
Cons_SurplusDiff_pct, WaterNU,Income_Act,Income_ActDiff,Income_ActDiff_pct,Income_Act_Comm,Income_Act_CommDiff,Income_Act_CommDiff_pct, Cost, Income_Act_CommSys     ;
option decimals=8;


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*             Policy Scenario 4 and Climate Change scenario 4                  *
*             Increase in RWP (30%), no change in HDu                          *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*

p_hda(c)= phda_ori(c)*(1) ;
p_hdr(c)= phdr_ori(c)*(1);
RW_price.fx(c) = 1.3*RW_price0(c);

solve PMP_we_0 using nlp maximizing TS;


Comm_report(c,a,s,'PS4')  = X.l(c,a,s);
Comm_report(c,a,s,'diff_PS4-CC4') = Comm_report(c,a,s,'PS4') - Comm_report(c,a,s,'CC4');
Comm_report(c,'area',s,'PS4')  = sum(a,X.l(c,a,s));
Comm_report(c,'area','total','PS4') = sum((a,s),X.l(c,a,s));
Comm_report(c,'iarea','irr','PS4') =   IL.l(c);
Comm_report(c,'iarea','irr','diff_PS4-CC4%') =
                                 [[Comm_report(c,'iarea','irr','PS4')-Comm_report(c,'iarea','irr','CC4')]/Comm_report(c,'iarea','irr','CC4')]*100;

Basin_report('irr','PS4') = sum ((c,a),X.l(c,a,'irr'));

ResWater (c,'PS4') = RW.L(c);
ResWaterDiff (c, 'PS4') =   ResWater (c,'PS4')- ResWater (c,'CC4');
ResWaterDiff_pct (c, 'PS4')=   [[ResWater (c,'PS4')- ResWater (c,'CC4')]/ResWater (c,'CC4')]*100;

ResWaterCC (c,'PS4') = RW_CC.L(c);
ResWaterDiffCC (c, 'PS4') =   ResWaterCC (c,'PS4')- ResWaterCC (c,'CC4');
ResWaterDiffCC_pct (c, 'PS4')=   [[ResWaterCC (c,'PS4')- ResWaterCC (c,'CC4')]/ResWaterCC (c,'CC4')]*100;

ChangeRW (c,'PS4') = ResWater (c,'PS4')- ResWaterCC (c,'PS4');
ChangeRW_pct(c,'PS4') = [ResWater (c,'PS4')- ResWaterCC (c,'PS4')]/ResWater (c,'PS4');

AgWateract (c,a,'irr','PS4') = fir(c,a,'irr')*X.l(c,a,'irr');
AgWateractDiff (c,a,'irr','PS4') =AgWateract (c,a,'irr','PS4') - AgWateract (c,a,'irr','CC4') ;
AgWateractDiff_pct (c,a,'irr','PS4')$(AgWateract (c,a,'irr','CC4') gt 0) =
                                                     (AgWateract (c,a,'irr','PS4') - AgWateract (c,a,'irr','CC4'))/AgWateract (c,a,'irr','CC4') ;


*Ag_WaterUse1 (c,'BL') = sum(a$map_cas(c,a,'irr'), fir(c,a,'irr')*X.l(c,a,'irr'))  ;
Ag_WaterUse2 (c,'PS4') =  FW4.l(c);
AgWaterDiff (c, 'PS4') = Ag_WaterUse2 (c,'PS4') - Ag_WaterUse2 (c,'CC4');
AgWaterDiff_pct (c, 'PS4') = [[Ag_WaterUse2 (c,'PS4') - Ag_WaterUse2 (c,'CC4')]/Ag_WaterUse2 (c,'CC4')]*100;

*Res_WaterUse1 (c,'BL') =  RW.l(c)*12*households(c);
Res_WaterUse2 (c,'PS4') =  FW3.l(c);
Res_WaterUseDiff (c,'PS4') =  Res_WaterUse2 (c,'PS4')- Res_WaterUse2 (c,'CC4') ;
Res_WaterUseDiff_pct (c,'PS4') =  [[Res_WaterUse2 (c,'PS4')- Res_WaterUse2 (c,'CC4')]/Res_WaterUse2 (c,'CC4')]*100 ;
totwateruse2 (c,'PS4') = FW2.l(c);
totwateruse2Diff_pct (c,'PS4') = [[totwateruse2 (c,'PS4') - totwateruse2 (c,'CC4')]/totwateruse2 (c,'CC4')]*100;

totincome('PS4')= z.l;
totincomeDiff_pct('PS4') = [[totincome('PS4')-totincome('CC4')]/totincome('CC4')]*100;


Income_Comm(c,'PS4') = Zc.l(c);
Income_CommDiff (c,'PS4') = Income_Comm(c,'PS4')-Income_Comm(c,'CC4') ;
Income_CommDiff_pct(c,'PS4')= [[Income_Comm(c,'PS4')-Income_Comm(c,'CC4')]/Income_Comm(c,'CC4')]*100 ;
Cons_Surplus(c,'PS4') = Cons_Surplus(c,'CC4')-[[[[(RW_price.l(c)- RW_price0(c))*ResWaterCC (c,'CC4')]+
[(ResWaterCC (c,'CC4')-RW_CC.L(c))*(Pvirtual (c,'CC4')- RW_price.l(c))]+ [((PV.l(c)-Pvirtual(c,'CC4'))*(ResWaterCC (c,'CC4')-RW_CC.L(c)))/2]]]*[(12*households(c))/10]];

*Cons_Surplus(c,'PS4') = CS.l(c);
Cons_SurplusDiff(c,'PS4') = Cons_Surplus(c,'PS4')-Cons_Surplus(c,'CC4');
Cons_SurplusDiff_pct(c,'PS4') = [[Cons_Surplus(c,'PS4')-Cons_Surplus(c,'CC4')]/Cons_Surplus(c,'CC4')]*100;

totCS('PS4')= sum(c,Cons_Surplus(c,'PS4'));
*totCS('PS4')= TCS.l;
totCSDiff_pct('PS4')= [[totCS('PS4')- totCS('CC4')]/totCS('CC4')]*100; ;
totsurplus('PS4') = TS.L;
totsurplusDiff_pct('PS4') = [[totsurplus('CC4')- totsurplus('CC4')]/totsurplus('CC4')]*100;

TSc(c,'PS4')= Zc.l(c) + CS.l(c);



WaterNU(c,'PS4')= WNU2.l(c);

Income_Act(a,'PS4') = sum((c,s), yld(c,a,s)*ps0(a)*X.l(c,a,s)) - sum((c,s), AC.l(c,a,s)*X.l(c,a,s));
Income_ActDiff(a,'PS4') = Income_Act(a,'PS4') - Income_Act(a,'CC4');
Income_ActDiff_pct(a,'PS4')$(Income_Act(a,'CC4') gt 0) = [[Income_Act(a,'PS4') - Income_Act(a,'CC4')]/Income_Act(a,'CC4')]*100;

Income_Act_Comm(c,a,'PS4')= sum(s,yld(c,a,s)*ps0(a)*X.l(c,a,s)) - sum(s,AC.l(c,a,s)*X.l(c,a,s));
Income_Act_CommDiff(c,a,'PS4')= Income_Act_Comm(c,a,'PS4')-Income_Act_Comm(c,a,'CC4') ;
Income_Act_CommDiff_pct(c,a,'PS4')$(Income_Act_Comm(c,a,'CC4') gt 0) = [[Income_Act_Comm(c,a,'PS4')-Income_Act_Comm(c,a,'CC4')]/Income_Act_Comm(c,a,'CC4')]*100 ;
Cost(c,a,s,'PS4') = AC.L(C,a,s);
Income_Act_CommSys(c,a,s,'PS4')= (yld(c,a,s)*ps0(a)*Comm_report(c,a,s,'PS4')) - (Cost(c,a,s,'PS4')*X.l(c,a,s));

display Comm_report,Basin_report, ResWater,ResWaterDiff,ResWaterDiff_pct,ResWaterCC,ResWaterDiffCC,ResWaterDiffCC_pct,ChangeRW, ChangeRW_pct,AgWateract,AgWateractDiff
AgWateractDiff_pct, Ag_WaterUse2,  AgWaterDiff,AgWaterDiff_pct, Res_WaterUse2, Res_WaterUseDiff,Res_WaterUseDiff_pct, totwateruse2, totwateruse2Diff_pct,totincome,
totincomeDiff_pct,totCS,totCSDiff_pct,totsurplus,totsurplusDiff_pct,Income_Comm,Income_CommDiff,Income_CommDiff_pct,Cons_Surplus,Cons_SurplusDiff,
Cons_SurplusDiff_pct, WaterNU,Income_Act,Income_ActDiff,Income_ActDiff_pct,Income_Act_Comm,Income_Act_CommDiff,Income_Act_CommDiff_pct, Cost, Income_Act_CommSys     ;
option decimals=8;


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*             Policy Scenario 5 and Climate Change scenario 4                  *
*             Increase in RWP (30%), with change in HDu                          *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*

p_hda(c)= phda_ori(c)*(1.15);
p_hdr(c)= phdr_ori(c)*(1.1);


solve PMP_we_0 using nlp maximizing TS;


Comm_report(c,a,s,'PS5')  = X.l(c,a,s);
Comm_report(c,a,s,'diff_PS5-CC4') = Comm_report(c,a,s,'PS5') - Comm_report(c,a,s,'CC4');
Comm_report(c,'area',s,'PS5')  = sum(a,X.l(c,a,s));
Comm_report(c,'area','total','PS5') = sum((a,s),X.l(c,a,s));
Comm_report(c,'iarea','irr','PS5') =   IL.l(c);
Comm_report(c,'iarea','irr','diff_PS5-CC4%') =
                                 [[Comm_report(c,'iarea','irr','PS5')-Comm_report(c,'iarea','irr','CC4')]/Comm_report(c,'iarea','irr','CC4')]*100;

Basin_report('irr','PS5') = sum ((c,a),X.l(c,a,'irr'));

ResWater (c,'PS5') = RW.L(c);
ResWaterDiff (c, 'PS5') =   ResWater (c,'PS5')- ResWater (c,'CC4');
ResWaterDiff_pct (c, 'PS5')=   [[ResWater (c,'PS5')- ResWater (c,'CC4')]/ResWater (c,'CC4')]*100;

ResWaterCC (c,'PS5') = RW_CC.L(c);
ResWaterDiffCC (c, 'PS5') =   ResWaterCC (c,'PS5')- ResWaterCC (c,'CC4');
ResWaterDiffCC_pct (c, 'PS5')=   [[ResWaterCC (c,'PS5')- ResWaterCC (c,'CC4')]/ResWaterCC (c,'CC4')]*100;

ChangeRW (c,'PS5') = ResWater (c,'PS5')- ResWaterCC (c,'PS5');
ChangeRW_pct(c,'PS5') = [ResWater (c,'PS5')- ResWaterCC (c,'PS5')]/ResWater (c,'PS5');

AgWateract (c,a,'irr','PS5') = fir(c,a,'irr')*X.l(c,a,'irr');
AgWateractDiff (c,a,'irr','PS5') =AgWateract (c,a,'irr','PS5') - AgWateract (c,a,'irr','CC4') ;
AgWateractDiff_pct (c,a,'irr','PS5')$(AgWateract (c,a,'irr','CC4') gt 0) =
                                                     (AgWateract (c,a,'irr','PS5') - AgWateract (c,a,'irr','CC4'))/AgWateract (c,a,'irr','CC4') ;


*Ag_WaterUse1 (c,'BL') = sum(a$map_cas(c,a,'irr'), fir(c,a,'irr')*X.l(c,a,'irr'))  ;
Ag_WaterUse2 (c,'PS5') =  FW4.l(c);
AgWaterDiff (c, 'PS5') = Ag_WaterUse2 (c,'PS5') - Ag_WaterUse2 (c,'CC4');
AgWaterDiff_pct (c, 'PS5') = [[Ag_WaterUse2 (c,'PS5') - Ag_WaterUse2 (c,'CC4')]/Ag_WaterUse2 (c,'CC4')]*100;

*Res_WaterUse1 (c,'BL') =  RW.l(c)*12*households(c);
Res_WaterUse2 (c,'PS5') =  FW3.l(c);
Res_WaterUseDiff (c,'PS5') =  Res_WaterUse2 (c,'PS5')- Res_WaterUse2 (c,'CC4') ;
Res_WaterUseDiff_pct (c,'PS5') =  [[Res_WaterUse2 (c,'PS5')- Res_WaterUse2 (c,'CC4')]/Res_WaterUse2 (c,'CC4')]*100 ;
totwateruse2 (c,'PS5') = FW2.l(c);
totwateruse2Diff_pct (c,'PS5') = [[totwateruse2 (c,'PS5') - totwateruse2 (c,'CC4')]/totwateruse2 (c,'CC4')]*100;

totincome('PS5')= z.l;
totincomeDiff_pct('PS5') = [[totincome('PS5')-totincome('CC4')]/totincome('CC4')]*100;


Income_Comm(c,'PS5') = Zc.l(c);
Income_CommDiff (c,'PS5') = Income_Comm(c,'PS5')-Income_Comm(c,'CC4') ;
Income_CommDiff_pct(c,'PS5')= [[Income_Comm(c,'PS5')-Income_Comm(c,'CC4')]/Income_Comm(c,'CC4')]*100 ;
Cons_Surplus(c,'PS5') = Cons_Surplus(c,'CC4')-[[[[(RW_price.l(c)- RW_price0(c))*ResWaterCC (c,'CC4')]+
[(ResWaterCC (c,'CC4')-RW_CC.L(c))*(Pvirtual (c,'CC4')- RW_price.l(c))]+ [((PV.l(c)-Pvirtual(c,'CC4'))*(ResWaterCC (c,'CC4')-RW_CC.L(c)))/2]]]*[(12*households(c))/10]];

*Cons_Surplus(c,'PS5') = CS.l(c);
Cons_SurplusDiff(c,'PS5') = Cons_Surplus(c,'PS5')-Cons_Surplus(c,'CC4');
Cons_SurplusDiff_pct(c,'PS5') = [[Cons_Surplus(c,'PS5')-Cons_Surplus(c,'CC4')]/Cons_Surplus(c,'CC4')]*100;

totCS('PS5')= sum(c,Cons_Surplus(c,'PS5'));
*totCS('PS5')= TCS.l;
totCSDiff_pct('PS5')= [[totCS('PS5')- totCS('CC4')]/totCS('CC4')]*100; ;
totsurplus('PS5') = TS.L;
totsurplusDiff_pct('PS5') = [[totsurplus('CC4')- totsurplus('CC4')]/totsurplus('CC4')]*100;

TSc(c,'PS5')= Zc.l(c) + CS.l(c);


WaterNU(c,'PS5')= WNU2.l(c);

Income_Act(a,'PS5') = sum((c,s), yld(c,a,s)*ps0(a)*X.l(c,a,s)) - sum((c,s), AC.l(c,a,s)*X.l(c,a,s));
Income_ActDiff(a,'PS5') = Income_Act(a,'PS5') - Income_Act(a,'CC4');
Income_ActDiff_pct(a,'PS5')$(Income_Act(a,'CC4') gt 0) = [[Income_Act(a,'PS5') - Income_Act(a,'CC4')]/Income_Act(a,'CC4')]*100;

Income_Act_Comm(c,a,'PS5')= sum(s,yld(c,a,s)*ps0(a)*X.l(c,a,s)) - sum(s,AC.l(c,a,s)*X.l(c,a,s));
Income_Act_CommDiff(c,a,'PS5')= Income_Act_Comm(c,a,'PS5')-Income_Act_Comm(c,a,'CC4') ;
Income_Act_CommDiff_pct(c,a,'PS5')$(Income_Act_Comm(c,a,'CC4') gt 0) = [[Income_Act_Comm(c,a,'PS5')-Income_Act_Comm(c,a,'CC4')]/Income_Act_Comm(c,a,'CC4')]*100 ;
Cost(c,a,s,'PS5') = AC.L(C,a,s);
Income_Act_CommSys(c,a,s,'PS5')= (yld(c,a,s)*ps0(a)*Comm_report(c,a,s,'PS5')) - (Cost(c,a,s,'PS5')*X.l(c,a,s));

display Comm_report,Basin_report, ResWater,ResWaterDiff,ResWaterDiff_pct,ResWaterCC,ResWaterDiffCC,ResWaterDiffCC_pct,ChangeRW, ChangeRW_pct,AgWateract,AgWateractDiff
AgWateractDiff_pct, Ag_WaterUse2,  AgWaterDiff,AgWaterDiff_pct, Res_WaterUse2, Res_WaterUseDiff,Res_WaterUseDiff_pct, totwateruse2, totwateruse2Diff_pct,totincome,
totincomeDiff_pct,totCS,totCSDiff_pct,totsurplus,totsurplusDiff_pct,Income_Comm,Income_CommDiff,Income_CommDiff_pct,Cons_Surplus,Cons_SurplusDiff,
Cons_SurplusDiff_pct, WaterNU,Income_Act,Income_ActDiff,Income_ActDiff_pct,Income_Act_Comm,Income_Act_CommDiff,Income_Act_CommDiff_pct, Cost, Income_Act_CommSys     ;
option decimals=8;








execute_unload '..\results\Basin_WatComm.gdx' Comm_report Basin_report  ResWater ResWaterDiff ResWaterDiff_pct ResWaterCC ResWaterDiffCC
ResWaterDiffCC_pct ChangeRW  ChangeRW_pct AgWateract AgWateractDiff
AgWateractDiff_pct  Ag_WaterUse2   AgWaterDiff AgWaterDiff_pct  Res_WaterUse2  Res_WaterUseDiff Res_WaterUseDiff_pct  totwateruse2  totwateruse2Diff_pct totincome
totincomeDiff_pct totCS totCSDiff_pct totsurplus totsurplusDiff_pct Income_Comm Income_CommDiff Income_CommDiff_pct Cons_Surplus Cons_SurplusDiff
Cons_SurplusDiff_pct  WaterNU Income_Act Income_ActDiff Income_ActDiff_pct Income_Act_Comm Income_Act_CommDiff Income_Act_CommDiff_pct Cost Income_Act_CommSys TSc  ;

execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=Comm_report rng=Comm_report!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=Basin_report rng=Basin_report!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=ResWater rng=ResWater!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=ResWaterDiff rng=ResWaterDiff!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=ResWaterDiff_pct rng=ResWaterDiff_pct!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=ResWaterCC rng=ResWaterCC!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=ResWaterDiffCC rng=ResWaterDiffCC!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=ResWaterDiffCC_pct rng=ResWaterDiffCC_pct!A1' ;

execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=ChangeRW rng=ChangeRW!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=ChangeRW_pct rng=ChangeRW_pct!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=AgWateract rng=AgWateract!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=AgWateractDiff rng=AgWateractDiff!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=AgWateractDiff_pct rng=AgWateractDiff_pct!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=Ag_WaterUse2 rng=Ag_WaterUse2!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=AgWaterDiff rng=AgWaterDiff!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=AgWaterDiff_pct rng=AgWaterDiff_pct!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=Res_WaterUse2 rng=Res_WaterUse2!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=Res_WaterUseDiff rng=Res_WaterUseDiff!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=Res_WaterUseDiff_pct rng=Res_WaterUseDiff_pct!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=totwateruse2 rng=totwateruse2!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=totwateruse2Diff_pct rng=totwateruse2Diff_pct!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=totincome rng=totincome!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=totincomeDiff_pct rng=totincomeDiff_pct!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=totCS rng=totCS!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=totCSDiff_pct rng=totCSDiff_pct!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=totsurplus rng=totsurplus!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=totsurplusDiff_pct rng=totsurplusDiff_pct!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=Income_Comm rng=Income_Comm!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=Income_CommDiff rng=Income_CommDiff!A2' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=Income_CommDiff_pct rng=Income_CommDiff_pct!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=Cons_Surplus rng=Cons_Surplus!A2' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=Cons_SurplusDiff rng=Cons_SurplusDiff!A2' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=Cons_SurplusDiff_pct rng=Cons_SurplusDiff_pct!A2'
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=WaterNU rng=WaterNU!A1' ;

execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=Income_Act rng=Income_Act!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=Income_ActDiff rng=Income_ActDiff!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=Income_ActDiff_pct rng=Income_ActDiff_pct!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=Income_Act_Comm rng=Income_Act_Comm!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=Income_Act_CommDiff rng=Income_Act_CommDiff!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=Income_Act_CommDiff_pct rng=Income_Act_CommDiff_pct!A1' ;

execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=Cost rng=Cost!A1' ;
execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=Income_Act_CommSys rng=Income_Act_CommSys!A1' ;

execute 'gdxxrw.exe ..\results\Basin_WatComm.gdx o=..\results\Basin_WatComm.xlsx par=TSc rng=TSc!A1' ;
