#!/bin/bash
error=false
# for files in tests/valid no output should be given
FILES="$(pwd)/tests/valid/*"
for f in $FILES
do
  echo "Processing $f ..."
  # take action on each file. $f store current file name
  scripts/validate-skos -s skos.shacl.ttl -l all "$f" 2>/dev/null
  if test $? -eq 1; then echo "Error: $f should be valid, but is invalid"; error=true; fi;
done

# for files in tests/invalid output should be received
FILES="$(pwd)/tests/invalid/*"
for f in $FILES
do
  echo "Processing $f ..."
  # validate with script and log error messages to dev null
  scripts/validate-skos -s skos.shacl.ttl -l all "$f" 2>/dev/null
  if test $? -eq 0; then echo "Error: $f should be invalid, but is valid"; error=true; fi
done

if test "$error" = true; 
then 
  echo "There were errors in your tests!"
  exit 1
fi
