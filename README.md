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
