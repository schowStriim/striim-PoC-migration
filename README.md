# Striim PoC migration repository
This repository provides instructions on how to create a basic Striim Poc (Proof of Concept) and instructions on when to run the initial load and CDC pipelines.

## Pre-requisites
1) Striim server is up and running.
   - More info: https://github.com/schowStriim/striim-installs
2) Striim server is in the same region/account as the target database.
3) Striim server can communicate with the source and target database.
4) striim-PoC-migration repo is cloned in the striim server's home directory. 

## Schema & Table set up process:
1) Navigate to striim-PoC-migration/table-build/ directory.
2) Select your database sql file to create the PoC schema and table in your **source development database**.
   - For example: If you want to migrate an Oracle database to the cloud, please select oracle.sql
3) Access to your development source database.
4) Execute the sql file selected on the previous step to create the Striim PoC source schema and table.
5) Select your database sql file to create the PoC schema and table in your **target development database**.
   - For example: If you want to migrate an Oracle database to GCP Big Query, please select bigquery.sql
6) Access to your target development database.
7) Execute the sql file selected on the previous step to create the Striim PoC target schema and table.
