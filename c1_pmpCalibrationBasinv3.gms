*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
$ontext
   Basin Agricultural Model

   Name      :   c1_pmpCalibrationBasin.gms
   Purpose   :   Cost function calibration
   Author    :   M Blanco, R Ponce
   Date      :   15.09.14
   Since     :   January 2011
   CalledBy  :

   Notes     :

$offtext
$onmulti      ;
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*                         INCLUDE SETS AND BASE DATA                           *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
$include basedata\load_baseData.gms
;
parameter test; test=sum(c,tland(c));



*~~~~~~~~~~~~~~~~~~~~~~~~ BASEYEAR DATA    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*   ---- definition of current activities in each Commune
map_cas(c,a,s)= yes$X0(c,a,s);

*   ---- definition of base model parameters

*~~~~~~~~~~~~~~~~~~~~~~~~ CALIBRATION PARAMETERS            ~~~~~~~~~~~~~~~~~~*
Parameter
   eps1       "epsilon (activity)"
   eps2       "epsilon (crop)"
   eps3       "epsilon (total crop area)"
   mu1        "dual values from calibration constraints (activity)"
   mu1_ext        "dual values from calibration constraints (activity)"
   mu2        "dual values from calibration constraints (group)"
   mu3        "dual values from calibration constraints (total activity area)"
   cvpar      "cost function parameters"
   LambdaL    "land marginal value"

;
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*            PMP CALIBRATION                                                  *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*~~~~~~~~~~~~~~~~~ SOLVE LP MODEL WITH CALIBRATION CONSTRAINTS ~~~~~~~~~~~~~~~*
$include b1_coreModelBasinv3.gms
;

* consider only potential activities
X.fx(c,a,s)$(not map_cas(c,a,s)) = 0;

* bounds on variables
X.up(c,a,s)$map_cas(c,a,s) = tland(c);

* exogenous producer prices
PS.fx(a) = ps0(a)  ;
RW_price.fx(c) = RW_price0(c);
PV.lo(c) = 1;
RW.lo(c)=1;
RW_cc.lo(c)=1;


*   ---- calibration parameters
*   ---- eps1 > eps2 - ep2 < eps3
eps1=0.00001;
eps2=0.0000001;
eps3=0.000001;


*   ---- calibration constraints
equation
   calib1    calibration constraints (activity)

;

CALIB1(c,a,s)..  X(c,a,s)$map_cas(c,a,s) =l= x0(c,a,s)*(1+eps2);


parameter chPMP, cpar, tstland;

display price_par, income, income_par;


model baseLP_w modelo lineal base w /
   CoreModel
   e_ts
   e_totcs
   e_CS
   e_RW
   e_RW_cc
   e_RWAlpha
   e_RWP
   e_PV
   e_cost_LP

/;

solve baseLP_w using NLP maximizing ts   ;


Model calibV4_ext calibration model MB /
   CoreModel
   e_ts
   e_totcs
   e_CS
   e_RW
   e_RW_cc
   e_RWAlpha
   e_RWP
   e_PV
   e_cost_LP
   calib1
/;
solve calibV4_ext using NLP maximizing ts;

parameter chPMP, cpar, tstland, tstreswat, watnotuse, testwatagr;

chPMP(c,a,s,'sgm','w_e') = sgm(c,a,s);
chPMP(c,a,s,'X0','w_e')  = x0(c,a,s);
chPMP(c,a,s,'calib','w_e') = X.l(c,a,s);
chPMP(c,a,s,'diff','w_e') = chPMP(c,a,s,'X0','w_e')- chPMP(c,a,s,'calib','w_e');
tstland(c,'w_e')= sum((a,s),chPMP(c,a,s,'X0','w_e'))- sum((a,s),chPMP(c,a,s,'calib','w_e'));
tstreswat (c) = (RW0(c)-RW.l(c));
testwatagr(c) = FW4.l(c) - [W0_a(c) * p_hda(c)];
watnotuse (c) = WNU2.l(c);
*~~~~~~~~~~~~~~~~~~~~~~~~  COST FUNCTION PARAMETERS            ~~~~~~~~~~~~~~~~*
* mu1
mu1(c,a,s,'w_e')$map_cas(c,a,s)  = CALIB1.M(c,a,s);

*   ---- constant elasticity supply function: Q = a p**b
*        haciendo selas=beta=1/b => p = a**(-beta) Q**beta
*        TC = (a**(-beta)/(beta+1))  Q**(beta+1)
*        en funcion de X => TC = (a**(-beta)/(beta+1)) yld**(beta+1) X**(beta+1)
*        haciendo alfa=(a**(-beta)/(beta+1)) yld**(beta+1) => TC = alfa X**(beta+1)
*        AV = alfa X**beta

*        alfa se estima a traves de las condiciones de optimalidad MC=c+mu
*        MC = alfa (beta+1) X**beta = c + mu
*        alfa = (c+mu)/(beta+1) x0**(-beta)

BETA_ext(c,a,s)$map_cas(c,a,s) = 1/selas(a);
ALPHA_ext(c,a,s)$map_cas(c,a,s)= (1/(1+beta_ext(c,a,s)))*(vcos(c,a,s)+mu1(c,a,s,'w_e'))*x0(c,a,s)**(-beta_ext(c,a,s));

*   ---- checking pmp parameters
cpar(c,a,s,'alpha','w_e')$map_cas(c,a,s)  = alpha_ext(c,a,s);
cpar(c,a,s,'beta','w_e')$map_cas(c,a,s)   = beta_ext(c,a,s);


*   ---- create gdx file with model data
*display chPMP, cpar, tstreswat,tstland,watnotuse, testwatagr,Rw0, RW.l, RW_price.l, RWP_MAX.l, RW_ALPHA.l, price_par;
display chPMP, cpar, tstreswat,tstland,watnotuse, testwatagr,Rw0, RW.l, RW_price.l, RW_ALPHA.l, price_par;


execute_unload 'basedata\cparBasinV3.gdx' cpar ;

execute 'gdxxrw.exe basedata\cparBasinV3.gdx o= basedata\cparBasinV3.xlsx par=cpar rng=cpar!A1' ;
