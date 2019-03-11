NAMES := regioes ufs regioes_intermediarias regioes_imediatas municipios
EXTENSIONS := csv
TABELAS := $(foreach ext,$(EXTENSIONS),municipios.$(ext))

TEMP_DIR := temp
RAW_MAP_FILES := $(foreach ext,shp cpg dbf prj shx,$(TEMP_DIR)/lim_municipio_a.$(ext))
RAW_MAP_FILES_ZIP := $(TEMP_DIR)/Limites_v2017.zip


all: $(filter %.shp,$(RAW_MAP_FILES)) $(filter %.csv,$(TABELAS))
.PHONY: all


municipios.geo.json: $(filter %.shp,$(RAW_MAP_FILES)) $(filter %.csv,$(TABELAS))
	mapshaper -i $< snap \
		-rename-layers municipios \
		-rename-fields codigo_municipio=geocodigo \
		-filter-fields codigo_municipio \
		-simplify visvalingam 4% -filter-islands min-area=1e8 \
		-join $(word 2,$^) keys=codigo_municipio,codigo_municipio \
		-o force format=geojson id-field=codigo_municipio $@


ufs.geo.json: municipios.geo.json
	mapshaper -i $< \
		-dissolve2 sigla_uf copy-fields=sigla_uf \
		-simplify visvalingam 9% \
		-o force id-field=sigla_uf $@ \
	&& mapshaper -i $@ \
		-filter-fields FID -o force $@




.SECONDARY: $(RAW_MAP_FILES) .raw-map-files-sentinel $(RAW_MAP_FILES_ZIP)

$(RAW_MAP_FILES): .raw-map-files-sentinel

.raw-map-files-sentinel: $(RAW_MAP_FILES_ZIP)
	unzip -o $^ $(notdir $(RAW_MAP_FILES)) -d $(TEMP_DIR)
	touch $(RAW_MAP_FILES)

$(RAW_MAP_FILES_ZIP):
	mkdir -p $(TEMP_DIR)
	wget -O $@ \
		'ftp://geoftp.ibge.gov.br/cartas_e_mapas/bases_cartograficas_continuas/bc250/versao2017/shapefile/Limites_v2017.zip'


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
