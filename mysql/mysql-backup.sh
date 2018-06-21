#!/bin/bash

set -u

OUT_DIR="/var/hurwitzlab/db_dump"
EXCLUDE_DBS="(Database|db|information_schema|mysql|performance_schema|sys|test)"
EXCLUDE_TABLES="(uproc_kegg_result|uproc_pfam_result|kegg_annotation|pfam_annotation|protein|protein_evidence_type|protein_type|sample_to_protein)"
MY_CNF=$(mktemp)

cat << EOF > $MY_CNF
[client]
user=backup
password=0nBjtmQpVWYX.
EOF

DATABASES=$(mysql --defaults-extra-file=$MY_CNF -Be 'show databases' | grep -vE $EXCLUDE_DBS)

sudo setenforce 0

cd $OUT_DIR

i=0
for DB in $DATABASES; do
  let i++
  printf "%5d: %s\n" $i $DB
  OUT_FILE_NAME="$DB-$(date +"%F")"
  OUT_FILE_SQL="$OUT_FILE_NAME.sql.gz"
  TAB_DIR="$PWD/$DB"
  TABLES=$(mysqlshow $DB | awk 'NR>4' | grep '^|' | awk '{print $2}' | grep -vE $EXCLUDE_TABLES | xargs echo)

  mysqldump --defaults-extra-file=$MY_CNF --force --opt $DB $TABLES | gzip > $OUT_FILE_SQL

  [[ -d "$TAB_DIR" ]] && rm -rf "$TAB_DIR"
  mkdir -m 777 -p "$TAB_DIR"

  mysqldump --defaults-extra-file=$MY_CNF --opt --tab=$TAB_DIR $DB $TABLES

  tar czf "${OUT_FILE_NAME}.tab.tgz" "$TAB_DIR"
  rm -rf "$TAB_DIR"
done

rm $MY_CNF

sudo setenforce 0
