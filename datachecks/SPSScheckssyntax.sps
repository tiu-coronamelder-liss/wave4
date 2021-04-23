* Encoding: UTF-8.
* This script produces output to check the data and outcomes in the report. 
* Open data.
GET
  FILE='L_Corona_app_wave4_3p.sav'.
DATASET NAME DataSet2 WINDOW=FRONT.

* Remove the participants for which data was not complete.1608 rows in the dataset. 14 had missings. 1594 completes. 
USE ALL.
COMPUTE filter_$=( ~ SYSMIS(duur)).
VARIABLE LABELS filter_$ ' ~ SYSMIS(duur) (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

* Create new variable user status to check the R script. 
* Check user status finegrained.
compute user_status_intention = 1. 
if (Behavior_UTAUT = 1) user_status_intention = 1.
if((Behavior_UTAUT =3) & ((BI1a_UTAUT = 1) | (BI1a_UTAUT = 2) | (BI1a_UTAUT = 3))) user_status_intention = 2.
if (Behavior_UTAUT =3) & ((BI1a_UTAUT = 4)) user_status_intention = 3.
if (Behavior_UTAUT =3) & ((BI1a_UTAUT = 5) | (BI1a_UTAUT = 6) | (BI1a_UTAUT = 7)) user_status_intention = 4.
if (Behavior_UTAUT =2) user_status_intention = 5.
execute.

value labels user_status_intention 
1 'Gebruiker'
2 'Nooit gebruikt en niet van plan'
3 'Nooit gebruikt en neutraal'
4 'Nooit gebruikt en wel van plan'
5 'Voormalig gebruiker'.
execute.

* Frequency user status intention.
FREQUENCIES VARIABLES=user_status_intention
  /ORDER=ANALYSIS.

* Demographics.
FREQUENCIES VARIABLES=geslacht lftdcat sted belbezig burgstat nettocat oplmet woonvorm
  /ORDER=ANALYSIS.

* Health motivation.
FREQUENCIES VARIABLES=CoronaInfectionSelf CoronaInfectionSelfTest CoronaInfectionSelfTest_1 CoronaInfectionSelfTest_2 
 /ORDER=ANALYSIS.

FREQUENCIES VARIABLES= HBM_PSus_self1 HBM_PSev_other2 
 /ORDER=ANALYSIS.

* Adherence general behavioral measures.
FREQUENCIES VARIABLES= Intention_AdherenceGeneralMeasures_quarantaine Behavior_AdherenceGeneralMeasures_handwashing Corona_complaints Behavior_AdherenceGeneralMeasures_quarantaine
 /ORDER=ANALYSIS.

* Conspiracy theories.
FREQUENCIES VARIABLES= Beliefs_Conspiracy1 Beliefs_Conspiracy2 
 /ORDER=ANALYSIS.

* Trust government. 
FREQUENCIES VARIABLES= Beliefs_TrustGovernment
 /ORDER=ANALYSIS.


* Awareness.
FREQUENCIES VARIABLES= Awareness
 /ORDER=ANALYSIS.

* Use and intention. 
FREQUENCIES VARIABLES= Behavior_UTAUT BI1a_UTAUT BI1b_UTAUT
 /ORDER=ANALYSIS.

* Use and intention. 
FREQUENCIES VARIABLES= Behavior_UTAUT BI1b_UTAUT
 /ORDER=ANALYSIS.

* CheckBI1a_UTAUT for only never users.  
USE ALL.
COMPUTE filter_$=( ~ SYSMIS(duur)  & (Behavior_UTAUT = 3)).
VARIABLE LABELS filter_$ ' ~ SYSMIS(duur)  & (Behavior_UTAUT = 3) (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

FREQUENCIES VARIABLES= Behavior_UTAUT BI1a_UTAUT 
 /ORDER=ANALYSIS.

* For all checks with users vs non users: select only the current and never users and split by  Behavior_UTAUT.
USE ALL.
COMPUTE filter_$=( ~ SYSMIS(duur)  & (Behavior_UTAUT ~= 2)).
VARIABLE LABELS filter_$ ' ~ SYSMIS(duur)  & (Behavior_UTAUT ~= 2) (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

