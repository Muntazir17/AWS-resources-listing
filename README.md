# AWS-resources-listing


##  Description
This shell script automates the process of listing resources in an AWS account across multiple specified services within a given region. It verifies necessary tools, handles errors, and outputs a summary of all resources to a JSON file. This script is particularly useful for quickly gathering information about an AWS environment and verifying the presence and state of resources.

## Prerequisite
To use this script, you need:
- **AWS CLI**: Installed and configured to access your AWS account.
  - Installation Guide: [AWS CLI Installation](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- **JQ**: A command-line JSON processor for formatting and analyzing JSON outputs from AWS CLI commands.
  - Installation:
    - Debian-based systems: `sudo apt-get install jq`
    - macOS: `brew install jq`
    - CentOS-based systems: `sudo yum install jq`
    
## Usage
Run the script with:
```bash
./aws_resource_list_detailed.sh <aws_region> <aws_service1> <aws_service2> ...
```

Example:
```bash
./aws_resource_list_detailed.sh us-east-1 ec2 s3 cloudwatch
```

## Link to Script
The full script is available here: [aws_resource_list.sh](aws_resource_list.sh)

---

