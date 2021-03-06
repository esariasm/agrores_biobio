*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
$ontext
   Basin Agricultural Model

   Name      :   run1_defineDatabase
   Purpose   :   define model database
   Author    :   R Ponce
   Date      :   03.09.14
   Since     :   January 2011
   CalledBy  :

   Notes     :   Import excel data into gdx
                 Build model database

$offtext
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
$onmulti
* Mode database to generate GDX files with base data
* Mode datacheck to check market balances and common data

$setglobal database on
$setglobal datacheck off

*-------------------------------------------------------------------------------
*
*   Common sets and parameters
*
*-------------------------------------------------------------------------------

set
   reg                'regions and regional aggregates'
   comm               'communes'
   act                'activities'
   agg                'crop aggregates'
   sys                'production system'
   CCSce              'Climate Change Scenarios'
   var                'variables'             /area,yld,prd/
   map_agg            'mapping aggregates-activities'
   map_reg_comm       'mapping regions-communes'
   yrs                'years 1995-2012'
   Station            ' hydrologic station'
   map_comm_station    'mapping communes-hydrologic station'

;
parameter
   p_cropData      'crop management data commune level'
   p_supplyData    'supply data'
   p_climChange    'impacts of climate change on yields and Cir. Two Scenarios A240-B240'
   p_marketData    'market data'
   p_watsup_station 'Supply data at the basin in m3/yr'

;

$if %database%==on $goto database
$if %datacheck%==on $goto datacheck

$label database
*-------------------------------------------------------------------------------
*
*   Import raw data (from XLS to GDX)
*
*-------------------------------------------------------------------------------
*   ---- auxiliary parameters

parameter
   t_cropData          'crop data'
   t_costShare         'input use as % of total Cost'
   t_outputPriceReal   'Producer Prices 1997-2007(real Dic 2007)($)'
   t_outputPriceNom    'Producer Prices 1997-2007(Nominal)($)'
   t_elasticities     'supply elasticities'
   t_CIR               'Crop Irrigation Requirements mm/h (by AGrimied)'
   t_climChange        'Climate Change Impacts on Yields by PUC (t/h)'
   t_CCA240             'Climate Change Impacts on Yields by PUC A2040(t/h)'
   t_CCB240             'Climate Change Impacts on Yields by PUC B2040(t/h)'
   t_ttlCost           'Total Cost $/h (Dic 2007)'

;

*   ---- import sets (from xls to gdx)
$call "gdxxrw.exe ..\data\activities\DataBase.xlsx o=..\data\sets\sets.gdx se=2 index=indexSet!A3"

$gdxin ..\data\sets\sets.gdx
$load  act agg map_agg  reg sys comm map_reg_comm  CCSce  yrs station
$gdxin


*   ---- import data (from xls to gdx)
*X actualizado al 2019
$call "gdxxrw.exe ..\data\activities\DataBase.xlsx o=..\data\activities\production.gdx se=2 index=indexDat!A3"
*P actualizado al 2018
$call "gdxxrw.exe ..\data\markets\ProducerPrices.xlsx o=..\data\markets\prdPricesReal.gdx se=2 index=indexDat!A3"
*Escenarios Ponce
$call "gdxxrw.exe ..\data\scenarios\CCImpacts(PUC).xlsx o=..\data\scenarios\climChange.gdx se=2 index=indexDat!A3"
$call "gdxxrw.exe ..\data\scenarios\CCYields.xlsx o=..\data\scenarios\ccyields.gdx se=2 index=indexDat!A3"
$call "gdxxrw.exe ..\data\Irrigation\CIR(Agrimed).xlsx o=..\data\Irrigation\CIR.gdx se=2 index=indexDat!A3"
$call "gdxxrw.exe ..\data\markets\elasticities.xlsx o=..\data\markets\elasticities.gdx se=2 index=index!A3"




$gdxin ..\data\activities\production.gdx
$load  t_cropData
$gdxin

$gdxin ..\data\markets\prdPricesReal.gdx
$load  t_outputPriceReal
$gdxin

$gdxin ..\data\scenarios\climchange.gdx
$load  t_climChange
$gdxin

$gdxin ..\data\scenarios\ccyields.gdx
$load  t_CCA240
$gdxin

$gdxin ..\data\scenarios\ccyields.gdx
$load  t_CCB240
$gdxin

$gdxin ..\data\irrigation\CIR.gdx
$load  t_cir
$gdxin

$gdxin ..\data\markets\elasticities.gdx
$load  t_elasticities
$gdxin




*-------------------------------------------------------------------------------
*
*   Define model database
*
*-------------------------------------------------------------------------------

*Actualizacion de datos al 2019, INE y ODEPA
*alfalfa = cste


*Based on ActualizacionCultivos.xlsx

*Araucania: Curacautin, traiguen, los_sauces, angol, ercilla, collipulli, renaico
*Curacautin,  new araucania: lonquimay,collipulli,angol,victoria


t_cropData('curacautin','oat',sys,'area')= t_cropData("curacautin",'oat',sys,'area')*(1-0.182939384)   ;
t_cropData('curacautin','common_bean',sys,'area')= t_cropData("curacautin",'common_bean',sys,'area')*(1-0.069974555) ;
t_cropData('curacautin','potato',sys,'area')= t_cropData("curacautin",'potato',sys,'area')* (1-0.257092324) ;
t_cropData('curacautin','wheat',sys,'area')= t_cropData("curacautin",'wheat',sys,'area')* 2.089297017 ;
t_cropData('curacautin','rice',sys,'area')= t_cropData("curacautin",'rice',sys,'area')* 0;
t_cropData('curacautin','maize',sys,'area')= t_cropData("curacautin",'maize',sys,'area')*(1-0.679190751);
t_cropData('curacautin','sugar_beat',sys,'area')= t_cropData("curacautin",'sugar_beat',sys,'area')* (1.161885246);

t_cropData('curacautin','Peach',sys,'area')= t_cropData("curacautin",'Peach',sys,'area')* (1-0.107142857);
t_cropData('curacautin','Cherry',sys,'area')= t_cropData("curacautin",'Cherry',sys,'area')* 5.983654891;
t_cropData('curacautin','Apple',sys,'area')= t_cropData("curacautin",'Apple',sys,'area')*  2.775391071;
t_cropData('curacautin','Walnut',sys,'area')= t_cropData("curacautin",'Walnut',sys,'area')* 7.393201236;
t_cropData('curacautin','Orange',sys,'area')= t_cropData("curacautin",'Orange',sys,'area')* 0;
t_cropData('curacautin','Olive',sys,'area')= t_cropData("curacautin",'Olive',sys,'area')*   2.583333333;
t_cropData('curacautin','Avocado',sys,'area')= t_cropData("curacautin",'Avocado',sys,'area')* 0;
t_cropData('curacautin','Pear',sys,'area')= t_cropData("curacautin",'Pear',sys,'area')*  (1-0.815081652);
t_cropData('curacautin','grapes',sys,'area')= t_cropData("curacautin",'grapes',sys,'area')*0;
t_cropData('curacautin','vineyard',sys,'area')= t_cropData("curacautin",'vineyard',sys,'area')*0;
t_cropData('curacautin','plum',sys,'area')= t_cropData("curacautin",'plum',sys,'area')*0 ;


*traiguen
t_cropData('traiguen','oat',sys,'area')= t_cropData("traiguen",'oat',sys,'area')*(1-0.182939384)  ;
t_cropData('traiguen','common_bean',sys,'area')= t_cropData("traiguen",'common_bean',sys,'area')* (1-0.069974555) ;
t_cropData('traiguen','potato',sys,'area')= t_cropData("traiguen",'potato',sys,'area')* (1-0.257092324) ;
t_cropData('traiguen','wheat',sys,'area')= t_cropData("traiguen",'wheat',sys,'area')*  2.089297017 ;
t_cropData('traiguen','rice',sys,'area')= t_cropData("traiguen",'rice',sys,'area')* 0;
t_cropData('traiguen','maize',sys,'area')= t_cropData("traiguen",'maize',sys,'area')*(1-0.679190751);
t_cropData('traiguen','sugar_beat',sys,'area')= t_cropData("traiguen",'sugar_beat',sys,'area')* (1.161885246);

t_cropData('traiguen','Peach',sys,'area')= t_cropData("traiguen",'Peach',sys,'area')* (1-0.107142857);
t_cropData('traiguen','Cherry',sys,'area')= t_cropData("traiguen",'Cherry',sys,'area')* 5.983654891;
t_cropData('traiguen','Apple',sys,'area')= t_cropData("traiguen",'Apple',sys,'area')*  2.775391071;
t_cropData('traiguen','Walnut',sys,'area')= t_cropData("traiguen",'Walnut',sys,'area')* 7.393201236;
t_cropData('traiguen','Orange',sys,'area')= t_cropData("traiguen",'Orange',sys,'area')*  0;
t_cropData('traiguen','Olive',sys,'area')= t_cropData("traiguen",'Olive',sys,'area')* 2.583333333;
t_cropData('traiguen','Avocado',sys,'area')= t_cropData("traiguen",'Avocado',sys,'area')*  0;
t_cropData('traiguen','Pear',sys,'area')= t_cropData("traiguen",'Pear',sys,'area')* (1-0.815081652);
t_cropData('traiguen','grapes',sys,'area')= t_cropData("traiguen",'grapes',sys,'area')*0;
t_cropData('traiguen','vineyard',sys,'area')= t_cropData("traiguen",'vineyard',sys,'area')*0;
t_cropData('traiguen','plum',sys,'area')= t_cropData("traiguen",'plum',sys,'area')*0 ;

*los_sauces
t_cropData('los_sauces','oat',sys,'area')= t_cropData("los_sauces",'oat',sys,'area')*(1-0.182939384)  ;
t_cropData('los_sauces','common_bean',sys,'area')= t_cropData("los_sauces",'common_bean',sys,'area')* (1-0.069974555);
t_cropData('los_sauces','potato',sys,'area')= t_cropData("los_sauces",'potato',sys,'area')* (1-0.257092324) ;
t_cropData('los_sauces','wheat',sys,'area')= t_cropData("los_sauces",'wheat',sys,'area')*  2.089297017 ;
t_cropData('los_sauces','rice',sys,'area')= t_cropData("los_sauces",'rice',sys,'area')* 0;
t_cropData('los_sauces','maize',sys,'area')= t_cropData("los_sauces",'maize',sys,'area')*(1-0.679190751);
t_cropData('los_sauces','sugar_beat',sys,'area')= t_cropData("los_sauces",'sugar_beat',sys,'area')* (1.161885246);

t_cropData('los_sauces','Peach',sys,'area')= t_cropData("los_sauces",'Peach',sys,'area')* (1-0.107142857);
t_cropData('los_sauces','Cherry',sys,'area')= t_cropData("los_sauces",'Cherry',sys,'area')*  5.983654891;
t_cropData('los_sauces','Apple',sys,'area')= t_cropData("los_sauces",'Apple',sys,'area')*   2.775391071;
t_cropData('los_sauces','Walnut',sys,'area')= t_cropData("los_sauces",'Walnut',sys,'area')*7.393201236;
t_cropData('los_sauces','Orange',sys,'area')= t_cropData("los_sauces",'Orange',sys,'area')* 0;
t_cropData('los_sauces','Olive',sys,'area')= t_cropData("los_sauces",'Olive',sys,'area')*  2.583333333;
t_cropData('los_sauces','Avocado',sys,'area')= t_cropData("los_sauces",'Avocado',sys,'area')*  0;
t_cropData('los_sauces','Pear',sys,'area')= t_cropData("los_sauces",'Pear',sys,'area')*(1-0.815081652);
t_cropData('los_sauces','grapes',sys,'area')= t_cropData("los_sauces",'grapes',sys,'area')*0;
t_cropData('los_sauces','vineyard',sys,'area')= t_cropData("los_sauces",'vineyard',sys,'area')*0;
t_cropData('los_sauces','plum',sys,'area')= t_cropData("los_sauces",'plum',sys,'area')*0 ;

*angol
t_cropData('angol','oat',sys,'area')= t_cropData("angol",'oat',sys,'area')*(1-0.182939384)  ;
t_cropData('angol','common_bean',sys,'area')= t_cropData("angol",'common_bean',sys,'area')* (1-0.069974555) ;
t_cropData('angol','potato',sys,'area')= t_cropData("angol",'potato',sys,'area')* (1-0.257092324) ;
t_cropData('angol','wheat',sys,'area')= t_cropData("angol",'wheat',sys,'area')*  2.089297017 ;
t_cropData('angol','rice',sys,'area')= t_cropData("angol",'rice',sys,'area')* 0;
t_cropData('angol','maize',sys,'area')= t_cropData("angol",'maize',sys,'area')*(1-0.679190751);
t_cropData('angol','sugar_beat',sys,'area')= t_cropData("angol",'sugar_beat',sys,'area')* (1.161885246);

