#!/bin/bash
#SBATCH -J test
#SBATCH -p opus
#SBATCH -o logs/%x_%j.log
#SBATCH -c 4
#SBATCH --mem=32GB
#SBATCH --gpus=1

RESULT_DIR=results
DATASETS_DIR=datasets
RESOURCES_DIR=resources
PRE_TRAINED_DIR=pre-trained

# ------------------------
# preprocess
# ------------------------
bash scripts/preprocess.sh \
    -d ${DATASETS_DIR} \
    -r ${RESOURCES_DIR} \
    -p ${PRE_TRAINED_DIR}

# ------------------------
# fairseq preprocess
# ------------------------
bash scripts/fairseq_preprocess.sh \
    -d ${DATASETS_DIR}/sentencepiece \
    -p ${PRE_TRAINED_DIR} \
    -s en \
    -t ja

# ------------------------
# fairseq train
# ------------------------
bash scripts/fairseq_train.sh \
    -d ${DATASETS_DIR}/sentencepiece/fairseq_preprocess \
    -n SAN_SEED42 \
    -m ${PRE_TRAINED_DIR}/enja_base_model/base.pretrain.pt \
    -r ${RESULT_DIR}/en2ja/jparacrawl_v3.0/base \
    -s 42 \
    -l en-ja

# ------------------------
# fairseq generate
# ------------------------
bash scripts/fairseq_generate.sh \
    -d ${DATASETS_DIR}/sentencepiece/fairseq_preprocess \
    -m ${RESULT_DIR}/en2ja/jparacrawl_v3.0/base/SAN_SEED42/checkpoints/checkpoint_best.pt \
    -r ${RESULT_DIR}/en2ja/jparacrawl_v3.0/base/SAN_SEED42 \
    -s en \
    -t ja

# ------------------------
# Eval Comet and BLEU
# ------------------------
sacrebleu \
    ${DATASETS_DIR}/test.ja \
    -i ${RESULT_DIR}/en2ja/jparacrawl_v3.0/base/SAN_SEED42/test/sys.ja \
    -tok ja-mecab \
    > ${RESULT_DIR}/en2ja/jparacrawl_v3.0/base/SAN_SEED42/bleu.log

comet-score \
    -s ${DATASETS_DIR}/test.en \
    -t ${RESULT_DIR}/en2ja/jparacrawl_v3.0/base/SAN_SEED42/test/sys.ja \
    -r ${DATASETS_DIR}/test.ja \
    --model Unbabel/wmt22-comet-da \
    > ${RESULT_DIR}/en2ja/jparacrawl_v3.0/base/SAN_SEED42/comet.log