# PrestaShop Local Setup — Payment Testing

Run PrestaShop 8 locally on Mac for payment module testing.

## Prerequisites

- [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop/) — install and start it first

## Quick Start

```bash
git clone https://github.com/hrsabnis-cloud/RapydTest_Presta.git
cd RapydTest_Presta
chmod +x setup-mac.sh
./setup-mac.sh
```

First run takes **3–5 minutes** while Docker pulls images and PrestaShop auto-installs.

## URLs

| Service | URL |
|---|---|
| Storefront | http://localhost:8080 |
| Back Office | http://localhost:8080/admin_test |
| phpMyAdmin | http://localhost:8081 |

## Credentials

**Back Office admin:**
- Email: `admin@example.com`
- Password: `Admin1234!`

**Database:**
- Host: `127.0.0.1:3306`
- Database: `prestashop_db`
- User: `prestashop_user`
- Password: `prestashop_pass`

## Payment Module Setup (Sandbox)

### Option 1 — Rapyd Payment Module

1. Log into Back Office → **Modules → Module Manager**
2. Upload the Rapyd module zip (from your Rapyd developer portal)
3. Click **Configure** on the Rapyd module
4. Enter your **Sandbox** API keys from https://dashboard.rapyd.net
5. Set mode to **Sandbox**

**Rapyd sandbox test cards:**

| Card Number | Type | Result |
|---|---|---|
| 4111 1111 1111 1111 | Visa | Success |
| 5500 0000 0000 0004 | Mastercard | Success |
| 4000 0000 0000 0002 | Visa | Decline |

CVV: any 3 digits · Expiry: any future date

### Option 2 — Stripe (built-in test module)

1. Back Office → **Modules → Module Manager** → search "Stripe"
2. Install and configure with Stripe test keys from https://dashboard.stripe.com/test
3. Use test card: `4242 4242 4242 4242`, any future expiry, any CVV

### Option 3 — Check/Wire (no card needed)

PrestaShop ships with "Payment by check" — works out of the box for flow testing without any card.

## Common Commands

```bash
# View logs
docker compose logs -f prestashop

# Stop everything
docker compose down

# Stop and wipe all data (full reset)
docker compose down -v

# Restart
docker compose restart

# Shell into PrestaShop container
docker exec -it prestashop_app bash

# Shell into DB
docker exec -it prestashop_db mariadb -u prestashop_user -pprestashop_pass prestashop_db
```

## Troubleshooting

**Blank page / 500 error on first load:**  
The auto-installer is still running. Wait 2–3 more minutes and refresh.

**Port 8080 already in use:**  
Edit `docker-compose.yml`, change `"8080:80"` to `"8090:80"`, then `docker compose up -d`.

**PrestaShop shows install page again after restart:**  
Run `docker exec prestashop_app rm -rf /var/www/html/install` to remove the installer.

**Database connection error:**  
MariaDB may still be starting. Run `docker compose logs mariadb` to check.
