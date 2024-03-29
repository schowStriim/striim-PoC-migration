# Striim PoC migration repository
This repository provides instructions on how to create a basic Striim test database migration, or Poc (Proof of Concept) and instructions on when to run the initial load and CDC pipelines.

## Pre-requisites
1) Striim server is up and running (we suggest deploying Striim in the same region/cloud account as the target database).
   - More info: https://github.com/schowStriim/striim-installs
2) Striim server can connect to the source and target database.
3) striim-PoC-migration repo is cloned in the Striim server's home directory.
4) General familiarity of database migrations, and the difference between  initial load and Change Data Capture (CDC).
   - More info:
      - Change-Data-Capture (CDC): https://www.striim.com/docs/en/what-is-change-data-capture-.html
      - Initial Load vs CDC: https://www.striim.com/docs/en/initial-load-versus-continuous-replication.html
      - CDC examples: https://www.striim.com/docs/en/sql-cdc-replication-examples.html

## Schema & Table set up process:
If you’re using your own sample dataset, proceed to the CDC configuration. Otherwise, follow these steps to create a small test table to migrate to the target system.
1) Navigate to ./striim-PoC-migration/table-build/ directory.
2) Select your database sql file to create the PoC schema and table in your source development database.
   - For example: If you want to migrate an Oracle database to the cloud, please select oracle.sql
3) Log in to your development source database.
4) Execute the sql file selected on the previous step to create the Striim PoC source schema and table.
5) Navigate to ./striim-PoC-migration/initial_load_data/ directory.
6) Select your database sql file to ingest some data to the source table that was created in step #4.
7) Select your database sql file to create the PoC schema and table in your target development database.
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
   - (PostgreSQL Only) Execute this query to create a replication slot: `SELECT pg_create_logical_replication_slot('striim_slot', 'wal2json');`
      - Verify it was created by running this query: `SELECT * FROM pg_replication_slots;`
3) Retrieve the LSN/Timestamp/SCN value from your source database: https://www.striim.com/docs/en/switching-from-initial-load-to-continuous-replication.html
4) For future use, store the LSN/Timestamp/SCN value in a secure location. We are preserving this value in order to record all of the changes made throughout the initial load process.

## Create Initial Load application in Striim:
1. Log in to Striim UI.
2. Select Apps tab.
3. Click "Create app" button on the right corner.
4. Select "Start from scratch".
5. Give a name to the new application. For example: striim_poc_app_initial_load.
6. In the "Components" left menu, type in "Database" and drag and drop the Database Reader component to the middle.
   * More info: https://www.striim.com/docs/en/database-reader.html
7. Provide a unique name for the Database Reader component.
8. Provide the connection url in JDBC format in the connection url property.
   * Note: The database name you specify in the Connection URL is the one where the Striim schema.employee table was initially created in the Schema & Tables set up process.
9. Provide username and password to access the database provided in the Connection URL property.
10. In the Tables property, type in the following: striim_schema.employee
11. In the Fetch Size property, set it to 10000.
12. In the Advanced Settings, click the Quiesce on IL toggle to true, to automatically stop the Initial Load application once it’s complete.
13. Create a new output by typing an output/stream name.
14. Scroll down and click on "Save".
15. Click on the wave icon and then the plus sign.
16. Click on "Connect next Target component".
17. Provide a unique name in the Name property.
18. Make sure the Input Stream name is the same as the name provided in step #11.
19. Select "DatabaseWriter" in the adapter property.
20. Provide the connection url in JDBC format in the connection url property.
   * Note: The database name you specify in the Connection URL is the one where the Striim schema.employee table was initially created in the Schema & Tables set up process.
21. Provide a username and password to access the database provided in the Connection URL property.
22. If your source is NOT SQL Server, in the Tables property, type in the following: striim_schema.employee,striim_schema.employee
   * Note that this is different than the source component’s tables property, since Striim needs to know which source table to map to which target table.
23. If your source is a SQL Server database, in the Tables property type in
   * striim_schema.employee,<SourceDatabaseName>.striim_schema.employee
24. In the Batch and Commit Policy properties, type in the following: EventCount:10000,Interval:60
   * Note: This means that Striim will wait for 10,000 events, or 60 seconds before writing out to the target system - whichever happens first. For your initial migration, the values from the above Batch and Commit Policy are a good place to start, but this is entirely dependent on the specific environment and typically varies depending on the size of the source database and the Striim server. If the test data set you’re using has less than 10,000 events, it will be 60 seconds before the data will arrive on the target.