t_cropData('angol','Peach',sys,'area')= t_cropData("angol",'Peach',sys,'area')*  (1-0.107142857);
t_cropData('angol','Cherry',sys,'area')= t_cropData("angol",'Cherry',sys,'area')*    5.983654891;
t_cropData('angol','Apple',sys,'area')= t_cropData("angol",'Apple',sys,'area')*    2.775391071;
t_cropData('angol','Walnut',sys,'area')= t_cropData("angol",'Walnut',sys,'area')*  7.393201236;
t_cropData('angol','Orange',sys,'area')= t_cropData("angol",'Orange',sys,'area')*    0;
t_cropData('angol','Olive',sys,'area')= t_cropData("angol",'Olive',sys,'area')*     2.583333333;
t_cropData('angol','Avocado',sys,'area')= t_cropData("angol",'Avocado',sys,'area')*     0;
t_cropData('angol','Pear',sys,'area')= t_cropData("angol",'Pear',sys,'area')*  (1-0.815081652);
t_cropData('angol','grapes',sys,'area')= t_cropData("angol",'grapes',sys,'area')*0;
t_cropData('angol','vineyard',sys,'area')= t_cropData("angol",'vineyard',sys,'area')*0;
t_cropData('angol','plum',sys,'area')= t_cropData("angol",'plum',sys,'area')*0 ;

*ercilla
t_cropData('ercilla','oat',sys,'area')= t_cropData("ercilla",'oat',sys,'area')*(1-0.182939384)   ;
t_cropData('ercilla','common_bean',sys,'area')= t_cropData("ercilla",'common_bean',sys,'area')* (1-0.069974555) ;
t_cropData('ercilla','potato',sys,'area')= t_cropData("ercilla",'potato',sys,'area')* (1-0.257092324) ;
t_cropData('ercilla','wheat',sys,'area')= t_cropData("ercilla",'wheat',sys,'area')*  2.089297017 ;
t_cropData('ercilla','rice',sys,'area')= t_cropData("ercilla",'rice',sys,'area')* 0;
t_cropData('ercilla','maize',sys,'area')= t_cropData("ercilla",'maize',sys,'area')*(1-0.679190751);
t_cropData('ercilla','sugar_beat',sys,'area')= t_cropData("ercilla",'sugar_beat',sys,'area')* (1.161885246);

t_cropData('ercilla','Peach',sys,'area')= t_cropData("ercilla",'Peach',sys,'area')*    (1-0.107142857);
t_cropData('ercilla','Cherry',sys,'area')= t_cropData("ercilla",'Cherry',sys,'area')*  5.983654891;
t_cropData('ercilla','Apple',sys,'area')= t_cropData("ercilla",'Apple',sys,'area')*  2.775391071;
t_cropData('ercilla','Walnut',sys,'area')= t_cropData("ercilla",'Walnut',sys,'area')*7.393201236;
t_cropData('ercilla','Orange',sys,'area')= t_cropData("ercilla",'Orange',sys,'area')*  0;
t_cropData('ercilla','Olive',sys,'area')= t_cropData("ercilla",'Olive',sys,'area')*   2.583333333;
t_cropData('ercilla','Avocado',sys,'area')= t_cropData("ercilla",'Avocado',sys,'area')*  0;
t_cropData('ercilla','Pear',sys,'area')= t_cropData("ercilla",'Pear',sys,'area')* (1-0.815081652);
t_cropData('ercilla','grapes',sys,'area')= t_cropData("ercilla",'grapes',sys,'area')*0;
t_cropData('ercilla','vineyard',sys,'area')= t_cropData("ercilla",'vineyard',sys,'area')*0;
t_cropData('ercilla','plum',sys,'area')= t_cropData("ercilla",'plum',sys,'area')*0 ;

*collipulli
t_cropData('collipulli','oat',sys,'area')= t_cropData("collipulli",'oat',sys,'area')*(1-0.182939384)   ;
t_cropData('collipulli','common_bean',sys,'area')= t_cropData("collipulli",'common_bean',sys,'area')* (1-0.069974555) ;
t_cropData('collipulli','potato',sys,'area')= t_cropData("collipulli",'potato',sys,'area')*(1-0.257092324) ;
t_cropData('collipulli','wheat',sys,'area')= t_cropData("collipulli",'wheat',sys,'area')*  2.089297017 ;
t_cropData('collipulli','rice',sys,'area')= t_cropData("collipulli",'rice',sys,'area')* 0;
t_cropData('collipulli','maize',sys,'area')= t_cropData("collipulli",'maize',sys,'area')*(1-0.679190751);
t_cropData('collipulli','sugar_beat',sys,'area')= t_cropData("collipulli",'sugar_beat',sys,'area')* (1.161885246);

t_cropData('collipulli','Peach',sys,'area')= t_cropData("collipulli",'Peach',sys,'area')*   (1-0.107142857);
t_cropData('collipulli','Cherry',sys,'area')= t_cropData("collipulli",'Cherry',sys,'area')*  5.983654891;
t_cropData('collipulli','Apple',sys,'area')= t_cropData("collipulli",'Apple',sys,'area')*  2.775391071;
t_cropData('collipulli','Walnut',sys,'area')= t_cropData("collipulli",'Walnut',sys,'area')*  7.393201236;
t_cropData('collipulli','Orange',sys,'area')= t_cropData("collipulli",'Orange',sys,'area')*  0;
t_cropData('collipulli','Olive',sys,'area')= t_cropData("collipulli",'Olive',sys,'area')*  2.583333333;
t_cropData('collipulli','Avocado',sys,'area')= t_cropData("collipulli",'Avocado',sys,'area')*  0;
t_cropData('collipulli','Pear',sys,'area')= t_cropData("collipulli",'Pear',sys,'area')* (1-0.815081652);
t_cropData('collipulli','grapes',sys,'area')= t_cropData("collipulli",'grapes',sys,'area')*0;
t_cropData('collipulli','vineyard',sys,'area')= t_cropData("collipulli",'vineyard',sys,'area')*0;
t_cropData('collipulli','plum',sys,'area')= t_cropData("collipulli",'plum',sys,'area')*0 ;

*renaico
t_cropData('renaico','oat',sys,'area')= t_cropData("renaico",'oat',sys,'area')*(1-0.182939384)  ;
t_cropData('renaico','common_bean',sys,'area')= t_cropData("renaico",'common_bean',sys,'area')* (1-0.069974555) ;
t_cropData('renaico','potato',sys,'area')= t_cropData("renaico",'potato',sys,'area')* (1-0.257092324) ;
t_cropData('renaico','wheat',sys,'area')= t_cropData("renaico",'wheat',sys,'area')*  2.089297017 ;
t_cropData('renaico','rice',sys,'area')= t_cropData("renaico",'rice',sys,'area')* 0;
t_cropData('renaico','maize',sys,'area')= t_cropData("renaico",'maize',sys,'area')*(1-0.679190751);
t_cropData('renaico','sugar_beat',sys,'area')= t_cropData("renaico",'sugar_beat',sys,'area')* (1.161885246);

t_cropData('renaico','Peach',sys,'area')= t_cropData("renaico",'Peach',sys,'area')*  (1-0.107142857);
t_cropData('renaico','Cherry',sys,'area')= t_cropData("renaico",'Cherry',sys,'area')*   5.983654891;
t_cropData('renaico','Apple',sys,'area')= t_cropData("renaico",'Apple',sys,'area')*    2.775391071;
t_cropData('renaico','Walnut',sys,'area')= t_cropData("renaico",'Walnut',sys,'area')*  7.393201236;
t_cropData('renaico','Orange',sys,'area')= t_cropData("renaico",'Orange',sys,'area')*  0;
t_cropData('renaico','Olive',sys,'area')= t_cropData("renaico",'Olive',sys,'area')*   2.583333333;
t_cropData('renaico','Avocado',sys,'area')= t_cropData("renaico",'Avocado',sys,'area')*     0;
t_cropData('renaico','Pear',sys,'area')= t_cropData("renaico",'Pear',sys,'area')*   (1-0.815081652);
t_cropData('renaico','grapes',sys,'area')= t_cropData("renaico",'grapes',sys,'area')*0;
t_cropData('renaico','vineyard',sys,'area')= t_cropData("renaico",'vineyard',sys,'area')*0;
t_cropData('renaico','plum',sys,'area')= t_cropData("renaico",'plum',sys,'area')*0 ;

***********new: araucania: lonquimay,collipulli,angol,victoria
*Lonquimay
t_cropData('lonquimay','oat',sys,'area')= t_cropData("lonquimay",'oat',sys,'area')*(1-0.182939384)  ;
t_cropData('lonquimay','common_bean',sys,'area')= t_cropData("lonquimay",'common_bean',sys,'area')* (1-0.069974555) ;
t_cropData('lonquimay','potato',sys,'area')= t_cropData("lonquimay",'potato',sys,'area')* (1-0.257092324) ;
t_cropData('lonquimay','wheat',sys,'area')= t_cropData("lonquimay",'wheat',sys,'area')*  2.089297017 ;
t_cropData('lonquimay','rice',sys,'area')= t_cropData("lonquimay",'rice',sys,'area')* 0;
t_cropData('lonquimay','maize',sys,'area')= t_cropData("lonquimay",'maize',sys,'area')*(1-0.679190751);
t_cropData('lonquimay','sugar_beat',sys,'area')= t_cropData("lonquimay",'sugar_beat',sys,'area')* (1.161885246);

t_cropData('lonquimay','Peach',sys,'area')= t_cropData("lonquimay",'Peach',sys,'area')*  (1-0.107142857);
t_cropData('lonquimay','Cherry',sys,'area')= t_cropData("lonquimay",'Cherry',sys,'area')*   5.983654891;
t_cropData('lonquimay','Apple',sys,'area')= t_cropData("lonquimay",'Apple',sys,'area')*    2.775391071;
t_cropData('lonquimay','Walnut',sys,'area')= t_cropData("lonquimay",'Walnut',sys,'area')*  7.393201236;
t_cropData('lonquimay','Orange',sys,'area')= t_cropData("lonquimay",'Orange',sys,'area')*  0;
t_cropData('lonquimay','Olive',sys,'area')= t_cropData("lonquimay",'Olive',sys,'area')*   2.583333333;
t_cropData('lonquimay','Avocado',sys,'area')= t_cropData("lonquimay",'Avocado',sys,'area')*     0;
t_cropData('lonquimay','Pear',sys,'area')= t_cropData("lonquimay",'Pear',sys,'area')*   (1-0.815081652);
t_cropData('lonquimay','grapes',sys,'area')= t_cropData("lonquimay",'grapes',sys,'area')*0;
t_cropData('lonquimay','vineyard',sys,'area')= t_cropData("lonquimay",'vineyard',sys,'area')*0;
t_cropData('lonquimay','plum',sys,'area')= t_cropData("lonquimay",'plum',sys,'area')*0 ;

*Collipulli
t_cropData('collipulli','oat',sys,'area')= t_cropData("collipulli",'oat',sys,'area')*(1-0.182939384)  ;
t_cropData('collipulli','common_bean',sys,'area')= t_cropData("collipulli",'common_bean',sys,'area')* (1-0.069974555) ;
t_cropData('collipulli','potato',sys,'area')= t_cropData("collipulli",'potato',sys,'area')* (1-0.257092324) ;
t_cropData('collipulli','wheat',sys,'area')= t_cropData("collipulli",'wheat',sys,'area')*  2.089297017 ;
t_cropData('collipulli','rice',sys,'area')= t_cropData("collipulli",'rice',sys,'area')* 0;
t_cropData('collipulli','maize',sys,'area')= t_cropData("collipulli",'maize',sys,'area')*(1-0.679190751);
t_cropData('collipulli','sugar_beat',sys,'area')= t_cropData("collipulli",'sugar_beat',sys,'area')* (1.161885246);

t_cropData('collipulli','Peach',sys,'area')= t_cropData("collipulli",'Peach',sys,'area')*  (1-0.107142857);
t_cropData('collipulli','Cherry',sys,'area')= t_cropData("collipulli",'Cherry',sys,'area')*   5.983654891;
t_cropData('collipulli','Apple',sys,'area')= t_cropData("collipulli",'Apple',sys,'area')*    2.775391071;
t_cropData('collipulli','Walnut',sys,'area')= t_cropData("collipulli",'Walnut',sys,'area')*  7.393201236;
t_cropData('collipulli','Orange',sys,'area')= t_cropData("collipulli",'Orange',sys,'area')*  0;
t_cropData('collipulli','Olive',sys,'area')= t_cropData("collipulli",'Olive',sys,'area')*   2.583333333;
t_cropData('collipulli','Avocado',sys,'area')= t_cropData("collipulli",'Avocado',sys,'area')*     0;
t_cropData('collipulli','Pear',sys,'area')= t_cropData("collipulli",'Pear',sys,'area')*   (1-0.815081652);
t_cropData('collipulli','grapes',sys,'area')= t_cropData("collipulli",'grapes',sys,'area')*0;
t_cropData('collipulli','vineyard',sys,'area')= t_cropData("collipulli",'vineyard',sys,'area')*0;
t_cropData('collipulli','plum',sys,'area')= t_cropData("collipulli",'plum',sys,'area')*0 ;

*angol
t_cropData('angol','oat',sys,'area')= t_cropData("angol",'oat',sys,'area')*(1-0.182939384)  ;
t_cropData('angol','common_bean',sys,'area')= t_cropData("angol",'common_bean',sys,'area')* (1-0.069974555) ;
t_cropData('angol','potato',sys,'area')= t_cropData("angol",'potato',sys,'area')* (1-0.257092324) ;
t_cropData('angol','wheat',sys,'area')= t_cropData("angol",'wheat',sys,'area')*  2.089297017 ;
t_cropData('angol','rice',sys,'area')= t_cropData("angol",'rice',sys,'area')* 0;
t_cropData('angol','maize',sys,'area')= t_cropData("angol",'maize',sys,'area')*(1-0.679190751);
t_cropData('angol','sugar_beat',sys,'area')= t_cropData("angol",'sugar_beat',sys,'area')* (1.161885246);

