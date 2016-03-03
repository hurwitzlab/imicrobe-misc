#!/bin/bash

set -u

OUT_DIR="/var/hurwitzlab/db_dump"
EXCLUDE="(Database|db|information_schema|mysql|performance_schema|sys|test)"
MY_CNF=$(mktemp)

cat << EOF > $MY_CNF
[client]
user=backup
password=0nBjtmQpVWYX.
EOF

DATABASES=$(mysql --defaults-extra-file=$MY_CNF -Be 'show databases' | grep -vE $EXCLUDE)

sudo setenforce 0

cd $OUT_DIR

i=0
for DB in $DATABASES; do
  let i++
  printf "%5d: %s\n" $i $DB
  OUT_FILE_NAME=$DB-$(date +"%F")
  OUT_FILE_SQL=$OUT_FILE_NAME.sql.gz
  TAB_DIR=$DB

  mysqldump --defaults-extra-file=$MY_CNF --force --opt --databases $DB | gzip > $OUT_FILE_SQL

  if [[ -d $TAB_DIR ]]; then
    rm -rf $TAB_DIR
  fi
  mkdir -m 777 -p $TAB_DIR

  mysqldump --defaults-extra-file=$MY_CNF --force --opt --single-transaction --quick --tab=$TAB_DIR $DB

  tar czf ${OUT_FILE_NAME}.tab.tgz $DB
  rm -rf $TAB_DIR
done

rm $MY_CNF

sudo setenforce 0
