## Hugo Builder and S3 Upload (hugo-builder-s3)
## By Ryan McCaffery (mccaffers.com)
##
## This code is licensed under Creative Commons Zero (CC0)
## You can copy, modify, distribute and perform the work, even for commercial purposes, all without asking permission.
## See LICENSE.md for more details
## ---------------------------------------

# Clear any existing cache of certificates
rm -rf /tmp/certs

# Populate certificates and set ACL
mkdir -p /tmp/certs
cp /var/task/certs/* /tmp/certs/
chmod 400 /tmp/certs/*

# Move into /tmp
cd /tmp

# Check if the project exists
if [ -d "/tmp/$ProjectName" ] 
then
    # if the projce folder exists, cd into it
    cd $ProjectName

    # reset any prior changes made to the repository
    git reset HEAD --hard

    GIT_SSH_COMMAND='ssh -i /tmp/certs/github -o IdentitiesOnly=yes -o UserKnownHostsFile=/tmp/certs/known_hosts' git pull
    git submodule update --init --recursive
else
    GIT_SSH_COMMAND='ssh -i /tmp/certs/github -o IdentitiesOnly=yes -o UserKnownHostsFile=/tmp/certs/known_hosts' git clone $GitUrl
    cd $ProjectName
    git submodule update --init --recursive
fi

# Generate the static files for publishing
hugo --minify

# Move the files to S3 and invalidate existing caches
aws s3 cp /tmp/$ProjectName/public s3://$S3BucketName/ --recursive
aws cloudfront create-invalidation --distribution-id $Distributionid --paths "/*"

# If a test environment S3 bucket has been added then build, with drafts on
if [ -n "$S3BucketName_TestEnvironment" ]; then
    rm -rf /tmp/$ProjectName/public
    mv -f /tmp/$ProjectName/test-config/config.yaml /tmp/$ProjectName/config.yaml 
    
    # `-D` builds drafts and publishes them for viewing
    hugo -D

    # Publishes to a test S3 bucket and invalidates a test cloudfront environment
    aws s3 cp /tmp/$ProjectName/public s3://$S3BucketName_TestEnvironment/ --recursive
    aws cloudfront create-invalidation --distribution-id $Distributionid_TestEnvironment --paths "/*"
fi