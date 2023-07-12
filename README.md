# Deploy-EC2-Jenkins-Server-with-Terraform
Infrastructure Automation: Deploying an EC2 Jenkins Server with Terraform

Introduction

Today, I am going to show you how we can use Terraform for infrastructure automation to deploy a Jenkins Server on AWS, along with other resources but before we begin, I’m going to take a rather unconventional way to the explain concepts of Terraform.

Imagine you’re building a house with LEGO bricks. Instead of building it one brick at a time, you have a magical wand that lets you build the entire house with just one wave and not only that, but you can also use the same wand to take down the entire house with another wave.

Now, imagine you want to build the same house in another city. Instead of manually rebuilding the entire house from scratch, you can just use your magical wand again to recreate the entire house in the new location.

Terraform is like that magical wand, but instead of building houses with LEGO bricks, it builds entire infrastructures for your applications in the cloud, using code. It allows you to define the entire infrastructure as code, which means you can easily replicate and manage your infrastructure across different environments and providers and just like the wand, Terraform makes it easy to take down and modify your infrastructure with just a few lines of code.
What is Terraform

Terraform is an open-source infrastructure as code (IaC) tool that allows developers to define and manage cloud infrastructure resources in a declarative way.

Declarative is a programming concept where a program describes what should be accomplished, rather than how to accomplish it. In the context of Terraform, a declarative approach means that you define the desired state of your infrastructure and Terraform takes care of figuring out the necessary actions to achieve that state.

In Terraform, you define the desired state of your infrastructure using a configuration file, which specifies the resources you want to create, their properties and any dependencies between them. You do not need to write procedural code that specifies how to create and manage those resources. Instead, Terraform compares the desired state with the current state of the infrastructure and determines the necessary actions to achieve the desired state.

Terraform is also cloud agnostic. This means it supports multiple cloud providers such as Amazon Web Services (AWS), Microsoft Azure, and Google Cloud Platform (GCP), as well as various other services, such as databases, DNS, and monitoring tools.
Benefits of using Terraform

    Infrastructure as code: Terraform provides a way to define infrastructure as code, which means you can version control and manage your infrastructure just like you would with application code.
    Reusability: Terraform allows you to reuse infrastructure code across different environments, making it easier to manage and deploy consistent infrastructure.
    Cloud-agnostic: Terraform can manage resources across multiple cloud providers and services, making it a great tool for multi-cloud deployments.
    Consistency: Terraform ensures that the infrastructure deployed is consistent across all environments, making it easier to manage and maintain.

Now let me give you some background information to understand the more specific components of Terraform.
Background
Terraform Providers

A provider is a plugin that enables Terraform to interact with a particular infrastructure platform, service, or system. Providers are responsible for translating Terraform configuration files into API calls to create and manage resources.
Resources

Resources are the most basic building blocks that represent a piece of infrastructure that you want to manage and can represent a wide variety of infrastructure components, such as virtual machines, databases, load balancers, DNS records, or any other resource that can be created or managed by a particular provider.
Resource Type

A resource type is a category or class of infrastructure resources that can be created, updated, or destroyed using Terraform.
Resource Name

A resource name is a unique identifier assigned to a specific resource within a given Terraform configuration.
Resource Arguments

Resource arguments are the parameters or attributes that are passed to a resource block in Terraform. They provide the necessary information for Terraform to provision and manage a specific resource.
Variables

Variables are used to define values that can be passed into a Terraform configuration at runtime. These variables can be easily changed or customized in your configurations to make them more dynamic and reusable.
Jenkins

Jenkins is a powerful and popular open-source automation tool that helps software developers and engineers automate their development processes to build, test and deploy software projects.
Main Terraform Commands
Terraform init

The “terraform init” command initializes a new or existing Terraform working directory by downloading and installing the necessary plugins and modules for the Terraform configuration in that directory specified in the configuration files.
Terraform validate

The “terraform validate” command checks the syntax and structure of the Terraform configuration files in the current working directory and validates the Terraform code for any errors or mistakes before deploying it to the target environment.
Terraform plan

The “terraform plan” command creates an execution plan and generates a list of all the changes that Terraform will make to the infrastructure resources to bring it to the desired state defined in the Terraform configuration files.
Terraform apply

The “terraform apply” command applies the changes by deploying the infrastructure resources defined in the configuration files to the target environment.
Terraform destroy

The “terraform destroy” command removes all the resources that Terraform has created in the target environment based on the configuration files.
Prerequisites

    Basic knowledge and understanding of Terraform concepts and commands
    Basic Linux command line knowledge
    AWS Account with an IAM user with administrative privileges
    AWS Cloud9 IDE set up and read for use
    AWS CLI installed and configured in Cloud9

Use Case

