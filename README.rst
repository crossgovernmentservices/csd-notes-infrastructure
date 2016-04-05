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

Layout
======

Resources which are shared across environments such as top-level DNS entries are managed via terraform templates in the ``shared/`` directory. Terraform templates in the root level create and manage per-environment resources.

Usage
=====

Variables
---------

Variables that are not environment-specific are stored in ``terraform.tfvars`` and ``shared/terraform.tfvars``.

Secrets
-------

Files containing secrets (currently ``terraform.tfvars`` and ``shared/terraform.tfvars``) are encrypted with GPG and managed with `BlackBox`_. Ask an admin to add your GPG key so you can decrypt.

Creating/updating Shared resources
----------------------------------

Decrypt secrets::

  $ blackbox_edit_start terraform.tfvars

or::

  $ blackbox_decrypt_all_files

To see changes to be made (if any)::

  $ cd shared/
  $ terraform plan

To apply changes::

  $ cd shared/
  $ terraform apply

Terraform will apply changes and output a zone ID for the main parent subdomain (``r53_notes_zone_id``), which is required input for an environment's terraform template.

Creating/updating environment resources
---------------------------------------
Decrypt secrets::

  $ blackbox_edit_start terraform.tfvars

or::

  $ blackbox_decrypt_all_files

To see changes to be made (if any)::

  $ export ENV=dev  # or ENV=test, ENV=production, etc.
  $ terraform plan -state=$ENV.tfstate -var 'environment=$ENV' \
      -var 'rds_username=$DB_USERNAME' -var 'rds_password=$DB_PASSWORD' \
      -var 'r53_notes_zone_id=$NOTES_ZONEID'  # from output of shared template

To apply changes::

  $ export ENV=dev  # or ENV=test, ENV=production, etc.
  $ terraform apply -state=$ENV.tfstate -var 'environment=$ENV' \
      -var 'rds_username=$DB_USERNAME' -var 'rds_password=$DB_PASSWORD' \
      -var 'r53_notes_zone_id=$NOTES_ZONEID'  # from output of shared template

Variables above are required. Other optional variables are detailed in ``outputs.tf``.

Environment state
-----------------

An env-specific state is specified above (``-state=$ENV.tfstate``) to keep environments separate and avoid accidentally updating the wrong environment. Terraform will generate ``.tfstate`` files on each ``plan``, ``apply`` or ``refresh`` run. These files MUST NOT be checked into source control as they will contain secrets.

.. _BlackBox: https://github.com/StackExchange/blackbox
