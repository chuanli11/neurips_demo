cd /home/ubuntu/ml/neurips2022/diffusers/examples/dreambooth &&

. /home/ubuntu/ml/neurips2022/diffusers/examples/dreambooth/venv/bin/activate && 

CUDA_VISIBLE_DEVICES=$GPU_ID python test_dreambooth.py \
--model_path $MODEL_DIR \
--pred_path $PRED_DIR \
--num_preds $NUM_PRED