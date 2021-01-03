/* Auteurs : Saida Guezoui et Benoit Gilles

%let path=C:\Users\saida\OneDrive\Desktop\Master 1\STAT EXPLORATOIRE\TP3 ;


LIBNAME TPsexp "&path";
PROC IMPORT OUT= kenya 
            DATAFILE= "&path\kenya.txt" 
            DBMS=TAB REPLACE;
     		GETNAMES=YES;
			DELIMITER=";";
     		DATAROW=2; 
RUN;

/***************    Affichage du dictionnaire    ***************/
/*47 observations ; 17 variables  */
PROC CONTENTS DATA=TPsexp.kenya;
RUN;


/***************************************************************/
/****************    Statistiques Univariées    ****************/
/***************************************************************/

proc means data=TPsexp.kenya  MIN MEAN MAX MEDIAN CLM VAR Q1 Q3 Maxdec=2 ;
run; 

PROC UNIVARIATE DATA=TPsexp.kenya;
RUN;


/********Graphiques : utilisation de la PROC SGPLOT********/


PROC SGPLOT DATA=TPsexp.kenya;
HISTOGRAM electricity;
RUN;
PROC SGPLOT DATA=TPsexp.kenya;
HISTOGRAM radio;
RUN;
PROC SGPLOT DATA=TPsexp.kenya;
HISTOGRAM television;
RUN;
PROC SGPLOT DATA=TPsexp.kenya;
HISTOGRAM refrigerator;
RUN;
PROC SGPLOT DATA=TPsexp.kenya;
HISTOGRAM landlinephone;
RUN;
PROC SGPLOT DATA=TPsexp.kenya;
HISTOGRAM mobilephone;
RUN;
PROC SGPLOT DATA=TPsexp.kenya;
HISTOGRAM solarpanel;
RUN;
PROC SGPLOT DATA=TPsexp.kenya;
HISTOGRAM table;
RUN;
PROC SGPLOT DATA=TPsexp.kenya;
HISTOGRAM chair;
RUN;
PROC SGPLOT DATA=TPsexp.kenya;
HISTOGRAM sofa;
RUN;
PROC SGPLOT DATA=TPsexp.kenya;
HISTOGRAM bed;
RUN;
PROC SGPLOT DATA=TPsexp.kenya;
HISTOGRAM cupboard;
RUN;
PROC SGPLOT DATA=TPsexp.kenya;
HISTOGRAM clock;
RUN;
PROC SGPLOT DATA=TPsexp.kenya;
HISTOGRAM microwave;
RUN;
PROC SGPLOT DATA=TPsexp.kenya;
HISTOGRAM dvdplayer ;
RUN;
PROC SGPLOT DATA=TPsexp.kenya;
HISTOGRAM cdplayer;
RUN; 

/* Affichage des boxplots de 3 variables */ 
proc sgplot data= kenya ;
vbox electricity / boxwidth = 0.25 discreteoffset= -0.5; 
vbox television / boxwidth = 0.25 discreteoffset= 0;
vbox refrigerator / boxwidth = 0.25 discreteoffset= 0.5;
run;

/* Affichage de tous les boxplots à la fois*/ 

PROC SGPLOT DATA=TPsexp.kenya;
vbox electricity /  discreteoffset= -0.5 BOXWIDTH=0.06;
vbox radio / discreteoffset = -0.45 BOXWIDTH=0.06;
vbox television / discreteoffset = -0.40 BOXWIDTH=0.06;
vbox refrigerator / discreteoffset = -0.26 BOXWIDTH=0.06;
vbox landlinephone / discreteoffset = -0.18 BOXWIDTH=0.06;
vbox mobilephone / discreteoffset = -0.10 BOXWIDTH=0.06;
vbox solarpanel / discreteoffset = -0.10 BOXWIDTH=0.06;
vbox table / discreteoffset = 0.00 BOXWIDTH=0.06;
vbox chair / discreteoffset = 0.10 BOXWIDTH=0.06;
vbox sofa / discreteoffset = 0.15 BOXWIDTH=0.06;
vbox bed / discreteoffset = 0.20 BOXWIDTH=0.06;
vbox cupboard / discreteoffset = 0.25 BOXWIDTH=0.06;
vbox clock / discreteoffset = 0.30 BOXWIDTH=0.06;
vbox microwave/ discreteoffset = 0.38 BOXWIDTH=0.06;
vbox  dvdplayer/ discreteoffset = 0.43 BOXWIDTH=0.06;
vbox  cdplayer / discreteoffset = 0.50 BOXWIDTH=0.06;
xaxis grid;
RUN;


