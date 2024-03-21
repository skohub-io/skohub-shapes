# Shape Repository For SkoHub

This is a repository for [SHACL](https://www.w3.org/TR/shacl/) shapes used in SkoHub modules.

## Shapes

### `skos.shacl.ttl`

*this is just a first draft, comments are very welcome*

This shape is inspired by and borrows heavily from the SKOS-XL shape definition from [EU Vocabularies](https://op.europa.eu/fr/web/eu-vocabularies/application-profiles).

Most adjustments were made regarding correcting syntax and pulling out the SPARQL-based constraints into dedicated shapes.
At least with [Apache Jena SHACL](https://jena.apache.org/documentation/shacl/index.html) and [pySHACL](https://github.com/RDFLib/pySHACL) I got lots of different error messages when trying to use the shape as it is.

If you take our [template repo](https://github.com/skohub-io/vocab-template) as a starting point the validation against this shape is already built in.

## Check with Apache Jena SHACL

To use this shape with [Apache Jena](https://jena.apache.org/download/index.cgi) SHACL validate your file with `shacl validate --shapes skos.shacl.ttl --data YOUR-DATA.ttl`

## Check with Docker

To validate with the help of a docker container, you can run the script `scripts/validate-skos`:

    ./scripts/validate-skos YOUR_SKOS_FILE_TTL

Call with `-h` or without arguments to list options.

## Add Validation in a vocabulary repository

Adding the following GitHub Action to a repository (add a `.github/workflows/main.yaml` file), will validate your vocabulary against the [SkoHub Shape](./skohub.shacl.ttl).
Notice that, when the action is triggered, you will get an error shown in GitHub not only for violations but also for warnings. That is because GitHub Actions either pass or fail.


```yaml
name: Validate TTL Files

on: [push]

jobs:
  check-for-warnings:
    name: Check for Warnings
    runs-on: ubuntu-latest
    steps:
    - name: Checkout repository
      uses: actions/checkout@v3

    - name: Check for Warnings
      run: |
        curl -s https://raw.githubusercontent.com/skohub-io/shapes/main/scripts/checkForWarning.rq >> checkForWarning.rq
        find . -type f -name '*.ttl' | while read file; do
          # Adjust the file path to remove the './' part
          adjusted_file_path=$(echo "$file" | sed 's|^./||')
          echo "Processing $adjusted_file_path with Docker..."
          docker run --rm -v "$(pwd)/$adjusted_file_path:/rdf/test.ttl" skohub/jena:4.6.1 shacl validate --shapes https://raw.githubusercontent.com/skohub-io/shapes/main/skohub.shacl.ttl --data /rdf/test.ttl >> result.ttl
          validation_result="$(docker run --rm --mount type=bind,source=./checkForWarning.rq,target=/rdf/checkForViolation.rq --mount type=bind,source=./result.ttl,target=/rdf/result.ttl skohub/jena:4.6.1 arq --data /rdf/result.ttl --query /rdf/checkForViolation.rq)"
          echo $validation_result
          lines=$(echo "$validation_result" | wc -l )
          # Correct validation has 4 lines of output
          [[ ${lines} -eq 4 ]] || exit 1
        done

  check-for-errors:
    name: Check for Errors
    runs-on: ubuntu-latest
    steps:
    - name: Checkout repository
      uses: actions/checkout@v3

    - name: Check for Errors
      run: |
        curl -s https://raw.githubusercontent.com/skohub-io/shapes/main/scripts/checkForViolation.rq >> checkForViolation.rq
        find . -type f -name '*.ttl' | while read file; do
          # Adjust the file path to remove the './' part
          adjusted_file_path=$(echo "$file" | sed 's|^./||')
          echo "Processing $adjusted_file_path with Docker..."
          docker run --rm -v "$(pwd)/$adjusted_file_path:/rdf/test.ttl" skohub/jena:4.6.1 shacl validate --shapes https://raw.githubusercontent.com/skohub-io/shapes/main/skohub.shacl.ttl --data /rdf/test.ttl >> result.ttl
          validation_result="$(docker run --rm --mount type=bind,source=./checkForViolation.rq,target=/rdf/checkForViolation.rq --mount type=bind,source=./result.ttl,target=/rdf/result.ttl skohub/jena:4.6.1 arq --data /rdf/result.ttl --query /rdf/checkForViolation.rq)"
          echo $validation_result
          lines=$(echo "$validation_result" | wc -l )
          # Correct validation has 4 lines of output
          [[ ${lines} -eq 4 ]] || exit 1
        done
```

## Checked Constraints

All class and property definitions from the [SKOS reference](https://www.w3.org/TR/skos-reference/) are added in the test files.
All valid and invalid consistency examples are added to the test files.

Integrity conditions are checked by the `skos.shacl.ttl` shape.


## Tests

There is some basis test functionality provided to test the shape.
Currently there are not many tests provided, but the general idea is as follows:
- build a small valid Concept Scheme for a node shape
- build a small invalid Concept Scheme for a node shape
- put these in the appropriate folders under `test/`
- check if it works with [`scripts/test.sh`](scripts/test.sh)

These tests are also run on every push via GitHub Actions.

It is very basic, but works like this:
- all files in the valid folder are run against the shape. If the validation script exits with `exit 1` it returns an error
- all files in the invalid folder are run against the shape. If the validation script exits with `exit 0` it returns an error

Feel free to suggest improvements or add more tests!
