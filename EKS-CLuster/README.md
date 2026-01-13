# Create EKS on AWS using Terraform.

### EKS Architecture:
<img width="874" alt="Screenshot 2025-07-10 at 1 36 39 PM" src="https://github.com/user-attachments/assets/cf80f42b-ac60-4065-8237-e46ebdb60e49" />

### Prerequisites

1. We need to install AWS CLI as we will use the AWS CLI (aws configure) command to connect Terraform with AWS in the next steps.
```bash
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
```
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
apt install unzip( install unzip if not installed)
unzip awscliv2.zip
sudo ./aws/install
```
2. Next, Install Terraform using the below link.
```bash
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
```

3. Connect Terraform with AWS
```bash
aws configure
aws configure list
```

4. Navigate to the directory where terrafrom config files are available and initialize terraform, this will intialize the terraform environment for you and download the modules, providers and other configuration required.
```bash
terraform init
terraform plan
terraform apply
```

5. EKS and Node Groups are ready

<img width="1433" alt="Screenshot 2024-12-03 at 12 08 29 PM" src="https://github.com/user-attachments/assets/f7fdbe1d-b4dd-4cfd-97f0-66077fb4417c">

6. kubectl Install:
```
# Remove any broken version
sudo rm -f /usr/local/bin/kubectl

# Download latest stable kubectl (works with EKS 1.33)
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Make it executable
chmod +x kubectl

# Move it to system path
sudo mv kubectl /usr/local/bin/

# Check version
kubectl version --client
```

7. Once the cluster is up, you can configure kubectl to interact with it by using the aws eks update-kubeconfig command. Here's the command to set up the kubeconfig file:
   
```bash
aws eks --region us-east-1 update-kubeconfig --name project
```

8. Verify resources
<img width="1433" alt="Screenshot 2024-12-03 at 12 12 54 PM" src="https://github.com/user-attachments/assets/caa1c4f1-b311-4ab7-aaec-174dc8a15354">

To verify EKS Cluster Versio
```
aws eks describe-cluster --name project --region ap-south-1 --query "cluster.version" --output text
```

### NOTE: Make sure to delete the resources:

```bash
kubectl patch ingress ingress -n default -p '{"metadata":{"finalizers":[]}}' --type=merge
terraform destroy
```

