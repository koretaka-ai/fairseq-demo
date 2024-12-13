#!/bin/bash

while getopts d:m:r:s:t: OPT
do
    case $OPT in
    d ) DATASETS_DIR=$OPTARG
        ;;
    m ) MODEL=$OPTARG
        ;;
    r ) RESULT_DIR=$OPTARG
        ;;
    s ) SRC_LANG=$OPTARG
        ;;
    t ) TGT_LANG=$OPTARG
        ;;
    esac
done

OUTPUT_DIR=${RESULT_DIR}/${EXP_NAME}/test
mkdir -p ${OUTPUT_DIR}

fairseq-generate ${DATASETS_DIR} \
    -s ${SRC_LANG} \
    -t ${TGT_LANG} \
    --task translation \
    --path ${MODEL} \
    --gen-subset test \
    --batch-size 32 \
    --nbest 1 \
    --beam 5 \
    --min-len 1 \
    --remove-bpe "sentencepiece" \
    > ${OUTPUT_DIR}/sys.txt

grep ^H ${OUTPUT_DIR}/sys.txt | cut -c 3- | sort -n | cut -f 3- > ${OUTPUT_DIR}/sys.${TGT_LANG}