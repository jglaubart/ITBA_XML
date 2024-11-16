#!/bin/bash

# Initial validations: Amount of parameters, parameter in range, congress api set
error=0
if [ $# -ne 1 ]   # only one parameter requested
then
    error=1
elif [[ ! "$1" =~ ^-?[0-9]+$ ]] || [ "$1" -lt 1 ] || [ "$1" -gt 118 ] # parameter must be an integer between 1 and 118 inclusive
then
    error=2
fi

congress_number=$1

#Get your personal key in https://gpo.congress.gov/sign-up/.
# After getting your personal key, set the variable adding de fragment "export $CONGRESS_APPI=personal_key" in your .bashrc file
if [ -z "$CONGRESS_API" ]; then
    echo "Warning: Using default API key."
    error=3
fi

echo "1) Obtaining congress information..."
curl -s -X GET "https://api.congress.gov/v3/congress/${congress_number}?format=xml&api_key=${CONGRESS_API}" \
    -H "accept: application/xml" -o congress_info.xml
if [ $? -ne 0 ]
then
    echo "Error: Failed to obtain congress details"
    exit 1
fi

curl -s -X GET "https://api.congress.gov/v3/member/congress/${congress_number}?format=xml&currentMember=false&limit=500&api_key=${CONGRESS_API}" \
    -H "accept: application/xml" -o congress_members_info.xml
if [ $? -ne 0 ]
then
    echo "Error: Failed to obtain congress members"
    exit 1
fi

echo "2) Extracting congress data..."
java net.sf.saxon.Query extract_congress_data.xq error=$error > congress_data.xml
if [ $? -ne 0 ]
then
    echo "Error: Congress data extraction failed"
    exit 1
fi

echo "3) Generating HTML page..."
java net.sf.saxon.Transform -s:congress_data.xml -xsl:generate_html.xsl -o:congress_page.html
if [ $? -ne 0 ]
then
    echo "Error: Conversion from XML to HTML failed"
    exit 1
fi
if [ $error -eq 0 ]
then
    echo "END: Process finished succesfully"
else
    echo "END: Process finished with error code $error"
fi