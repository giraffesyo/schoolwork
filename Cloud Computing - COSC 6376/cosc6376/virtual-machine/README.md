This is an example of running a node.js application that is built locally and deployed to a machine image on Google Cloud. The machine imamge is then used to create a virtual machine instance, which will automatically start the node.js application.

## Prerequisites

This example asumes you're on Mac OS or Linux, as thee `buildimage.sh` script uses bash. You will also need the following:

- [Google Cloud SDK](https://cloud.google.com/sdk/)
- [Node.js](https://nodejs.org/en/)
- [Packer](https://www.packer.io/)
- [Yarn](https://yarnpkg.com/en/)

## Setup

1. Clone this repository
2. Run yarn inside of the [app](../app/) directory
3. Run `gcloud auth login` to authenticate with Google Cloud
4. Populate the [packer/variables.pkr.hcl](./packer/variables.auto.pkrvars.hcl) file with your project ID and zone, or create a `variables.auto.pkrvars.hcl` file with the same variables which will automatically override the default values.
5. Enable the following Google Cloud APIs (ensure you have your project set for gcloud, e.g. `gcloud config set project <project-id>`)
   1. gcloud services enable sourcerepo.googleapis.com
   2. gcloud services enable compute.googleapis.com
   3. gcloud services enable servicemanagement.googleapis.com
   4. gcloud services enable storage-api.googleapis.com
6. The account that packer runs as needs the following roles:
   - Compute Instances Admin
   - Service Account User
7. Activate application default user account `gcloud auth application-default login credentials.json`

## Build the image

Assuming everything is setup correctly, you can now build the image. Run the following command:

```bash
./buildimage.sh
```
