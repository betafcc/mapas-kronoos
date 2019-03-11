tabelas: $(TABELAS) $(TABELAS_MIN)
.PHONY: tabelas


$(TABELAS) $(TABELAS_MIN): .tabelas-sentinel
.SECONDARY: .tabelas-sentinel
.tabelas-sentinel: tabelas-municipios-brasileiros.ipynb
	poetry run jupyter nbconvert \
		--execute $< \
		--stdout > /dev/null


install:
	pipenv install --skip-lock
.PHONY: install


lab:
	pipenv run jupyter lab
.PHONY: lab
