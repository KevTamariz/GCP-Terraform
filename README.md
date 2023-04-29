# GCP-Terraform

In this repository you're going to find the code of the infrastructure that i created for project

Infrastructure created:
- Set backend for terrarom state
- Provider (GCP)
- Service account for resources
- Default VPC (import)
- Default subnet (import)
- IP's:
    - MIG
    - Ingress my app
    - Ingress guestbook
- Manage instance group
- Autoscaler
- LoadBalancer
    - Target proxy https
    - URL Map 
    - Backend Service
    - Health check
    - Forwarding rule
- DNS Zone
    - DNS Records:
    - MIG
    - My app kubernetes
    - Guestbook kubernetes
- GKE Cluster
    - Node1
    - Node2
    
