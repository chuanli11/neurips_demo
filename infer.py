from diffusers import StableDiffusionPipeline
import torch

model_id = "eolecvk"
model_path = f"/home/ubuntu/models/{model_id}"
output_path = f"/home/ubuntu/outputs/{model_id}"

pipe = StableDiffusionPipeline.from_pretrained(model_path).to("cuda")
pipe.enable_xformers_memory_efficient_attention()

prompt = "A photo of aabbccddeeffgg person in the style of topgun"
image = pipe(prompt, num_inference_steps=50, guidance_scale=7.5).images[0]

image.save("{output_path}/test.png")