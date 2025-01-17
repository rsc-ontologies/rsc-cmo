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

		
## Module for ontology: chebi

# We use ROBOT filter instead of the default ODK ROBOT extract method because the latter pulls in too much from ChEBI.
# Using ROBOT filter like this allows us to only import the terms we need under their very general CHEBI 'root' parents 
# (so far we only use 'molecular entity', 'atom' and 'chemical substance').
# We remove 'chemical entity' as main 'root' parent, as this grouping is not really needed and since it would clash 
# with the subsumption of 'molecular entity' as a child of BFO:'material entity' as defined in the OBI import module, 
# The root classes 'chemical substance' & 'atom' are declared a subclassOf BFO:'material entity' in chmo-edit.owl.
# This ROBOT filter approach entails, that not all axioms of the imported terms are imported as well, 
# e.g. currently only 'part of' relations between the terms specified in the chebi_import.txt are imported. 
# If other axioms are needed in the future the CHMO editors need to make sure to include the needed object properties 
# and classes used in these, which is quite a time consuming task, but needed, as ROBOT extract pulls in too much 
# and the CHEBI module would otherwise be too big to load. 
 
$(IMPORTDIR)/chebi_import.owl: $(MIRRORDIR)/chebi.owl $(IMPORTDIR)/chebi_terms_combined.txt
	if [ $(IMP) = true ] && [ $(IMP_LARGE) = true ]; then $(ROBOT) \
	    filter -i $< -T $(IMPORTDIR)/chebi_terms_combined.txt --signature true --select "annotations self" \
	        --exclude-term http://purl.obolibrary.org/obo/CHEBI_24431 \
	        --exclude-term http://purl.obolibrary.org/obo/CHEBI_36342 \
		query --update ../sparql/inject-subset-declaration.ru --update ../sparql/inject-synonymtype-declaration.ru \
		    --update ../sparql/postprocess-module.ru \
		$(ANNOTATE_CONVERT_FILE); fi
		
		
## Module for ontology: obi
## We need to use the ODK default ROBOT 'extract' method plus 'filter' in here to remove out-of-scope terms that 
## get also pulled in. And we remove the NCBITaxon intermediates between OBI:organism and NCBITaxon:Homo Sapiens.

$(IMPORTDIR)/obi_import.owl: $(MIRRORDIR)/obi.owl $(IMPORTDIR)/obi_terms_combined.txt
	if [ $(IMP) = true ]; then $(ROBOT) query -i $< --update ../sparql/preprocess-module.ru \
		extract -T $(IMPORTDIR)/obi_terms_combined.txt --copy-ontology-annotations true --force true \
		    --individuals include --method BOT \
		remove --term OBI:0100026 --select "descendants" --exclude-term NCBITaxon:9606 \
		remove -T $(IMPORTDIR)/obi_terms_to_remove.txt --select "self instances descendants" \
		query --update ../sparql/inject-subset-declaration.ru --update ../sparql/inject-synonymtype-declaration.ru --update ../sparql/postprocess-module.ru \
		$(ANNOTATE_CONVERT_FILE); fi