NAMES := regioes ufs regioes_intermediarias regioes_imediatas municipios
EXTENSIONS := csv json xlsx
MIN_FOLDER := min
TABELAS := $(foreach ext,$(EXTENSIONS),municipios.$(ext))
TABELAS_MIN := $(foreach ext,$(EXTENSIONS),$(foreach name,$(NAMES),$(MIN_FOLDER)/$(name).$(ext)))


tabelas: $(TABELAS) $(TABELAS_MIN)
.PHONY: tabelas


$(TABELAS) $(TABELAS_MIN): .tabelas-sentinel
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
