# Azure Festive Tech Calendar Hackathon

## The Problem

The website needs to be published around the world. Even though they have written the code, they are not sure about the best way to deploy and scale this. During initial testing with Santa’s helpers around the world they quickly ran into performance challenges as well as compliance requirements.

The application takes a connection string *(“connectionString”)* and a Blob container name *(“storageContainerName”)*.

## The Requirements

This is where your help comes in! Santa and his elves have compiled a list of requirements. Santa is not looking to change the code of the application, therefor code changes are prohibited.

**Website hosting and scaling**
The solution needs to be deployed on Microsoft Azure. The Website needs to scale keep up with the growing number of children wanting to send in their wish list.

**Personalization**
For each country Santa would like to personalize the page. As he is not looking for code changes or implementing multi-tenancy.

**Data compliance**
Data needs to be protected and preferably stored in the country that the children are living in.

Remember, we’re not looking for code changes in the website itself. Santa is perfectly fine with deploying resources for each country as long as it doesn’t happen manually and turn into a repetitive point and click adventure in the Azure Portal.

Once you have your deployment automated and documented your solution to the problem you can submit through the participate page

## My Solution

The solution proposed uses GitHub Actions and Terraform to deploy the Infrastructure and WebApp code.

### GitHub Actions

There are two GitHub Action YAML files. The main file `main.yml` contains two jobs. The script creates and pushes a docker image to an Azure Container Registry, and then runs Terraform to deploy the Infrastructure. The second YAML file is a secondary build process `branched.yml`; it creates a docker container and pushes it to the container registry tagged with the git branch name. The docker creation step allows for custom code to be built and deployed used custom image tags.

Ideally, the Docker build step would sit with the source code and run on commits to the source code rather than with the infrastructure code. But for ease of use and to ensure the code I am building is up to date, I have tied the docker build steps to the terraform infrastructure deployment and clone the base repo in the Dockerfile.

The `branched.yml` build step uses the branch name for the container tag, and the `main.yml` file uses a GitHub secret to supply the default container tag.

    DEFAULT_CONTAINER

There are some secrets needed for the GitHub Actions to run. The Terraform script is run in AzureCLI and requires a Service Principal User to be created and the various IDs and Secret to be kept within the repo settings.

    CLIENT_ID
    CLIENT_SECRET
    SUBSCRIPTION_ID
    TENANT_ID

Both pipelines push docker containers to a Container Registry (during my testing I used my Azure Container Registry but I believe other registries should also work). Therefore there are three secrets for the Registry Name, Username, and Password which are used push the Blazor Docker Container to the Registry.

    REGISTRY_NAME
    REGISTRY_USERNAME
    REGISTRY_PASSWORD

### Docker Build

I decided to create a Docker image to simplify the deployment of the WebApp. Originally I had a GitHub action job that created the image and pushed to the WebApp. But I found this deployment method to be inconsistent. Therefore I decided to create and deploy a Docker image. I am using a default tag rather than one generated during the build process, to allow for custom code to be deployed. With the terraform configuration there is scope for supplying container tags for custom images rather than the default tag.

The GitHub Action, checks out the required DockerFile, logs into my Azure Container Registry, and runs the docker build and push. The DockerFile uses the .Net Core 5.0 images as a base, checks out the code from the festive-tech-santa-wishlist GitHub repo, build and publishes the website and copies the resulting build artifacts into the final release image.

### Terraform Deploy

The Terraform job runs to deploy the Terraform defined in the terraform files. (main.tf, variables.tf). The Terraform script is designed to deploy a single Resource Group for all resources to be deployed into, an Azure FrontDoor for each Geography, and then an Azure WebApp, Azure Storage into each Region.

#### Terraform Variables

`resource_prefix` defaults to "festive-tech" but is the starting prefix for all resources when deployed.
`rglocation` defaults to "northeurope" but is just used as the location of the festive-tech Resource Group.

`subscription_id` is the subscription ID of the Azure Subscription used for deployment and is passed in from the GitHub Secrets.

`admin_username`
`admin_password`
`registry_name`
`tag_name`

The above variables are used for accessing the container registry, and is passed in via GitHub secrets and `--var` commands in the `terraform plan` and `terraform apply` steps os the GitHub Action.

