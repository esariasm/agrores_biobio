*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
$ontext
   Basin Agricultural Model

   Name      :   CoreModelBasin.gms
   Purpose   :   Core model definition
   Author    :   R Ponce
   Date      :   15.09.14
   Since     :   January 2011
   CalledBy  :   run2_baseline run3_sim

   Notes     :   This file includes
                 + definition of main model equations
                 + definition of core model
$offtext
$onmulti ;
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*                         CORE MODEL DEFINITION                                *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
variables
*---Commune-----
   TS         'total surplus (households + farmers)basline'
   Z           "total net income "
   Zc          "net income per Commune"

;


positive variables
*---Commune------
   TCS         "Total consumer surplus baseline"
   CS          "consumer surplus baseline MM $"



   RW          'Residential water demand m3/yr per household'
   RW_cc       'Residential water demand for CC simulations m3/yr per household'
   RWP_MAX     Residential water maximum price"
   RW_ALPHA    "Constant terms of RW demand (constant, inhabitants, temperature, income, rooms. Linear form"
   RW_price    "Residential water price"
   PV          "Virtual residential water price for CC simulations"



   X           "crop activity level (ha)"
   FW2         "water  constraint in each commune (th m3)"
   FW3         'residential water constraint in each commune (th m3)'
   FW4         'ag water constraint in each commune (th m3)'
   WNU2        'Water not used in each commune'
   IL          "irrigated land"
   TC          "total variable cost"
   AC          "average variable cost"
   PS          "producer price"
   QS          "Total supply"
   TTlC        "total cost"
   LabDem      "Labor Demand"

;




equations
*---Commune------
   e_ts            "objective value function baseline"
   e_totIncome     "Total agricultural income"
   e_income        "agricultural income per commune"
   e_totCs         "total consumer surplus baseline"
   e_CS            "consumer surplus baseline MM$ year"
   e_CS_cc          "consumer surplus CC MM$ year"
   e_RW            "residential water demand (m3/year)"
   e_RW_cc         "residential water demand for CC simulations (m3/year)"
   e_RWAlpha       "constant part of residential water demand"
   e_PMAX          "maximum price of the RW demand eq"
   e_RWP           "Residential water price"
   e_PV            "Virtual Residential water price for CC simulations"
   e_cost_LP       "cost accounting LP"
   e_cost_NLP      "cost accounting NLP"
   e_tLND          "total land constraint"
   e_iLAND         "irrigable land constraint"
   e_RWUse         "residential water use in each commune"
   e_AWUse         "agricultural water use in each commune"
   e_TWUse         "Total water use in each commune"
   e_water2        "water constraint Curacautin"
   e_water3        "water constraint Traiguen"
   e_water4        "water constraint Los Sauces"
   e_water5        "water constraint Ercilla"
   e_water6        "water constraint Collipulli"
   e_water7        "water constraint Mulchen"
   e_water8        "water constraint Angol"
   e_water9        "water constraint Renaico"
   e_water10       "water constraint Negrete"
   e_water11       "water constraint Nacimiento"

*NEW WATER CONSTRAINTS

   e_water12      "water constraint Pinto"
   e_water13      "water constraint Antuco"
   e_water14      "water constraint Quilleco"
   e_water15      "water constraint Tucapel"
   e_water16      "water constraint Yungay"
   e_water17      "water constraint Cabrero"
   e_water18      "water constraint Quillon"
   e_water19      "water constraint Yumbel"
   e_water20      "water constraint Lonquimay"
   e_water21      "water constraint Alto_BioBio"
   e_water23      "water constraint Quilaco"
   e_water24      "water constraint Santa_Barbara"
   e_water25      "water constraint Los_Angeles"
   e_water26      "water constraint Laja"
   e_water27      "water constraint San_Rosendo"
   e_water28      "water constraint Hualqui"
   e_water29      "water constraint Chiguayante"
   e_water30      "water constraint Santa_Juana"
   e_water33      "water constraint Concepci?n"
   e_water34      "water constraint Coronel"
   e_water35      "water constraint San_Pedro_de_la_Paz"
   e_water36      "water constraint Hualpen"
   e_water37      "water constraint Victoria"

   e_water22       "Total Water constraint in commune c"


   e_watNU2        'Water not used in Curacautin'
   e_watNU3        'Water not used in Traiguen'
   e_watNU4        'Water not used in Los Sauces '
   e_watNU5        'Water not used in Ercilla '
   e_watNU6        'Water not used in Collipulli '
   e_watNU7        'Water not used in Mulchen '
   e_watNU8        'Water not used in Angol '
   e_watNU9        'Water not used in Renaico '
   e_watNU10       'Water not used in Negrete '
   e_watNU11       'Water not used in Nacimiento '

