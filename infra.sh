#!/bin/bash

: ${1?"Usage: $0 apply|destroy|plan|output|refresh ENV"}

case "$1" in
    apply) ACTION=apply ;;
    plan) ACTION=plan ;;
    output) ACTION=output ;;
    refresh) ACTION=refresh ;;
    destroy) ACTION="destroy -force" ;;
esac

# default env is 'dev'
ENV=${2:-dev}

# use default.env file if named env file isn't present
if [ ! -f envs/${ENV}.env ]; then
    ENV_FILE=envs/${ENV}.env
else
    ENV_FILE=envs/default.env
fi

cd ../csd-notes-config && blackbox_postdeploy
DB_USER=$(grep DB_USERNAME ${ENV_FILE} | sed -E 's/(.*)=(.*)/\2/')
DB_PASSWORD=$(grep DB_PASSWORD ${ENV_FILE} | sed -E 's/(.*)=(.*)/\2/')

cd ../csd-notes-infrastructure && blackbox_postdeploy

# always delete local tfstate files before doing anything else, because
# terraform blindly pushes any local state to remote storage as a first step
rm ./*.tfstate*
rm ./.terraform/*.tfstate*

terraform remote config -backend=s3 -backend-config="bucket=csd-notes-terraform"\
  -backend-config="key=${ENV}.tfstate" -backend-config="region=eu-west-1"

terraform remote pull

terraform ${ACTION} -var "rds_username=${DB_USER}" -var "rds_password=${DB_PASSWORD}"\
  -var "environment=${ENV}" -var "domain_prefix=${ENV}"

terraform remote push
