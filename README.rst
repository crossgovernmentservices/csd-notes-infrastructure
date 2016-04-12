=========================
 CSD Notes Infrastructure
=========================

Terraform templates to create and manage CSD Notes infrastructure.

Requirements
============
- `Terraform <https://www.terraform.io>`_
    + Install on OSX with:

      .. code:: shell

        $ brew install terraform
- `BlackBox`_
- AWS account credentials
    + Place in ``~/.aws/credentials``:

      .. code:: ini

         [default]
         aws_access_key_id = ACCESS_KEY
         aws_secret_access_key = SECRET_KEY

Usage
=====

Variables
---------

Variables that are not environment-specific are stored in ``terraform.tfvars``.

Secrets
-------

Secrets are stored in ``terraform.tfvars``, encrypted with GPG and managed with `BlackBox`_. Ask an admin to add your GPG key so you can decrypt.

Shared environment state
------------------------

Env-specific state files are used to keep environments separate. Terraform's
remote state storage is used to store Terraform state in Amazon S3, keeping environments in sync between different uses and users.


Managing environments
---------------------
Decrypt secrets::

  $ blackbox_edit_start terraform.tfvars

or to decrypt all BlackBox-managed files::

  $ blackbox_postdeploy

Define env::

  $ export ENV=dev  # or ENV=test, ENV=production, etc.

Configure remote storage::

  $ terraform remote config
      -backend=s3 -backend-config="bucket=csd-notes-terraform" \
      -backend-config="key=${ENV}.tfstate" -backend-config="region=eu-west-1"

Sync local state with remote::
  $ terraform remote pull

To see changes to be made (if any)::

  $ terraform plan -var "rds_username=${DB_USER}"
      -var "rds_password=${DB_PASSWORD}" \
      -var "environment=${ENV}" -var "domain_prefix=${ENV}"

To create or update an environment::

  $ terraform apply -var "rds_username=${DB_USER}"
      -var "rds_password=${DB_PASSWORD}" \
      -var "environment=${ENV}" -var "domain_prefix=${ENV}"

To delete an environment::

  $ terraform destroy -var "rds_username=${DB_USER}"
      -var "rds_password=${DB_PASSWORD}" \
      -var "environment=${ENV}" -var "domain_prefix=${ENV}"

Variables above are required, and will generally taken from the relevant ``.env`` file in the `CSD Notes Config`_ repo.


.. _BlackBox: https://github.com/StackExchange/blackbox
.. _CSD Notes Config: https://github.com/crossgovernmentservices/csd-notes-config
