[![Test, Build, Push and Deploy Docker Image](https://github.com/infrastructure-ninja/idmehireme/actions/workflows/test-build-deploy.yml/badge.svg)](https://github.com/infrastructure-ninja/idmehireme/actions/workflows/test-build-deploy.yml)

# ID.me Hire Me!
ID.me Technical Exercise Repository

[Presentation Link](https://docs.google.com/presentation/d/1LNKf5cLInbiE1M_hXF5b959w62ResSU6fJDHC7XfM54/edit?usp=sharing)

## Introduction
   Thank you for the opportunity to take part in this technical exercise as part of the ID.me candidate interview process. I am pleased to showcase the skills and thought processes I have spent years developing in a cohesive manner. While it is not reasonable to expect every person to know everything (and I would be suspicious of anyone that says they do), one of the most important aspects to get across is that I __learn by doing__ and I generally learn what is necessary to get unblocked, then get back on track.

   I made this exercise at _least_ three time as hard on myself as it needed to be. I made the conscious choice to use tools that I had no previous experience with. While this may result in a demo product that is a bit more “naïve”, it should demonstrate the ability to come into an environment and having enough real-world experience to be able to make sense of new tools and operational patterns.      


## Greenfield Deployment Instructions
Even though the entire system is deployed and managed through infrastructure-as-code tools, when first bringing up an environment it is necessary to manually create service account credentials that allow those tools to work effectively and securely. The following list is what it takes to fully bring up an environment from scratch so that it can be managed by GitHub Actions and Terraform cloud.

### Google Cloud Platform
Create the project, and create a project-level owner service account (with JSON key)
> 1. <code>gcloud projects create --name=idmehireme</code>
> 2. <code>gcloud projects list</code>
> 3. <code>gcloud config set project \<PROJECT ID\></code>
> 4. Enable billing for this project (It appears you must use the GUI to complete this :frowning: )
> 5. <code>gcloud iam service-accounts create tf-owner-svcacct --display-name="Terraform Owner Service Account"</code>
> 6. <code>gcloud iam service-accounts list</code>
> 7. <code>gcloud iam service-accounts keys create tf-owner-svcacct.json --iam-account="tf-owner-svcacct@idmehireme-xxxxx.iam.gserviceaccount.com"</code>
> 8. <code>gcloud projects add-iam-policy-binding idmehireme-xxxxx --member=serviceAccount:tf-owner-svcacct@idmehireme-xxxxx.iam.gserviceaccount.com --role=roles/owner</code>
> 9. Get resulting JSON file into BASE64 format into the GitHub secret GCP_DEPLOY_KEY (hint: <code>cat tf-owner-svcacct.json | base64</code>)
> 10. Finally, put resulting JSON data into the GOOGLE_CREDENTIALS environment variable on Terraform cloud

### Terraform Cloud
> 1. Ensure the Organization is created.
> 2. Ensure the Workspace is created.
> 3. Ensure the terraform/main.tf file has proper references to the organization and workspace.
> 4. Create an API key and set it into a GitHub secret called *TF_API_TOKEN*.
> 5. Create all other necessary variables (some are sensitive, some are not).

### AWS
> 1. Create a custom role that only has access to the Route53 service, and the specific DNS domain using IAM.
> 2. Generate an API key and set it into a GitHub secret called *aws_access_key*/*aws_secret_key*.

### MonboDB Atlas
> 1. Create a database inside MongoDB Atlas.
> 2. Create an API key with access to a specific database.
> 3. Obtain the full connection URL and put this into the Terraform cloud variable named *app_mongo_url*.
> 4. Set the Terraform cloud variable named *app_mongo_dbname* to something (perhaps "url-shortener"?).

### Sentry.io
> 1. Setup a project.
> 2. Get the "client DSN" and use it to set the Terraform cloud variable named *app_sentry_dsn*.

---

## Secrets/Variables Used
For a green-field deployment, these are the following required variables/secrets that must be in place. These are referenced above in the green-field deployment instructions, but they are provided here again in tabular format for reference.
### GitHub Repo (Secrets for Actions)

Secret Name | Sensitive | Description/Notes
----------- | --------- | -----------------
TF_API_TOKEN | :white_check_mark: | For communicating with Terraform Cloud during DEPLOY job.
GCP_DEPLOY_KEY | :white_check_mark: | GCP service account JSON that is BASE64 encoded. For communicating with GCR during BUILD job.
GCP_PROJECT_ID | | The GCP project ID we are deploying into.
GCP_APP_NAME | | The application name using alphanumeric and hyphens only. Used all over the place, including the docker container name.
LOADER_WEBOOK | | Webhook to access to kick off the client load simulation as part of the SIMULATE job.

### Terraform Cloud (Variables)
Secret Name | Sensitive | Description/Notes
----------- | --------- | -----------------
app_sentry_dsn | :white_check_mark: | The "client DSN" provided by Sentry.io.
app_mongo_url | :white_check_mark: | The full connection URL provided by MongoDB.
app_mongo_dbname | | The name of the database, as configured in MongoDB.
aws_secret_key | :white_check_mark: | AWS Secret Access Key used to complete the DNS subdomain delegation work.
aws_access_key | :white_check_mark: | AWS Access Key ID used to complete the DNS subdomain delegation work.

### Terraform Cloud (Environment Variables)
Secret Name | Sensitive | Description/Notes
----------- | --------- | -----------------
GOOGLE_CREDENTIALS | :white_check_mark: | GCP service account JSON that is _not_ BASE64 encoded. 
