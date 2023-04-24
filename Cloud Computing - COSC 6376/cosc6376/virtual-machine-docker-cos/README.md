This is an example of running a node.js application that is built locally using a dockerfile, pushed to dockerhub. A Google managed, container optimized image is used to run a VM instance and start the container.

## Prerequisites

This example asumes you're on Mac OS or Linux, as thee `deploy.sh` script uses bash, but you can mimic what it's doing on windows by just running the terraform commands directly.

You will also need the following:

- [Google Cloud SDK](https://cloud.google.com/sdk/)
- [Docker](https://www.docker.com/)

## Setup

1. Clone this repository
2. Create a dockerhub account and create a repository for the node.js application
3. Login to dockerhub from the command line `docker login`
4. Build the node.js application `docker build -t <dockerhub-username>/<repository-name> .` from the `app` directory
5. Run `gcloud auth login` to authenticate with Google Cloud
6. Enable the following Google Cloud APIs (ensure you have your project set for gcloud, e.g. `gcloud config set project <project-id>`)
   1. gcloud services enable sourcerepo.googleapis.com
   2. gcloud services enable compute.googleapis.com
   3. gcloud services enable servicemanagement.googleapis.com
   4. gcloud services enable storage-api.googleapis.com
7. The account that terraform runs as needs the following roles:
   - Compute Instances Admin
   - Service Account User
8. Activate application default user account `gcloud auth application-default login credentials.json`
