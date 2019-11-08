# Pathway-Explorer
Create a systemic approach for visualizing pathways by mapping patients’ journey through the hospital and critical points of care.  This tool would help us explore the observable deviations within pathways in order to model potential future states. It would also allow us to understand the actual scope of variation in expected outcomes or within pathways, and provide evidence to improve patients care.



# File Descriptions

Pathway Explorer Test App.R
  Where the working version of the scipt for our test app can be found.
 
Base DM for Pathway Explorer .sql
  Base SQL data model for elective activity, CPGs and non patients. Includes all fields that might be relevant to this work. 
  
Event Log for BuparR - Elective.sql
  Data that feeds into the app -- this is derived from the Base DM, and transformed into event log format to work with bupaR

BupaR Elective CPG to OPA .R
  This file includes the R script where we worked on bupaR process maps for elective activity prior to building the shiny app. 


  