CROSSTABS
  /TABLES=geslacht lftdcat sted belbezig burgstat nettocat oplmet woonvorm BY Behavior_UTAUT
  /FORMAT=AVALUE TABLES
  /CELLS=COUNT ROW 
  /COUNT ROUND CELL.

* Check user status health motivation / suscep / severity.
CROSSTABS
  /TABLES=HBM_PSus_self1 HBM_PSus_other2 BY Behavior_UTAUT
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW COLUMN 
  /COUNT ROUND CELL.

CROSSTABS
  /TABLES=HBM_PSus_self1 HBM_PSus_other2 BY user_status_intention
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW COLUMN 
  /COUNT ROUND CELL.

* Check user status adherence to general measures. 
CROSSTABS
  /TABLES= Intention_AdherenceGeneralMeasures_handwashing Behavior_AdherenceGeneralMeasures_avoidbusyplaces Intention_AdherenceGeneralMeasures_testwithsymptoms BY Behavior_UTAUT
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW COLUMN 
  /COUNT ROUND CELL.

* Check user status general statements conspiracy.
CROSSTABS
  /TABLES= Beliefs_Conspiracy2 BY Behavior_UTAUT
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW COLUMN 
  /COUNT ROUND CELL.

* Check trust government. 
CROSSTABS
  /TABLES= Beliefs_TrustGovernment BY Behavior_UTAUT
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW COLUMN 
  /COUNT ROUND CELL.

* Use all 1900 again. 
USE ALL.
COMPUTE filter_$=( ~ SYSMIS(duur)).
VARIABLE LABELS filter_$ ' ~ SYSMIS(duur) (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.
CROSSTABS
  /TABLES= Beliefs_Conspiracy2 BY user_status_intention 
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW COLUMN 
  /COUNT ROUND CELL.

* Expected use and value of the CoronaMelder.
FREQUENCIES VARIABLES= PE1_UTAUT Beliefs_ResponseefficasyOther
 /ORDER=ANALYSIS.
CROSSTABS
  /TABLES= PE1_UTAUT BY Behavior_UTAUT
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW COLUMN 
  /COUNT ROUND CELL.

CROSSTABS
  /TABLES= PE1_UTAUT BY user_status_intention 
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW COLUMN 
  /COUNT ROUND CELL.

* In the Media.
FREQUENCIES VARIABLES= Media MediaValence
 /ORDER=ANALYSIS.
CROSSTABS
  /TABLES= Media MediaValence BY Behavior_UTAUT
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW COLUMN 
  /COUNT ROUND CELL.

CROSSTABS
  /TABLES= Media MediaValence BY user_status_intention 
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW COLUMN 
  /COUNT ROUND CELL.

* Adequacy of technology and societal effects.
FREQUENCIES VARIABLES= Beliefs_technologyperformance Beliefs_benefiteconomic
 /ORDER=ANALYSIS.
CROSSTABS
  /TABLES= Beliefs_technologyperformance Beliefs_benefiteconomic BY Behavior_UTAUT
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW COLUMN 
  /COUNT ROUND CELL.

CROSSTABS
  /TABLES= Beliefs_technologyperformance Beliefs_benefiteconomic BY user_status_intention 
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW COLUMN 
  /COUNT ROUND CELL.

* Self efficacy and effort expectancy. 
* Check EE vars for only non users.
USE ALL.
COMPUTE filter_$=( ~ SYSMIS(duur)  & (Behavior_UTAUT = 3)).
VARIABLE LABELS filter_$ ' ~ SYSMIS(duur)  & (Behavior_UTAUT = 3) (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

FREQUENCIES VARIABLES= EE1b_UTAUT EE1b_UTAUT EE2b_UTAUT
 /ORDER=ANALYSIS.

* Check EE for only users.
USE ALL.
COMPUTE filter_$=( ~ SYSMIS(duur)  & (Behavior_UTAUT = 1)).
VARIABLE LABELS filter_$ ' ~ SYSMIS(duur)  & (Behavior_UTAUT = 3) (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

