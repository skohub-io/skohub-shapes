# Shape Repository For SkoHub

This is a repository for [SHACL](https://www.w3.org/TR/shacl/) shapes used in SkoHub modules.

## Shapes

### `skos.shacl.ttl`

*this is just a first draft, comments are very welcome*

This shape is inspired by and borrows heavily from the SKOS-XL shape definition from [EU Vocabularies](https://op.europa.eu/fr/web/eu-vocabularies/application-profiles).

Most adjustments were made regarding correcting syntax and pulling out the SPARQL-based constraints into dedicated shapes.
At least with [Apache Jena SHACL](https://jena.apache.org/documentation/shacl/index.html) and [pySHACL](https://github.com/RDFLib/pySHACL) I got lots of different error messages when trying to use the shape as it is.

## Check with Apache Jena SHACL

To use this shape with Apache Jena SHACL validate your file with `shacl validate --shapes skos.shacl.ttl --data YOUR-DATA.ttl`

## Check with Docker

TODO
