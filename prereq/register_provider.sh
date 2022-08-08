#! /bin/bash
# Script used to register Azure provider on the subscription

# Set the subscription
az account set --subscription $1

# Register all the providers
az provider register -n Microsoft.VirtualMachineImages --wait
az provider register -n Microsoft.Compute --wait
az provider register -n Microsoft.KeyVault --wait
az provider register -n Microsoft.Storage --wait
az provider register -n Microsoft.Network --wait