# aws-tf-healthcare

## 1. Introduction
### 1.1. Overview Project Objective
A healthcare provider is planning to migrate their on-premises infrastructure to AWS. They currently use SQL Server for patient records, along with on-premise applications for billing and scheduling. Local storage contains sensitive medical data. Security and compliance with healthcare regulations (such as HIPAA) are the top priorities. Additionally, the provider requires a disaster recovery (DR) solution and a scalable architecture for future growth.


### 1.2. High Level Architect
This architecture provides the healthcare provider with a secure, scalable, and compliant cloud environment for hosting their critical applications and sensitive medical data.

![High Level Architect](ckvn-healthcare.jpg)

### 1.3. Estimated AWS Cost
For MVP purpose: https://calculator.aws/#/estimate?id=927c147271d56f0cad379736daa77b4658acbd28 

## 2. Scope of Work
### Workstream 1: Inventory Discovery & Security and Compliance
- Inventory Discovery: Perform a full inventory of all servers, databases, applications, and systems currently operating on-premises
- Security Architecture Review: Identify sensitive data, especially healthcare data and patient information, to ensure compliance with security and regulatory requirements.

### Workstream 2: Data and Application Migration
- IAM Setup: Configure IAM with strict security policies to protect access to sensitive data.
- Security Monitoring Implementation: Utilize AWS CloudTrail and AWS Security Hub to monitor and track security events.
- SQL Server Database Migration: Plan and execute the migration of the patient database to AWS RDS.
- Applications Migration: Deploy and test the applications in the AWS environment to ensure stability and efficiency.

### Workstream 3: Disaster Recovery (DR)
- DR Strategy Development: Set up a DR strategy for the entire infrastructure, ensuring high availability.
- DR Testing Plan: Create a periodic DR testing plan to ensure the DR solution works effectively.

### Workstream 4: Training and Knowledge Transfer
- Operations Training: Provide training sessions for the healthcare provider’s team to manage and operate the new system.
- Documentation and SOP Transfer: Develop and hand over Standard Operating Procedures (SOPs) to support the internal team in managing the infrastructure.



## 3. Live demo
Check out this repository https://github.com/anhdungadg/aws-tf-healthcare and run.

```
$ terraform init
$ terraform plan
$ terraform apply
```

* Remember: Update `s3_policy_notprincipal` for your IAM user value.

_In best scenario: Creation complete after 15m3s._


## 4. Conclusion
The "Cloud Migration with Security and Compliance Focus" project will ensure the healthcare provider achieves a secure, compliant cloud environment that adheres to healthcare regulations, provides fast disaster recovery, and supports flexible infrastructure growth for the future.
