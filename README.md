 DevOps EC2 Automation Project

## Objective
Deploy the Spring Boot app on AWS EC2 using Java 21, Maven, and Ubuntu 22.04 with port 80 open — as part of the Techeazy DevOps Assignment.

## 📁 Project Structure

.

├── terraform/               
│ ├── main.tf            
│ ├── variables.tf               
│ ├── outputs.tf                   
├── scripts/                    
│ └── user_data.sh           


---

## 🛠️ Tools Used

- **Terraform**
- **AWS EC2, IAM, S3**
- **Maven**
- **Java (OpenJDK 21)**
- **Ubuntu 22.04 AMI**
- **Bash scripting**

---

## 🧩 Features

### ✅ EC2 Automation (Assignment 1)
- Launches a new EC2 instance
- Installs:
  - Java 21 (`openjdk-21-jdk`)
  - Maven
- Clones the test repo: [GitHub – Trainings-TechEazy/test-repo-for-devops](https://github.com/Trainings-TechEazy/test-repo-for-devops)
- Builds the app using `mvn clean package`
- Runs the JAR file on port 80
- Accessible via: `http://<EC2-PUBLIC-IP>:80/hello`

### ✅ S3 & IAM Automation (Assignment 2)
- Creates two IAM roles:
  - `S3ReadOnlyRole` – Allows listing and reading from S3
  - `S3WriteOnlyRole` – Allows creating and writing to S3
- Attaches `S3WriteOnlyRole` to EC2 using an instance profile
- Creates a **private S3 bucket** (name is configurable)
- Uploads logs:
  - `/var/log/cloud-init.log`
  - Application JAR log (`hellomvc-0.0.1-SNAPSHOT.jar`)
- Adds **S3 lifecycle rule** to delete logs after 7 days

---

## 📦 Variables

Defined in `variables.tf`:

| Variable       | Default                       | Description                        |
|----------------|-------------------------------|------------------------------------|
| `region`        | `ap-south-1`                 | AWS region                         |
| `bucket_name`   | `ashrith-devops-app-logs`    | S3 bucket name                     |
| `instance_type` | `t2.micro`                   | EC2 instance type (free tier)      |
| `ami_id`        | `ami-0f5ee92e2d63afc18`      | Ubuntu 22.04 (Mumbai)              |
| `key_name`      | `ashrith`                    | Your EC2 key pair name             |
| `stage`         | `dev`                        | Stage name used in resource names  |

---

## 🚀 How to Deploy

### 🔧 1. Pre-requisites
- AWS CLI configured (`aws configure`)
- Terraform installed
- Valid key pair exists in AWS (`ashrith.pem`)

### 📌 2. Deploy

```bash
cd terraform/
terraform init
terraform apply -auto-approve