t_cropData('angol','Peach',sys,'area')= t_cropData("angol",'Peach',sys,'area')*  (1-0.107142857);
t_cropData('angol','Cherry',sys,'area')= t_cropData("angol",'Cherry',sys,'area')*   5.983654891;
t_cropData('angol','Apple',sys,'area')= t_cropData("angol",'Apple',sys,'area')*    2.775391071;
t_cropData('angol','Walnut',sys,'area')= t_cropData("angol",'Walnut',sys,'area')*  7.393201236;
t_cropData('angol','Orange',sys,'area')= t_cropData("angol",'Orange',sys,'area')*  0;
t_cropData('angol','Olive',sys,'area')= t_cropData("angol",'Olive',sys,'area')*   2.583333333;
t_cropData('angol','Avocado',sys,'area')= t_cropData("angol",'Avocado',sys,'area')*     0;
t_cropData('angol','Pear',sys,'area')= t_cropData("angol",'Pear',sys,'area')*   (1-0.815081652);
t_cropData('angol','grapes',sys,'area')= t_cropData("angol",'grapes',sys,'area')*0;
t_cropData('angol','vineyard',sys,'area')= t_cropData("angol",'vineyard',sys,'area')*0;
t_cropData('angol','plum',sys,'area')= t_cropData("angol",'plum',sys,'area')*0 ;

*victoria
t_cropData('victoria','oat',sys,'area')= t_cropData("victoria",'oat',sys,'area')*(1-0.182939384)  ;
t_cropData('victoria','common_bean',sys,'area')= t_cropData("victoria",'common_bean',sys,'area')* (1-0.069974555) ;
t_cropData('victoria','potato',sys,'area')= t_cropData("victoria",'potato',sys,'area')* (1-0.257092324) ;
t_cropData('victoria','wheat',sys,'area')= t_cropData("victoria",'wheat',sys,'area')*  2.089297017 ;
t_cropData('victoria','rice',sys,'area')= t_cropData("victoria",'rice',sys,'area')* 0;
t_cropData('victoria','maize',sys,'area')= t_cropData("victoria",'maize',sys,'area')*(1-0.679190751);
t_cropData('victoria','sugar_beat',sys,'area')= t_cropData("victoria",'sugar_beat',sys,'area')* (1.161885246);

t_cropData('victoria','Peach',sys,'area')= t_cropData("victoria",'Peach',sys,'area')*  (1-0.107142857);
t_cropData('victoria','Cherry',sys,'area')= t_cropData("victoria",'Cherry',sys,'area')*   5.983654891;
t_cropData('victoria','Apple',sys,'area')= t_cropData("victoria",'Apple',sys,'area')*    2.775391071;
t_cropData('victoria','Walnut',sys,'area')= t_cropData("victoria",'Walnut',sys,'area')*  7.393201236;
t_cropData('victoria','Orange',sys,'area')= t_cropData("victoria",'Orange',sys,'area')*  0;
t_cropData('victoria','Olive',sys,'area')= t_cropData("victoria",'Olive',sys,'area')*   2.583333333;
t_cropData('victoria','Avocado',sys,'area')= t_cropData("victoria",'Avocado',sys,'area')*     0;
t_cropData('victoria','Pear',sys,'area')= t_cropData("victoria",'Pear',sys,'area')*   (1-0.815081652);
t_cropData('victoria','grapes',sys,'area')= t_cropData("victoria",'grapes',sys,'area')*0;
t_cropData('victoria','vineyard',sys,'area')= t_cropData("victoria",'vineyard',sys,'area')*0;
t_cropData('victoria','plum',sys,'area')= t_cropData("victoria",'plum',sys,'area')*0 ;




************************************************************************************************************************
*Actualizacion de datos al 2019, INE y ODEPA
*Falta:  alfalfa


*BioBio: Mulchen, Negrete, Nacimiento
*new: ?uble/biobio: pinto, antuco, quilleco,tucapel,yungay,cabrero,quillon,
*new: yumbel, alto_biobio, quilaco, santa_barbara, los_angeles, laja, san_rosendo
*new: hualqui, chiguayante, concepcion, hualpen, coronel, san_pedro_de_la_paz
*new: santa_juana

*Mulchen
t_cropData('mulchen','oat',sys,'area')= t_cropData("mulchen",'oat',sys,'area')*(2.048303908)   ;
t_cropData('mulchen','common_bean',sys,'area')= t_cropData("mulchen",'common_bean',sys,'area')* (1-0.307731434) ;
t_cropData('mulchen','potato',sys,'area')= t_cropData("mulchen",'potato',sys,'area')* (1-0.200920789) ;
t_cropData('mulchen','wheat',sys,'area')= t_cropData("mulchen",'wheat',sys,'area')*  (1-0.105972998) ;
t_cropData('mulchen','rice',sys,'area')= t_cropData("mulchen",'rice',sys,'area')* (1-0.239894129);
t_cropData('mulchen','maize',sys,'area')= t_cropData("mulchen",'maize',sys,'area')*(2.328322849);
t_cropData('mulchen','sugar_beat',sys,'area')= t_cropData("mulchen",'sugar_beat',sys,'area')* (1-0.352354788);
t_cropData('mulchen','grapes',sys,'area')= t_cropData("mulchen",'grapes',sys,'area')*0;
t_cropData('mulchen','vineyard',sys,'area')= t_cropData("mulchen",'vineyard',sys,'area')*0;

t_cropData('mulchen','Peach',sys,'area')= t_cropData("mulchen",'Peach',sys,'area')* (1-0.933993399);
t_cropData('mulchen','Cherry',sys,'area')= t_cropData("mulchen",'Cherry',sys,'area')* (1-0.481364486);
t_cropData('mulchen','Apple',sys,'area')= t_cropData("mulchen",'Apple',sys,'area')*    (1-0.584118106);
t_cropData('mulchen','Walnut',sys,'area')= t_cropData("mulchen",'Walnut',sys,'area')*  13.12309108;
t_cropData('mulchen','Orange',sys,'area')= t_cropData("mulchen",'Orange',sys,'area')* 0;
t_cropData('mulchen','Olive',sys,'area')= t_cropData("mulchen",'Olive',sys,'area')*    (1-0.867240452);
t_cropData('mulchen','Avocado',sys,'area')= t_cropData("mulchen",'Avocado',sys,'area')*    (1-0.390830946);
t_cropData('mulchen','Pear',sys,'area')= t_cropData("mulchen",'Pear',sys,'area')*    (1-0.909264963);
t_cropData('mulchen','plum',sys,'area')= t_cropData("mulchen",'plum',sys,'area')*0 ;

*Negrete
t_cropData('Negrete','oat',sys,'area')= t_cropData("Negrete",'oat',sys,'area')*(2.048303908)    ;
t_cropData('Negrete','common_bean',sys,'area')= t_cropData("Negrete",'common_bean',sys,'area')* (1-0.307731434) ;
t_cropData('Negrete','potato',sys,'area')= t_cropData("Negrete",'potato',sys,'area')* (1-0.200920789) ;
t_cropData('Negrete','wheat',sys,'area')= t_cropData("Negrete",'wheat',sys,'area')*  (1-0.105972998) ;
t_cropData('Negrete','rice',sys,'area')= t_cropData("Negrete",'rice',sys,'area')* (1-0.239894129);
t_cropData('Negrete','maize',sys,'area')= t_cropData("Negrete",'maize',sys,'area')*(2.328322849);
t_cropData('Negrete','sugar_beat',sys,'area')= t_cropData("Negrete",'sugar_beat',sys,'area')* (1-0.352354788);

t_cropData('Negrete','Peach',sys,'area')= t_cropData("Negrete",'Peach',sys,'area')*  (1-0.933993399);
t_cropData('Negrete','Cherry',sys,'area')= t_cropData("Negrete",'Cherry',sys,'area')*(1-0.481364486);
t_cropData('Negrete','Apple',sys,'area')= t_cropData("Negrete",'Apple',sys,'area')*  (1-0.584118106);
t_cropData('Negrete','Walnut',sys,'area')= t_cropData("Negrete",'Walnut',sys,'area')* 13.12309108;
t_cropData('Negrete','Orange',sys,'area')= t_cropData("Negrete",'Orange',sys,'area')*   0;
t_cropData('Negrete','Olive',sys,'area')= t_cropData("Negrete",'Olive',sys,'area')*   (1-0.867240452);
t_cropData('Negrete','Avocado',sys,'area')= t_cropData("Negrete",'Avocado',sys,'area')*  (1-0.390830946);
t_cropData('Negrete','Pear',sys,'area')= t_cropData("Negrete",'Pear',sys,'area')* (1-0.909264963);
t_cropData('Negrete','plum',sys,'area')= t_cropData("Negrete",'plum',sys,'area')*0 ;
t_cropData('Negrete','grapes',sys,'area')= t_cropData("Negrete",'grapes',sys,'area')*0;
t_cropData('Negrete','vineyard',sys,'area')= t_cropData("Negrete",'vineyard',sys,'area')*0;

*Nacimiento
t_cropData('Nacimiento','oat',sys,'area')= t_cropData("Nacimiento",'oat',sys,'area')*(2.048303908)  ;
t_cropData('Nacimiento','common_bean',sys,'area')= t_cropData("Nacimiento",'common_bean',sys,'area')* (1-0.307731434) ;
t_cropData('Nacimiento','potato',sys,'area')= t_cropData("Nacimiento",'potato',sys,'area')* (1-0.200920789) ;
t_cropData('Nacimiento','wheat',sys,'area')= t_cropData("Nacimiento",'wheat',sys,'area')*  (1-0.105972998) ;
t_cropData('Nacimiento','rice',sys,'area')= t_cropData("Nacimiento",'rice',sys,'area')* (1-0.239894129);
t_cropData('Nacimiento','maize',sys,'area')= t_cropData("Nacimiento",'maize',sys,'area')*(2.328322849);
t_cropData('Nacimiento','sugar_beat',sys,'area')= t_cropData("Nacimiento",'sugar_beat',sys,'area')*(1-0.352354788);

t_cropData('Nacimiento','Peach',sys,'area')= t_cropData("Nacimiento",'Peach',sys,'area')*  (1-0.933993399);
t_cropData('Nacimiento','Cherry',sys,'area')= t_cropData("Nacimiento",'Cherry',sys,'area')* (1-0.481364486);
t_cropData('Nacimiento','Apple',sys,'area')= t_cropData("Nacimiento",'Apple',sys,'area')* (1-0.584118106);
t_cropData('Nacimiento','Walnut',sys,'area')= t_cropData("Nacimiento",'Walnut',sys,'area')* 13.12309108;
t_cropData('Nacimiento','Orange',sys,'area')= t_cropData("Nacimiento",'Orange',sys,'area')*   0;
t_cropData('Nacimiento','Olive',sys,'area')= t_cropData("Nacimiento",'Olive',sys,'area')*  (1-0.867240452);
t_cropData('Nacimiento','Avocado',sys,'area')= t_cropData("Nacimiento",'Avocado',sys,'area')*  (1-0.390830946);
t_cropData('Nacimiento','Pear',sys,'area')= t_cropData("Nacimiento",'Pear',sys,'area')*  (1-0.909264963);
t_cropData('Nacimiento','plum',sys,'area')= t_cropData("Nacimiento",'plum',sys,'area')*0 ;
t_cropData('Nacimiento','grapes',sys,'area')= t_cropData("Nacimiento",'grapes',sys,'area')*0;
t_cropData('Nacimiento','vineyard',sys,'area')= t_cropData("Nacimiento",'vineyard',sys,'area')*0;

********new: ?uble/biobio
* pinto
t_cropData('pinto','oat',sys,'area')= t_cropData("pinto",'oat',sys,'area')*(2.048303908)  ;
t_cropData('pinto','common_bean',sys,'area')= t_cropData("pinto",'common_bean',sys,'area')* (1-0.307731434) ;
t_cropData('pinto','potato',sys,'area')= t_cropData("pinto",'potato',sys,'area')* (1-0.200920789) ;
t_cropData('pinto','wheat',sys,'area')= t_cropData("pinto",'wheat',sys,'area')*  (1-0.105972998) ;
t_cropData('pinto','rice',sys,'area')= t_cropData("pinto",'rice',sys,'area')* (1-0.239894129);
t_cropData('pinto','maize',sys,'area')= t_cropData("pinto",'maize',sys,'area')*(2.328322849);
t_cropData('pinto','sugar_beat',sys,'area')= t_cropData("pinto",'sugar_beat',sys,'area')*(1-0.352354788);

t_cropData('pinto','Peach',sys,'area')= t_cropData("pinto",'Peach',sys,'area')*  (1-0.933993399);
t_cropData('pinto','Cherry',sys,'area')= t_cropData("pinto",'Cherry',sys,'area')* (1-0.481364486);
t_cropData('pinto','Apple',sys,'area')= t_cropData("pinto",'Apple',sys,'area')* (1-0.584118106);
t_cropData('pinto','Walnut',sys,'area')= t_cropData("pinto",'Walnut',sys,'area')* 13.12309108;
t_cropData('pinto','Orange',sys,'area')= t_cropData("pinto",'Orange',sys,'area')*   0;
t_cropData('pinto','Olive',sys,'area')= t_cropData("pinto",'Olive',sys,'area')*  (1-0.867240452);
t_cropData('pinto','Avocado',sys,'area')= t_cropData("pinto",'Avocado',sys,'area')*  (1-0.390830946);
t_cropData('pinto','Pear',sys,'area')= t_cropData("pinto",'Pear',sys,'area')*  (1-0.909264963);
t_cropData('pinto','plum',sys,'area')= t_cropData("pinto",'plum',sys,'area')*0 ;
t_cropData('pinto','grapes',sys,'area')= t_cropData("pinto",'grapes',sys,'area')*0;
t_cropData('pinto','vineyard',sys,'area')= t_cropData("pinto",'vineyard',sys,'area')*0;

