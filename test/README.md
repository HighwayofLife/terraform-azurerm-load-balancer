Test Terraform Module
=====================

This directory contains code to test the terraform module.

Usage
-----

From the root directory, run go test:
```sh
go test -v ./test/...
```

Prerequisites
-------------

An SPN is needed to test the module, this can be created for a specific subscription.

```sh
# Login to Azure
az login

# Select subscription to use
az account set --subscription mysubscriptionname

# Create an SPN with RBAC Contributor role
az ad sp create-for-rbac --name <spn-name> --role Contributor
# Use az ad sp create-for-rbac --help for scopes
```
