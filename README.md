# stable_diffusers_on_nix
Fresh and up to date huggingface diffusers library and other relevant ones to use as a python shell

use with :
nix-shell mkshell.nix

Can make images and videos with Stable Diffusion Pipelines

e.g.
```
import torch
from diffusers import TextToVideoSDPipeline
from diffusers.utils import export_to_video

pipe = TextToVideoSDPipeline.from_pretrained("damo-vilab/text-to-video-ms-1.7b", torch_dtype=torch.float16, variant="fp16")

pipe.enable_model_cpu_offload()

prompt = "Linus Torvalds is eating spaghetti"
video_frames = pipe(prompt).frames

video_path = export_to_video(video_frames)
video_path

```
