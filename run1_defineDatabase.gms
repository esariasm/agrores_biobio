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
*Curacautin
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
************************************************************************************************************************
*Actualizacion de datos al 2019, INE y ODEPA
*Falta:  alfalfa


*BioBio: Mulchen, Negrete, Nacimiento
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




*--------------labor demand: jornadas de trabajo por hectarea al año----------
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



