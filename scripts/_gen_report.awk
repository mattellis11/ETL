BEGIN {
    FS=","
    OFS=","
    # declare variables
    customer_id=""
    state=""
    zip=""
    last_name=""
    first_name=""
}
{
    if (NR == 1) {
        customer_id=$1
        state=$12
        zip=$13
        last_name=$3
        first_name=$2
        arr_total_purchase[$1]=$6
    }
    else {
        if ( $1 != customer_id) { # true when line is a new customer
            # print previous customer info to report
            printf "%s,%s,%s,%s,%s,%.2f\n",customer_id,state,zip,last_name,first_name,arr_total_purchase[customer_id] > "summary.tmp"

            # assign new customer info to variables
            customer_id=$1
            state=$12
            zip=$13
            last_name=$3
            first_name=$2
            arr_total_purchase[$1]=$6
        }
        else { # true when processing another transaction from the same customer
            # add this transaction amount to the total purchase amount
            arr_total_purchase[customer_id]+=$6
        }
    }
}