You are an Infrastructure Automation Engineer at REX TECH. Your team would like to start using Jenkins as their CI/CD tool to create pipelines for DevOps projects. Your manager has tasked you to deploy the Jenkins server on Amazon Web Services (AWS) using Terraform so that it can be used in other environments and so changes to the environment are better tracked.
Objectives

    Deploy an EC2 Instances in the Default VPC.
    Bootstrap the EC2 instance with a script that will install and start Jenkins.
    Create and assign a Security Group to the Jenkins EC2 server which allows traffic on port 22 for SSH, port 443 for HTTPS and traffic from port 8080, which is the default port the Jenkins service uses.
    Create an private S3 bucket for the Jenkins Artifacts.
    Verify that you can reach the Jenkins install via port 8080 in a browser.
    Create an IAM Role that allows S3 read/write access for the Jenkins Server and assign the role to the Jenkins server.
    Verify functionality by connecting into your instance and archiving access to the S3 bucket using AWS CLI commands without leveraging your credentials.

Okay! Let’s get this party started by first setting up our environment in the preliminary Step 0!
Step 0: Install latest Terraform version in IDE environment

AWS Cloud9 already comes with Terraform installed, however, we’ll need to upgrade it to the latest version to be able to leverage its full capabilities to date.

Run the following command in succession to install the latest Terraform version on you Cloud9 IDE —

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform

Run “terraform version” to verify the latest version is installed on your Cloud9 terminal —

Now, let’s head to Step 1: Creating the providers.tf file.
Step 1: Create providers.tf Terraform file

In this file we will configure the AWS provider so we can interact with AWS services using their officially APIs.

Run the following command to create the file using the nano text editor —

nano providers.tf

Copy and paste the code below into the text editor, press “Ctrl and O” key together to save the file, then press Enter. Press “Ctrl and X” to exit the text editor.
Code explanation

This code configures the AWS provider with a specific region. The provider block is used to define the details of the AWS provider and inside the block contains its configuration options.

The region argument is set to the value of the variable var.aws_region.By using this syntax, Terraform will look for a variable named aws_region in the current workspace. We will see how we can define this variable in a separate variables.tf file.

On to Step 2 — Creating the Jenkins Servers security group.
Step 2: Create Jenkins server’s security group Terraform configuration file

To fulfill our objectives, we need to create a security group for the Jenkins EC2 server and allow the appropriate ports so we can connect to the server over the internet.

Run the following command to create the file using the nano text editor —

nano jenkins-sg.tf

Again, copy and paste the code below into the text editor, save the file, then exit it as previously done in Step 1.
Code explanation

This Terraform code defines an AWS security group resource for the Jenkins server. A security group acts as a virtual firewall that controls inbound and outbound traffic to and from the EC2 instance.

The resource block defines the resource type aws_security_group and its name jenkins-sg. The description field provides a brief description of the security group.

The ingress blocks specify the inbound traffic rules for the security group. There are three ingress blocks, each allowing traffic on different ports (22, 443, and 8080) using the TCP protocol. The cidr_blocks argument specifies the IP address of range 0.0.0.0/0 to have access the Jenkins server, therefore allowing traffic from any IP address.

The egress block specifies the outbound traffic rules for the security group. In this case, all outbound traffic is allowed. The from_port and to_port arguments are set to 0 and the protocol argument is set to -1 to allow any outbound traffic.

Now, we’re skipping over to Step 3 — Creating an IAM role to allow the Jenkins server read/write access to the S3 bucket.
Step 3: Create IAM role that allows Jenkins server read/write access to S3 bucket

We need an IAM Role to be assumed by the Jenkins server with a policy that allows S3 read/write access.

This can be accomplished by creating a separate Terraform file called s3-iam-role.tf.

Run the following command to create the file —

nano s3-iam-role.tf

Copy and paste the code below into the text editor, save the file, then exit.
Code explanation

The aws_iam_role resource defines a new IAM role called s3-jenkins_role that can be assumed by Jenkins EC2 instance. The assume_role_policy argument specifies a JSON-encoded policy that will allow the Jenkins EC2 instance to assume the role.

The aws_iam_policy resource defines a new IAM policy called s3-jenkins-rw-policy that allows read and write access to the S3 bucket. The policy argument specifies the policy document in JSON format.

The aws_iam_role_policy_attachment resource attaches the IAM policy to the IAM role by specifying the policy ARN and the role name.

The aws_iam_instance_profile resource creates an IAM instance profile called s3-jenkins-profile and associates it with the IAM role. The instance profile will be used to launch the Jenkins EC2 instance with the IAM role and associated permissions.

Great! We are doing good. Now let’s proceed to Step 4 — creating a bash script to automate the installation of Jenkins on the launched EC2 instance.
Step 4: Create bash script file to automate installation of Jenkins on EC2 instance