*NEW WATER not used

   e_watNU12      "water constraint Pinto"
   e_watNU13      "water constraint Antuco"
   e_watNU14      "water constraint Quilleco"
   e_watNU15      "water constraint Tucapel"
   e_watNU16      "water constraint Yungay"
   e_watNU17      "water constraint Cabrero"
   e_watNU18      "water constraint Quillon"
   e_watNU19      "water constraint Yumbel"
   e_watNU20      "water constraint Lonquimay"
   e_watNU21      "water constraint Alto_BioBio"
   e_watNU23      "water constraint Quilaco"
   e_watNU24      "water constraint Santa_Barbara"
   e_watNU25      "water constraint Los_Angeles"
   e_watNU26      "water constraint Laja"
   e_watNU27      "water constraint San_Rosendo"
   e_watNU28      "water constraint Hualqui"
   e_watNU29      "water constraint Chiguayante"
   e_watNU30      "water constraint Santa_Juana"
   e_watNU33      "water constraint Concepci?n"
   e_watNU34      "water constraint Coronel"
   e_watNU35      "water constraint San_Pedro_de_la_Paz"
   e_watNU36      "water constraint Hualpen"
   e_watNU37      "water constraint Victoria"


   e_TCost         "total cost"
   e_QS            "total production"
   e_lab           "Labor demand (total Working days per year)"
   e_reswat        "variation of RW"

;
*------All values in million CLP------

*-------Commune level------
*Total surplus
e_TS..          sum(c,Zc(c)) + sum(c,CS(c)) =e= TS ;

*Total consumer surplus
e_totCs..       sum(c,cs(c)) =e= TCS  ;

*Total agriculture income
e_totIncome..   sum(c,Zc(c)) =e= Z ;

*Agricultural Income by commune
e_income(c)..   (sum(map_cas(c,a,s), yld(c,a,s)*ps(a)*X(c,a,s))
                - sum(map_cas(c,a,s), AC(c,a,s)*X(c,a,s)))
                =e= Zc(c);

*CONSUMER'S SURPLUS

*e_CS(c)..           CS(c) =e=  [[(RWP_MAX(c)-RW_price(c))*RW(c)/2]-[(PV(c)-RW_price(c))*(RW(c)-RW_cc(c))/2]]*[(12*households(c))/10000];
e_CS(c)..           CS(c) =e=  [[RW_price(c)*RW(c)/(price_par(c)+1)]-[(PV(c)-RW_price(c))*(RW(c)-RW_cc(c))/2]]*[(12*households(c))/10];

*CAMBIAR PV, RW, RW_CC, RW_ALPHA, RW_PRICE

*Residential Water demand
*e_RW(c)..           RW(c) =e= RW_ALPHA(c) + price_par(c)*RW_price(c)     ;
e_RW(c)..            RW(c) =e= exp(RW_ALPHA(c) + price_par(c)*log(RW_price(c)))     ;

*Residential Water demand for CC Simulations
e_RW_cc(c)..         RW_cc(c) =e= exp(RW_ALPHA(c) + price_par(c)*log(PV(c)));

