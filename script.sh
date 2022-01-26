cd /tmp

if [ -d "/tmp/$ProjectName" ] 
then
    cd $ProjectName
    GIT_SSH_COMMAND='ssh -i /var/task/certs/github -o IdentitiesOnly=yes -o UserKnownHostsFile=/var/task/certs/known_hosts' git pull
    git submodule update --init --recursive
else
    GIT_SSH_COMMAND='ssh -i /var/task/certs/github -o IdentitiesOnly=yes -o UserKnownHostsFile=/var/task/certs/known_hosts' git clone $GitUrl
    cd $ProjectName
    git submodule update --init --recursive
fi

hugo -D
aws s3 cp /tmp/$ProjectName/public s3://$S3BucketName/ --recursive --acl public-read