When we launch the EC2 instance, this bash script with run automatically as the EC2’s user data which will install and start the Jenkins service.

Run the following command to create the file using the nano text editor —

nano install_jenkins.sh

Copy and paste the code below into the text editor, save the file, then exit.
Code explanation

This bash script installs and starts Jenkins on the EC2 instance. Let’s go through what each command does:

    sudo yum update -y: This updates the package manager and all installed packages to their latest version.
    sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo: This downloads the Jenkins repository file and saves it to /etc/yum.repos.d/ directory.
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key: This imports the Jenkins GPG key to verify package integrity.
    sudo yum upgrade -y: This command upgrades all installed packages to their latest version.
    sudo amazon-linux-extras install java-openjdk11 -y: This command installs Java 11 from the Amazon Linux Extras repository.
    sudo yum install jenkins -y: This installs the Jenkins package from the Jenkins repository.
    sudo systemctl enable jenkins: This command enables the Jenkins service to start automatically on boot.
    sudo systemctl start jenkins: This command starts the Jenkins service.

Now, let’s jump to Step 5— Creating the main Terraform file.
Step 5: Create main.tf Terraform file

The main.tf Terraform file contains the main set of configuration for your module.

Run the following command to create the file using the nano text editor —

nano main.tf

Copy and paste the code below into the text editor, save the file, then exit.
Code explanation

This Terraform code contains resource blocks that define infrastructure resources that will be provisioned in AWS.

The terraform block declares aws as the required provider and specifies the source and version. The provider is responsible for managing and interacting with resources in AWS.

The resource block defines an EC2 instance resource with the name jenkins. It defines attributes like the Amazon Machine Image (AMI) to use, the instance type, the security group and tags. The user_data attribute specifies the install_jenkins.sh script to run when the instance is launched.

The aws_s3_bucket resource block defines an S3 bucket, and aws_s3_bucket_acl block sets the access control list (ACL) for the S3 bucket.

Now, let’s us proceed to Step 6 — Creating the variables.tf file.
Step 6: Create Terraform file that stores configuration variables

To prevent us from hard coding arguments in our main.tf file or other files, we can define variables in the variables.tf file that can be used throughout the Terraform environment. Variables are used to parameterize Terraform code, making it more reusable and configurable.

Let’s create the file —

nano variables.tf

Copy and paste the code below into the text editor, save the file, then exit.
Code explanation

This Terraform code defines several input variables that are used throughout of Terraform infrastructure deployment.

Let me give an explanation of each variable:

    aws_region: Specifies the AWS region where the infrastructure should be deployed which has a default value of us-east-1.
    ami: Specifies the ID of the Amazon Machine Image (AMI) that should be used to launch the EC2 instance. This variable has a default value of ami-04581fbf744a7d11f, which corresponds to an Amazon Linux 2 AMI.
    instance_type: Specifies the t2.micro instance type of the EC2 instance which is a low-cost, general-purpose instance type.
    key_name: Specifies the name of the key pair that should be used to connect to the EC2 instance. This variable has a default value of levelupkeypair.
    associate_public_ip_address: Specifies whether the EC2 instance should be launched with a public IP address and has the default value of true.
    jenkins-tag-name: Specifies the name of the tag that should be applied to the EC2 instance and S3 bucket resources and has a default value of Jenkins-Server.
    bucket: Specifies the name of the S3 bucket that should be created to the value of jenkins-s3-bucket-ifeanyi-luit20.
    acl: Specifies the access control list (ACL) that should be applied to the S3 bucket. This variable has a default value of private.

On to Step 7 we go! Let’s create an output.tf file to obtain the public IP adresss of the Jenkins server.
Step 7: Create output Terraform file to show the Jenkins Server’s Public IP Address

The output.tf file can be used to reference the public IP address of the Jenkins server instance. It will be displayed as part of the Terraform output after the infrastructure has been created or updated to be used to connect to the Jenkins server through a browser.

Let’s create the file —

nano output.tf

Copy and paste the code below into the text editor, save the file, then exit.
Code explanation

This Terraform code defines an output named instance_public_ip that will expose the public IP address of an AWS EC2 instance running the Jenkins server.

The value attribute is set to aws_instance.jenkins.public_ip, which means that the output value will be the public IP address of the aws_instance resource named jenkins.

Now, to the fun part Step 8 — Deploying the infrastructure using Terraform commands.
Step 8: Terraform init, validate, plan and apply

In your Cloud9 terminal, run the following command to initialize the required providers —

terraform init

After it has finished initializing, you will be greeted with a successful prompt, as shown below.

Next, lets validate that our code doesn't have any syntax errors by running the following command —

