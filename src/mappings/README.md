# Semantic Mappings

This repository contains semantic mappings from CHMO terms to several external
vocabularies.

They are encoded in the
[Simple Standard for Sharing Ontological Mappings (SSSOM)](https://mapping-commons.github.io/sssom/dev/),
which tracks the following for each mapping:

1. The author ORCiD identifier
2. The reviewer's ORCiD identifier
3. The way the mapping was created (e.g., `semapv:ManualMappingCuration` means
   that it was a manual mapping)

Further, all mappings were curated by comparing definitions, not just labels.

## Maintenance

SSSOM files can be formatted with:

```console
$ uv tool install sssom-pydantic
$ sssom_pydantic format afo-mappings.sssom.tsv
$ sssom_pydantic format fix-mappings.sssom.tsv
$ sssom_pydantic format rex-mappings.sssom.tsv
$ sssom_pydantic format wikidata-mappings.sssom.tsv
```
