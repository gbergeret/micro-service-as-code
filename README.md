# Infrastructure as Code for a Micro Service Environment (PoC)

This is a proof of concept for micro service IaC environment where everything
related to the service is self contained in the service repository.

This repository will use EC2 instances to deploy the service but we can easily
swap this by a kubernetes cluster (commonly used in micro-services environment).
We are going to use EC2 instances here to reduce dependencies in this PoC.

This infrastructure is coded as a module so we can run end to end tests using
test-kitchen.