*Constant terms of RW demand equation
*e_RWAlpha(c)..      RW_ALPHA(c) =e=  const(c)+ temp_par(c)*temp(c)+room_par(c)*rooms(c)+inha_par(c)*inhab(c) + income_par(c)*income(c);
e_RWAlpha(c)..      RW_ALPHA(c) =e=  const(c)+ temp_par(c)*temp(c)+room_par(c)*rooms(c)+inha_par(c)*inhab(c) + income_par(c)*log(income(c));


* maximun price of the RW demand equation
e_PMAX(c)..          RWP_MAX(c) =e= (-RW_ALPHA(c)/(price_par(c)))      ;

*Residential water price
*e_RWP(c)..          RW_price(c) =e= (RW(c)-RW_Alpha(c))/(price_par(c)) ;
e_RWP(c)..          RW_price(c) =e= exp[(log(RW(c))-RW_Alpha(c))/price_par(c)];;


* Virtual Residential Water Price for CC Simulations
*e_PV(c)..          PV(c) =e= (RW_cc(c)-RW_Alpha(c))/(price_par(c)) ;
e_PV(c)..          PV(c) =e= exp[(log(RW_cc(c))-RW_Alpha(c))/price_par(c)];

e_cost_LP(c,a,s)..  vcos(c,a,s)   =e= AC(c,a,s);

e_cost_NLP(c,a,s).. alpha(c,a,s)*X(c,a,s)**beta(c,a,s)     =e= AC(c,a,s);

e_tLND(c)..  sum((a,s)$map_cas(c,a,s), X(c,a,s)) =L= tland(c);
e_iLAND(c)..  sum(a$map_cas(c,a,'irr'), X(c,a,'irr')) =L= IL(c);

*Water restriction by commune including externalities in water consumption, according to the following est-to-west order:
*Curacautin, Traiguen, Los_Sauces, Angol(+Collipulli, +Ercilla), Reanaico(+Collipulli, +Mulchen), Negrete, Nacimiento.
*It assumes that 50% of residual water from Collipulli goes to Angol, and the other 50% to Renaico.

e_RWUse(c)..    RW_CC(c)*12*households(c) =e= FW3(c);

e_AWUse(c)..    sum(a$map_cas(c,a,'irr'), fir(c,a,'irr')*X(c,a,'irr'))  =e= FW4(c);

e_TWUse(c)..    FW4(c) + FW3(c)   =e= FW2(c)   ;

e_water2('Curacautin')..  FW2('Curacautin')  =L= W0_a('Curacautin')*p_hda('Curacautin')+ W0_r('Curacautin')*p_hdr('Curacautin');
e_water37('Victoria')..  FW2('Victoria') =L= W0_a('Victoria')*p_hda('Victoria')+ W0_r('Victoria')*p_hdr('Victoria')+0.5*WNU2('Curacautin')*p_hdra('Victoria');
e_water6('Collipulli')..  FW2('Collipulli') =L= W0_a('Collipulli')*p_hda('Collipulli')+ W0_r('Collipulli')*p_hdr('Collipulli')+0.5*WNU2('Curacautin')*p_hdra('Collipulli') ;
e_water5('Ercilla')..  FW2('Ercilla') =L= W0_a('Ercilla')*p_hda('Ercilla')+ W0_r('Ercilla')*p_hdr('Ercilla')+ WNU2('Victoria')*p_hdra('Ercilla') ;
e_water3('Traiguen')..  FW2('Traiguen') =L= W0_a('Traiguen')*p_hda('Traiguen')+ W0_r('Traiguen')*p_hdr('Traiguen');
e_water4('Los_Sauces')..  FW2('Los_Sauces') =L= W0_a('Los_Sauces')*p_hda('Los_Sauces')+ W0_r('Los_Sauces')*p_hdr('Los_Sauces')+WNU2('Traiguen')*p_hdra('Los_Sauces');
e_water8('Angol')..  FW2('Angol') =L= W0_a('Angol')*p_hda('Angol')+ W0_r('Angol')*p_hdr('Angol')+ (WNU2('Los_Sauces')+WNU2('Ercilla'))*p_hdra('Angol');
e_water9('Renaico')..  FW2('Renaico') =L= W0_a('Renaico')*p_hda('Renaico')+ W0_r('Renaico')*p_hdr('Renaico')+ (WNU2('Collipulli')+WNU2('Angol'))*p_hdra('Renaico');

