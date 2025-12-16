#!/bin/bash
ENV=${1:-dev}

echo "Loading $ENV environment..."

# Copy the correct .env file
case $ENV in
  dev)
    cp env/dev.env .env
    COMPOSE_FILES="-f docker-compose.yml -f docker-compose.override.yml"
    ;;
  staging)
    cp env/staging.env .env
    COMPOSE_FILES="-f docker-compose.yml"
    ;;
  prod)
    cp env/prod.env .env
    COMPOSE_FILES="-f docker-compose.yml -f docker-compose.prod.yml"
    ;;
  *)
    echo "Usage: ./run.sh [dev|staging|prod]"
    exit 1
    ;;
esac

# Stop and start
docker-compose down 2>/dev/null
docker-compose $COMPOSE_FILES up -d --build

echo ""
echo "✅ $ENV environment started!"
echo "Wait 30 seconds, then test with: curl http://localhost:8000/health"
