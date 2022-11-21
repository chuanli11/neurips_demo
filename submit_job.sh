#!/bin/bash

RUN_ID=${1:-"lambda"}
GPU_ID=${2:-"0"}
NUM_PRED=${3:-"1"}
USE_TF32=${4:-"on"}

# Constant variables
WEBCAM_DIR="/home/ubuntu/Pictures/Webcam"
SD_NAME="CompVis/stable-diffusion-v1-4"
CLASS_DATA_DIR="/home/ubuntu/ml/neurips2022/class_data/set1"
TOKEN="aabbccddeeffgg"

echo "Set up project on remote server: "
INPUT_DIR="/home/ubuntu/ml/neurips2022/person/${RUN_ID}/input"
PRED_DIR="/home/ubuntu/ml/neurips2022/person/${RUN_ID}/output"
MODEL_DIR="/home/ubuntu/ml/neurips2022/person/${RUN_ID}/model"
mkdir -p $INPUT_DIR
mkdir -p $PRED_DIR
mkdir -p $MODEL_DIR
mkdir -p $CLASS_DATA_DIR
cp "helper.py" "/home/ubuntu/ml/neurips2022/person/${RUN_ID}"
cp "test.ipynb" "/home/ubuntu/ml/neurips2022/person/${RUN_ID}/test_${RUN_ID}.ipynb"
sed -i "s/chuanli/${RUN_ID}/g" "/home/ubuntu/ml/neurips2022/person/${RUN_ID}/test_${RUN_ID}.ipynb"

echo "Resize images in ${WEBCAM_DIR}: "
python compress.py $WEBCAM_DIR

echo "Upload images to ${INPUT_DIR}: "
mv ${WEBCAM_DIR}/*.jpg ${INPUT_DIR}

echo "Train and test Dreambooth: "
# Environment variables for training and testing commands
CMD_ENV="export RUN_ID=${RUN_ID} && "
CMD_ENV+="export GPU_ID=${GPU_ID} && "
CMD_ENV+="export NUM_PRED=${NUM_PRED} && "
CMD_ENV+="export USE_TF32=${USE_TF32} && "
CMD_ENV+="export SD_NAME=${SD_NAME} && "
CMD_ENV+="export CLASS_DATA_DIR=${CLASS_DATA_DIR} && "
CMD_ENV+="export TOKEN=${TOKEN} && "
CMD_ENV+="export INPUT_DIR=${INPUT_DIR} && "
CMD_ENV+="export PRED_DIR=${PRED_DIR} && "
CMD_ENV+="export MODEL_DIR=${MODEL_DIR}"

CMD_TRAIN=$CMD_ENV" && "
CMD_TRAIN+=$(cat train_and_test.sh)
echo $CMD_TRAIN | sed "s/ [\\]//g"
echo $CMD_TRAIN | sed "s/ [\\]//g" | ssh lambda-001

echo "Job ${RUN_ID} done, GPU ${GPU_ID} is free."