e_water20('Lonquimay')..  FW2('Lonquimay') =L= W0_a('Lonquimay')*p_hda('Lonquimay')+ W0_r('Lonquimay')*p_hdr('Lonquimay');
e_water21('Alto_BioBio')..  FW2('Alto_BioBio') =L= W0_a('Alto_BioBio')*p_hda('Alto_BioBio')+ W0_r('Alto_BioBio')*p_hdr('Alto_BioBio')+0.5*WNU2('Lonquimay')*p_hdra('Alto_BioBio');
e_water23('Quilaco')..  FW2('Quilaco') =L= W0_a('Quilaco')*p_hda('Quilaco')+ W0_r('Quilaco')*p_hdr('Quilaco')+0.5*WNU2('Lonquimay')*p_hdra('Quilaco')+0.5*WNU2('Alto_BioBio')*p_hdra('Quilaco');
e_water7('Mulchen')..  FW2('Mulchen') =L= W0_a('Mulchen')*p_hda('Mulchen')+ W0_r('Mulchen')*p_hdr('Mulchen') +WNU2('Quilaco'))*p_hdra('Mulchen');
e_water10('Negrete')..  FW2('Negrete') =L= W0_a('Negrete')*p_hda('Negrete')+ W0_r('Negrete')*p_hdr('Negrete')+(WNU2('Renaico')+WNU2('Mulchen'))*p_hdra('Negrete');
e_water11('Nacimiento')..  FW2('Nacimiento') =L= W0_a('Nacimiento')*p_hda('Nacimiento')+ W0_r('Nacimiento')*p_hdr('Nacimiento')+WNU2('Negrete'))*p_hdra('Nacimiento');


e_water12('Pinto')..  FW2('Pinto') =L= W0_a('Pinto')*p_hda('Pinto')+ W0_r('Pinto')*p_hdr('Pinto');
e_water13('Antuco')..  FW2('Antuco') =L= W0_a('Antuco')*p_hda('Antuco')+ W0_r('Antuco')*p_hdr('Antuco')+WNU2('Pinto')*p_hdra('Antuco')+WNU2('Pinto')*p_hdra('Antuco');
e_water24('Santa_Barbara')..  FW2('Santa_Barbara') =L= W0_a('Santa_Barbara')*p_hda('Santa_Barbara')+ W0_r('Santa_Barbara')*p_hdr('Santa_Barbara')+0.5*WNU2('Antuco')*p_hdra('Santa_Barbara')+0.5*WNU2('Alto_BioBio')*p_hdra('Santa_Barbara');
e_water14('Quilleco')..  FW2('Quilleco') =L= W0_a('Quilleco')*p_hda('Quilleco')+ W0_r('Quilleco')*p_hdr('Quilleco')+0.5*WNU2('Antuco')*p_hdra('Quilleco');
e_water25('Los_Angeles')..  FW2('Los_Angeles') =L= W0_a('Los_Angeles')*p_hda('Los_Angeles')+ W0_r('Los_Angeles')*p_hdr('Los_Angeles')+WNU2('Quilleco')*p_hdra('Los_Angeles')+WNU2('Santa_Barbara')*p_hdra('Los_Angeles');
e_water26('Laja')..  FW2('Laja') =L= W0_a('Laja')*p_hda('Laja')+ W0_r('Laja')*p_hdr('Laja')+WNU2('Los_Angeles')*p_hdra('Laja');

e_water30('Santa_Juana')..  FW2('Santa_Juana') =L= W0_a('Santa_Juana')*p_hda('Santa_Juana')+ W0_r('Santa_Juana')*p_hdr('Santa_Juana')+0.5*WNU2('Laja')*p_hdra('Santa_Juana')+WNU2('Nacimiento')*p_hdra('Santa_Juana');


