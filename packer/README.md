# AMI builder for Linux Metrics workshop

## Usage

```
packer build -var 'aws_access_key=...' -var 'aws_secret_key=...' -var 'subnet_id=...' -var 'vpc_id=...' packer.json
```
