NAMES := regioes ufs regioes_intermediarias regioes_imediatas municipios
EXTENSIONS := csv
TABELAS := $(foreach ext,$(EXTENSIONS),municipios.$(ext))


tabelas: $(TABELAS)
.PHONY: tabelas


$(TABELAS): .tabelas-sentinel
.SECONDARY: .tabelas-sentinel
.tabelas-sentinel: tabelas-municipios-brasileiros.ipynb
	pipenv run jupyter nbconvert \
		--execute $< \
		--stdout > /dev/null


install:
	pipenv install --skip-lock
.PHONY: install


lab:
	pipenv run jupyter lab
.PHONY: lab