e_water15('Tucapel')..  FW2('Tucapel') =L= W0_a('Tucapel')*p_hda('Tucapel')+ W0_r('Tucapel')*p_hdr('Tucapel');
e_water16('Yungay')..  FW2('Yungay') =L= W0_a('Yungay')*p_hda('Yungay')+ W0_r('Yungay')*p_hdr('Yungay')+WNU2('Tucapel')*p_hdra('Yungay');
e_water17('Cabrero')..  FW2('Cabrero') =L= W0_a('Cabrero')*p_hda('Cabrero')+ W0_r('Cabrero')*p_hdr('Cabrero')+WNU2('Yungay')*p_hdra('Cabrero');
e_water18('Quillon')..  FW2('Quillon') =L= W0_a('Quillon')*p_hda('Quillon')+ W0_r('Quillon')*p_hdr('Quillon');
e_water19('Yumbel')..  FW2('Yumbel') =L= W0_a('Yumbel')*p_hda('Yumbel')+ W0_r('Yumbel')*p_hdr('Yumbel')+WNU2('Cabrero')*p_hdra('Yumbel')+WNU2('Quillon')*p_hdra('Yumbel');


e_water27('San_Rosendo')..  FW2('San_Rosendo') =L= W0_a('San_Rosendo')*p_hda('San_Rosendo')+ W0_r('San_Rosendo')*p_hdr('San_Rosendo')+0.5*WNU2('Laja')*p_hdra('San_Rosendo')+0.5*WNU2('Yumbel')*p_hdra('San_Rosendo');


e_water28('Hualqui')..  FW2('Hualqui') =L= W0_a('Hualqui')*p_hda('Hualqui')+ W0_r('Hualqui')*p_hdr('Hualqui')+0.5*WNU2('San_Rosendo')*p_hdra('Hualqui')+0.5*WNU2('Yumbel')*p_hdra('Hualqui')+0.5*WNU2('Santa_Juana')*p_hdra('Hualqui');
e_water29('Chiguayante')..  FW2('Chiguayante') =L= W0_a('Chiguayante')*p_hda('Chiguayante')+ W0_r('Chiguayante')*p_hdr('Chiguayante')+WNU2('Hualqui')*p_hdra('Chiguayante');
e_water33('Concepci?n')..  FW2('Concepci?n') =L= W0_a('Concepci?n')*p_hda('Concepci?n')+ W0_r('Concepci?n')*p_hdr('Concepci?n')+WNU2('Chiguayante')*p_hdra('Concepci?n');

e_water34('Coronel')..  FW2('Coronel') =L= W0_a('Coronel')*p_hda('Coronel')+ W0_r('Coronel')*p_hdr('Coronel')+0.5*WNU2('Santa_Juana')*p_hdra('Coronel');
e_water35('San_Pedro_de_la_Paz')..  FW2('San_Pedro_de_la_Paz') =L= W0_a('San_Pedro_de_la_Paz')*p_hda('San_Pedro_de_la_Paz')+ W0_r('San_Pedro_de_la_Paz')*p_hdr('San_Pedro_de_la_Paz')+WNU2('Coronel')*p_hdra('San_Pedro_de_la_Paz');

e_water36('Hualpen')..  FW2('Hualpen') =L= W0_a('Hualpen')*p_hda('Hualpen')+ W0_r('Hualpen')*p_hdr('Hualpen')+WNU2('San_Pedro_de_la_Paz')*p_hdra('Hualpen')+WNU2('Concepci?n')*p_hdra('Hualpen');





