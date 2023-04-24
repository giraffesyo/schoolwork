This is an example of running a node.js application that is built locally using a dockerfile, pushed to dockerhub. A Google managed, container optimized image is used to run a VM instance and start the container.

## Prerequisites

This example asumes you're on Mac OS or Linux, as thee `deploy.sh` script uses bash, but you can mimic what it's doing on windows by just running the terraform commands directly.

You will also need the following:

- [Google Cloud SDK](https://cloud.google.com/sdk/)
- [Docker](https://www.docker.com/)

## Setup

1. Clone this repository
2. If you want to build the image
   1. Create a dockerhub account and create a repository for the node.js application
   2. Login to dockerhub from the command line `docker login`
   3. Build the node.js docker image `./buildimage.sh` from the `app` directory,
   4. Push the image to dockerhub, note that you can do this with `docker push <imagename>`
   5. Note that if you just want to test the image locally you can do so with `docker run -p 3000:3000 --rm -it giraffesyo/cosc6376` and then try to curl port 3000, e.g. `curl http://localhost:3000`
3. Else, I have the image already built and pushed at giraffesyo/cosc6376, that is the default image name in the terraform config
4. Run `gcloud auth login` to authenticate with Google Cloud
5. Enable the following Google Cloud APIs (ensure you have your project set for gcloud, e.g. `gcloud config set project <project-id>`)
   1. gcloud services enable sourcerepo.googleapis.com
   2. gcloud services enable compute.googleapis.com
   3. gcloud services enable servicemanagement.googleapis.com
   4. gcloud services enable storage-api.googleapis.com
6. The account that terraform runs as needs the following roles:

- Compute Instances Admin
- Service Account User

7.  Activate application default user account `gcloud auth application-default login credentials.json`
