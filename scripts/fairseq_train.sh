#!/bin/bash

while getopts d:n:m:r:s:l: OPT
do
    case $OPT in
    d ) DATASETS_DIR=$OPTARG
        ;;
    n ) EXP_NAME=$OPTARG
        ;;
    m ) PRETRAINED_MODEL=$OPTARG
        ;;
    r ) RESULT_DIR=$OPTARG
        ;;
    s ) SEED=$OPTARG
        ;;
    l ) LANGS=$OPTARG
        ;;
    esac
done

save_dir=${RESULT_DIR}/${EXP_NAME}
rm -fr $save_dir
mkdir -p $save_dir

SRC_LANG=$(echo "$LANGS" | cut -d'-' -f1)
TGT_LANG=$(echo "$LANGS" | cut -d'-' -f2)

echo Training server name : `hostname` > ${save_dir}/train.log
fairseq-train ${DATASETS_DIR} \
    --restore-file ${PRETRAINED_MODEL} \
    --arch transformer --optimizer adam \
    --source-lang ${SRC_LANG} --target-lang ${TGT_LANG} \
    --save-dir ${save_dir}/checkpoints \
    --clip-norm 0.0 \
    --seed ${SEED} \
    --lr-scheduler inverse_sqrt --warmup-init-lr 1e-07 \
    --warmup-updates 4000 --lr 3e-5 --dropout 0.1 \
    --weight-decay 0.0 \
    --criterion label_smoothed_cross_entropy \
    --label-smoothing 0.1 \
    --max-tokens 5000 --no-epoch-checkpoints \
    --reset-optimizer \
    --max-epoch 5 --reset-dataloader \
    --patience 2 \
    >> ${save_dir}/train.log