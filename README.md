Branch Loan API - Production-Ready DevOps Implementation
## Overview
A production-ready Flask API for microloans with complete DevOps infrastructure. This solution transforms a basic Flask application into a scalable, automated, and secure system with containerization, multi-environment support, CI/CD automation, and comprehensive documentation.

## Features
 HTTPS with Custom Domain - Secure API access via https://branchloans.com

 Multi-Environment Support - Development, Staging, Production configurations

 Automated CI/CD Pipeline - GitHub Actions with security scanning

 Docker Containerization - Consistent deployments across environments

 Production Monitoring - Health checks, structured logging, resource limits

 Complete Documentation - Setup, troubleshooting, and architecture guides

 Quick Start
Prerequisites
Docker & Docker Compose

Git

OpenSSL (for certificate generation)

1. Clone and Setup
bash
git clone https://github.com/mimrajmallick/dummy-branch-app
cd dummy-branch-app

# Generate SSL certificates
mkdir -p ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout ssl/branchloans.key -out ssl/branchloans.crt \
  -subj "/CN=branchloans.com"

# Configure local domain
echo "127.0.0.1 branchloans.com" | sudo tee -a /etc/hosts
2. Run with HTTPS
bash
# Start all services with HTTPS
docker-compose up -d --build

# Wait for services to start
sleep 60

# Test the API
curl -k https://branchloans.com/health
# Should return: {"status":"ok"}
## Architecture
Step 1: Secure Connection
When you visit https://branchloans.com, your browser establishes a secure, encrypted connection to our Nginx web server. Think of this as having a private, coded conversation where no one else can listen in.

Step 2: Traffic Management
Nginx acts as a smart traffic director. It handles the heavy lifting of SSL/TLS encryption (the "S" in HTTPS), verifies the security certificate, and then forwards the decrypted request to the right place—in this case, our Flask API application.

Step 3: Business Logic Processing
The Flask API receives your loan application request. This is where the actual business logic lives: it validates your loan amount, checks the interest rate calculation, and prepares the data to be stored. Flask is like the loan officer who reviews your application paperwork.

Step 4: Data Storage
Finally, Flask communicates with the PostgreSQL database to securely save your loan application information. PostgreSQL is our digital filing cabinet—organized, reliable, and designed to keep your data safe and accessible. 
## Multi-Environment Setup
Environment Switching
bash
# Development (port 8001, debug logging, hot reload)
./run.sh dev
curl http://localhost:8001/health

# Production (port 8000, JSON logging, optimized)
./run.sh prod  
curl http://localhost:8000/health
curl -k https://branchloans.com/health
Environment Differences
Environment	Port	Logging	Hot Reload	Database Size	Purpose
Development	8001	Debug	 Enabled	512MB RAM	Local development
Staging	8000	Info	 Disabled	1GB RAM	Pre-production testing
Production	8000	JSON	 Disabled	2GB RAM	Live deployment
## CI/CD Pipeline
Pipeline Stages
 Test - Runs Python tests and validations

 Build - Creates Docker image with Buildx

 Security Scan - Trivy vulnerability scanning (fails on CRITICAL/HIGH)

 Push - Deploys to GitHub Container Registry (ghcr.io)

Trigger Rules
Push to main branch → Full pipeline (test, build, scan, push)

Pull Requests → Test only (no image push)

Manual trigger → Available via GitHub UI

Security Features
Secrets managed via GitHub Secrets (GITHUB_TOKEN)

Images tagged with git commit SHA for traceability

Automatic vulnerability scanning with Trivy

Fail-fast on security issues

## Project Structure
text
dummy-branch-app/
├── .github/workflows/           # CI/CD pipeline configuration
│   └── ci-cd.yml               # GitHub Actions workflow
├── app/                         # Flask application code
│   ├── __init__.py             # Flask app factory
│   ├── models.py               # SQLAlchemy models
│   └── routes.py               # API endpoints
├── env/                         # Environment configurations
│   ├── dev.env                 # Development settings
│   ├── staging.env             # Staging settings
│   └── prod.env                # Production settings
├── nginx/                       # Reverse proxy configuration
│   └── nginx.conf              # Nginx with SSL
├── ssl/                         # SSL certificates
│   ├── branchloans.crt         # Self-signed certificate
│   └── branchloans.key         # Private key
├── scripts/                     # Utility scripts
│   └── seed.py                 # Database seeding
├── alembic/                     # Database migrations
├── docker-compose.yml           # Main Docker Compose file
├── docker-compose.override.yml  # Development overrides
├── docker-compose.prod.yml      # Production overrides
├── Dockerfile                   # Application container
├── requirements.txt             # Python dependencies
├── run.sh                       # Environment switcher
└── README.md                    # This documentation
 Security Implementation
