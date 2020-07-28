# Intuit-project
#Prerequisits - 
#1.create a bucket in S3 to store state file
#2.Edit the key filename and vpc info in Intuit-project/env/ec2/variable.tf
git clone https://github.com/srimul/Intuit-project.git'
cd Intuit-project/env/ec2
terraform init
terraform plan
terraform apply -auto-approve