*antuco
t_cropData('antuco','oat',sys,'area')= t_cropData("antuco",'oat',sys,'area')*(2.048303908)  ;
t_cropData('antuco','common_bean',sys,'area')= t_cropData("antuco",'common_bean',sys,'area')* (1-0.307731434) ;
t_cropData('antuco','potato',sys,'area')= t_cropData("antuco",'potato',sys,'area')* (1-0.200920789) ;
t_cropData('antuco','wheat',sys,'area')= t_cropData("antuco",'wheat',sys,'area')*  (1-0.105972998) ;
t_cropData('antuco','rice',sys,'area')= t_cropData("antuco",'rice',sys,'area')* (1-0.239894129);
t_cropData('antuco','maize',sys,'area')= t_cropData("antuco",'maize',sys,'area')*(2.328322849);
t_cropData('antuco','sugar_beat',sys,'area')= t_cropData("antuco",'sugar_beat',sys,'area')*(1-0.352354788);

t_cropData('antuco','Peach',sys,'area')= t_cropData("antuco",'Peach',sys,'area')*  (1-0.933993399);
t_cropData('antuco','Cherry',sys,'area')= t_cropData("antuco",'Cherry',sys,'area')* (1-0.481364486);
t_cropData('antuco','Apple',sys,'area')= t_cropData("antuco",'Apple',sys,'area')* (1-0.584118106);
t_cropData('antuco','Walnut',sys,'area')= t_cropData("antuco",'Walnut',sys,'area')* 13.12309108;
t_cropData('antuco','Orange',sys,'area')= t_cropData("antuco",'Orange',sys,'area')*   0;
t_cropData('antuco','Olive',sys,'area')= t_cropData("antuco",'Olive',sys,'area')*  (1-0.867240452);
t_cropData('antuco','Avocado',sys,'area')= t_cropData("antuco",'Avocado',sys,'area')*  (1-0.390830946);
t_cropData('antuco','Pear',sys,'area')= t_cropData("antuco",'Pear',sys,'area')*  (1-0.909264963);
t_cropData('antuco','plum',sys,'area')= t_cropData("antuco",'plum',sys,'area')*0 ;
t_cropData('antuco','grapes',sys,'area')= t_cropData("antuco",'grapes',sys,'area')*0;
t_cropData('antuco','vineyard',sys,'area')= t_cropData("antuco",'vineyard',sys,'area')*0;

*quilleco
t_cropData('quilleco','oat',sys,'area')= t_cropData("quilleco",'oat',sys,'area')*(2.048303908)  ;
t_cropData('quilleco','common_bean',sys,'area')= t_cropData("quilleco",'common_bean',sys,'area')* (1-0.307731434) ;
t_cropData('quilleco','potato',sys,'area')= t_cropData("quilleco",'potato',sys,'area')* (1-0.200920789) ;
t_cropData('quilleco','wheat',sys,'area')= t_cropData("quilleco",'wheat',sys,'area')*  (1-0.105972998) ;
t_cropData('quilleco','rice',sys,'area')= t_cropData("quilleco",'rice',sys,'area')* (1-0.239894129);
t_cropData('quilleco','maize',sys,'area')= t_cropData("quilleco",'maize',sys,'area')*(2.328322849);
t_cropData('quilleco','sugar_beat',sys,'area')= t_cropData("quilleco",'sugar_beat',sys,'area')*(1-0.352354788);

t_cropData('quilleco','Peach',sys,'area')= t_cropData("quilleco",'Peach',sys,'area')*  (1-0.933993399);
t_cropData('quilleco','Cherry',sys,'area')= t_cropData("quilleco",'Cherry',sys,'area')* (1-0.481364486);
t_cropData('quilleco','Apple',sys,'area')= t_cropData("quilleco",'Apple',sys,'area')* (1-0.584118106);
t_cropData('quilleco','Walnut',sys,'area')= t_cropData("quilleco",'Walnut',sys,'area')* 13.12309108;
t_cropData('quilleco','Orange',sys,'area')= t_cropData("quilleco",'Orange',sys,'area')*   0;
t_cropData('quilleco','Olive',sys,'area')= t_cropData("quilleco",'Olive',sys,'area')*  (1-0.867240452);
t_cropData('quilleco','Avocado',sys,'area')= t_cropData("quilleco",'Avocado',sys,'area')*  (1-0.390830946);
t_cropData('quilleco','Pear',sys,'area')= t_cropData("quilleco",'Pear',sys,'area')*  (1-0.909264963);
t_cropData('quilleco','plum',sys,'area')= t_cropData("quilleco",'plum',sys,'area')*0 ;
t_cropData('quilleco','grapes',sys,'area')= t_cropData("quilleco",'grapes',sys,'area')*0;
t_cropData('quilleco','vineyard',sys,'area')= t_cropData("quilleco",'vineyard',sys,'area')*0;

*tucapel
t_cropData('tucapel','oat',sys,'area')= t_cropData("tucapel",'oat',sys,'area')*(2.048303908)  ;
t_cropData('tucapel','common_bean',sys,'area')= t_cropData("tucapel",'common_bean',sys,'area')* (1-0.307731434) ;
t_cropData('tucapel','potato',sys,'area')= t_cropData("tucapel",'potato',sys,'area')* (1-0.200920789) ;
t_cropData('tucapel','wheat',sys,'area')= t_cropData("tucapel",'wheat',sys,'area')*  (1-0.105972998) ;
t_cropData('tucapel','rice',sys,'area')= t_cropData("tucapel",'rice',sys,'area')* (1-0.239894129);
t_cropData('tucapel','maize',sys,'area')= t_cropData("tucapel",'maize',sys,'area')*(2.328322849);
t_cropData('tucapel','sugar_beat',sys,'area')= t_cropData("tucapel",'sugar_beat',sys,'area')*(1-0.352354788);

t_cropData('tucapel','Peach',sys,'area')= t_cropData("tucapel",'Peach',sys,'area')*  (1-0.933993399);
t_cropData('tucapel','Cherry',sys,'area')= t_cropData("tucapel",'Cherry',sys,'area')* (1-0.481364486);
t_cropData('tucapel','Apple',sys,'area')= t_cropData("tucapel",'Apple',sys,'area')* (1-0.584118106);
t_cropData('tucapel','Walnut',sys,'area')= t_cropData("tucapel",'Walnut',sys,'area')* 13.12309108;
t_cropData('tucapel','Orange',sys,'area')= t_cropData("tucapel",'Orange',sys,'area')*   0;
t_cropData('tucapel','Olive',sys,'area')= t_cropData("tucapel",'Olive',sys,'area')*  (1-0.867240452);
t_cropData('tucapel','Avocado',sys,'area')= t_cropData("tucapel",'Avocado',sys,'area')*  (1-0.390830946);
t_cropData('tucapel','Pear',sys,'area')= t_cropData("tucapel",'Pear',sys,'area')*  (1-0.909264963);
t_cropData('tucapel','plum',sys,'area')= t_cropData("tucapel",'plum',sys,'area')*0 ;
t_cropData('tucapel','grapes',sys,'area')= t_cropData("tucapel",'grapes',sys,'area')*0;
t_cropData('tucapel','vineyard',sys,'area')= t_cropData("tucapel",'vineyard',sys,'area')*0;

*yungay
t_cropData('yungay','oat',sys,'area')= t_cropData("yungay",'oat',sys,'area')*(2.048303908)  ;
t_cropData('yungay','common_bean',sys,'area')= t_cropData("yungay",'common_bean',sys,'area')* (1-0.307731434) ;
t_cropData('yungay','potato',sys,'area')= t_cropData("yungay",'potato',sys,'area')* (1-0.200920789) ;
t_cropData('yungay','wheat',sys,'area')= t_cropData("yungay",'wheat',sys,'area')*  (1-0.105972998) ;
t_cropData('yungay','rice',sys,'area')= t_cropData("yungay",'rice',sys,'area')* (1-0.239894129);
t_cropData('yungay','maize',sys,'area')= t_cropData("yungay",'maize',sys,'area')*(2.328322849);
t_cropData('yungay','sugar_beat',sys,'area')= t_cropData("yungay",'sugar_beat',sys,'area')*(1-0.352354788);

t_cropData('yungay','Peach',sys,'area')= t_cropData("yungay",'Peach',sys,'area')*  (1-0.933993399);
t_cropData('yungay','Cherry',sys,'area')= t_cropData("yungay",'Cherry',sys,'area')* (1-0.481364486);
t_cropData('yungay','Apple',sys,'area')= t_cropData("yungay",'Apple',sys,'area')* (1-0.584118106);
t_cropData('yungay','Walnut',sys,'area')= t_cropData("yungay",'Walnut',sys,'area')* 13.12309108;
t_cropData('yungay','Orange',sys,'area')= t_cropData("yungay",'Orange',sys,'area')*   0;
t_cropData('yungay','Olive',sys,'area')= t_cropData("yungay",'Olive',sys,'area')*  (1-0.867240452);
t_cropData('yungay','Avocado',sys,'area')= t_cropData("yungay",'Avocado',sys,'area')*  (1-0.390830946);
t_cropData('yungay','Pear',sys,'area')= t_cropData("yungay",'Pear',sys,'area')*  (1-0.909264963);
t_cropData('yungay','plum',sys,'area')= t_cropData("yungay",'plum',sys,'area')*0 ;
t_cropData('yungay','grapes',sys,'area')= t_cropData("yungay",'grapes',sys,'area')*0;
t_cropData('yungay','vineyard',sys,'area')= t_cropData("yungay",'vineyard',sys,'area')*0;

*cabrero
t_cropData('cabrero','oat',sys,'area')= t_cropData("cabrero",'oat',sys,'area')*(2.048303908)  ;
t_cropData('cabrero','common_bean',sys,'area')= t_cropData("cabrero",'common_bean',sys,'area')* (1-0.307731434) ;
t_cropData('cabrero','potato',sys,'area')= t_cropData("cabrero",'potato',sys,'area')* (1-0.200920789) ;
t_cropData('cabrero','wheat',sys,'area')= t_cropData("cabrero",'wheat',sys,'area')*  (1-0.105972998) ;
t_cropData('cabrero','rice',sys,'area')= t_cropData("cabrero",'rice',sys,'area')* (1-0.239894129);
t_cropData('cabrero','maize',sys,'area')= t_cropData("cabrero",'maize',sys,'area')*(2.328322849);
t_cropData('cabrero','sugar_beat',sys,'area')= t_cropData("cabrero",'sugar_beat',sys,'area')*(1-0.352354788);

t_cropData('cabrero','Peach',sys,'area')= t_cropData("cabrero",'Peach',sys,'area')*  (1-0.933993399);
t_cropData('cabrero','Cherry',sys,'area')= t_cropData("cabrero",'Cherry',sys,'area')* (1-0.481364486);
t_cropData('cabrero','Apple',sys,'area')= t_cropData("cabrero",'Apple',sys,'area')* (1-0.584118106);
t_cropData('cabrero','Walnut',sys,'area')= t_cropData("cabrero",'Walnut',sys,'area')* 13.12309108;
t_cropData('cabrero','Orange',sys,'area')= t_cropData("cabrero",'Orange',sys,'area')*   0;
t_cropData('cabrero','Olive',sys,'area')= t_cropData("cabrero",'Olive',sys,'area')*  (1-0.867240452);
t_cropData('cabrero','Avocado',sys,'area')= t_cropData("cabrero",'Avocado',sys,'area')*  (1-0.390830946);
t_cropData('cabrero','Pear',sys,'area')= t_cropData("cabrero",'Pear',sys,'area')*  (1-0.909264963);
t_cropData('cabrero','plum',sys,'area')= t_cropData("cabrero",'plum',sys,'area')*0 ;
t_cropData('cabrero','grapes',sys,'area')= t_cropData("cabrero",'grapes',sys,'area')*0;
t_cropData('cabrero','vineyard',sys,'area')= t_cropData("cabrero",'vineyard',sys,'area')*0;

*quillon

t_cropData('quillon','oat',sys,'area')= t_cropData("quillon",'oat',sys,'area')*(2.048303908)  ;
t_cropData('quillon','common_bean',sys,'area')= t_cropData("quillon",'common_bean',sys,'area')* (1-0.307731434) ;
t_cropData('quillon','potato',sys,'area')= t_cropData("quillon",'potato',sys,'area')* (1-0.200920789) ;
t_cropData('quillon','wheat',sys,'area')= t_cropData("quillon",'wheat',sys,'area')*  (1-0.105972998) ;
t_cropData('quillon','rice',sys,'area')= t_cropData("quillon",'rice',sys,'area')* (1-0.239894129);
t_cropData('quillon','maize',sys,'area')= t_cropData("quillon",'maize',sys,'area')*(2.328322849);
t_cropData('quillon','sugar_beat',sys,'area')= t_cropData("quillon",'sugar_beat',sys,'area')*(1-0.352354788);

