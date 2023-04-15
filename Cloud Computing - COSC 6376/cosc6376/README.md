# Evaluating Deployment Strategies for a Monolithic Application: Containers vs. Cloud Functions vs. Managed Container Orchestration

## Project background and related work

In modern application development, a developer can be far detached from the production deployment and how ultimately the code gets executed to assist the end-user. This project seeks to explore various deployment options for an event-driven application, optimizing for cost and performance. Deploy options that are good fits for these types of applications include containers on virtual machines (VMs), serverless computing using cloud functions, or managed container orchestration platforms like Google Kubernetes Engine (GKE). The choice of deployment strategy can have a significant impact on the application's overall performance, cost, and maintainability. This project aims to evaluate and compare these deployment options for a monolithic application.

## Project Objective

The primary objective of this project is to evaluate and compare different deployment strategies for a monolithic application, including:

- Deploying the application in containers running on VMs.
- Decomposing the application into microservices and deploying them using Google Cloud Functions.
- Deploying the application in containers managed by a container orchestration platform like GKE.
- The project will involve analyzing the performance, cost, and ease of management for each deployment strategy.

## Challenges and/or Motivation

The primary challenges in this project include:

- Understanding the nuances and performance characteristics of each deployment option.
- Identifying the most suitable application to be deployed and evaluated.
- Ensuring the integrity and functionality of the application are maintained throughout the deployment and evaluation process.
- The motivation behind this project is to explore the potential benefits and trade-offs of various deployment strategies, enabling better-informed decisions on application deployment to optimize cost and performance.

## Timeline and milestones (e.g., task for each week)

1. Research and select an appropriate monolithic application for deployment.
2. Deep dive into containerization (Docker), Google Cloud Functions, and Google Kubernetes Engine.
3. Decompose the chosen application into microservices for deployment on Google Cloud Functions.
4. Prepare the application for containerization and deployment on VMs and GKE.
5. Deploy and test the application using the three deployment strategies.
6. Analyze and compare the performance, cost, and ease of management for each deployment strategy; finalize project documentation and presentation.

## Tools

- Google Cloud Functions (FaaS platform)
- Docker (Containerization)
- Google Kubernetes Engine (Managed container orchestration platform)
- Google Compute Engine (VMs)
- Node.js (Programming language)
- Google Cloud Monitoring (Monitoring tool)
- Version control tools (specifically Git and GitHub)
