rm -rf /tmp/certs
mkdir -p /tmp/certs
cp /var/task/certs/* /tmp/certs/
chmod 400 /tmp/certs/*

cd /tmp

if [ -d "/tmp/$ProjectName" ] 
then
    cd $ProjectName
    GIT_SSH_COMMAND='ssh -i /tmp/certs/github -o IdentitiesOnly=yes -o UserKnownHostsFile=/tmp/certs/known_hosts' git pull
    git submodule update --init --recursive
else
    GIT_SSH_COMMAND='ssh -i /tmp/certs/github -o IdentitiesOnly=yes -o UserKnownHostsFile=/tmp/certs/known_hosts' git clone $GitUrl
    cd $ProjectName
    git submodule update --init --recursive
fi

hugo
aws s3 cp /tmp/$ProjectName/public s3://$S3BucketName/ --recursive
aws cloudfront create-invalidation --distribution-id $Distributionid --paths "/*"