t_cropData('quillon','Peach',sys,'area')= t_cropData("quillon",'Peach',sys,'area')*  (1-0.933993399);
t_cropData('quillon','Cherry',sys,'area')= t_cropData("quillon",'Cherry',sys,'area')* (1-0.481364486);
t_cropData('quillon','Apple',sys,'area')= t_cropData("quillon",'Apple',sys,'area')* (1-0.584118106);
t_cropData('quillon','Walnut',sys,'area')= t_cropData("quillon",'Walnut',sys,'area')* 13.12309108;
t_cropData('quillon','Orange',sys,'area')= t_cropData("quillon",'Orange',sys,'area')*   0;
t_cropData('quillon','Olive',sys,'area')= t_cropData("quillon",'Olive',sys,'area')*  (1-0.867240452);
t_cropData('quillon','Avocado',sys,'area')= t_cropData("quillon",'Avocado',sys,'area')*  (1-0.390830946);
t_cropData('quillon','Pear',sys,'area')= t_cropData("quillon",'Pear',sys,'area')*  (1-0.909264963);
t_cropData('quillon','plum',sys,'area')= t_cropData("quillon",'plum',sys,'area')*0 ;
t_cropData('quillon','grapes',sys,'area')= t_cropData("quillon",'grapes',sys,'area')*0;
t_cropData('quillon','vineyard',sys,'area')= t_cropData("quillon",'vineyard',sys,'area')*0;

*new: yumbel,
t_cropData('yumbel','oat',sys,'area')= t_cropData("yumbel",'oat',sys,'area')*(2.048303908)  ;
t_cropData('yumbel','common_bean',sys,'area')= t_cropData("yumbel",'common_bean',sys,'area')* (1-0.307731434) ;
t_cropData('yumbel','potato',sys,'area')= t_cropData("yumbel",'potato',sys,'area')* (1-0.200920789) ;
t_cropData('yumbel','wheat',sys,'area')= t_cropData("yumbel",'wheat',sys,'area')*  (1-0.105972998) ;
t_cropData('yumbel','rice',sys,'area')= t_cropData("yumbel",'rice',sys,'area')* (1-0.239894129);
t_cropData('yumbel','maize',sys,'area')= t_cropData("yumbel",'maize',sys,'area')*(2.328322849);
t_cropData('yumbel','sugar_beat',sys,'area')= t_cropData("yumbel",'sugar_beat',sys,'area')*(1-0.352354788);

t_cropData('yumbel','Peach',sys,'area')= t_cropData("yumbel",'Peach',sys,'area')*  (1-0.933993399);
t_cropData('yumbel','Cherry',sys,'area')= t_cropData("yumbel",'Cherry',sys,'area')* (1-0.481364486);
t_cropData('yumbel','Apple',sys,'area')= t_cropData("yumbel",'Apple',sys,'area')* (1-0.584118106);
t_cropData('yumbel','Walnut',sys,'area')= t_cropData("yumbel",'Walnut',sys,'area')* 13.12309108;
t_cropData('yumbel','Orange',sys,'area')= t_cropData("yumbel",'Orange',sys,'area')*   0;
t_cropData('yumbel','Olive',sys,'area')= t_cropData("yumbel",'Olive',sys,'area')*  (1-0.867240452);
t_cropData('yumbel','Avocado',sys,'area')= t_cropData("yumbel",'Avocado',sys,'area')*  (1-0.390830946);
t_cropData('yumbel','Pear',sys,'area')= t_cropData("yumbel",'Pear',sys,'area')*  (1-0.909264963);
t_cropData('yumbel','plum',sys,'area')= t_cropData("yumbel",'plum',sys,'area')*0 ;
t_cropData('yumbel','grapes',sys,'area')= t_cropData("yumbel",'grapes',sys,'area')*0;
t_cropData('yumbel','vineyard',sys,'area')= t_cropData("yumbel",'vineyard',sys,'area')*0;

*alto_biobio,
t_cropData('alto_biobio','oat',sys,'area')= t_cropData("alto_biobio",'oat',sys,'area')*(2.048303908)  ;
t_cropData('alto_biobio','common_bean',sys,'area')= t_cropData("alto_biobio",'common_bean',sys,'area')* (1-0.307731434) ;
t_cropData('alto_biobio','potato',sys,'area')= t_cropData("alto_biobio",'potato',sys,'area')* (1-0.200920789) ;
t_cropData('alto_biobio','wheat',sys,'area')= t_cropData("alto_biobio",'wheat',sys,'area')*  (1-0.105972998) ;
t_cropData('alto_biobio','rice',sys,'area')= t_cropData("alto_biobio",'rice',sys,'area')* (1-0.239894129);
t_cropData('alto_biobio','maize',sys,'area')= t_cropData("alto_biobio",'maize',sys,'area')*(2.328322849);
t_cropData('alto_biobio','sugar_beat',sys,'area')= t_cropData("alto_biobio",'sugar_beat',sys,'area')*(1-0.352354788);

t_cropData('alto_biobio','Peach',sys,'area')= t_cropData("alto_biobio",'Peach',sys,'area')*  (1-0.933993399);
t_cropData('alto_biobio','Cherry',sys,'area')= t_cropData("alto_biobio",'Cherry',sys,'area')* (1-0.481364486);
t_cropData('alto_biobio','Apple',sys,'area')= t_cropData("alto_biobio",'Apple',sys,'area')* (1-0.584118106);
t_cropData('alto_biobio','Walnut',sys,'area')= t_cropData("alto_biobio",'Walnut',sys,'area')* 13.12309108;
t_cropData('alto_biobio','Orange',sys,'area')= t_cropData("alto_biobio",'Orange',sys,'area')*   0;
t_cropData('alto_biobio','Olive',sys,'area')= t_cropData("alto_biobio",'Olive',sys,'area')*  (1-0.867240452);
t_cropData('alto_biobio','Avocado',sys,'area')= t_cropData("alto_biobio",'Avocado',sys,'area')*  (1-0.390830946);
t_cropData('alto_biobio','Pear',sys,'area')= t_cropData("alto_biobio",'Pear',sys,'area')*  (1-0.909264963);
t_cropData('alto_biobio','plum',sys,'area')= t_cropData("alto_biobio",'plum',sys,'area')*0 ;
t_cropData('alto_biobio','grapes',sys,'area')= t_cropData("alto_biobio",'grapes',sys,'area')*0;
t_cropData('alto_biobio','vineyard',sys,'area')= t_cropData("alto_biobio",'vineyard',sys,'area')*0;

*quilaco,
t_cropData('quilaco','oat',sys,'area')= t_cropData("quilaco",'oat',sys,'area')*(2.048303908)  ;
t_cropData('quilaco','common_bean',sys,'area')= t_cropData("quilaco",'common_bean',sys,'area')* (1-0.307731434) ;
t_cropData('quilaco','potato',sys,'area')= t_cropData("quilaco",'potato',sys,'area')* (1-0.200920789) ;
t_cropData('quilaco','wheat',sys,'area')= t_cropData("quilaco",'wheat',sys,'area')*  (1-0.105972998) ;
t_cropData('quilaco','rice',sys,'area')= t_cropData("quilaco",'rice',sys,'area')* (1-0.239894129);
t_cropData('quilaco','maize',sys,'area')= t_cropData("quilaco",'maize',sys,'area')*(2.328322849);
t_cropData('quilaco','sugar_beat',sys,'area')= t_cropData("quilaco",'sugar_beat',sys,'area')*(1-0.352354788);

t_cropData('quilaco','Peach',sys,'area')= t_cropData("quilaco",'Peach',sys,'area')*  (1-0.933993399);
t_cropData('quilaco','Cherry',sys,'area')= t_cropData("quilaco",'Cherry',sys,'area')* (1-0.481364486);
t_cropData('quilaco','Apple',sys,'area')= t_cropData("quilaco",'Apple',sys,'area')* (1-0.584118106);
t_cropData('quilaco','Walnut',sys,'area')= t_cropData("quilaco",'Walnut',sys,'area')* 13.12309108;
t_cropData('quilaco','Orange',sys,'area')= t_cropData("quilaco",'Orange',sys,'area')*   0;
t_cropData('quilaco','Olive',sys,'area')= t_cropData("quilaco",'Olive',sys,'area')*  (1-0.867240452);
t_cropData('quilaco','Avocado',sys,'area')= t_cropData("quilaco",'Avocado',sys,'area')*  (1-0.390830946);
t_cropData('quilaco','Pear',sys,'area')= t_cropData("quilaco",'Pear',sys,'area')*  (1-0.909264963);
t_cropData('quilaco','plum',sys,'area')= t_cropData("quilaco",'plum',sys,'area')*0 ;
t_cropData('quilaco','grapes',sys,'area')= t_cropData("quilaco",'grapes',sys,'area')*0;
t_cropData('quilaco','vineyard',sys,'area')= t_cropData("quilaco",'vineyard',sys,'area')*0;

*santa_barbara,
t_cropData('santa_barbara','oat',sys,'area')= t_cropData("santa_barbara",'oat',sys,'area')*(2.048303908)  ;
t_cropData('santa_barbara','common_bean',sys,'area')= t_cropData("santa_barbara",'common_bean',sys,'area')* (1-0.307731434) ;
t_cropData('santa_barbara','potato',sys,'area')= t_cropData("santa_barbara",'potato',sys,'area')* (1-0.200920789) ;
t_cropData('santa_barbara','wheat',sys,'area')= t_cropData("santa_barbara",'wheat',sys,'area')*  (1-0.105972998) ;
t_cropData('santa_barbara','rice',sys,'area')= t_cropData("santa_barbara",'rice',sys,'area')* (1-0.239894129);
t_cropData('santa_barbara','maize',sys,'area')= t_cropData("santa_barbara",'maize',sys,'area')*(2.328322849);
t_cropData('santa_barbara','sugar_beat',sys,'area')= t_cropData("santa_barbara",'sugar_beat',sys,'area')*(1-0.352354788);

t_cropData('santa_barbara','Peach',sys,'area')= t_cropData("santa_barbara",'Peach',sys,'area')*  (1-0.933993399);
t_cropData('santa_barbara','Cherry',sys,'area')= t_cropData("santa_barbara",'Cherry',sys,'area')* (1-0.481364486);
t_cropData('santa_barbara','Apple',sys,'area')= t_cropData("santa_barbara",'Apple',sys,'area')* (1-0.584118106);
t_cropData('santa_barbara','Walnut',sys,'area')= t_cropData("santa_barbara",'Walnut',sys,'area')* 13.12309108;
t_cropData('santa_barbara','Orange',sys,'area')= t_cropData("santa_barbara",'Orange',sys,'area')*   0;
t_cropData('santa_barbara','Olive',sys,'area')= t_cropData("santa_barbara",'Olive',sys,'area')*  (1-0.867240452);
t_cropData('santa_barbara','Avocado',sys,'area')= t_cropData("santa_barbara",'Avocado',sys,'area')*  (1-0.390830946);
t_cropData('santa_barbara','Pear',sys,'area')= t_cropData("santa_barbara",'Pear',sys,'area')*  (1-0.909264963);
t_cropData('santa_barbara','plum',sys,'area')= t_cropData("santa_barbara",'plum',sys,'area')*0 ;
t_cropData('santa_barbara','grapes',sys,'area')= t_cropData("santa_barbara",'grapes',sys,'area')*0;
t_cropData('santa_barbara','vineyard',sys,'area')= t_cropData("santa_barbara",'vineyard',sys,'area')*0;

*los_angeles,
t_cropData('los_angeles','oat',sys,'area')= t_cropData("los_angeles",'oat',sys,'area')*(2.048303908)  ;
t_cropData('los_angeles','common_bean',sys,'area')= t_cropData("los_angeles",'common_bean',sys,'area')* (1-0.307731434) ;
t_cropData('los_angeles','potato',sys,'area')= t_cropData("los_angeles",'potato',sys,'area')* (1-0.200920789) ;
t_cropData('los_angeles','wheat',sys,'area')= t_cropData("los_angeles",'wheat',sys,'area')*  (1-0.105972998) ;
t_cropData('los_angeles','rice',sys,'area')= t_cropData("los_angeles",'rice',sys,'area')* (1-0.239894129);
t_cropData('los_angeles','maize',sys,'area')= t_cropData("los_angeles",'maize',sys,'area')*(2.328322849);
t_cropData('los_angeles','sugar_beat',sys,'area')= t_cropData("los_angeles",'sugar_beat',sys,'area')*(1-0.352354788);

t_cropData('los_angeles','Peach',sys,'area')= t_cropData("los_angeles",'Peach',sys,'area')*  (1-0.933993399);
t_cropData('los_angeles','Cherry',sys,'area')= t_cropData("los_angeles",'Cherry',sys,'area')* (1-0.481364486);
t_cropData('los_angeles','Apple',sys,'area')= t_cropData("los_angeles",'Apple',sys,'area')* (1-0.584118106);
t_cropData('los_angeles','Walnut',sys,'area')= t_cropData("los_angeles",'Walnut',sys,'area')* 13.12309108;
t_cropData('los_angeles','Orange',sys,'area')= t_cropData("los_angeles",'Orange',sys,'area')*   0;
t_cropData('los_angeles','Olive',sys,'area')= t_cropData("los_angeles",'Olive',sys,'area')*  (1-0.867240452);
t_cropData('los_angeles','Avocado',sys,'area')= t_cropData("los_angeles",'Avocado',sys,'area')*  (1-0.390830946);
t_cropData('los_angeles','Pear',sys,'area')= t_cropData("los_angeles",'Pear',sys,'area')*  (1-0.909264963);
t_cropData('los_angeles','plum',sys,'area')= t_cropData("los_angeles",'plum',sys,'area')*0 ;
t_cropData('los_angeles','grapes',sys,'area')= t_cropData("los_angeles",'grapes',sys,'area')*0;
t_cropData('los_angeles','vineyard',sys,'area')= t_cropData("los_angeles",'vineyard',sys,'area')*0;