FREQUENCIES VARIABLES= EE1a_UTAUT EE2a_UTAUT EE1b_UTAUT EE2b_UTAUT
 /ORDER=ANALYSIS.

* SElf efficasy.
* Use all 1900 again. 
USE ALL.
COMPUTE filter_$=( ~ SYSMIS(duur)).
VARIABLE LABELS filter_$ ' ~ SYSMIS(duur) (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.
FREQUENCIES VARIABLES= HBM_selfefficacy_CoronaMelder
 /ORDER=ANALYSIS.

* Tech related barriers. 
* Use all 1900 again. 
USE ALL.
COMPUTE filter_$=( ~ SYSMIS(duur)).
VARIABLE LABELS filter_$ ' ~ SYSMIS(duur) (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.
FREQUENCIES VARIABLES=  FC1_UTAUT FC2_UTAUT HBM_barriers_CoronaMelder HBM_perceivedbenefits_CoronaMelder
 /ORDER=ANALYSIS.

CROSSTABS
  /TABLES= FC1_UTAUT FC2_UTAUT HBM_barriers_CoronaMelder HBM_perceivedbenefits_CoronaMelder BY Behavior_UTAUT
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW COLUMN 
  /COUNT ROUND CELL.

CROSSTABS
  /TABLES= FC1_UTAUT FC2_UTAUT HBM_barriers_CoronaMelder BY user_status_intention 
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW COLUMN 
  /COUNT ROUND CELL.

* Voluntariness. 
FREQUENCIES VARIABLES=  Beliefs_voluntariness Beliefs_voluntariness2 Beliefs_AffectIrritation Beliefs_AffectAnger
 /ORDER=ANALYSIS.

CROSSTABS
  /TABLES= Beliefs_voluntariness  Beliefs_voluntariness2 Beliefs_AffectIrritation Beliefs_AffectAnger BY Behavior_UTAUT
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW COLUMN 
  /COUNT ROUND CELL.

CROSSTABS
  /TABLES= Beliefs_voluntariness  Beliefs_voluntariness2 Beliefs_AffectIrritation Beliefs_AffectAnger BY user_status_intention 
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW COLUMN 
  /COUNT ROUND CELL.

* Extra items voluntariness.
FREQUENCIES VARIABLES=  Beliefs_voluntariness_employer Beliefs_voluntariness_school Beliefs_voluntariness_government Beliefs_voluntariness_civic
 /ORDER=ANALYSIS.

* Affective responses. 
FREQUENCIES VARIABLES=  Beliefs_fear Beliefs_notificationfear
 /ORDER=ANALYSIS.

CROSSTABS
  /TABLES= Beliefs_fear Beliefs_notificationfear BY Behavior_UTAUT
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW COLUMN 
  /COUNT ROUND CELL.

CROSSTABS
  /TABLES= Beliefs_fear Beliefs_notificationfear BY user_status_intention 
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW COLUMN 
  /COUNT ROUND CELL.

* *Social influences.
FREQUENCIES VARIABLES=  SI1_UTAUT SI2_UTAUT Beliefs_civicduty Beliefs_AppAdoption
 /ORDER=ANALYSIS.

CROSSTABS
  /TABLES= SI1_UTAUT SI2_UTAUT Beliefs_civicduty Beliefs_AppAdoption BY Behavior_UTAUT
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW COLUMN 
  /COUNT ROUND CELL.

CROSSTABS
  /TABLES= SI1_UTAUT SI2_UTAUT Beliefs_civicduty Beliefs_AppAdoption BY user_status_intention 
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW COLUMN 
  /COUNT ROUND CELL.

* Privacy and data safety. 
FREQUENCIES VARIABLES=  Beliefs_datasafety Beliefs_locationmonitoring Beliefs_identitymonitoring Beliefs_surveillancestate1 Beliefs_surveillancestate2
 /ORDER=ANALYSIS.

