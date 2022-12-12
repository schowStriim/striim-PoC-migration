# Striim PoC migration repository
This repository provides instructions on how to create a basic Striim Poc (Proof of Concept) and instructions on when to run the initial load and CDC pipelines.

## Pre-requisites
1) Striim server is up and running.
   - More info: https://github.com/schowStriim/striim-installs
2) Striim server is in the same region/account as the target database.
3) Striim server can communicate with the source and target database.
4) striim-PoC-migration repo is cloned in the striim server's home directory.
5) Familiarity of Striim initial load vs Change-Data-Capture (CDC).
   - More info:
      - Initial Load vs CDC: https://www.striim.com/docs/en/initial-load-versus-continuous-replication.html
      - Change-Data-Capture (CDC): https://www.striim.com/docs/en/what-is-change-data-capture-.html
      - CDC examples: https://www.striim.com/docs/en/sql-cdc-replication-examples.html

## Schema & Table set up process:
1) Navigate to **/<striim-home>/striim-PoC-migration/table-build/** directory.
2) Select your database sql file to create the PoC schema and table in your **source development database**.
   - For example: If you want to migrate an Oracle database to the cloud, please select oracle.sql
3) Access to your development source database.
4) Execute the sql file selected on the previous step to create the Striim PoC source schema and table.
5) Select your database sql file to create the PoC schema and table in your **target development database**.
   - For example: If you want to migrate an Oracle database to GCP Big Query, please select bigquery.sql
6) Access to your target development database.
7) Execute the sql file selected on the previous step to create the Striim PoC target schema and table.

## CDC configuration:
1) Access to your development source database.
2) Follow the instructions in this link to enable CDC: https://www.striim.com/docs/en/change-data-capture--cdc-.html
   - For example: To enable Oracle CDC:
                     1) Navigate to the link above.
                     2) Scroll down and click on "Oracle Reader" to view the supported Oracle versions.
                     3) Scroll down and click on "Configuring Oracle to use Oracle Reader" to enable CDC in your oracle database and create a user with all the privileges.
3) Retrieve the LSN/Timestamp/SCN value from your source database: https://www.striim.com/docs/en/switching-from-initial-load-to-continuous- replication.html
4) For future use, store the LSN/Timestamp/SCN value in a secure location. We are preserving this value in order to record all of the changes made throughout the initial load process.


