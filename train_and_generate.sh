export MODEL_NAME="CompVis/stable-diffusion-v1-4"
export INSTANCE_DIR="inputs/${MODEL_ID}"
export OUTPUT_DIR="models/${MODEL_ID}"
export TOKEN="aabbccddeeffgg"

# Training
accelerate launch train_dreambooth.py   \
--pretrained_model_name_or_path=$MODEL_NAME    \
--instance_data_dir=$INSTANCE_DIR   --output_dir=$OUTPUT_DIR   \
--instance_prompt="a photo of "$TOKEN" person"   \
--resolution=512   --gradient_accumulation_steps=1 --gradient_checkpointing \
--lr_scheduler="constant"   \
--lr_warmup_steps=0   --max_train_steps=1000 \
--train_batch_size=4 \
--learning_rate=1e-6 \
--train_text_encoder

# Inference
python inference.py