cd /home/ubuntu/ml/neurips2022/diffusers/examples/dreambooth &&

. /home/ubuntu/ml/neurips2022/diffusers/examples/dreambooth/venv/bin/activate && 

CUDA_VISIBLE_DEVICES=$GPU_ID python train_dreambooth.py \
--pretrained_model_name_or_path=$SD_NAME \
--instance_data_dir=$INPUT_DIR \
--train_text_encoder \
--output_dir=$MODEL_DIR \
--instance_prompt="a photo of "${TOKEN}" person" \
--resolution=512 \
--train_batch_size=2 \
--gradient_accumulation_steps=1 \
--lr_scheduler="constant" \
--lr_warmup_steps=0 \
--learning_rate=1e-6 \
--max_train_steps=1000 \
--pred_path $PRED_DIR