/***************************************************************/
/****************    Statistiques Bivariées    *****************/
/***************************************************************/

filename orig "C:\Users\saida\OneDrive\Desktop\captures projet stat explo";
goptions reset = all;
goptions device =gif gsfname=orig;

/* Corrélation entre les variables */ 
PROC CORR DATA=TPsexp.kenya plots out= matrice_covariance ;
var electricity -- cdplayer ; 
RUN;

filename orig clear;

PROC GPLOT DATA=TPsexp.kenya;
SYMBOL V=square;
PLOT dvdplayer * television;
RUN;

PROC GPLOT DATA=TPsexp.kenya;
SYMBOL V=square;
PLOT electricity * chair;
RUN;


/***************************************************************/
/*************************     ACP     *************************/
/***************************************************************/

OPTION MAUTOSOURCE SASAUTOS="C:\Users\saida\OneDrive\Desktop\Master 1\STAT EXPLORATOIRE\TP3";
PROC OPTIONS OPTION=SASAUTOS;
RUN;
/*****************ACP canonique ***********************/ 

%acp(TPsexp.kenya, county ,electricity--cdplayer, q=2); 

%acp(TPsexp.kenya, county ,electricity--cdplayer, q=2); 
%gacpsx
%gacpbx
%gacpvx(x=1,y=2,nc=6,coeff=1); /* vx pour carte des variables*/ 
%gacpix(x=1,y=2,nc=6,coeff=1); /* ix pour carte des individus*/ 
run;

%gacpvx(x=1,y=2,nc=6,coeff=1); 
%gacpix(x=1,y=2,nc=6,coeff=1)

/* Calcul des qualités de représentation des variables */
DATA VAR_qualite ;
SET Covarfac ;
DROP v3 -- v16 ;
Qualite_axe1 = v1*v1 ;                          
Qualite_axe2 = v2*v2 ;                           
Qualite_plan = Qualite_axe1 + Qualite_axe2 ;      
RUN ;
/* Calcul des contributions des variables aux axes 1 et 2 et le plan principale */
DATA VAR_contribution; 
SET VAR_qualite ; 
Contrib_axe1 =  Qualite_axe1 / 9.00; 
Contrib_axe2 = Qualite_axe2 / 3.81; 
Contrib_plan =  Contrib_axe1 + Contrib_axe2; 
Drop v1-- Qualite_plan; 
Run; 
proc print data = VAR_qualite; 
run; 

proc print data= VAR_contribution;
run; 

/***************************************************************/
/************Classification ascendante hiéarchique *************/
/***************************************************************/

TITLE "Classification ascendante hiérarchique des districts, méthode=WARD";
PROC CLUSTER DATA=TPsexp.kenya
	METHOD=ward		
	OUTTREE=tree	
	PSEUDO		
	RSQUARE		
	SIMPLE		
	STANDARD;	 
ID county ; 	
VAR electricity -- cdplayer ; 
RUN;

PROC cluster DATA=TPsexp.kenya methode =ward outtree= TPsexp.tree pseudo rsquare standard; 
ID county;
var electricity --cdplayer ;
RUN;

proc sort data=tree;
  by _ncl_; /* tri par rapport au nombre de classe */ 
run;
     /****sprsq *****/
data sprsq;
 set tree;
 by _ncl_;
if first._ncl_;
keep _ncl_ _sprsq_;
run;
proc gplot data=sprsq;
where _ncl_ <10;
plot _sprsq_*_ncl_;
symbol i=join;
run;
quit;


  /**** pseudo f et pseudo t ****/