terraform validate

You should receive a success message stating that the configuration is valid, as show below.

Now let’s run the following command to generate a list of all the changes that Terraform will make —

terraform plan

You should be able to see listed all the changes Terraform is expect to make to the infrastructure resources. The “+” sign is what is going to be added and the “ — ”is what is going to be destroyed.

Now let’s deploy this bad boy! Run the following command to apply the changes and deploy the infrastructure resources.

Note — Make sure to type “yes” to agree to the changes after running this command

terraform apply

Terraform will begin applying all the changes to the infrastructure. Be patient, give it a few seconds to finish deploying. It should end with an Apply complete message and state the amount of resources added, changed and destroyed along with the Jenkins server’s public IP address as an output.

Make sure to copy and save the Jenkins servers public IP address, as it will needed to access the Jenkins server from a browser.

Now, let’s go through the AWS Management Console and verify that all the resources were indeed created in the Step 9.
Step 9: Verify Services — EC2 Instance, Security Group, IAM Role and S3 Bucket

In the AWS Management Console, head to the EC2 dashboard and verify that the Jenkins server was launched.

If you scroll down and click on the EC2’s Security tab you should also be able to see the s3-jekins_role created along with the security group jenkins-sg.

Scroll down again and view the inbound rules of the security group. Verify that it matches the desired configuration of allowing ports 22, 443 and 8080 from anywhere.

Now, head to the S3 dashboard and verify that the S3 bucket was created.

Click on your bucket, select the Permission tab and hover the mouse over Access. As configured, the S3 bucket is not public.

Now that we have validated all our resources have been created by Terraform, let’s head to Step 10 to connect into the Jenkins Server and verify that Jenkins service is running.
Step 10: Connect to EC2 Instance and verify Jenkins service is running

In the EC2 dashboard, click on the Jenkins server, then click Connect on the top right.

Select EC2 Instance Connect, then click Connect.

Once connected, run the following command to get the status of the Jenkins service —

systemctl status jenkins

You should be be able to see that the Jenkins server is active (running).

Copy and save the Jenkins administrator password which is shown at the end of the first line that start with a date. In this case, it is the characters that start with “1dd5e3e..”. This will be used to unlock Jenkins once we connect to it over the browser.

Alrighty! Now to Step 11- Lets connect to our Jenkins server!
Step 11: Connect to Jenkins Server from Browser

Open up you desired browser and paste the public IP address of the Jenkins Server mapped to port 8080 in the format below —

<public_ip_address>:8080

Success!

If you did all the steps correctly, you should now be connected to your Jenkins server! You’ve used Terraform to automatically deploy your AWS infrastructure by leveraging the power of Infrastructure as Code!
Set up Jenkins

We can now proceed to set up the Jenkins Server by pasting the administrator password in the field provided, then clicking Continue.

Select Install suggested plugins, then go through the rest of prompts.

Fill in the fields to create your admin user, then continue.

At the end you should be greated with the awesome message, “Jenkins is ready!”
Success!

You’ve just set up your first Jenkins Server running on an Amazon EC2 instance deployed by Terraform.

Now to the last step! Step 12 — Verifying the IAM role only allows the Jenkins server read/write permission to the S3 bucket.
Step 12: Verify that IAM role allows S3 bucket access from Jenkins Server

Head to S3 in the AWS Management Console, select the S3 bucket, then click Upload to upload a file to the S3 bucket.

Select your file then click Upload. In this demonstration, I will be uploading the PythonCheatSheet.pdf file.

You should now be able to see your file successfully uploaded.

Now, connect back to you Jenkins Server using EC2 Instance Connect from the EC2 dashboard.

Run the following command to attempt to list the objects in your S3 bucket including the name of the S3 bucket—

In this demonstration, I used the name of my S3 bucket created by Terraform.

aws ls s3://<s3_bucket_name>

As seen below, we can view, list, access the object previously uploaded into the S3 bucket.

Additionally, if I run the command again, without specifying the S3 bucket which the Jenkins server has access to via the IAM role, we will be greeted with an AccessDenied message prompt.

We have verified that we do not have access to other S3 buckets and their contents.
Congratulations!

You’ve successfully completed “Terraforming Through The Night”. You’ve learned basic and fundamental concepts of Terraform and leveraged this powerful for infrastructure automation to deploy a Jenkins Server on AWS, along with other resources like Security Groups, S3 buckets and IAM roles.
Clean up
Destroy infrastructure

Run the follow command to remove/delete/tear down all the resources previously provisioned from Terraform —

terraform destroy

Wait for it to complete. At the end, you should receive a prompt stating Destroy complete along with how many resources were destroyed.

If you’ve got this far, thanks for reading! I hope it was worthwhile to you.
