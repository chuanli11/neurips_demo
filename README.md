
# Design Doc

**Do image resizing**


## Open questions

TOP PRIORITY:

1. Optimize upload speed to cloud
    * resize / compress images locally before upload
    * ensure high speed connection to network
    * backup workstation to do training if network connection fails completely

2. Queuing jobs


---

* Optimize workflow throughput for multiple simultaneous users; queue jobs?
* Finalize best practice for:
    * dreambooth training params,
    * input pictures (qty, angles, facial expressions)
    * Set of high quality prompts for inference
* Mode of picture transfer:
    * from camera to local tensorbook
    * from cloud instance to end user
* Streamline installing xformers on cloud instance

## Workflow

**Setup**

TODO: Add persistent storage

* [Create ssh key in lambda dashboard](https://cloud.lambdalabs.com/ssh-keys)
* Send private key to all tensorbook; update permission `sudo chmod 600 /path/to/my/key.pem`
* Launch cloud instance(s) and attach new ssh key to it
* Test ssh access: `ssh ubuntu@{CLOUD_IP} -i /path/to/my/key.pem`
* Setup tensorbook
    * Install imagemagick:
    ```
    sudo apt-get install imagemagick
    ```
    * Update ssh config file in tensorbooks;
    `sudo nano ~/.ssh/config`:
    ```
    Host lambda-001
        HostName <CLOUD_IP_HERE>
        User ubuntu
        IdentityFile /path/to/my/key.pem
    ```
* Setup cloud instance
```
# Install model code
git clone https://github.com/huggingface/diffusers.git
cd diffusers/examples/dreambooth
pip install --upgrade pip
pip install -U -r requirements.txt
accelerate config
huggingface-cli login

# Install xformers for faster inference
# cf inference.py : `pipe.enable_xformers_memory_efficient_attention()`
# ...TBC
```

**Take pictures of users**

**Transfer pictures of users from camera to tensorbook**

**Transfer pictures of users from tensorbook to cloud persistent storage**
`upload_img.sh`
```
#!/bin/bash

export HOSTNAME='lambda-001'
export RUN_ID='eolecvk'
export IMG_DIR_SRC='/home/eole/Desktop/pic_me'
export IMG_DIR_DST=/home/ubuntu/inputs/${RUN_ID}

python compress.py ${IMG_DIR_SRC}
ssh ${HOSTNAME} "mkdir -p '${IMG_DIR_DST}'"
rsync -avh ${IMG_DIR_SRC}/ lambda-001:${IMG_DIR_DST}
```

**Launch remote training job from tensor notebook**
`launch_job.sh`
```
# training
cat train.sh | ssh lambda-001

# inference
cat infer.py | ssh lambda-001 python -
```

5. Download output pictures (or do we need to email it???)
`download_img.sh`