data FT2;
   set tree ;
   by _ncl_;
   if first._ncl_;
   if _psf_=. and _pst2_=. then delete;
   keep _ncl_ _psf_  _pst2_;
   legend1 across=2 cborder=red
   position = (top right inside ) mode = protect
   label=none
    value= (h= 0.5 tick=1 "F" tick=2 "T2");

   axis1 label = none;
   symbol1 c=green i=join l=1;
   symbol2 c=red i=join l=2 ;

   proc gplot data= FT2 ;
    where _ncl_ < 10;
    plot (_psf_ _pst2_)*_ncl_/overlay legend=legend1
          vaxis=axis1;

   run;
   quit;

/*Procedure TREE*/ 

PROC TREE DATA=tree NCLUSTERS=3 OUT=out; /*3 classes*/ 
copy electricity --cdplayer ;
ID county;
run;
/* creation de la colonne cluster (num de la classe)et clusname  */

PROC PRINT DATA=out;
RUN;

PROC MAPIMPORT OUT=carto_kenya DATAFILE="C:\Users\saida\OneDrive\Desktop\Master 1\STAT EXPLORATOIRE\TP4\Kenya_admin_2014_WGS84.shp";
RUN;

PROC GMAP DATA=out MAP=carto_kenya ;
ID county;
CHORO cluster / DISCRETE WOUTLINE=1 LEVELS=4;
title "kenya";
RUN;
QUIT;


PROC SORT DATA=out;
BY cluster;
RUN;
PROC PRINT DATA=out; 
BY cluster;
RUN;

/*8*/
PROC TABULATE DATA=out NOSEPS FORMAT=8.2;
CLASS cluster;
var electricity --cdplayer ; 
TABLE (electricity --cdplayer), (cluster all)*(mean) / rts= 7 condense ;
LABEL cluster="classe";
KEYLABEL mean="moyenne";
RUN;

/*test */
%macro valeurtest(vble) ;

title "";
PROC SQL;
CREATE TABLE meanbyclus AS
SELECT DISTINCT mean(&vble) as byclus_m&vble, cluster, 1 as indic, count(*) as nl
FROM out
GROUP BY cluster
;


CREATE TABLE meantot AS
SELECT DISTINCT mean(&vble) as m&vble, var(&vble) as var&vble, 1 as indic, count(*) as n
FROM out
;

create table pourvaleurtest as
select data1.cluster, data1.byclus_m&vble,  data2.m&vble, data2.var&vble, data1.nl, data2.n
from meanbyclus as data1 FULL JOIN meantot as data2
on data1.indic=data2.indic;

create table &vble as
select cluster as cluster,((byclus_m&vble-m&vble)/sqrt(((n-nl)/nl)*(var&vble/(n-1)))) as &vble
from pourvaleurtest
order by cluster
;
QUIT;
%mend valeurtest;


%LET selvar=electricity radio television refrigerator landlinephone mobilephone solarpanel
table chair sofa bed cupboard clock microwave dvdplayer cdplayer;  

%valeurtest(%scan(&selvar,1,' '));
%valeurtest(%scan(&selvar,2,' '));
%valeurtest(%scan(&selvar,3,' '));
%valeurtest(%scan(&selvar,4,' '));
%valeurtest(%scan(&selvar,5,' '));
%valeurtest(%scan(&selvar,6,' '));
%valeurtest(%scan(&selvar,7,' '));
%valeurtest(%scan(&selvar,8,' '));
%valeurtest(%scan(&selvar,9,' '));
%valeurtest(%scan(&selvar,10,' '));
%valeurtest(%scan(&selvar,11,' '));
%valeurtest(%scan(&selvar,12,' '));
%valeurtest(%scan(&selvar,13,' '));
%valeurtest(%scan(&selvar,14,' '));
%valeurtest(%scan(&selvar,15,' '));
%valeurtest(%scan(&selvar,16,' '));



/* Valeurs test */
data vt;
merge &selvar;
by cluster;
run;

Title "Valeurs tests";
proc tabulate data=vt noseps format =8.2;
class cluster ;
var &selvar;
table(&selvar),
mean="valeur test"*(cluster)
/rts=7 condense;
label cluster='Classes';
/*keylabel mean='moyenne';*/
run;
