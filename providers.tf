provider "aws" {
  region = var.region
}

#Creating backend
terraform{
    backend "s3"{
        bucket = "statebucketdevops"
        region = "ap-south-1"
        key = "terraform.tfstate"
    }
}