`geographies` is the variable used for specifying which geographies and regions you want to deploy to. Any custom container tags can be specified within this variable too. This is used in the terraform script to customise deployments to specific regions.

    default = {
        GeographyId = {
            name = "GeographyName"
            regions = {
                RegionId1 = { name = "Region 1 Name", shortname = "r1", tag = "" }
                RegionId2 = { name = "Region 2 Name", shortname = "r2", tag = "customImage" }
            }
        }
    }

The `geographies` variable is also flatten to a local variable `allregions` that lists all regions without the geographies information. The `allregion` variable is used during some of the for_each loops. This is due to the geography information is only required for deploying the Azure FrontDoor load balancers.

### Deployed Infrastructure

#### App Service Plan

The Terraform script deploys a Standard S1 App Service Plan running on Linux into each region. (The Tier and Size can be changed in the script depending if production requirements need increased additional compute resources). Along with this basic configuration, I also deploy auto-scaling rules for each App Service plan. The Service plan will scale up an additional instance if the CPU usage is kept above 75% for 5 minutes, and will then scale down again when usage is below 25% for 5 minutes. The ASP starts with a single instance deployed but can scale up to 10 instances in a given region this is restricted by the Standard tier and could also be increased.

These scaling actions will alert subscription administrators and co-administrators via email when activated.

#### Storage Account

The Storage Account is deployed using GRS to ensure resilience to region outage, but is part of a single deployment and paired with WebApp frontend, therefore, does not scale independently.

#### WebApp

Once App Service Plans and Storage Accounts are deployed, the script will deploy the WebApps. It includes the connection strings to storage accounts deployed for each region. It is also configured to access the Docker Container Registry to deploy the previously build Docker image using the default tag unless there is a custom tag specified in the specific regions.

#### FrontDoor

I have also decided to deploy FrontDoor resources to run as a Load Balancer. Initially I deployed a single FrontDoor resource for all regions, but I felt this did not solve the compliance requirements, as the load balancer uses latency to determine the nearest deployment, whilst this works the majority of the time it is not guaranteed to route to a compliant deployment. I.e. latency to Europe North and Europe West maybe lower than to country-specific regions UK South or West Central Germany. Therefore I decided to deploy a FrontDoor resource within each geography to ensure data compliance with information staying within the country where possible.

### Outstanding Work / Known Restrictions

The following issues are outstanding due to running out of time. Given the time, I would look to implement these features too.

#### Application Insights

I looked into deploying Application Insights for monitoring purposes, but using the WebApp for Containers configuration, it would deploy the native monitoring without the SDK. Therefore additional instrumentation of the code could be needed to enhance the system further at a later date. But as this meant potential changes to the codebase of the Web site.

#### Network & Routing

I wanted to restrict routing to Microsoft networks and minimise the exposure of the Storage Account to the internet, to ensure increased security. I planned to deploy a VNet into each region and use VNet Integration and the Storage Account Endpoint to ensure all access to the Storage Account was down via the VNet. This did not work, as I was unable to configure the VNet integration using Terraform. (Commands are commented out). If I had time, I planned to rectify this by deploying a small AzureCLI script that could run as part of the GitHub Action, but I ran out of time.

#### Custom Domains

The deployed WebApps and FrontDoor applications do not take in custom domains, and only deploy the azurewebsite.net / azurefd.net are not deployed but could be added to the geographies variable to allow additional customisation of the domains.

#### Storage Account scaling

The current WebApp deploy can scale the number of AppServicePlans available to connect to the storage account. However these web front ends will all connect to a single Storage Account. I had planned to deploy additional scripts using Azure Automation and the Storage Accounts Alerts to horizontally the full region deployment (App Service Plan, Storage Account and WebApp) behind the same Azure FrontDoor to ensure the Storage Account does not become the bottleneck. This would use alerts based on StorageAccount latency and error-codes to deploy the additional infrastructure.

#### Continuous Deployment

Currently, the Docker containers are not re-pushed when updated in the container registry. There is a setting within the Containers for Continuous Deployment to create the required webhooks. I was unable to get this working against my ACR.  
