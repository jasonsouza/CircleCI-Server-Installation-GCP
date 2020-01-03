# CircleCI-Server-Installation-GCP
This projected is an automated implementation of [CircleCI Server Static Installation Scripts](https://circleci.com/docs/2.0/non-aws/) to your Google Cloud account.

Please consider the [limitations](https://circleci.com/docs/2.0/non-aws/#limitations) of the Static implementation of CircleCI Server prior to deploying and operating in production. 

Keep in mind that CircleCI only provides support for CircleCI Server deployed in non-AWS cloud providers for Platinum support customers only. Contact CircleCI support or your Customer Success Manager to get started.

## Prerequisites
1. [Install Terraform](https://www.terraform.io/downloads.html). If you already have Terraform installed, please make sure that you are using version 0.12 or higher.
2. The JSON file of your service account key. You can create one by following [these instructions](https://cloud.google.com/iam/docs/creating-managing-service-account-keys).
3. A CircleCI License file (.rli). Contact CircleCI support if you need a license.



