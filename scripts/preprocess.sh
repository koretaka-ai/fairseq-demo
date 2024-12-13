#!/bin/bash

while getopts d:r:p: OPT
do
    case $OPT in
    d ) DATASETS_DIR=$OPTARG
        ;;
    r ) RESOURCES_DIR=$OPTARG
        ;;
    p ) PRE_TRAINED_DIR=$OPTARG
        ;;
    esac
done

mkdir -p ${DATASETS_DIR} ${RESOURCES_DIR} ${PRE_TRAINED_DIR}

SPM_EN=${PRE_TRAINED_DIR}/enja_spm_models/spm.en.nopretok.model
SPM_JA=${PRE_TRAINED_DIR}/enja_spm_models/spm.ja.nopretok.model

# ------------------------
# Download
# ------------------------
pushd ${RESOURCES_DIR}
if [ -f ./examples.utf ]; then
    echo "[Info] examples file already exists, skipping download"
else
    wget ftp://ftp.edrdg.org/pub/Nihongo/examples.utf.gz
    gunzip examples.utf.gz
fi
popd

# ------------------------
# extract parallel sentence
# ------------------------
python srcs/preprocess_tanaka_corpus.py \
    --input_file ${RESOURCES_DIR}/examples.utf \
    --output_dir ${RESOURCES_DIR}

# ------------------------
# split corpus
# ------------------------
python srcs/split_corpus_train_dev_test.py \
    --input_file_prefix ${RESOURCES_DIR}/examples \
    --output_dir ${DATASETS_DIR} \
    --src_lang ja \
    --tgt_lang en \
    --num_dev 2000 \
    --num_test 2000 \
    --seed 42 

# ------------------------
# Download sentencepiece model
# ------------------------
pushd ${PRE_TRAINED_DIR}
if [ -d ./enja_spm_models ]; then
    echo "[Info] jparacral sentencepiece model already exists, skipping download"
else
    echo "[Info] Downloading jparacrawl sentencepiece model"
    wget  http://www.kecl.ntt.co.jp/icl/lirg/jparacrawl/release/3.0/spm_models/en-ja_spm.tar.gz
    tar xzvf en-ja_spm.tar.gz
    rm en-ja_spm.tar.gz
fi
popd

# ------------------------
# tokenize dataset
# ------------------------
if [ -d ./sentencepiece ]; then
    echo "[Info] tokenized datasets already exists"
else
    save_dir=${DATASETS_DIR}/sentencepiece
    mkdir -p $save_dir    
    echo "[Info] tokenizing ... "
    for type in train dev test; do
        python srcs/apply_spm.py --model ${SPM_EN} --input ${DATASETS_DIR}/${type}.en --output ${save_dir}/${type}.en
        python srcs/apply_spm.py --model ${SPM_JA} --input ${DATASETS_DIR}/${type}.ja --output ${save_dir}/${type}.ja
    done
fi