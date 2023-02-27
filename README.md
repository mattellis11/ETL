# Linux Semester Project - ETL Engine

### Introduction

In this project, you will do work similar to an ETL engine using Linux tools and utilities. All of the
following should be automated with one driving bash script that runs each step or multiple steps
- This is a comprehensive project, you will use what you have learned through the semester to
complete it.
- Use a variety of different Linux utilities/filters to accomplish the tasks (tr, awk, sed, bash, sort, cut,
etc). You may only use standard Linux utilities covered in this class.
Do not use programming languages we have not covered in class (python, perl, ruby, etc), this will result in a zero for this project. Try not to use the same utility/program to solve each problem, but a variety of different utilities. However, use the program that makes the most sense for your problem. For example, awk is a good utility for reports and a good candidate for several other steps as well.
- Each numbered step should be written as a separate script or tool within your script. In other words do not write one big piped program to perform all the steps. The goal is to have separate smaller programs within your script that could be reused later for other ETL problems.
- The script should trap reasonable errors and print useful error messages to help the user resolve
problems.
- The script should print messages to standard output to indicate which steps of the ETL process have been completed.
- If no parameters are passed to your script, it should print a usage statement that makes it easy for the user to figure out how to run the script.
- The bash script should accept parameters for the following:
– Remote file transfer parameters
- ($1) remote-server: server name or IP address.
- ($2) remove-userid: userid to login to the remote machine (assume you are using ssh keys so
that a password is not required).
- ($3) remote-file: full path to the remote file on the remote server.

### Project Details

Your ETL script (etl.sh) should execute scripts or Linux utilities that perform ALL of the following steps.
<p>1. Transfer the source file using the scp command to your project directory.
<ul>
<li>The scp command should accept the remote-server, remote-usrid, and remote-file variables
as arguments for its required input.</li>
<li>The source file contains fields (customer id, first name, last name, email, gender, purchase amount, credit card, transaction id, transaction date, street, city, state, zip, phone)</li>
<li>Refer to the source files header for the definitive format.</li>
<li>The source file will be refereed to as the transaction file from this point forward and should be
named so in your code.</li>
</ul>
<p>2. Unzip the transaction file.
<p>3. Remove the header record from the transaction file.
<p>4. Convert all text in the transaction file to lower case.
<p>5. The ”gender” field has values ”f”, ”m”, “female”, “male”, ”1”, ”0” - convert them as follows
<ul>
<li>”1” to ”f”</li>
<li>”0” to ”m”</li>
<li>“male” to “m”</li>
<li>“female” to “f”</li>
<li>“u” in fields that do not have a valid value in them</li>
<li>The Gender field should ONLY have “m”,”f”,or “u” after this step</li>
</ul>
<p>6. Filter all records out of the transaction file from the “state” field that do not have a state or contain “NA”. Place these records in an exceptions file named exceptions.csv.
NOTE: These exceptions should no longer be located in the transaction file.
<p>7. Remove the $ sign in the transaction file from the purchase amt field.
<p>8. Sort transaction file by customerID. The format of the transaction file should not change. Only the sort order should be different. The final transaction file should be named transaction.csv.
<p>9. Generate a summary file using the transaction.csv file. Accumulate the total purchase amount for each ”customerID” and produce a new file with a single record per customerID and the total amount over all records for that customer. Use commas as your field delimiter.

(a) The fields in this file should be in this order
<ol><li>customerID</li>
<li>state</li>
<li>zip</li>
<li>lastname</li>
<li>firstname</li>
<li>total purchase amount</ol>
<p>Make sure you use non-blank fields for the summary record when they are available. This is your
summary file.

(b) Sort the summary file based upon (be careful with this step, the key to this is the sort order
“priority”)
<ol><li>state</li>
<li>zip (decending order)</li>
<li>lastname</li>
<li>firstname</li></ol>
<p>Keep the file format the same as specified in step 9(a). Only the sort order should be different.
<p>The final summary file should be named summary.csv.

<p>10. After executing your script all intermediate working files should be removed. The only files remaining should be the final transaction.csv, and summary.csv, exception.csv files. These files should NOT be deleted if the scripts exits with an error.

### Usage
Usage: ./etl.sh [Server IP Address] [Server User ID] [Full-Path Of Source File]
