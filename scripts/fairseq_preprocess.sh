#!/bin/bash

while getopts d:p:s:t: OPT
do
    case $OPT in
    d ) DATASETS_DIR=$OPTARG
        ;;
    p ) PRE_TRAINED_DIR=$OPTARG
        ;;
    s ) SRC_LANG=$OPTARG
        ;;
    t ) TGT_LANG=$OPTARG
        ;;
    esac
done

# --- Download jparacrawl_base_model ---
mkdir -p ${PRE_TRAINED_DIR}
pushd ${PRE_TRAINED_DIR}
if [ -d ./enja_base_model ]; then
    echo "[Info] Pre-trained jparacrawl base model already exists, skipping download"
else
    echo "[Info] Downloading Pre-trained jparacrawl base model"
    wget http://www.kecl.ntt.co.jp/icl/lirg/jparacrawl/release/3.0/pretrained_models/en-ja/base.tar.gz
    tar xzvf base.tar.gz
    rm base.tar.gz
    mv base ./enja_base_model
fi
popd

# --- fairseq-preprocess ---
preprocessed_dir=${DATASETS_DIR}/fairseq_preprocess
rm -rf $preprocessed_dir
mkdir -p $preprocessed_dir

fairseq-preprocess --source-lang ${SRC_LANG} --target-lang ${TGT_LANG} \
    --trainpref ${DATASETS_DIR}/train \
    --validpref ${DATASETS_DIR}/dev \
    --testpref ${DATASETS_DIR}/test \
    --destdir ${preprocessed_dir} \
    --srcdict ${PRE_TRAINED_DIR}/enja_base_model/dict.${SRC_LANG}.txt \
    --tgtdict ${PRE_TRAINED_DIR}/enja_base_model/dict.${TGT_LANG}.txt