CROSSTABS
  /TABLES= Beliefs_datasafety Beliefs_locationmonitoring Beliefs_identitymonitoring Beliefs_surveillancestate1 Beliefs_surveillancestate2 BY Behavior_UTAUT
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW COLUMN 
  /COUNT ROUND CELL.

CROSSTABS
  /TABLES= Beliefs_datasafety Beliefs_locationmonitoring Beliefs_identitymonitoring Beliefs_surveillancestate1 Beliefs_surveillancestate2 BY user_status_intention 
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW COLUMN 
  /COUNT ROUND CELL.

* Effects
* Notifications.
FREQUENCIES VARIABLES=  notifications_1
 /ORDER=ANALYSIS.

* Intention to adhere with and without symptoms.
FREQUENCIES VARIABLES=  AdherenceNotificationMeasuresNosymptoms_Quarantaine AdherenceNotificationMeasuresNoSymptoms_Visits AdherenceNotificationMeasuresSymptoms_Quarantaine AdherenceNotificationMeasuresSymptoms_Visits 
 /ORDER=ANALYSIS.

* Intention to adhere with and without symptoms.
FREQUENCIES VARIABLES=  AdherenceNotificationMeasuresNoSymptoms_Visits  
 /ORDER=ANALYSIS.

* Same but only for the current users. 
USE ALL.
COMPUTE filter_$=( ~ SYSMIS(duur)  & (Behavior_UTAUT = 1)).
VARIABLE LABELS filter_$ ' ~ SYSMIS(duur)  & (Behavior_UTAUT ~= 2) (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.
FREQUENCIES VARIABLES=  AdherenceNotificationMeasuresNosymptoms_Quarantaine AdherenceNotificationMeasuresNoSymptoms_Visits AdherenceNotificationMeasuresSymptoms_Quarantaine AdherenceNotificationMeasuresSymptoms_Visits 
 /ORDER=ANALYSIS.

* Explaining variables for intention to adherence to advices in notification. 
* Use all 1900 again. 
USE ALL.
COMPUTE filter_$=( ~ SYSMIS(duur)).
VARIABLE LABELS filter_$ ' ~ SYSMIS(duur) (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.
FREQUENCIES VARIABLES=  HBM_selfefficacy_Test HBM_selfefficacy_Quarantaine HBM_perceivedbenefits_Test HBM_barriers_GP
 /ORDER=ANALYSIS.

* Feeling pressured to adhere to advices. 
FREQUENCIES VARIABLES=  AdherenceNotification_voluntariness1 AdherenceNotification_voluntariness2 AdherenceNotification_AffectAnger AdherenceNotification_AffectIrritation
 /ORDER=ANALYSIS.

* Intention to share GGD keys.
FREQUENCIES VARIABLES=  Intention_reportinfection
 /ORDER=ANALYSIS.

* Same but only for the current users. 
USE ALL.
COMPUTE filter_$=( ~ SYSMIS(duur)  & (Behavior_UTAUT = 1)).
VARIABLE LABELS filter_$ ' ~ SYSMIS(duur)  & (Behavior_UTAUT ~= 2) (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.
FREQUENCIES VARIABLES=   Intention_reportinfection 
 /ORDER=ANALYSIS.

* False security
* Use all 1900 again. 
USE ALL.
COMPUTE filter_$=( ~ SYSMIS(duur)).
VARIABLE LABELS filter_$ ' ~ SYSMIS(duur) (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.
FREQUENCIES VARIABLES=  Beliefs_falsesecurity1 Beliefs_falsesecurity2
 /ORDER=ANALYSIS.

* Check of intention to test with symptoms: with versus without a notification: Only in current users. 
USE ALL.
COMPUTE filter_$=( ~ SYSMIS(duur)  & (Behavior_UTAUT = 1)).
VARIABLE LABELS filter_$ ' ~ SYSMIS(duur)  & (Behavior_UTAUT ~= 2) (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

CROSSTABS
  /TABLES= Intention_AdherenceGeneralMeasures_testwithsymptoms BY AdherenceNotificationMeasuresSymptoms_Test
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT 
  /COUNT ROUND CELL.

