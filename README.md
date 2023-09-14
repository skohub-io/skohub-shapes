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

To validate with the help of a docker container, you can run the following (run from current directory or adjust the respective paths to shape and your file):

`docker run --rm -v $(pwd)/skos.shacl.ttl:/rdf/shape.ttl -v $(pwd)/YOUR_SKOS_FILE.ttl:/rdf/file.ttl skohub/jena:4.6.1 shacl v -s /rdf/shape.ttl -d /rdf/file.ttl`

## Checked Constraints

[S13](https://www.w3.org/TR/skos-reference/#L1567): skos:prefLabel, skos:altLabel and skos:hiddenLabel are pairwise disjoint properties.
[S14]https://www.w3.org/TR/skos-reference/#L1567: A resource has no more than one value of skos:prefLabel per language tag.

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
