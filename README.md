
# Design Doc

## Open questions

* Optimize workflow throughput for multiple simultaneous users; queue jobs?
* Finalize dreambooth training params
* Collection of high quality prompts
* Mode of transfer from camera to local tensorbook
* Mode of transfer from cloud to end user
* Instructions for forming input image dataset (# of pics, angles, facial expressions)


## Workflow

**Setup**
* Cloud: one of more cloud A100x8 Instance setup:
    * ssh key
        Add new ssh key: https://cloud.lambdalabs.com/ssh-keys
        sudo chmod 600 /path/to/my/key.pem
        ssh ubuntu@{CLOUD_IP} -i /path/to/my/key.pem
    * connected to persistent storage
    * repo code loaded -> NO NEED TO UPLOAD SCRIPT RAN THROUGH SSH
    * library installed (including xformers)
* Local: one or more tensorbooks setup:
```
git clone https://github.com/eolecvk/neurips_demo.git
cd neurips_demo
/bin/bash local_setup.sh
```

**Take pictures of users**
* How many pictures?
* What kind of angles?
* What kind of facial expressions?

**Transfer pictures of users from camera to tensorbook**
* miniSD card ?
* bluetooth ?
* ???

**Transfer pictures of users from tensorbook to cloud persistent storage**
`upload_img.sh`
```
#!/bin/bash

IMG_DIR=???
IP_ADDRESS=104.171.203.185
rsync -avh $IMG_DIR root@${IP_ADDRESS}:/${IMG_DIR}  /inputs/$IMG_DIR
```

**Launch remote training job from tensor notebook**
`launch_job.sh`
```
# training
ssh root@${IP_ADDRESS} 'bash -s' < train.sh

# inference
ssh root@${IP_ADDRESS} 'bash -s' < train.sh
```

5. Download output pictures (or do we need to email it???)
`download_img.sh`
```
#!/bin/bash

IMG_DIR=???
IP_ADDRESS=104.171.203.185

scp -r ubuntu@${IP_ADDRESS}:/outputs/$IMG_DIR $IMG_DIR 

```