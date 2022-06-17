# Terraform Loop
The objective of this project is to understand and how to use the "loops" in terraform creating instances, disk, and ips
using Google Cloud

## Requirements 
 * [Terraform](https://www.terraform.io/): Automate Infrastructure on Any Cloud
 * [GoogleCloudSDK](https://cloud.google.com/sdk): Libraries and tools for interacting with Google Cloud products and services.

## Goals
 * Create template
 * Create Public IPS
 * Create Additional disk, attach and mount
 * Create Instances from template

## Variables
```shell script
project = ""
zone = ""
region = ""
```

## Plan And Deploy 
```shell script
terraform plan
terraform deploy
```


## Authors

*  **Edwin Caminero** - *Initial work* - [github](https://github.com/ecaminero)
See also the list of [contributors](https://github.com/ecaminero/terraform-loop-gcp) who participated in this project.

  
## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details


## Acknowledgments

* Inspiration
* Understanding loops in terraform