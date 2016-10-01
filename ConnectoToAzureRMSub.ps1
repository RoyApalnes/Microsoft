#Get connected to your Azure Subscription.

#Install Azure RM Commands.
Install-Module AzureRM

#Import Azure RM Commands.
Import-Module AzureRM

#Login to AzureRM.
Login-AzureRmAccount

#See which Azure RM Subscription your currently managin.
Get-AzureRmContext

#Get a view of all Azure RM Subscriptions your account is administrating.
Get-AzureRmSubscription

#Select a subscription by copying the SubscriptionName.
Get-AzureRmSubscription –SubscriptionName "MSDN-plattformer" | Select-AzureRmSubscription