# Infrastructure as Code for a Micro Service Environment (PoC)

This is a proof of concept for micro service IaC environment where everything
related to the service is self contained in the service repository.

This repository will use EC2 instances to deploy the service but we can easily
swap this by a kubernetes cluster (commonly used in micro-services environment).
We are going to use EC2 instances here to reduce dependencies in this PoC.

This infrastructure is coded in HCL2 as a module so we can run end to end tests
using test-kitchen.

## Micro Service

The micro service is a basic `Hello World!` node app replying `Pong!` if you call
/ping. The point of having a node app is simply to show a full end to end
pipeline from app code to running application. We could adapt this for any
language or app as long as we adapt the test and building steps.

_The application has a `/health` endpoint which occasionally return 500 (10% of
the time)._

## Tools

The service is published on Docker Hub
[gbergere/micro-service-as-code](https://hub.docker.com/r/gbergere/micro-service-as-code/tags/)
then deployed via terraform on EC2 instances. I would ideally love to deploy it 
on Kubernetes (reason why I build a Docker container) but for now we keep
dependencies simple.

* TravisCI
* Docker and DockerHub
* GitHub (as you can see)
* Terraform (>= v0.12.0)
* Test Kitchen (to test Infrastructure as Code)
* AWS (to run the service)
* CoreOS (with `cloud-config`)

## FAQ

**Can we run this service in production as it is?**

This is done as a terraform module so we can run tests on terraform (fairly
easily). If we would like to deploy this in production we would simply have to
call this module in a terraform project to create the stack (and deploy the
version defined in the module call).
You can see a small example in the `test/fixtures/wrapper` directory calling this
module to test it with test-kitchen terraform.

**How to deploy a new version?**

To deploy a new version on the application you simply need to apply terraform
with a new `app_version` value on the module call. This will trigger a rolling
deployment with terraform in an immutable infrastructure still with a rotation
of the autoscaling group. The application won't have any down time.
