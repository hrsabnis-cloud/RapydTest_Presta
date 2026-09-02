#!/bin/bash
# PrestaShop Local Setup Script for Mac
# Requires: Docker Desktop for Mac (https://www.docker.com/products/docker-desktop/)

set -e

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

echo -e "${GREEN}=== PrestaShop Local Setup ===${NC}"

# Check Docker
if ! command -v docker &>/dev/null; then
  echo -e "${RED}Docker not found. Install Docker Desktop: https://www.docker.com/products/docker-desktop/${NC}"
  exit 1
fi
if ! docker info &>/dev/null; then
  echo -e "${RED}Docker Desktop is not running. Start it from your Applications folder.${NC}"
  exit 1
fi
echo -e "${GREEN}✓ Docker is running${NC}"

# Create modules directory for custom modules
mkdir -p modules

# Pull images ahead of time for faster startup
echo -e "${YELLOW}Pulling Docker images (this may take a few minutes on first run)...${NC}"
docker compose pull

# Start services
echo -e "${YELLOW}Starting services...${NC}"
docker compose up -d

echo ""
echo -e "${GREEN}=== Services Starting ===${NC}"
echo "PrestaShop auto-installation takes 3-5 minutes on first launch."
echo "Watch progress: docker compose logs -f prestashop"
echo ""
echo -e "${YELLOW}Waiting for PrestaShop to become ready...${NC}"

# Wait for PrestaShop to be up (up to 10 minutes)
MAX_WAIT=600
ELAPSED=0
while [ $ELAPSED -lt $MAX_WAIT ]; do
  STATUS=$(docker inspect --format='{{.State.Health.Status}}' prestashop_app 2>/dev/null || echo "starting")
  if [ "$STATUS" = "healthy" ]; then
    break
  fi
  HTTP=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/ 2>/dev/null || echo "0")
  if [ "$HTTP" = "200" ] || [ "$HTTP" = "302" ]; then
    break
  fi
  sleep 10
  ELAPSED=$((ELAPSED + 10))
  echo -ne "\rWaiting... ${ELAPSED}s elapsed (up to ${MAX_WAIT}s)"
done
echo ""

echo ""
echo -e "${GREEN}=== PrestaShop is Ready! ===${NC}"
echo ""
echo -e "  Storefront:    ${GREEN}http://localhost:8080${NC}"
echo -e "  Back Office:   ${GREEN}http://localhost:8080/admin_test${NC}"
echo -e "  phpMyAdmin:    ${GREEN}http://localhost:8081${NC}"
echo ""
echo "  Admin Login:"
echo "    Email:    admin@example.com"
echo "    Password: Admin1234!"
echo ""
echo "  Database:"
echo "    Host:     127.0.0.1:3306"
echo "    Name:     prestashop_db"
echo "    User:     prestashop_user"
echo "    Password: prestashop_pass"
echo ""
echo -e "${YELLOW}Next: Enable Rapyd payment module — see README.md${NC}"
