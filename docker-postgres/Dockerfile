FROM postgres:9.6
COPY sv_se.affix sv_se.dict /usr/share/postgresql/9.6/tsearch_data/
COPY swedish_dictionary.sql /docker-entrypoint-initdb.d/
