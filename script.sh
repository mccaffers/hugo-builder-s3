cd /tmp

if [ -d "/tmp/$ProjectName" ] 
then
    cd $ProjectName
    git pull
    git submodule update --init --recursive
else
    git clone $GitUrl
    cd $ProjectName
    git submodule update
fi

hugo -D
aws s3 rm s3://$S3BucketName --recursive
aws s3 cp /tmp/$ProjectName/public s3://$S3BucketName/ --recursive --acl public-read