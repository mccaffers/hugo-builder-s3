## Hugo Builder S3

This project builds a docker container to pull a git repository containing a Hugo Blog repository. The running container builds the hugo static files and then push the ./static folder to S3. 

The docker image can then be put behind an AWS Lambda (so I've included a dummy Python endpoint ```main.py```). You can then use a git webhook to automate updates to your blog.

### Build

Build image with a number of arguements:

```
docker build -t hugoS3 --build-arg S3BucketName=$S3BucketName --build-arg GitUrl=$Giturl --build-arg ProjectName=$ProjectName SSH_PRIVATE_KEY="$(cat /path/to/key)" --build-arg SSH_KNOWN_HOSTS="$(cat /path/to/known_hosts)" .;
```

Run locally or push to ECR and use within an AWS Lambda

### Creative Commons Zero License.

You can copy, modify, distribute and perform the work, even for commercial purposes, all without asking permission. See License.md for more details.