*laja,
t_cropData('laja','oat',sys,'area')= t_cropData("laja",'oat',sys,'area')*(2.048303908)  ;
t_cropData('laja','common_bean',sys,'area')= t_cropData("laja",'common_bean',sys,'area')* (1-0.307731434) ;
t_cropData('laja','potato',sys,'area')= t_cropData("laja",'potato',sys,'area')* (1-0.200920789) ;
t_cropData('laja','wheat',sys,'area')= t_cropData("laja",'wheat',sys,'area')*  (1-0.105972998) ;
t_cropData('laja','rice',sys,'area')= t_cropData("laja",'rice',sys,'area')* (1-0.239894129);
t_cropData('laja','maize',sys,'area')= t_cropData("laja",'maize',sys,'area')*(2.328322849);
t_cropData('laja','sugar_beat',sys,'area')= t_cropData("laja",'sugar_beat',sys,'area')*(1-0.352354788);

t_cropData('laja','Peach',sys,'area')= t_cropData("laja",'Peach',sys,'area')*  (1-0.933993399);
t_cropData('laja','Cherry',sys,'area')= t_cropData("laja",'Cherry',sys,'area')* (1-0.481364486);
t_cropData('laja','Apple',sys,'area')= t_cropData("laja",'Apple',sys,'area')* (1-0.584118106);
t_cropData('laja','Walnut',sys,'area')= t_cropData("laja",'Walnut',sys,'area')* 13.12309108;
t_cropData('laja','Orange',sys,'area')= t_cropData("laja",'Orange',sys,'area')*   0;
t_cropData('laja','Olive',sys,'area')= t_cropData("laja",'Olive',sys,'area')*  (1-0.867240452);
t_cropData('laja','Avocado',sys,'area')= t_cropData("laja",'Avocado',sys,'area')*  (1-0.390830946);
t_cropData('laja','Pear',sys,'area')= t_cropData("laja",'Pear',sys,'area')*  (1-0.909264963);
t_cropData('laja','plum',sys,'area')= t_cropData("laja",'plum',sys,'area')*0 ;
t_cropData('laja','grapes',sys,'area')= t_cropData("laja",'grapes',sys,'area')*0;
t_cropData('laja','vineyard',sys,'area')= t_cropData("laja",'vineyard',sys,'area')*0;

*san_rosendo
t_cropData('san_rosendo','oat',sys,'area')= t_cropData("san_rosendo",'oat',sys,'area')*(2.048303908)  ;
t_cropData('san_rosendo','common_bean',sys,'area')= t_cropData("san_rosendo",'common_bean',sys,'area')* (1-0.307731434) ;
t_cropData('san_rosendo','potato',sys,'area')= t_cropData("san_rosendo",'potato',sys,'area')* (1-0.200920789) ;
t_cropData('san_rosendo','wheat',sys,'area')= t_cropData("san_rosendo",'wheat',sys,'area')*  (1-0.105972998) ;
t_cropData('san_rosendo','rice',sys,'area')= t_cropData("san_rosendo",'rice',sys,'area')* (1-0.239894129);
t_cropData('san_rosendo','maize',sys,'area')= t_cropData("san_rosendo",'maize',sys,'area')*(2.328322849);
t_cropData('san_rosendo','sugar_beat',sys,'area')= t_cropData("san_rosendo",'sugar_beat',sys,'area')*(1-0.352354788);

t_cropData('san_rosendo','Peach',sys,'area')= t_cropData("san_rosendo",'Peach',sys,'area')*  (1-0.933993399);
t_cropData('san_rosendo','Cherry',sys,'area')= t_cropData("san_rosendo",'Cherry',sys,'area')* (1-0.481364486);
t_cropData('san_rosendo','Apple',sys,'area')= t_cropData("san_rosendo",'Apple',sys,'area')* (1-0.584118106);
t_cropData('san_rosendo','Walnut',sys,'area')= t_cropData("san_rosendo",'Walnut',sys,'area')* 13.12309108;
t_cropData('san_rosendo','Orange',sys,'area')= t_cropData("san_rosendo",'Orange',sys,'area')*   0;
t_cropData('san_rosendo','Olive',sys,'area')= t_cropData("san_rosendo",'Olive',sys,'area')*  (1-0.867240452);
t_cropData('san_rosendo','Avocado',sys,'area')= t_cropData("san_rosendo",'Avocado',sys,'area')*  (1-0.390830946);
t_cropData('san_rosendo','Pear',sys,'area')= t_cropData("san_rosendo",'Pear',sys,'area')*  (1-0.909264963);
t_cropData('san_rosendo','plum',sys,'area')= t_cropData("san_rosendo",'plum',sys,'area')*0 ;
t_cropData('san_rosendo','grapes',sys,'area')= t_cropData("san_rosendo",'grapes',sys,'area')*0;
t_cropData('san_rosendo','vineyard',sys,'area')= t_cropData("san_rosendo",'vineyard',sys,'area')*0;

*new: hualqui,
t_cropData('hualqui','oat',sys,'area')= t_cropData("hualqui",'oat',sys,'area')*(2.048303908)  ;
t_cropData('hualqui','common_bean',sys,'area')= t_cropData("hualqui",'common_bean',sys,'area')* (1-0.307731434) ;
t_cropData('hualqui','potato',sys,'area')= t_cropData("hualqui",'potato',sys,'area')* (1-0.200920789) ;
t_cropData('hualqui','wheat',sys,'area')= t_cropData("hualqui",'wheat',sys,'area')*  (1-0.105972998) ;
t_cropData('hualqui','rice',sys,'area')= t_cropData("hualqui",'rice',sys,'area')* (1-0.239894129);
t_cropData('hualqui','maize',sys,'area')= t_cropData("hualqui",'maize',sys,'area')*(2.328322849);
t_cropData('hualqui','sugar_beat',sys,'area')= t_cropData("hualqui",'sugar_beat',sys,'area')*(1-0.352354788);

t_cropData('hualqui','Peach',sys,'area')= t_cropData("hualqui",'Peach',sys,'area')*  (1-0.933993399);
t_cropData('hualqui','Cherry',sys,'area')= t_cropData("hualqui",'Cherry',sys,'area')* (1-0.481364486);
t_cropData('hualqui','Apple',sys,'area')= t_cropData("hualqui",'Apple',sys,'area')* (1-0.584118106);
t_cropData('hualqui','Walnut',sys,'area')= t_cropData("hualqui",'Walnut',sys,'area')* 13.12309108;
t_cropData('hualqui','Orange',sys,'area')= t_cropData("hualqui",'Orange',sys,'area')*   0;
t_cropData('hualqui','Olive',sys,'area')= t_cropData("hualqui",'Olive',sys,'area')*  (1-0.867240452);
t_cropData('hualqui','Avocado',sys,'area')= t_cropData("hualqui",'Avocado',sys,'area')*  (1-0.390830946);
t_cropData('hualqui','Pear',sys,'area')= t_cropData("hualqui",'Pear',sys,'area')*  (1-0.909264963);
t_cropData('hualqui','plum',sys,'area')= t_cropData("hualqui",'plum',sys,'area')*0 ;
t_cropData('hualqui','grapes',sys,'area')= t_cropData("hualqui",'grapes',sys,'area')*0;
t_cropData('hualqui','vineyard',sys,'area')= t_cropData("hualqui",'vineyard',sys,'area')*0;

*chiguayante,
t_cropData('chiguayante','oat',sys,'area')= t_cropData("chiguayante",'oat',sys,'area')*(2.048303908)  ;
t_cropData('chiguayante','common_bean',sys,'area')= t_cropData("chiguayante",'common_bean',sys,'area')* (1-0.307731434) ;
t_cropData('chiguayante','potato',sys,'area')= t_cropData("chiguayante",'potato',sys,'area')* (1-0.200920789) ;
t_cropData('chiguayante','wheat',sys,'area')= t_cropData("chiguayante",'wheat',sys,'area')*  (1-0.105972998) ;
t_cropData('chiguayante','rice',sys,'area')= t_cropData("chiguayante",'rice',sys,'area')* (1-0.239894129);
t_cropData('chiguayante','maize',sys,'area')= t_cropData("chiguayante",'maize',sys,'area')*(2.328322849);
t_cropData('chiguayante','sugar_beat',sys,'area')= t_cropData("chiguayante",'sugar_beat',sys,'area')*(1-0.352354788);

t_cropData('chiguayante','Peach',sys,'area')= t_cropData("chiguayante",'Peach',sys,'area')*  (1-0.933993399);
t_cropData('chiguayante','Cherry',sys,'area')= t_cropData("chiguayante",'Cherry',sys,'area')* (1-0.481364486);
t_cropData('chiguayante','Apple',sys,'area')= t_cropData("chiguayante",'Apple',sys,'area')* (1-0.584118106);
t_cropData('chiguayante','Walnut',sys,'area')= t_cropData("chiguayante",'Walnut',sys,'area')* 13.12309108;
t_cropData('chiguayante','Orange',sys,'area')= t_cropData("chiguayante",'Orange',sys,'area')*   0;
t_cropData('chiguayante','Olive',sys,'area')= t_cropData("chiguayante",'Olive',sys,'area')*  (1-0.867240452);
t_cropData('chiguayante','Avocado',sys,'area')= t_cropData("chiguayante",'Avocado',sys,'area')*  (1-0.390830946);
t_cropData('chiguayante','Pear',sys,'area')= t_cropData("chiguayante",'Pear',sys,'area')*  (1-0.909264963);
t_cropData('chiguayante','plum',sys,'area')= t_cropData("chiguayante",'plum',sys,'area')*0 ;
t_cropData('chiguayante','grapes',sys,'area')= t_cropData("chiguayante",'grapes',sys,'area')*0;
t_cropData('chiguayante','vineyard',sys,'area')= t_cropData("chiguayante",'vineyard',sys,'area')*0;

*concepcion,
t_cropData('concepcion','oat',sys,'area')= t_cropData("concepcion",'oat',sys,'area')*(2.048303908)  ;
t_cropData('concepcion','common_bean',sys,'area')= t_cropData("concepcion",'common_bean',sys,'area')* (1-0.307731434) ;
t_cropData('concepcion','potato',sys,'area')= t_cropData("concepcion",'potato',sys,'area')* (1-0.200920789) ;
t_cropData('concepcion','wheat',sys,'area')= t_cropData("concepcion",'wheat',sys,'area')*  (1-0.105972998) ;
t_cropData('concepcion','rice',sys,'area')= t_cropData("concepcion",'rice',sys,'area')* (1-0.239894129);
t_cropData('concepcion','maize',sys,'area')= t_cropData("concepcion",'maize',sys,'area')*(2.328322849);
t_cropData('concepcion','sugar_beat',sys,'area')= t_cropData("concepcion",'sugar_beat',sys,'area')*(1-0.352354788);

t_cropData('concepcion','Peach',sys,'area')= t_cropData("concepcion",'Peach',sys,'area')*  (1-0.933993399);
t_cropData('concepcion','Cherry',sys,'area')= t_cropData("concepcion",'Cherry',sys,'area')* (1-0.481364486);
t_cropData('concepcion','Apple',sys,'area')= t_cropData("concepcion",'Apple',sys,'area')* (1-0.584118106);
t_cropData('concepcion','Walnut',sys,'area')= t_cropData("concepcion",'Walnut',sys,'area')* 13.12309108;
t_cropData('concepcion','Orange',sys,'area')= t_cropData("concepcion",'Orange',sys,'area')*   0;
t_cropData('concepcion','Olive',sys,'area')= t_cropData("concepcion",'Olive',sys,'area')*  (1-0.867240452);
t_cropData('concepcion','Avocado',sys,'area')= t_cropData("concepcion",'Avocado',sys,'area')*  (1-0.390830946);
t_cropData('concepcion','Pear',sys,'area')= t_cropData("concepcion",'Pear',sys,'area')*  (1-0.909264963);
t_cropData('concepcion','plum',sys,'area')= t_cropData("concepcion",'plum',sys,'area')*0 ;
t_cropData('concepcion','grapes',sys,'area')= t_cropData("concepcion",'grapes',sys,'area')*0;
t_cropData('concepcion','vineyard',sys,'area')= t_cropData("concepcion",'vineyard',sys,'area')*0;

*hualpen,
t_cropData('hualpen','oat',sys,'area')= t_cropData("hualpen",'oat',sys,'area')*(2.048303908)  ;
t_cropData('hualpen','common_bean',sys,'area')= t_cropData("hualpen",'common_bean',sys,'area')* (1-0.307731434) ;
t_cropData('hualpen','potato',sys,'area')= t_cropData("hualpen",'potato',sys,'area')* (1-0.200920789) ;
t_cropData('hualpen','wheat',sys,'area')= t_cropData("hualpen",'wheat',sys,'area')*  (1-0.105972998) ;
t_cropData('hualpen','rice',sys,'area')= t_cropData("hualpen",'rice',sys,'area')* (1-0.239894129);
t_cropData('hualpen','maize',sys,'area')= t_cropData("hualpen",'maize',sys,'area')*(2.328322849);
t_cropData('hualpen','sugar_beat',sys,'area')= t_cropData("hualpen",'sugar_beat',sys,'area')*(1-0.352354788);

