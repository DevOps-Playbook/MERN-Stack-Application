# Observability Setup

## Metrics vs Monitoring

Metrics are measurements or data points that tell you what is happening. For example, the number of steps you walk each day, your heart rate, or the temperature outside—these are all metrics.

Monitoring is the process of keeping an eye on these metrics over time to understand what’s normal, identify changes, and detect problems. It's like watching your step count daily to see if you're meeting your fitness goal or checking your heart rate to make sure it's in a healthy range.

## 🚀 Prometheus
- Prometheus is an open-source systems monitoring and alerting toolkit originally built at SoundCloud.
- It is known for its robust data model, powerful query language (PromQL), and the ability to generate alerts based on the collected time-series data.
- It can be configured and set up on both bare-metal servers and container environments like Kubernetes.

## 🏠 Prometheus Architecture
- The architecture of Prometheus is designed to be highly flexible, scalable, and modular.
- It consists of several core components, each responsible for a specific aspect of the monitoring process.

![prometheus-architecture](https://github.com/user-attachments/assets/6ef039e0-ee11-4fda-a153-b9b52244df4a)

### 🖥️ Prometheus Web UI
- The Prometheus Web UI allows users to explore the collected metrics data, run ad-hoc PromQL queries, and visualize the results directly within Prometheus.

### 📊 Grafana
- Grafana is a powerful dashboard and visualization tool that integrates with Prometheus to provide rich, customizable visualizations of the metrics data.

### 🔌 API Clients
- API clients interact with Prometheus through its HTTP API to fetch data, query metrics, and integrate Prometheus with other systems or custom applications.

# 🛠️  Installation & Configurations
### 📦 Step 1: Create A kubernetes Cluster - FOr this demo we will work on EKS 

```bash
git clone https://github.com/DevOps-Playbook/MERN-Stack-Application.git
cd EKS-CLuster/
```

### 🧰 Step 2: Deploy the Cluster
```bash
Root Module (main.tf)
├── VPC Module
│   ├── 1. VPC Resource
│   ├── 2. Internet Gateway
│   ├── 3. Public Subnets (2)
│   ├── 4. Private Subnets (2)
│   ├── 5. NAT Gateway (in public subnet)
│   ├── 6. Route Tables (public & private)
│   └── 7. Route Table Associations
│
└── EKS Cluster Module
    ├── 8. EKS Cluster
    ├── 9. IAM Role for EKS
    ├── 10. Security Group for EKS
    ├── 11. Node Group(s)
    ├── 12. IAM Role for Node Group
    ├── 13. Node Group Security Group
    └── 14. AutoScaling Group for Nodes
```

### 🚀 Step 3: Install Prometheus

[Prometheus Setup ](https://github.com/DevOps-Playbook/MERN-Stack-Application/blob/main/Monitoring/prometheus/README.md)

### 🧰 Step 4: Install Grafana Chart

[Grafana Setup ](https://github.com/DevOps-Playbook/MERN-Stack-Application/blob/main/Monitoring/grafana/README.md)


