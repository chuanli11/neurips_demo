#!/bin/bash

RUN_ID=${1:-"lambda"}
GPU_ID=${2:-"0"}
NUM_PRED=${3:-"1"}
USE_TF32=${4:-"on"}

SD_NAME="CompVis/stable-diffusion-v1-4"
TOKEN="aabbccddeeffgg"

WEBCAM_DIR="/home/ubuntu/Pictures/Webcam" # This is on local machine (where webcam saves photos to)
STORAGE_DIR="/home/ubuntu/ml/neurips2022" # This is on cloud machine (but could also be mounted to the local machine)
INPUT_DIR="${STORAGE_DIR}/person/${RUN_ID}/input"
PRED_DIR="${STORAGE_DIR}/person/${RUN_ID}/output"
MODEL_DIR="${STORAGE_DIR}/person/${RUN_ID}/model"
CLASS_DATA_DIR="${STORAGE_DIR}/class_data/set1"
DREAMBOOTH_CODE_DIR="diffusers/examples/dreambooth"

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
CMD_ENV+="export MODEL_DIR=${MODEL_DIR} &&"
CMD_ENV+="export STORAGE_DIR=${STORAGE_DIR} &&"
CMD_ENV+="export DREAMBOOTH_CODE_DIR=${DREAMBOOTH_CODE_DIR}"

echo "Set up project on remote server: "
CMD_WORKSPACE=$CMD_ENV" && "
CMD_WORKSPACE+=$(cat create_workspace.sh)
echo $CMD_WORKSPACE | sed "s/ [\\]//g"
echo $CMD_WORKSPACE | sed "s/ [\\]//g" | ssh lambda-001

echo "Resize images in ${WEBCAM_DIR}: "
python compress.py ${WEBCAM_DIR}

echo "Upload images to ${INPUT_DIR}: "
rsync -avh ${WEBCAM_DIR}/*.jpg lambda-001:${INPUT_DIR}
mv ${WEBCAM_DIR}/*.jpg ${WEBCAM_DIR}_bk

echo "Train Dreambooth: "
CMD_TRAIN=$CMD_ENV" && "
CMD_TRAIN+=$(cat train.sh)
echo $CMD_TRAIN | sed "s/ [\\]//g"
echo $CMD_TRAIN | sed "s/ [\\]//g" | ssh lambda-001
echo "Training job ${RUN_ID} done, GPU ${GPU_ID} is free."

echo "Test Dreambooth: "
CMD_TEST=$CMD_ENV" && "
CMD_TEST+=$(cat test.sh)
echo $CMD_TEST | sed "s/ [\\]//g"
echo $CMD_TEST | sed "s/ [\\]//g" | ssh lambda-001
echo "Test job ${RUN_ID} done, GPU ${GPU_ID} is free."