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

There is a single GitHub Action created which contains two jobs. This creates and pushes a docker image to an Azure Container Registry, and then runs Terraform to deploy the infrastructure.

There are a number of secrets needed for the GitHub Actions to run. The Terraform script is run in AzureCLI and requires a Service Principal User to be created and the various ID's and Secret to be kept within the repo settings.

    CLIENT_ID
    CLIENT_SECRET
    SUBSCRIPTION_ID
    TENANT_ID

It also takes the Docker Registry Name, Username, and Password to be able to push the Blazor Docker Container to the Registry.

    REGISTRY_NAME
    REGISTRY_USERNAME
    REGISTRY_PASSWORD

### Docker Build

I decided to create a Docker image to simplify the deployment of the WebApp. Originally I had a GitHub action job that created the image and pushed to the WebApp. But I found this deployment method to be inconsistent. Therefore I decided to create and deploy a Docker image.

The GitHub Action, checks out the required DockerFile, logs into my Azure Container Registry, and then does a docker build and push.

The DockerFile uses the .Net Core 5.0 images as a base, checks out the code from the festive-tech-santa-wishlist GitHub repo, build and publishes the website and copies the resulting build artifacts into the final release image.

I also wanted to deploy Application Insights for monitoring, but using Containers does not allow the native monitoring without the SDK, therefore additional instrumentation of the code could be needed to enhance the system further at a later date.

### Terraform Deploy

The Terraform job runs to deploy the Terraform defined in the terraform files. (main.tf, variables.tf)

The Terraform script deploys a single Resource Group, an Azure FrontDoor for each Geography, and then an Azure WebApp, Azure Storage into each Region.

#### Terraform Variables

`resource_prefix` defaults to "festive-tech" but is the starting prefix for all resources when deployed.
`rglocation` defaults to "northeurope" but is just used as the location of the festive-tech Resource Group.

`subscription_id` is the subscription ID of the Azure Subscription used for deployment. This is passed in from the GitHub Secrets.

`admin_username`
`admin_password`
`registry_name`
`tag_name`

`geographies` is the variable used for specifying which geographies and which regions you want to deploy to.

    default = {
        GeographyId = {
        name = "GeographyName"
        regions = {
            RegionId1 = { name = "Region 1 Name", shortname = "r1" }
            RegionId2 = { name = "Region 2 Name", shortname = "r2" }
        }
        }

The `geographies` variable is also flatten to a local variable `allregions` that lists all regions without the geographies information. As the geography information is only required for deploying the Azure FrontDoor load balancers.

### Infrastructure Deployed

#### App Service Plan

The Terraform script deploys a Standard S1 App Service Plan running on Linux into each region. Along with this basic configuration I also deploy auto-scaling rules for each App Service plan. The Service plan will scale up an additional instance if the CPU usage is kept above 75% for 5 minutes, and will then scale down again when usage is below 25% for 5 minutes. The ASP starts with a single instance deployed but can scale up to 10 instances in a given region.

These scaling actions will alert subscription administrators and co-administrators via email when activated.

#### Storage Account

The Storage Account is deployed using GRS to ensure resilience to region outage, but is paired with a deployment, and does not scale independently.

#### WebApp

Once App Service Plans and Storage Accounts are deployed the script will deploy the WebApps. It includes the connection strings to storage accounts deployed for each region, and is configured to access the Docker Container Registry to deploy the previously build Docker image using the `latest` tag.

#### FrontDoor

To conform with the compliance I have deployed FrontDoor load balancers for each geography ie US / Germany etc, these allow for a single domain name but can load balancer across multiple deployed WebApps.

#### Additional Work

**Custom Domains** are not deployed but could be added to the geographies variable to allow additional customisation of the web apps.

**Storage Account scaling** - I would deploy additional Azure Automation scripts to deploy additional WebApp / StorageAccount configurations as needed when alerting from StorageAccount latency / error-codes.

**Web App Scaling** Modify Web App to use Premium for additional scaling / deploying additional S1 level WebApps when scaling to specific levels.
