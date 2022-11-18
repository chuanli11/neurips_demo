
# TODO:
# * Add arg parsing for MODEL_ID


export RUN_ID='eolecvk'
export MODEL_NAME="CompVis/stable-diffusion-v1-4"
export INSTANCE_DIR="/home/ubuntu/inputs/${RUN_ID}"
export OUTPUT_DIR="/home/ubuntu/models/${RUN_ID}"
export TOKEN="aabbccddeeffgg"

# v2
accelerate launch ~/diffusers/examples/dreambooth/train_dreambooth.py \
  --pretrained_model_name_or_path=$MODEL_NAME  \
  --instance_data_dir=$INSTANCE_DIR \
  --train_text_encoder \
  --class_data_dir=$CLASS_DIR \
  --output_dir=$OUTPUT_DIR \
  --with_prior_preservation --prior_loss_weight=1.0 \
  --instance_prompt="a photo of aabbccddeeffgg person" \
  --class_prompt="a photo of person" \
  --resolution=512 \
  --train_batch_size=2 \
  --gradient_accumulation_steps=1 \
  --learning_rate=1e-6 \
  --lr_scheduler="constant" \
  --lr_warmup_steps=0 \
  --num_class_images=200 \
  --max_train_steps=1000


# v1
# accelerate launch train_dreambooth.py   \
# --pretrained_model_name_or_path=$MODEL_NAME    \
# --instance_data_dir=$INSTANCE_DIR   --output_dir=$OUTPUT_DIR   \
# --instance_prompt="a photo of "$TOKEN" person"   \
# --resolution=512   --gradient_accumulation_steps=1 --gradient_checkpointing \
# --lr_scheduler="constant"   \
# --lr_warmup_steps=0   --max_train_steps=1000 \
# --train_batch_size=4 \
# --learning_rate=1e-6 \
# --train_text_encoder