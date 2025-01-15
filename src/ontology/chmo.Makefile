## Customize Makefile settings for chmo
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

## Module for ontology: ms
# Using ROBOT extract MIREOT here, as CHMO only reuses one class from MS

$(IMPORTDIR)/ms_import.owl: $(MIRRORDIR)/ms.owl $(IMPORTDIR)/ms_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		extract -T $(IMPORTDIR)/ms_terms_combined.txt --copy-ontology-annotations true --force true \
		--upper-terms $(IMPORTDIR)/ms_terms_combined.txt --lower-terms $(IMPORTDIR)/ms_terms_combined.txt \
		--individuals include --method MIREOT \
		query --update ../sparql/inject-subset-declaration.ru --update ../sparql/inject-synonymtype-declaration.ru --update ../sparql/postprocess-module.ru \
		$(ANNOTATE_CONVERT_FILE); fi