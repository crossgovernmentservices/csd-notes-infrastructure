#!/bin/bash

: ${1?"Usage: $0 apply|destroy ENV"}

case "$1" in
    apply) ACTION=apply ;;
    destroy) ACTION=destroy ;;
esac

ENV=${2:-dev}

cd csd-notes-config && blackbox_postdeploy
DB_USER=$(grep DB_USERNAME envs/${ENV}.env | sed -E 's/(.*)=(.*)/\2/')
DB_PASSWORD=$(grep DB_PASSWORD envs/${ENV}.env | sed -E 's/(.*)=(.*)/\2/')

cd ../csd-notes-infrastructure && blackbox_postdeploy

terraform remote config -backend=s3 -backend-config="bucket=csd-notes-terraform"\
  -backend-config="key=${ENV}.tfstate" -backend-config="region=eu-west-1"

terraform ${ACTION} -var "rds_username=${DB_USER}" -var "rds_password=${DB_PASSWORD}"\
  -var "environment=${ENV}" -var "domain_prefix=${ENV}"