e_watNU2('Curacautin')..      WNU2('Curacautin')$(p_hda('Curacautin') gt 0) =E= DW0('Curacautin') - (FW4('Curacautin')/p_hda('Curacautin')+FW3('Curacautin')/p_hdr('Curacautin'));
e_watNU37('Victoria')..      WNU2('Victoria')$(p_hda('Victoria') gt 0) =E= DW0('Victoria') - (FW4('Victoria')/p_hda('Victoria')+FW3('Victoria')/p_hdr('Victoria'))+0.5*WNU2('Curacautin');
e_watNU6('Collipulli')..      WNU2('Collipulli')$(p_hda('Collipulli') gt 0) =E= DW0('Collipulli') - (FW4('Collipulli')/p_hda('Collipulli')+FW3('Collipulli')/p_hdr('Collipulli'))+0.5*WNU2('Curacautin');
e_watNU5('Ercilla')..      WNU2('Ercilla')$(p_hda('Ercilla') gt 0) =E= DW0('Ercilla') - (FW4('Ercilla')/p_hda('Ercilla')+FW3('Ercilla')/p_hdr('Ercilla'))+ WNU2('Victoria');
e_watNU3('Traiguen')..      WNU2('Traiguen')$(p_hda('Traiguen') gt 0) =E= DW0('Traiguen') - (FW4('Traiguen')/p_hda('Traiguen')+FW3('Traiguen')/p_hdr('Traiguen'));
e_watNU4('Los_Sauces')..      WNU2('Los_Sauces')$(p_hda('Los_Sauces') gt 0) =E= DW0('Los_Sauces') - (FW4('Los_Sauces')/p_hda('Los_Sauces')+FW3('Los_Sauces')/p_hdr('Los_Sauces'))+WNU2('Traiguen');
e_watNU8('Angol')..      WNU2('Angol')$(p_hda('Angol') gt 0) =E= DW0('Angol') - (FW4('Angol')/p_hda('Angol')+FW3('Angol')/p_hdr('Angol'))+WNU2('Los_Sauces')+WNU2('Ercilla');
e_watNU9('Renaico')..      WNU2('Renaico')$(p_hda('Renaico') gt 0) =E= DW0('Renaico') - (FW4('Renaico')/p_hda('Renaico')+FW3('Renaico')/p_hdr('Renaico'))+WNU2('Collipulli')+WNU2('Angol');

e_watNU20('Lonquimay')..      WNU2('Lonquimay')$(p_hda('Lonquimay') gt 0) =E= DW0('Lonquimay') - (FW4('Lonquimay')/p_hda('Lonquimay')+FW3('Lonquimay')/p_hdr('Lonquimay'));
e_watNU21('Alto_BioBio')..      WNU2('Alto_BioBio')$(p_hda('Alto_BioBio') gt 0) =E= DW0('Alto_BioBio') - (FW4('Alto_BioBio')/p_hda('Alto_BioBio')+FW3('Alto_BioBio')/p_hdr('Alto_BioBio'))+0.5*WNU2('Lonquimay');
e_watNU23('Quilaco')..      WNU2('Quilaco')$(p_hda('Quilaco') gt 0) =E= DW0('Quilaco') - (FW4('Quilaco')/p_hda('Quilaco')+FW3('Quilaco')/p_hdr('Quilaco'))+0.5*WNU2('Lonquimay')+0.5*WNU2('Alto_BioBio');
e_watNU7('Mulchen')..      WNU2('Mulchen')$(p_hda('Mulchen') gt 0) =E= DW0('Mulchen') - (FW4('Mulchen')/p_hda('Mulchen')+FW3('Mulchen')/p_hdr('Mulchen'))+WNU2('Quilaco');                                                                                                                                          +0.5*WNU2('Collipulli');                                                                                                            0.5*WNU2('Collipulli')+WNU2('Mulchen')+WNU2('Angol');
e_watNU10('Negrete')..      WNU2('Negrete')$(p_hda('Negrete') gt 0) =E= DW0('Negrete') - (FW4('Negrete')/p_hda('Negrete')+FW3('Negrete')/p_hdr('Negrete'))+ WNU2('Renaico')+WNU2('Renaico')+WNU2('Mulchen');
e_watNU11('Nacimiento')..      WNU2('Nacimiento')$(p_hda('Nacimiento') gt 0) =E= DW0('Nacimiento') - (FW4('Nacimiento')/p_hda('Nacimiento')+FW3('Nacimiento')/p_hdr('Nacimiento'))+ WNU2('Negrete');

