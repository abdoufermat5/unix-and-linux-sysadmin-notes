#!/usr/bin/awk -f 

BEGIN {
    # set the input and output field separators
    FS=":"
    OFS=":"
    # zero the accounts counter
    accounts=0
}
{
    # set field 2 to nothing
    $2=""
    # print the entire line 
    print $0
    # increment the accounts counter
    accounts++
}

END {
    # print the results
    print accounts " accounts.\n"
}