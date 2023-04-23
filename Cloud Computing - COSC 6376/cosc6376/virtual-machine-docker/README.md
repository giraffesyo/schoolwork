This is an example of running a node.js application that is built locally using a dockerfile, pushed to dockerhub. A machine image is created that has docker installed and running as a service. The machine imamge is then used to create a virtual machine instance, which will automatically pull down the container and run the image.

## Prerequisites

This example asumes you're on Mac OS or Linux, as thee `buildimage.sh` script uses bash. You will also need the following:

- [Google Cloud SDK](https://cloud.google.com/sdk/)
- [Docker](https://www.docker.com/)
- [Packer](https://www.packer.io/)

## Setup

1. Clone this repository
2. Create a dockerhub account and create a repository for the node.js application
3. Login to dockerhub from the command line `docker login`
4. Build the node.js application `docker build -t <dockerhub-username>/<repository-name> .` from the `app` directory
5. Run `gcloud auth login` to authenticate with Google Cloud
6. Populate the [packer/variables.pkr.hcl](./packer/variables.auto.pkrvars.hcl) file with your project ID and zone, or create a `variables.auto.pkrvars.hcl` file with the same variables which will automatically override the default values.
7. Enable the following Google Cloud APIs (ensure you have your project set for gcloud, e.g. `gcloud config set project <project-id>`)
   1. gcloud services enable sourcerepo.googleapis.com
   2. gcloud services enable compute.googleapis.com
   3. gcloud services enable servicemanagement.googleapis.com
   4. gcloud services enable storage-api.googleapis.com
8. The account that packer runs as needs the following roles:
   - Compute Instances Admin
   - Service Account User
9. Activate application default user account `gcloud auth application-default login credentials.json`

## Build the image

Assuming everything is setup correctly, you can now build the image. Run the following command:

```bash
./buildimage.sh
```