25. In the Parallel Threads property, type in the following value: 10
   * Note: This value can be higher or lower depending on the size of the Striim server, but may not exceed the number of physical cores of the VM Striim is running on across all applications.
26. Scroll down and click on "Save".
27. **IMPORTANT:** You must disable foreign keys contraints and triggers before running the initial load.
28. Click on the "Created" dropdown on the top, click "Deploy App", "Deploy", and then "Start App".
29. Wait until the Initial Load application is in COMPLETED state.
30. In your target database, run a SELECT COUNT(*) FROM striim_schema.employee; query to verify that the total count matches with the count on your source database/table.

## Create CDC application in Striim:
1. Navigate to Apps -> Create Apps -> Start from Scratch again.
2. Give a name to the new CDC application. For example: striim_poc_app_cdc.
3. In the "Components" left menu, type in the source database. For example: Oracle
4. Select " CDC". For example: PostreSQL CDC
5. Drag and drop the CDC component to the middle.
6. Provide a unique name for the CDC component.
7. Provide the connection url in JDBC format in the connection url property.
   * Note: The database name you specify in the Connection URL is the one where the Striim schema.employee table was initially created in the Schema & Tables set up process.
8. Provide a username and password to access the database provided in the Connection URL property.
9. In the Tables property, type in the following: striim_schema.employee
10. (Optional) In the Start Timestamp/Start LSN/START SCN property, type in the value you saved in step #4 from the CDC Configuration section.
11. (PostgreSQL Only) In the Replication Slot property, pass in 'striim_slot'.
   * Note: this is the replication slot that we created in the CDC Configuration section.
12. Create a new output by typing an output/stream name.
13. Scroll down and click on "Save".
14. Click on the wave icon and then the plus sign.
15. Click on "Connect next Target component".
16. Provide a unique name in the Name property.
17. Make sure the Input Stream name is the same as the name provided in step #11.
18. Select "DatabaseWriter" in the adapter property.
19. Provide the connection url in JDBC format in the connection url property.
   * Note: The database name you specify in the Connection URL is the one where the Striim schema.employee table was initially created in the Schema & Tables set up process.
20. Provide a username and password to access the database provided in the Connection URL property.
21. In the Tables property, type in the following: striim_schema.employee,striim_schema.employee
22. In the Ignorable Exception Code property, provide the following: DUPLICATE_ROW_EXISTS, NO_OP_UPDATE, NO_OP_DELETE
23. Scroll down and click on "Save".
24. Enable Auto-Recovery mode by selecting -> "App Settings" -> Set a numeric value in the "Interval" property -> Click on "Save".
25. Click on the "Created" dropdown on the top, click "Deploy App", "Deploy", and then "Start App".
26. **IMPORTANT:** After the CDC is all caught up, we can undeploy the CDC app, remove the code in the Ignorable Code Exception and Re-enable all contraints and triggers.

## Test CDC Application:
1. Verify the Striim CDC application is in Running state.
2. Navigate to /striim-PoC-migration/cdc_data/.
3. Execute < database >/< database >_insert.sql.
4. Go to the Striim CDC application and verify that the Total Input count is the same as the Total Output count.
5. Execute `SELECT COUNT(*) FROM striim_schema.employee;` on both target and source database and verify that the value matches with the total count.
6. Execute < database >/< database >_update.sql.
7. Go to CDC Striim application and verify that the Total Input count is the same as the Total Output count.
8. Execute `SELECT COUNT(*) FROM striim_schema.employee;` on both target and source database and verify that the value matches with the total count.
9. Execute < database >/< database >_delete.sql.
10. Go to CDC Striim application and verify that the Total Input count is the same as the Total Output count.
11. Execute `SELECT COUNT(*) FROM striim_schema.employee;` on both target and source database and verify that the value matches with the total count.

## Execute your own test migration:
1. With this test migration complete, you can proceed with your own test dataset.
2. The initial load and CDC applications can be reused, just modify the source/target JDBC connection URLs, the associated table properties, and the Batch/Commit Policies for your use case.
3. Explore the Monitor page to monitor the applications in more detail, Alert Manager to create custom alerts, or even use the console to execute additional commands: https://www.striim.com/docs/en/console-commands.html.
