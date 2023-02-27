BEGIN { 
    FS = ","
    OFS = ","
}
{
    # Check for valid format(14 fields)
    if (NF != 14) {
        print > "removed.tmp"
        next
    }

    #****************************************************************************************
    # Source file fields
    # 1 customer_id
    # 2 first_name
    # 3 last_name
    # 4 email
    # 5 gender
    # 6 purchase_amount
    # 7 credit_card
    # 8 transaction_id
    # 9 transaction_date
    # 10 street
    # 11 city
    # 12 state
    # 13 zip
    # 14 phone
    #****************************************************************************************

    #****************************************************************************************
    # Standardize the "gender" field: valid cases are "m","f", and "u"
    # Convert:
    #   "1" -> "f"
    #   "0" -> "m"
    #   "male" -> "m"
    #   "female" -> "f"
    #   use the value "u" in fields that have an invalid value
    #****************************************************************************************
    switch ($5) {
        case 0: 
            $5 = "f"; 
            break
        case 1: 
            $5 = "m"; 
            break
        case "female": 
            $5 = "f"; 
            break
        case "male": 
            $5 = "m"; 
            break
        default: 
            $5 = "u";
    }
        
    # remove dollar sign from purchase amount field
    if ($6 ~ /$/) {
        $6 = substr($6,2,length($6))
    }
    
    # clean up state field
    if ( $12 == "na" || $12 == "") {
        print > "exceptions.csv"; # exceptions moved here
    } else {
        print > "02_data_cleaned.tmp" # all cleaned, valid data printed here
    }    
}
END {    
    # system() runs bash commands in the awk script
    system("echo 'Cleaning data...'")
    system("echo '1) Remove entries with invalid format. Move to removed.tmp -- complete.'")
    system("echo '2) Remove header and convert to lower case -- complete.'")
    system("echo '3) Standardize gender field -- complete.'")
    system("echo '4) Clean state field. Exceptions moved to exceptions.csv -- complete.'")
    system("echo '5) Remove dollar sign from purchase amount field -- complete.'")
}