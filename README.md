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
      - Change-Data-Capture (CDC): https://www.striim.com/docs/en/what-is-change-data-capture-.html
      - Initial Load vs CDC: https://www.striim.com/docs/en/initial-load-versus-continuous-replication.html
      - CDC examples: https://www.striim.com/docs/en/sql-cdc-replication-examples.html

## Schema & Table set up process:
1) Navigate to **<striim-home>/striim-PoC-migration/table-build/** directory.
2) Select your database sql file to create the PoC schema and table in your **source development database**.
   - For example: If you want to migrate an Oracle database to the cloud, please select oracle.sql
3) Log in to your development source database.
4) Execute the sql file selected on the previous step to create the Striim PoC source schema and table.
5) Navigate to **<striim-home>/striim-PoC-migration/initial_load_data/** directory.
6) Select your database sql file to ingest some data to the source table that was created in step #4.
7) Select your database sql file to create the PoC schema and table in your **target development database**.
   - For example: If you want to migrate an Oracle database to GCP Big Query, please select bigquery.sql
8) Log in to your target development database.
9) Execute the sql file selected on the previous step to create the Striim PoC target schema and table.

## CDC configuration:
1) Log in to your development source database.
2) Follow the instructions in this link to enable CDC: https://www.striim.com/docs/en/change-data-capture--cdc-.html
   - For example: To enable Oracle CDC:
     - Navigate to the link above.
     - Scroll down and click on "Oracle Reader" to view the supported Oracle versions.
     - Scroll down and click on "Configuring Oracle to use Oracle Reader" to enable CDC in your oracle database and create a user with all the privileges.
3) Retrieve the LSN/Timestamp/SCN value from your source database: https://www.striim.com/docs/en/switching-from-initial-load-to-continuous- replication.html
4) For future use, store the LSN/Timestamp/SCN value in a secure location. We are preserving this value in order to record all of the changes made throughout the initial load process.
5) (PostgreSQL Only) Execute this query to create a replication slot: `SELECT pg_create_logical_replication_slot('striim_slot', 'wal2json');`
   - Verify it was created by running this query: `SELECT * FROM pg_replication_slots;`

## Create Initial Load application in Striim:
1) Log in to Striim UI.
2) Select Apps tab.
3) Click on "Create app" button on the right corner.
4) Select "Start from scratch".
5) Give a name to the new application. For example: striim_poc_app_initial_load.
6) In the "Components" left menu, type in "Database" and drag and drop the Database component to the middle.
   - More info: https://www.striim.com/docs/en/database-reader.html
7) Provide a unique name for the Database Reader component.
8) Provide the connection url in JDBC format in the connection url property.
   - Note: The database name you specify in the Connection URL is the one where the striim schema.employee table was initially created in the **Schema & Tables set up process**.
9) Provide username and password to access the database provided in the Connection URL property.
10) In the Tables property, type in the following: striim_schema.employee
11) In the Fetch Size property, set it to 10000.
12) Create a new output by typing an output/stream name.
13) Scroll down and click on "Save".
14) Click on the wave icon and then the plus sign.
15) Click on "Connect next Target component".
16) Provide a unique name in the Name property.
17) Make sure the Input Stream name is the same as the name provided in step #11.
18) Select "DatabaseWriter" in the adapter property.
19) Provide the connection url in JDBC format in the connection url property.
    - Note: The database name you specify in the Connection URL is the one where the striim schema.employee table was initially created in the **Schema & Tables set up process**.
20) Provide username and password to access the database provided in the Connection URL property.
21) In the Tables property, type in the following: striim_schema.employee,striim_schema.employee
22) In the Batch and Commit Policy properties, type in the following: EventCount:10000,Interval:60
    - Note: For your initial migration, the values from the above Batch and Commit Policy are a good place to start, but this is entirely dependent on the specific environment and typically varies depending on the size of the source database and the Striim server.
23) In the Parallel Threads property, type in the following value: 10
    - Note: This value can be higher or lower depending on the size of the Striim server.
24) Scroll down and click on "Save".
25) Click on the "Created" dropdown on the top, click "Deploy App", "Deploy", and then "Start App".
26) Wait until the Initial Load application is in COMPLETED state. 
27) In your target database, run a `SELECT COUNT(*) FROM striim_schema.employee;` query to verify that the total count matches with the count on your source database/table.

## Create CDC application in Striim:
1) Navigate to Apps -> Create Apps -> Start from Scratch again.
2) Give a name to the new CDC application. For example: striim_poc_app_cdc.
3) In the "Components" left menu, type in the source database. For example: Oracle
4) Select "<database> CDC". For example: PostreSQL CDC
5) Drag and drop the Database component to the middle.
6) Provide a unique name for the CDC component.
7) Provide the connection url in JDBC format in the connection url property.
   - Note: The database name you specify in the Connection URL is the one where the striim schema.employee table was initially created in the **Schema & Tables set up process**.
8) Provide username and password to access the database provided in the Connection URL property.
9) In the Tables property, type in the following: striim_schema.employee
10) In the Fetch Size property, set it to 10000.
11) (Optional) In the Start Timestamp/Start LSN/START SCN property, type in the value you saved in step #4 from the **CDC Configuration** section.
12) (PostgreSQL Only) In the Replication Slot property, pass in 'striim_slot'.
     - Note: this is the replication slot that we created in step #5 from the **CDC Configuration** section.
13) Create a new output by typing an output/stream name.
14) Scroll down and click on "Save".
15) Click on the wave icon and then the plus sign.
16) Click on "Connect next Target component".
17) Provide a unique name in the Name property.
18) Make sure the Input Stream name is the same as the name provided in step #11.
19) Select "DatabaseWriter" in the adapter property.
20) Provide the connection url in JDBC format in the connection url property.
    - Note: The database name you specify in the Connection URL is the one where the striim schema.employee table was initially created in the **Schema & Tables set up process**.
21) Provide username and password to access the database provided in the Connection URL property.
22) In the Tables property, type in the following: striim_schema.employee,striim_schema.employee
23) In the Batch and Commit Policy properties, type in the following: EventCount:10000,Interval:60
    - Note: For your initial migration, the values from the above Batch and Commit Policy are a good place to start, but this is entirely dependent on the specific environment and typically varies depending on the size of the source database and the Striim server.
24) Scroll down and click on "Save".
25) Click on the "Created" dropdown on the top, click "Deploy App", "Deploy", and then "Start App".

## Test CDC Application:
1) Verify the Striim CDC application is in Running state.
2) Navigate to **<striim-home>/striim-PoC-migration/cdc_data/**.
3) Execute < database >_insert.sql.
4) Go to CDC Striim application and verify that the Total Input count is the same as the Total Output count.
5) Execute `SELECT COUNT(*) FROM striim_schema.employee;` on both target and source database and verify that the value matches with the total count.
6) Execute < database >_update.sql.
7) Go to CDC Striim application and verify that the Total Input count is the same as the Total Output count.
8) Execute `SELECT COUNT(*) FROM striim_schema.employee;` on both target and source database and verify that the value matches with the total count.
9) Execute < database >_delete.sql.
10) Go to CDC Striim application and verify that the Total Input count is the same as the Total Output count.
11) Execute `SELECT COUNT(*) FROM striim_schema.employee;` on both target and source database and verify that the value matches with the total count.
