#!/bin/bash

#############
## No return message means everything is fine
##
#############

while getopts f:s:l: flag
do
    case "${flag}" in
        f) file=${OPTARG};;
        s) shape=${OPTARG};;
        l) severity=${OPTARG};;  # not used right now
    esac
done

# fail if any other exit status than 0
set -e

# make path absolute if no absolute path is given
# docker does not like relative paths
if [[ ! "$file" = /* ]]; 
then
    file="$(pwd)/$file"
fi

# check file is not empty
test $(wc -l $file | awk '{print $1}') -gt 0 || (echo "file has no lines, aborting"; exit 1)

docker run --rm -v $(pwd)/$shape:/rdf/shape.ttl -v $file:/rdf/file.ttl skohub/jena:4.6.1 shacl v -s /rdf/shape.ttl -d /rdf/file.ttl > $(pwd)/result.ttl

if [[ $severity == "warning" ]]
then
    SEVERITY_FILE="$(pwd)/scripts/checkForWarning.rq"
elif [[ $severity == "both" ]]
then
    SEVERITY_FILE="$(pwd)/scripts/checkForBoth.rq"
else 
    SEVERITY_FILE="$(pwd)/scripts/checkForViolation.rq"
fi

validationResult="$(docker run --rm -v $SEVERITY_FILE:/rdf/check.rq --mount type=bind,source=$(pwd)/result.ttl,target=/rdf/result.ttl skohub/jena:4.6.1 arq --data /rdf/result.ttl --query /rdf/check.rq)"

lines=$(echo "$validationResult" | wc -l )

# an empty result, i.e. a correct validation has 4 lines of output
test ${lines} -eq 4 || (>&2 echo "validation errors, check output" ; >&2 echo "$validationResult"; exit 1)
exit 0