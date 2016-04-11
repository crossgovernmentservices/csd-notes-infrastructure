#!/bin/bash
cd csd-notes-config && blackbox_postdeploy
DB_USER=$(grep DB_USERNAME envs/dev.env | sed -E 's/(.*)=(.*)/\2/')
DB_PASSWORD=$(grep DB_PASSWORD envs/dev.env | sed -E 's/(.*)=(.*)/\2/')

cd ../csd-notes-infrastructure && blackbox_postdeploy

terraform remote config -backend=s3 -backend-config="bucket=csd-notes-terraform"\
  -backend-config="key=dev.tfstate" -backend-config="region=eu-west-1"

terraform apply  -var "rds_username=${DB_USER}" -var "rds_password=${DB_PASSWORD}"\
  -var "environment=dev" -var "domain_prefix=dev"
