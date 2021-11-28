# HugoS3


## HugoS3

This is a **hobby project** to build a docker container that pulls a hugo git repository, build it and then push it to S3. The docker image can then be put behind an AWS Lambda (so I've included a dummy Python endpoint ```main.py```). You can then use a git webhook to automate updates to your blog.

### Requirements

- docker
- AWS Account

### Deploy

Login to AWS (you can get the full ECR endpoint from AWS)
```
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin $ECR-Endpoint
```

Build image
```
docker build -t hugoS3 --build-arg S3BucketName=$S3BucketName --build-arg GitUrl=$Giturl --build-arg ProjectName=$ProjectName .;
```

Deploy image
```
docker tag hugoS3:latest {ECR Identifer}..dkr.ecr.{AWS Region}.amazonaws.com/hugoS3:latest;
docker push {ECR Identifer}.dkr.ecr.{AWS Region}.amazonaws.com/hugoS3:latest;
```

### License
[MIT](https://choosealicense.com/licenses/mit/)