t_cropData('hualpen','Peach',sys,'area')= t_cropData("hualpen",'Peach',sys,'area')*  (1-0.933993399);
t_cropData('hualpen','Cherry',sys,'area')= t_cropData("hualpen",'Cherry',sys,'area')* (1-0.481364486);
t_cropData('hualpen','Apple',sys,'area')= t_cropData("hualpen",'Apple',sys,'area')* (1-0.584118106);
t_cropData('hualpen','Walnut',sys,'area')= t_cropData("hualpen",'Walnut',sys,'area')* 13.12309108;
t_cropData('hualpen','Orange',sys,'area')= t_cropData("hualpen",'Orange',sys,'area')*   0;
t_cropData('hualpen','Olive',sys,'area')= t_cropData("hualpen",'Olive',sys,'area')*  (1-0.867240452);
t_cropData('hualpen','Avocado',sys,'area')= t_cropData("hualpen",'Avocado',sys,'area')*  (1-0.390830946);
t_cropData('hualpen','Pear',sys,'area')= t_cropData("hualpen",'Pear',sys,'area')*  (1-0.909264963);
t_cropData('hualpen','plum',sys,'area')= t_cropData("hualpen",'plum',sys,'area')*0 ;
t_cropData('hualpen','grapes',sys,'area')= t_cropData("hualpen",'grapes',sys,'area')*0;
t_cropData('hualpen','vineyard',sys,'area')= t_cropData("hualpen",'vineyard',sys,'area')*0;

*coronel,
t_cropData('coronel','oat',sys,'area')= t_cropData("coronel",'oat',sys,'area')*(2.048303908)  ;
t_cropData('coronel','common_bean',sys,'area')= t_cropData("coronel",'common_bean',sys,'area')* (1-0.307731434) ;
t_cropData('coronel','potato',sys,'area')= t_cropData("coronel",'potato',sys,'area')* (1-0.200920789) ;
t_cropData('coronel','wheat',sys,'area')= t_cropData("coronel",'wheat',sys,'area')*  (1-0.105972998) ;
t_cropData('coronel','rice',sys,'area')= t_cropData("coronel",'rice',sys,'area')* (1-0.239894129);
t_cropData('coronel','maize',sys,'area')= t_cropData("coronel",'maize',sys,'area')*(2.328322849);
t_cropData('coronel','sugar_beat',sys,'area')= t_cropData("coronel",'sugar_beat',sys,'area')*(1-0.352354788);

t_cropData('coronel','Peach',sys,'area')= t_cropData("coronel",'Peach',sys,'area')*  (1-0.933993399);
t_cropData('coronel','Cherry',sys,'area')= t_cropData("coronel",'Cherry',sys,'area')* (1-0.481364486);
t_cropData('coronel','Apple',sys,'area')= t_cropData("coronel",'Apple',sys,'area')* (1-0.584118106);
t_cropData('coronel','Walnut',sys,'area')= t_cropData("coronel",'Walnut',sys,'area')* 13.12309108;
t_cropData('coronel','Orange',sys,'area')= t_cropData("coronel",'Orange',sys,'area')*   0;
t_cropData('coronel','Olive',sys,'area')= t_cropData("coronel",'Olive',sys,'area')*  (1-0.867240452);
t_cropData('coronel','Avocado',sys,'area')= t_cropData("coronel",'Avocado',sys,'area')*  (1-0.390830946);
t_cropData('coronel','Pear',sys,'area')= t_cropData("coronel",'Pear',sys,'area')*  (1-0.909264963);
t_cropData('coronel','plum',sys,'area')= t_cropData("coronel",'plum',sys,'area')*0 ;
t_cropData('coronel','grapes',sys,'area')= t_cropData("coronel",'grapes',sys,'area')*0;
t_cropData('coronel','vineyard',sys,'area')= t_cropData("coronel",'vineyard',sys,'area')*0;

*san_pedro_de_la_paz
t_cropData('san_pedro_de_la_paz','oat',sys,'area')= t_cropData("san_pedro_de_la_paz",'oat',sys,'area')*(2.048303908)  ;
t_cropData('san_pedro_de_la_paz','common_bean',sys,'area')= t_cropData("san_pedro_de_la_paz",'common_bean',sys,'area')* (1-0.307731434) ;
t_cropData('san_pedro_de_la_paz','potato',sys,'area')= t_cropData("san_pedro_de_la_paz",'potato',sys,'area')* (1-0.200920789) ;
t_cropData('san_pedro_de_la_paz','wheat',sys,'area')= t_cropData("san_pedro_de_la_paz",'wheat',sys,'area')*  (1-0.105972998) ;
t_cropData('san_pedro_de_la_paz','rice',sys,'area')= t_cropData("san_pedro_de_la_paz",'rice',sys,'area')* (1-0.239894129);
t_cropData('san_pedro_de_la_paz','maize',sys,'area')= t_cropData("san_pedro_de_la_paz",'maize',sys,'area')*(2.328322849);
t_cropData('san_pedro_de_la_paz','sugar_beat',sys,'area')= t_cropData("san_pedro_de_la_paz",'sugar_beat',sys,'area')*(1-0.352354788);

t_cropData('san_pedro_de_la_paz','Peach',sys,'area')= t_cropData("san_pedro_de_la_paz",'Peach',sys,'area')*  (1-0.933993399);
t_cropData('san_pedro_de_la_paz','Cherry',sys,'area')= t_cropData("san_pedro_de_la_paz",'Cherry',sys,'area')* (1-0.481364486);
t_cropData('san_pedro_de_la_paz','Apple',sys,'area')= t_cropData("san_pedro_de_la_paz",'Apple',sys,'area')* (1-0.584118106);
t_cropData('san_pedro_de_la_paz','Walnut',sys,'area')= t_cropData("san_pedro_de_la_paz",'Walnut',sys,'area')* 13.12309108;
t_cropData('san_pedro_de_la_paz','Orange',sys,'area')= t_cropData("san_pedro_de_la_paz",'Orange',sys,'area')*   0;
t_cropData('san_pedro_de_la_paz','Olive',sys,'area')= t_cropData("san_pedro_de_la_paz",'Olive',sys,'area')*  (1-0.867240452);
t_cropData('san_pedro_de_la_paz','Avocado',sys,'area')= t_cropData("san_pedro_de_la_paz",'Avocado',sys,'area')*  (1-0.390830946);
t_cropData('san_pedro_de_la_paz','Pear',sys,'area')= t_cropData("san_pedro_de_la_paz",'Pear',sys,'area')*  (1-0.909264963);
t_cropData('san_pedro_de_la_paz','plum',sys,'area')= t_cropData("san_pedro_de_la_paz",'plum',sys,'area')*0 ;
t_cropData('san_pedro_de_la_paz','grapes',sys,'area')= t_cropData("san_pedro_de_la_paz",'grapes',sys,'area')*0;
t_cropData('san_pedro_de_la_paz','vineyard',sys,'area')= t_cropData("san_pedro_de_la_paz",'vineyard',sys,'area')*0;

*new: santa_juana
t_cropData('santa_juana','oat',sys,'area')= t_cropData("santa_juana",'oat',sys,'area')*(2.048303908)  ;
t_cropData('santa_juana','common_bean',sys,'area')= t_cropData("santa_juana",'common_bean',sys,'area')* (1-0.307731434) ;
t_cropData('santa_juana','potato',sys,'area')= t_cropData("santa_juana",'potato',sys,'area')* (1-0.200920789) ;
t_cropData('santa_juana','wheat',sys,'area')= t_cropData("santa_juana",'wheat',sys,'area')*  (1-0.105972998) ;
t_cropData('santa_juana','rice',sys,'area')= t_cropData("santa_juana",'rice',sys,'area')* (1-0.239894129);
t_cropData('santa_juana','maize',sys,'area')= t_cropData("santa_juana",'maize',sys,'area')*(2.328322849);
t_cropData('santa_juana','sugar_beat',sys,'area')= t_cropData("santa_juana",'sugar_beat',sys,'area')*(1-0.352354788);

t_cropData('santa_juana','Peach',sys,'area')= t_cropData("santa_juana",'Peach',sys,'area')*  (1-0.933993399);
t_cropData('santa_juana','Cherry',sys,'area')= t_cropData("santa_juana",'Cherry',sys,'area')* (1-0.481364486);
t_cropData('santa_juana','Apple',sys,'area')= t_cropData("santa_juana",'Apple',sys,'area')* (1-0.584118106);
t_cropData('santa_juana','Walnut',sys,'area')= t_cropData("santa_juana",'Walnut',sys,'area')* 13.12309108;
t_cropData('santa_juana','Orange',sys,'area')= t_cropData("santa_juana",'Orange',sys,'area')*   0;
t_cropData('santa_juana','Olive',sys,'area')= t_cropData("santa_juana",'Olive',sys,'area')*  (1-0.867240452);
t_cropData('santa_juana','Avocado',sys,'area')= t_cropData("santa_juana",'Avocado',sys,'area')*  (1-0.390830946);
t_cropData('santa_juana','Pear',sys,'area')= t_cropData("santa_juana",'Pear',sys,'area')*  (1-0.909264963);
t_cropData('santa_juana','plum',sys,'area')= t_cropData("santa_juana",'plum',sys,'area')*0 ;
t_cropData('santa_juana','grapes',sys,'area')= t_cropData("santa_juana",'grapes',sys,'area')*0;
t_cropData('santa_juana','vineyard',sys,'area')= t_cropData("santa_juana",'vineyard',sys,'area')*0;











**********************************+agregue vineyards y plums

*---- total production in  (t/h)
*-------Commune level  ------
p_cropData(comm,act,sys,'area')= t_cropData(comm,act,sys,'area');



*Yld 2007

p_cropData(comm,act,sys,'yld')= (1/10)* t_cropData(comm,act,sys,'yld');


$ontext

*Yield 2018/19 nacional   ton/ha
*Datos regionales, no comunales
p_cropData(comm,'oat',sys,'yld')=  5.158638112;
p_cropData(comm,'common_bean',sys,'yld')= 1.667047229;
p_cropData(comm,'potato',sys,'yld')=   27.80531439;
p_cropData(comm,'wheat',sys,'yld')=  6.28597921  ;
p_cropData(comm,'rice',sys,'yld')= 6.664781648;
p_cropData(comm,'maize',sys,'yld')= 12.87717481;
p_cropData(comm,'sugar_beat',sys,'yld')=  101.6617463;
p_cropData(comm,'Peach',sys,'yld')= 0;
p_cropData(comm,'Cherry',sys,'yld')=  8.4;
p_cropData(comm,'Apple',sys,'yld')=   44.8;
p_cropData(comm,'Walnut',sys,'yld')=   4.4;
p_cropData(comm,'Orange',sys,'yld')=    0;
p_cropData(comm,'Avocado',sys,'yld')=   4.3;
p_cropData(comm,'Pear',sys,'yld')=      53;
p_cropData(comm,'Olive',sys,'yld')=  2.9;
p_cropData(comm,'vineyard',sys,'yld')=  0;
p_cropData(comm,'grapes',sys,'yld')=  0;
p_cropData(comm,'plum',sys,'yld')=  0;

$offtext;



p_cropData(comm,act,sys,'prd')  = p_cropData(comm,act,sys,'yld')*p_cropData(comm,act,sys,'area');



*-----------------Cost per yield ($/h) ($ Dic 2018)-----------------
*------------------Even if the commune doesnt grown the crop---------
*2007 to 2018 by inflation rate
*1.461615363
*p_cropData(comm,act,'irr','vcost')= t_cropData(comm,act,'irr','Ttl_Cost')*1.461615363  ;
*p_cropData(comm,act,'dry','vcost')= t_cropData(comm,act,'dry','Ttl_Cost')*1.461615363  ;

*Actualizacion 2018 con datos inia
*Usar promedios
*Si area es 0 no multiplicar
*rice (irrigated), oats (rainfed), common beans (irrigated), maize (irrigated), potatoes (irrigated and rainfed), alfalfa (irrigated),
* sugar beet (irrigated), and wheat (irrigated and rainfed).
*The fruits considered were: cherries,  peaches, apples,  walnuts, olives, avocadoes, pears, all of them irrigated activities.


*NOgrapes, NOvineyards, NOoranges, NOplums,
*POTATO
*avocado disminuye costo 14%, aumenta precio 18%
*pear costo se triplica, precio aumenta 17,9%
*WHEAT costo se triplica en irr, duplica en dry, precio aumenta 30%


p_cropData(comm,act,'irr','vcost')= t_cropData(comm,act,'irr','Ttl_Cost') ;
p_cropData(comm,act,'dry','vcost')= t_cropData(comm,act,'dry','Ttl_Cost')  ;



p_cropData(comm,'potato',sys,'vcost')= t_cropData(comm,'potato',sys,'Ttl_Cost')*(1+0.52004365);

p_cropData(comm,'wheat','irr','vcost')= t_cropData(comm,'wheat','irr','Ttl_Cost')*(1+0.273990566);

p_cropData(comm,'rice','irr','vcost')= t_cropData(comm,'rice','irr','Ttl_Cost')*(1+0.064612253);

*OCUPAMOS WHEAT COMO ANALOGO AL NO TENER INFORMACION DE ODEPA
p_cropData(comm,'maize','irr','vcost')= t_cropData(comm,'maize','irr','Ttl_Cost')*(1+0.273990566);

*OCUPAMOS RICE COMO ANALOGO AL NO TENER INFORMACION DE ODEPA
p_cropData(comm,'sugar_beat','irr','vcost')= t_cropData(comm,'sugar_beat','irr','Ttl_Cost')*(1+0.064612253);

*OCUPAMOS WHEAT COMO ANALOGO AL NO TENER INFORMACION DE ODEPA
p_cropData(comm,'oat','dry','vcost')= t_cropData(comm,'oat','dry','Ttl_Cost')*(1+0.273990566);