e_watNU12('Pinto')..      WNU2('Pinto')$(p_hda('Pinto') gt 0) =E= DW0('Pinto') - (FW4('Pinto')/p_hda('Pinto')+FW3('Pinto')/p_hdr('Pinto'));
e_watNU13('Antuco')..      WNU2('Antuco')$(p_hda('Antuco') gt 0) =E= DW0('Antuco') - (FW4('Antuco')/p_hda('Antuco')+FW3('Antuco')/p_hdr('Antuco'))+WNU2('Pinto');
e_watNU24('Santa_Barbara')..      WNU2('Santa_Barbara')$(p_hda('Santa_Barbara') gt 0) =E= DW0('Santa_Barbara') - (FW4('Santa_Barbara')/p_hda('Santa_Barbara')+FW3('Santa_Barbara')/p_hdr('Santa_Barbara'))+0.5*WNU2('Antuco')+0.5*WNU2('Alto_BioBio');
e_watNU14('Quilleco')..      WNU2('Quilleco')$(p_hda('Quilleco') gt 0) =E= DW0('Quilleco') - (FW4('Quilleco')/p_hda('Quilleco')+FW3('Quilleco')/p_hdr('Quilleco'))+0.5*WNU2('Antuco');
e_watNU25('Los_Angeles')..      WNU2('Los_Angeles')$(p_hda('Los_Angeles') gt 0) =E= DW0('Los_Angeles') - (FW4('Los_Angeles')/p_hda('Los_Angeles')+FW3('Los_Angeles')/p_hdr('Los_Angeles'))+WNU2('Quilleco')+WNU2('Santa_Barbara');
e_watNU26('Laja')..      WNU2('Laja')$(p_hda('Laja') gt 0) =E= DW0('Laja') - (FW4('Laja')/p_hda('Laja')+FW3('Laja')/p_hdr('Laja'))+WNU2('Los_Angeles');

e_watNU30('Santa_Juana')..      WNU2('Santa_Juana')$(p_hda('Santa_Juana') gt 0) =E= DW0('Santa_Juana') - (FW4('Santa_Juana')/p_hda('Santa_Juana')+FW3('Santa_Juana')/p_hdr('Santa_Juana'))+0.5*WNU2('Laja')+WNU2('Nacimiento');


e_watNU15('Tucapel')..      WNU2('Tucapel')$(p_hda('Tucapel') gt 0) =E= DW0('Tucapel') - (FW4('Tucapel')/p_hda('Tucapel')+FW3('Tucapel')/p_hdr('Tucapel'));
e_watNU16('Yungay')..      WNU2('Yungay')$(p_hda('Yungay') gt 0) =E= DW0('Yungay') - (FW4('Yungay')/p_hda('Yungay')+FW3('Yungay')/p_hdr('Yungay'))+WNU2('Tucapel');
e_watNU17('Cabrero')..      WNU2('Cabrero')$(p_hda('Cabrero') gt 0) =E= DW0('Cabrero') - (FW4('Cabrero')/p_hda('Cabrero')+FW3('Cabrero')/p_hdr('Cabrero'))+WNU2('Yungay');
e_watNU18('Quillon')..      WNU2('Quillon')$(p_hda('Quillon') gt 0) =E= DW0('Quillon') - (FW4('Quillon')/p_hda('Quillon')+FW3('Quillon')/p_hdr('Quillon'));
e_watNU19('Yumbel')..      WNU2('Yumbel')$(p_hda('Yumbel') gt 0) =E= DW0('Yumbel') - (FW4('Yumbel')/p_hda('Yumbel')+FW3('Yumbel')/p_hdr('Yumbel'))+WNU2('Cabrero')+WNU2('Quillon');

e_watNU27('San_Rosendo')..      WNU2('San_Rosendo')$(p_hda('San_Rosendo') gt 0) =E= DW0('San_Rosendo') - (FW4('San_Rosendo')/p_hda('San_Rosendo')+FW3('San_Rosendo')/p_hdr('San_Rosendo'))+0.5*WNU2('Laja')+0.5*WNU2('Yumbel');

