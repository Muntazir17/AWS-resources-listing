#!/bin/bash

###############################################################################
# Author: Muntazir 
# Version: v0.1.0

# Enhanced script to automate the process of listing all resources in an AWS account.
# This version supports multiple services, formatted output, error handling, and more.

# Below are the services that are supported by this script:
# 1. EC2
# 2. RDS
# 3. S3
# 4. CloudFront
# 5. VPC
# 6. IAM
# 7. Route53
# 8. CloudWatch
# 9. CloudFormation
# 10. Lambda
# 11. SNS
# 12. SQS
# 13. DynamoDB
# 14. VPC
# 15. EBS

# Usage: ./aws_resource_list.sh <aws_region> <aws_service1> <aws_service2> ...
# Example: ./aws_resource_list.sh us-east-1 ec2 s3
#############################################################################

# Check if the required number of arguments are passed
if [ $# -lt 2 ]; then
    echo "Usage: ./aws_resource_list.sh <aws_region> <aws_service1> <aws_service2> ..."
    echo "Example: ./aws_resource_list.sh us-east-1 ec2 s3"
    exit 1
fi

# Assign the first argument to aws_region and the remaining to aws_services
aws_region=$1
shift
aws_services=("$@")

# Check if the AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install the AWS CLI and try again."
    exit 1
fi

# Check if the AWS CLI is configured
if [ ! -d ~/.aws ]; then
    echo "AWS CLI is not configured. Please configure the AWS CLI and try again."
    exit 1
fi

# Create a timestamped output file
output_file="aws_resources_$(date +'%Y%m%d_%H%M%S').json"
echo "[" > "$output_file"

# Function to list resources for a given service
list_resources() {
    local service=$1
    echo "Listing $service resources in $aws_region"

    case $service in
        ec2)
            aws ec2 describe-instances --region "$aws_region" --output json
            ;;
        rds)
            aws rds describe-db-instances --region "$aws_region" --output json
            ;;
        s3)
            aws s3api list-buckets --output json
            ;;
        cloudfront)
            aws cloudfront list-distributions --output json
            ;;
        vpc)
            aws ec2 describe-vpcs --region "$aws_region" --output json
            ;;
        iam)
            aws iam list-users --output json
            ;;
        route53)
            aws route53 list-hosted-zones --output json
            ;;
        cloudwatch)
            aws cloudwatch describe-alarms --region "$aws_region" --output json
            ;;
        cloudformation)
            aws cloudformation describe-stacks --region "$aws_region" --output json
            ;;
        lambda)
            aws lambda list-functions --region "$aws_region" --output json
            ;;
        sns)
            aws sns list-topics --region "$aws_region" --output json
            ;;
        sqs)
            aws sqs list-queues --region "$aws_region" --output json
            ;;
        dynamodb)
            aws dynamodb list-tables --region "$aws_region" --output json
            ;;
        ebs)
            aws ec2 describe-volumes --region "$aws_region" --output json
            ;;
        *)
            echo "Invalid service: $service"
            return 1
            ;;
    esac
}

# Summary report dictionary
declare -A resource_count

# Main loop to iterate over each service and collect resources
for service in "${aws_services[@]}"; do
    echo "Processing $service in $aws_region..."
    
    output=$(list_resources "$service")
    
    if [ $? -eq 0 ]; then
        # Save output to file
        echo "{ \"$service\": $output }," >> "$output_file"
        
        # Update summary count
        count=$(echo "$output" | jq '.[] | length')
        resource_count[$service]=$count
    else
        echo "Error retrieving $service resources. Check AWS CLI configuration and permissions."
    fi
done

# Close the JSON array in the output file
echo "]" >> "$output_file"

# Display summary report
echo -e "\nResource Summary:"
for service in "${!resource_count[@]}"; do
    echo "$service: ${resource_count[$service]} resources found"
done

echo -e "\nDetailed resource list saved to $output_file"