*OCUPAMOS RICE COMO ANALOGO AL NO TENER INFORMACION DE ODEPA
p_cropData(comm,'common_bean','irr','vcost')= t_cropData(comm,'common_bean','irr','Ttl_Cost')*(1+0.064612253);


p_cropData(comm,'apple','irr','vcost')= t_cropData(comm,'apple','irr','Ttl_Cost')*(1+0.115598619);
p_cropData(comm,'cherry','irr','vcost')= t_cropData(comm,'cherry','irr','Ttl_Cost')*(1+0.615498449) ;
p_cropData(comm,'avocado','irr','vcost')= t_cropData(comm,'avocado','irr','Ttl_Cost')* (1+0.339777524) ;
p_cropData(comm,'pear','irr','vcost')= t_cropData(comm,'pear','irr','Ttl_Cost')*(1+0.832572874) ;
p_cropData(comm,'olive','irr','vcost')= t_cropData(comm,'olive','irr','Ttl_Cost')* (1+1.790879707) ;

*OCUPAMOS AVOCADO COMO ANALOGO AL NO TENER INFORMACION DE ODEPA
p_cropData(comm,'walnut','irr','vcost')= t_cropData(comm,'walnut','irr','Ttl_Cost')*(1+0.339777524)  ;

*OCUPAMOS PEAR COMO ANALOGO AL NO TENER INFORMACION DE ODEPA
p_cropData(comm,'peach','irr','vcost')= t_cropData(comm,'peach','irr','Ttl_Cost')* (1+0.832572874) ;


*-----------------Revenue ($/ton) ($ Dic 2018)------------------
parameter t_avgeprice 'average producer price 2014-2018 (real)';
*http://www.fao.org/faostat/en/#data/PP

t_avgeprice(act,'avge')$(sum(yrs,1$t_outputPriceReal(act,yrs)) gt 0)=sum(yrs,t_outputPriceReal(act,yrs))/sum(yrs,1$t_outputPriceReal(act,yrs)) ;
t_avgeprice('fallow_land','avge')=0;
t_avgeprice('pine','avge')=sum(yrs,t_outputPriceReal('pine',yrs))/sum(yrs,1$t_outputPriceReal('pine',yrs));
t_avgeprice('eucalyptus','avge')=sum(yrs,t_outputPriceReal('eucalyptus',yrs))/sum(yrs,1$t_outputPriceReal('eucalyptus',yrs));






*Actualizacion 2018 ODEPA


t_avgeprice('apple','avge')=  t_avgeprice('apple','avge')* (1-0.171598684);
t_avgeprice('oat','avge')=  t_avgeprice('oat','avge')* (1+0.067624133);
t_avgeprice('avocado','avge')= t_avgeprice('avocado','avge')* (1+0.282872485) ;
t_avgeprice('rice','avge')= t_avgeprice('rice','avge')*(1+0.837451247)    ;
t_avgeprice('common_bean','avge')=t_avgeprice('common_bean','avge')* (1+1.563322807)   ;

t_avgeprice('potato','avge')= t_avgeprice('potato','avge')* (1+0.68626579)   ;
t_avgeprice('wheat','avge')= t_avgeprice('wheat','avge')* (1+0.113571729)   ;
t_avgeprice('cherry','avge')= t_avgeprice('cherry','avge')* (1+3.457482136)   ;
t_avgeprice('peach','avge')=  t_avgeprice('peach','avge')* (1-0.38187199)   ;
t_avgeprice('pear','avge')=  t_avgeprice('pear','avge')* (1+0.17917786)  ;
t_avgeprice('olive','avge')=  t_avgeprice('olive','avge')* (1+0.886792453 ) ;

*OCUPAMOS RICE COMO ANALOGO AL NO TENER INFORMACION DE ODEPA
t_avgeprice('sugar_beat','avge')=  t_avgeprice('sugar_beat','avge')* (1+0.837451247)   ;

*OCUPAMOS WHEAT COMO ANALOGO AL NO TENER INFORMACION DE ODEPA
t_avgeprice('maize','avge')=t_avgeprice('maize','avge')* (1+0.113571729)   ;

*OCUPAMOS AVOCADO COMO ANALOGO AL NO TENER INFORMACION DE ODEPA
t_avgeprice('Walnut','avge')=  t_avgeprice('Walnut','avge')* (1+0.282872485) ;


*Not used
*t_avgeprice('grapes','avge')=  t_avgeprice('grapes','avge')*    ;
*t_avgeprice('vineyard','avge')=  t_avgeprice('vineyard','avge')*    ;
*t_avgeprice('orange','avge')=  t_avgeprice('orange','avge')*    ;
*t_avgeprice('plum','avge')= t_avgeprice('plum','avge')*    ;


$ontext
*FAO 2018
t_avgeprice('apple','avge')=620.5*p_cropData('Nacimiento','apple','irr','yld');
t_avgeprice('avocado','avge')=2534.74*p_cropData('Nacimiento','avocado','irr','yld');
t_avgeprice('rice','avge')= 234.46*p_cropData('Nacimiento','rice','irr','yld');
t_avgeprice('common_bean','avge')=1354.96*p_cropData('Nacimiento','common_bean','irr','yld');
t_avgeprice('maize','avge')=176.84*p_cropData('Nacimiento','maize','irr','yld');
t_avgeprice('potato','avge')= 427.04*p_cropData('Nacimiento','potato','irr','yld');
t_avgeprice('wheat','avge')= 213.44*p_cropData('Nacimiento','wheat','irr','yld');
t_avgeprice('cherry','avge')= 2208.5*p_cropData('Nacimiento','cherry','irr','yld');
t_avgeprice('plum','avge')=  644.54*p_cropData('Nacimiento','plum','irr','yld');
t_avgeprice('peach','avge')=  1193.52*p_cropData('Nacimiento','peach','irr','yld');
t_avgeprice('orange','avge')=  701.02*p_cropData('Nacimiento','orange','irr','yld');
t_avgeprice('pear','avge')=  660.1*p_cropData('Nacimiento','pear','irr','yld');
t_avgeprice('grapes','avge')=  1657.46*p_cropData('Nacimiento','grapes','irr','yld');
t_avgeprice('vineyard','avge')=  1657.46*p_cropData('Nacimiento','vineyard','irr','yld');


*pesos/ton  (dolar promedio 2018 sii)
t_avgeprice(act,'avge')=t_avgeprice(act,'avge')*641.2208333 ;

$offtext


*----------------Gross Margin ($/h) ($ Dic 2019)----------------    (price 2018, cost 2019
*------Comune---

p_cropData(comm,act,'irr','srev')$p_cropData(comm,act,'irr','yld')= t_avgeprice(act,'avge')*p_cropData(comm,act,'irr','yld');
p_cropData(comm,act,'dry','srev')$p_cropData(comm,act,'dry','yld')= t_avgeprice(act,'avge')*p_cropData(comm,act,'dry','yld');
p_cropData(comm,act,sys,'gmar')= P_cropData(comm,act,sys,'srev')- p_cropData(comm,act,sys,'vcost');




*--------------labor demand: jornadas de trabajo por hectarea al a?o----------
*--------Comune-----
p_cropData(comm,act,'irr','labor')= t_cropdata(comm,act,'irr','labor');
p_cropData(comm,act,'dry','labor')= t_cropdata(comm,act,'dry','labor');
p_cropData(comm,act,'tot','labor')= p_cropdata(comm,act,'irr','labor') + p_cropData(comm,act,'dry','labor');
p_cropData('illapel','wheat','dry','labor')= 3.95;
p_cropData('canela','wheat','dry','labor')= 3.95;
p_cropData('ovalle','wheat','dry','labor')= 3.95;
p_cropData('canete','wheat','dry','labor')= 8.55;
p_cropData('la_higuera','Nat_Grassland','dry','labor')= 2.93;

*----------------Crop Irrigation requirements at the Base Line(th m3/h/yr)---------
*--------Original data in mm/m2/yr
*----For those crops without CIR information the associated figure is:
*Vineyard=grapes
*Rice= 15 tho m3/h/yr
*cherry, plum, walnut and pear uses 8 tho m3/year = used by peach
*Olive uses 5 tho m3/year = used by maize
*Avocado uses 10 tho m3/year =used by orange
*Alfalfa and managed grassland uses 12 tho m3/year

*------Comune level----
p_cropData(comm,act,'irr','cir')= (1/100)*t_cir(comm,act,'BL');
p_cropData(comm,'vineyard','irr','cir')= (1/100)*t_cir(comm,'grapes','BL');

p_cropData(comm,'rice','irr','cir')= 15;

p_cropData(comm,'cherry','irr','cir')= (1/100)*t_cir(comm,'peach','BL');
p_cropData(comm,'plum','irr','cir')= (1/100)*t_cir(comm,'peach','BL');
p_cropData(comm,'walnut','irr','cir')=(1/100) *t_cir(comm,'peach','BL');
p_cropData(comm,'pear','irr','cir')= (1/100)*t_cir(comm,'peach','BL');

p_cropData(comm,'olive','irr','cir')= (1/100)*t_cir(comm,'maize','BL');

p_cropData(comm,'avocado','irr','cir')= (1/100)*t_cir(comm,'orange','BL');

p_cropData(comm,'alfalfa','irr','cir')= 12;
p_cropData(comm,'Mnged_Grassland','irr','cir')= p_cropData(comm,'alfalfa','irr','cir');

*-------------Climate Change Impacts on Yields(t) and Cir (Crop irr req): A2-240 and B2-2040 -------

p_climChange(comm,act,'A240',sys,'CCyld')= (1/10)*t_CCA240(comm,act,sys,'yield');
p_climChange(comm,act,'B240',sys,'CCyld')= (1/10)*t_CCB240(comm,act,sys,'yield');

p_climChange(comm,act,'A240','Irr','CCcir')= (1/100)*t_cir(comm,act,'A240');
p_climChange(comm,act,'B240','Irr','CCcir')= (1/100)*t_cir(comm,act,'B240');

p_climChange(comm,'Vineyard','A240','Irr','CCcir')= t_cir(comm,'grapes','A240');
p_climChange(comm,'Vineyard','B240','Irr','CCcir')= t_cir(comm,'grapes','B240');

p_climChange(comm,'cherry','A240','Irr','CCcir')= t_cir(comm,'peach','A240');
p_climChange(comm,'cherry','B240','Irr','CCcir')= t_cir(comm,'peach','B240');

p_climChange(comm,'plum','A240','Irr','CCcir')= t_cir(comm,'peach','A240');
p_climChange(comm,'plum','B240','Irr','CCcir')= t_cir(comm,'peach','B240');

p_climChange(comm,'walnut','A240','Irr','CCcir')= t_cir(comm,'peach','A240');
p_climChange(comm,'walnut','B240','Irr','CCcir')= t_cir(comm,'peach','B240');

p_climChange(comm,'pear','A240','Irr','CCcir')= t_cir(comm,'peach','A240');
p_climChange(comm,'pear','B240','Irr','CCcir')= t_cir(comm,'peach','B240');

p_climChange(comm,'olive','A240','Irr','CCcir')= t_cir(comm,'maize','A240');
p_climChange(comm,'olive','B240','Irr','CCcir')= t_cir(comm,'maize','B240');

p_climChange(comm,'avocado','A240','Irr','CCcir')= t_cir(comm,'orange','A240');
p_climChange(comm,'avocado','B240','Irr','CCcir')= t_cir(comm,'orange','B240');

p_climChange(comm,'alfalfa','A240','Irr','CCcir')= 1.2*p_cropData(comm,'alfalfa','irr','cir');
p_climChange(comm,'alfalfa','B240','Irr','CCcir')= 1.2*p_cropData(comm,'alfalfa','irr','cir');

p_climChange(comm,'Mngd_Grassland','A240','Irr','CCcir')=p_climChange(comm,'alfalfa','A240','Irr','CCcir');
p_climChange(comm,'Mngd_Grassland','B240','Irr','CCcir')=p_climChange(comm,'alfalfa','B240','Irr','CCcir') ;




*--------------market Data: Elasticities--------------*
p_marketdata(act,'selast')= t_elasticities(act,'selas');

*   ---- supply data: elasticities, production and producer prices ($ Dic 2007)--------
p_supplyData(act,'prd')  = sum((comm,sys),p_cropData(comm,act,sys,'prd'));
p_supplyData(act,'spre')$p_supplyData(act,'prd')= t_avgeprice(act,'avge');

*----Alfalfa supply elasticity = Maize

p_supplyData(act,'selast')= t_elasticities(act,'selas');
p_supplyData('Alfalfa','selast')= t_elasticities('Maize','selas');

*   ---- create gdx file with model data

display   p_cropData;


execute_unload '..\results\Chile_db.gdx' p_cropData  p_climChange  p_supplyData   p_marketdata ;
execute 'gdxxrw.exe ..\results\Chile_db.gdx o=..\results\Chile_db.xlsx par=p_cropData rng=cropData!A1' ;
execute 'gdxxrw.exe ..\results\Chile_db.gdx o=..\results\Chile_db.xlsx par=p_climChange rng=climChange!A1' ;
execute 'gdxxrw.exe ..\results\Chile_db.gdx o=..\results\Chile_db.xlsx par=p_supplyData rng=supplyData!A1' ;
execute 'gdxxrw.exe ..\results\Chile_db.gdx o=..\results\Chile_db.xlsx par=p_marketdata rng=marketdata!A1' ;