e_watNU28('Hualqui')..      WNU2('Hualqui')$(p_hda('Hualqui') gt 0) =E= DW0('Hualqui') - (FW4('Hualqui')/p_hda('Hualqui')+FW3('Hualqui')/p_hdr('Hualqui'))+0.5*WNU2('San_Rosendo')+0.5*WNU2('Yumbel')+0.5*WNU2('Santa_Juana');
e_watNU29('Chiguayante')..      WNU2('Chiguayante')$(p_hda('Chiguayante') gt 0) =E= DW0('Chiguayante') - (FW4('Chiguayante')/p_hda('Chiguayante')+FW3('Chiguayante')/p_hdr('Chiguayante'))+WNU2('Hualqui');
e_watNU33('Concepci?n')..      WNU2('Concepci?n')$(p_hda('Concepci?n') gt 0) =E= DW0('Concepci?n') - (FW4('Concepci?n')/p_hda('Concepci?n')+FW3('Concepci?n')/p_hdr('Concepci?n'))+WNU2('Chiguayante');

e_watNU34('Coronel')..      WNU2('Coronel')$(p_hda('Coronel') gt 0) =E= DW0('Coronel') - (FW4('Coronel')/p_hda('Coronel')+FW3('Coronel')/p_hdr('Coronel'))+0.5*WNU2('Santa_Juana');
e_watNU35('San_Pedro_de_la_Paz')..      WNU2('San_Pedro_de_la_Paz')$(p_hda('San_Pedro_de_la_Paz') gt 0) =E= DW0('San_Pedro_de_la_Paz') - (FW4('San_Pedro_de_la_Paz')/p_hda('San_Pedro_de_la_Paz')+FW3('San_Pedro_de_la_Paz')/p_hdr('San_Pedro_de_la_Paz'))+WNU2('Coronel');

e_watNU36('Hualpen')..      WNU2('Hualpen')$(p_hda('Hualpen') gt 0) =E= DW0('Hualpen') - (FW4('Hualpen')/p_hda('Hualpen')+FW3('Hualpen')/p_hdr('Hualpen'))+WNU2('San_Pedro_de_la_Paz')+WNU2('Concepci?n');




e_lab(c,a,s)..     LabDem(c,a,s) =e= X(c,a,s)*lab(c,a,s);

e_TCost..       sum((c,a,s),AC(c,a,s)*X(c,a,s)) =e= TTlC;
e_QS(a)..       QS(a)=l= sum((c,s),yld(c,a,s)*X(c,a,s))  ;

IL.up(c) = 1.25*iland(c);


*-----Baseline Model------
model CoreModel core equations /
   e_totIncome
   e_income
   e_tLND
   e_iLAND
   e_RWUse
   e_AWUse
   e_TWUSE

   e_water2
   e_water3
   e_water4
   e_water5
   e_water6
   e_water7
   e_water8
   e_water9
   e_water10
   e_water11
    e_water12
   e_water13
   e_water14
   e_water15
   e_water16
   e_water17
   e_water18
   e_water19
   e_water20
   e_water21
   e_water23
   e_water24
   e_water25
   e_water26
   e_water27
   e_water28
   e_water29
   e_water30
   e_water33
   e_water34
   e_water35
   e_water36
   e_water37


   e_watNU2
   e_watNU3
   e_watNU4
   e_watNU5
   e_watNU6
   e_watNU7
   e_watNU8
   e_watNU9
   e_watNU10
   e_watNU11
   e_watNU12
   e_watNU13
   e_watNU14
   e_watNU15
   e_watNU16
   e_watNU17
   e_watNU18
   e_watNU19
   e_watNU20
   e_watNU21
   e_watNU23
   e_watNU24
   e_watNU25
   e_watNU26
   e_watNU27
   e_watNU28
   e_watNU29
   e_watNU30
   e_watNU33
   e_watNU34
   e_watNU35
   e_watNU36
   e_watNU37
   e_lab
/;


