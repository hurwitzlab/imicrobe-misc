#!/bin/bash

set -u

# if [[ $# -ne 1 ]]; then
#     echo Usage: $(basename $0) files-list
#     exit
# fi

IPLANT_DIR=${1:-/iplant/home/shared/imicrobe/projects}

echo Checking IPLANT_DIR \"$IPLANT_DIR\"

IPLANT_FILES=iplant-files

# ils -r $IPLANT_DIR > $IPLANT_FILES
# 
# BIN="$( readlink -f -- "${0%/*}" )"

FILES_LIST=files-list
$HOME/work/imicrobe-lib/scripts/iplant-ds-parser.pl $IPLANT_FILES > $FILES_LIST

echo FILES_LIST \"$FILES_LIST\"

FTP_DIR="/RepositoryPool00/PublicFTP"
i=0
while read DS_PATH; do
    FILE=${DS_PATH#/iplant/home/shared/imicrobe/}

    if [[ $(expr match "$FILE" '.*\(xls*\)') ]]; then
        continue
    fi

    FTP="$FTP_DIR/$FILE"

    if [[ -e $FTP ]] || [[ -e "$FTP.gz" ]]; then
        continue
    fi

    let i++
    DEST_DIR=$(dirname $FTP)
    if [[ ! -d $DEST_DIR ]]; then
        mkdir -p $DEST_DIR
    fi

    echo printf \"%5d: %s\\n\" $i $FILE
    echo cd $DEST_DIR
    echo iget $DS_PATH 

    if [[ ! $(expr match "$FTP" '.gz$') ]]; then
        echo gzip $(basename $FTP)
    fi
done < $FILES_LIST

if [[ $i -gt 0 ]]; then
    echo fixftp
fi