HTTPS Configuration
Self-signed SSL certificates for local development

Nginx as SSL termination proxy

TLS 1.2+ protocol enforcement

HTTP to HTTPS automatic redirection

Container Security
Non-root user execution in containers

Read-only filesystem where possible

Resource limits per environment

Health checks for automatic recovery

Secrets Management
Environment variables for configuration

GitHub Secrets for CI/CD credentials

Never committed to version control

Automatic token rotation support

## API Endpoints
Health Check
bash
GET /health
# Returns: {"status": "ok"}
Loan Management
bash
# List all loans
GET /api/loans

# Get specific loan
GET /api/loans/:id

# Create new loan
POST /api/loans
Content-Type: application/json

{
  "borrower_id": "usr_india_999",
  "amount": 12000.50,
  "currency": "INR",
  "term_months": 6,
  "interest_rate_apr": 24.0
}

# Get statistics
GET /api/stats
## Troubleshooting
Common Issues
API Not Responding
bash
# Check container status
docker-compose ps

# Check API logs
docker-compose logs api

# Restart API service
docker-compose restart api
sleep 30
curl http://localhost:8000/health
HTTPS Certificate Errors
bash
# Regenerate certificates
rm -rf ssl/*
mkdir -p ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout ssl/branchloans.key -out ssl/branchloans.crt \
  -subj "/CN=branchloans.com"

# Restart nginx
docker-compose restart nginx
Database Connection Issues
bash
# Check database health
docker-compose exec db pg_isready -U postgres

# Increase startup wait time
# Edit docker-compose.yml: change "sleep" value to 30+
docker-compose down
docker-compose up -d --build
sleep 60
Verification Steps
bash
# Verify complete setup
echo "1. Containers:"
docker-compose ps

echo ""
echo "2. API Health:"
curl http://localhost:8000/health

echo ""
echo "3. HTTPS Access:"
curl -k https://branchloans.com/health

echo ""
echo "4. All Endpoints:"
curl http://localhost:8000/api/loans
curl http://localhost:8000/api/stats
## Design Decisions
Why Nginx Reverse Proxy?
SSL Termination: Offloads encryption/decryption from application

Load Balancing: Ready for horizontal scaling

Static File Serving: Better performance for future assets

Security Headers: Centralized security configuration

Why Multiple Compose Files?
Separation of Concerns: Base config + environment-specific overrides

Reusability: Same base configuration across environments

Maintainability: Easy to update specific environments

Clarity: Clear differences between dev/staging/prod

Why GitHub Actions?
Native Integration: Built into GitHub, no external services

Cost Effective: Free for public repositories

Extensible: Large marketplace of actions

Familiarity: Common choice for open source projects

## Future Improvements
Short Term (1-2 weeks)
Add Prometheus metrics endpoint

Implement database backup automation

Add API request rate limiting

Create deployment dashboard

Medium Term (1-2 months)
Implement blue-green deployment strategy

Add Kubernetes manifests for orchestration

Integrate with cloud provider (AWS/GCP/Azure)

Add comprehensive API documentation (OpenAPI/Swagger)

Long Term (3-6 months)
Implement service mesh for microservices

Add AI/ML for loan risk assessment

Create mobile client applications

Expand to multiple geographic regions

## Time Investment
Part 1 (Containerization): 1.5 hours

Part 2 (Multi-Environment): 1 hour

Part 3 (CI/CD Pipeline): 1.5 hours

Part 4 (Documentation): 1 hour

Testing & Debugging: 1 hour

Total: ~6 hours

## Contributors
Samim Mallick - DevOps Implementation

Branch Engineering Team - Original Flask API

## License
This project is part of the Branch DevOps Intern Assignment. All code and documentation created for this assignment is available for review and evaluation purposes.

## Useful Links
GitHub Repository: https://github.com/mimrajmallick/dummy-branch-app

CI/CD Pipeline: https://github.com/mimrajmallick/dummy-branch-app/actions

Container Registry: ghcr.io/mimrajmallick/dummy-branch-app

Assignment Requirements: Branch DevOps Intern Take-Home Assignment

## Getting Help
For issues with this setup, please:

Check the troubleshooting section above

Review GitHub Actions logs for CI/CD issues

Contact: mimrajmallick79@gmail.com
