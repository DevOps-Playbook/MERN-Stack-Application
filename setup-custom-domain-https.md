## Deploying MERN App on Custom Subdomain with HTTPS

> This documents the steps taken to expose a MERN Stack app (running via Docker Compose on an AWS EC2) at https://nishant.devops-playbook.in.

### Prerequisites

1. MERN app running via docker compose on EC2 (frontend on port 5173, backend on port 5002)
2. Domain devops-playbook.in registered on Hostinger, DNS managed by Wix
3. EC2 instance with a public IP


**Step 1: Add DNS A Record in Wix**
Since devops-playbook.in uses Wix nameservers (ns14.wixdns.net), DNS records must be added in Wix — not Hostinger.

1. Go to manage.wix.com
2. Navigate to Settings → Domains → DNS Records
3. Under A (Host), click + Add Record
4. Fill in: FieldValueHost NamenishantPoints to3.133.59.141TTL1 Week

<img width="921" height="75" alt="Screenshot 2026-05-28 at 11 54 36 AM" src="https://github.com/user-attachments/assets/b105d159-a0b8-418b-af5b-d69e963950fc" />

5. Click Save Changes
6. Verify propagation from EC2:
7. bashnslookup nishant.devops-playbook.in --> **Should return: Address: 3.133.59.141**


**Step 2: Open Ports in AWS Security Group**
1. In AWS Console → EC2 → Security Groups → Inbound Rules, add:
2. TypePortSourceHTTP800.0.0.0/0HTTPS4430.0.0.0/0Custom TCP50020.0.0.0/0SSH22your IP

**Step 3: Install and Configure Nginx**
**1. install nginx**
```bash
sudo apt update && sudo apt install nginx -y
sudo systemctl enable nginx
```
**2. Create the site config:**

```bash
sudo nano /etc/nginx/sites-available/nishant.devops-playbook.in
```

```bash
nginxserver {
    listen 80;
    server_name nishant.devops-playbook.in;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name nishant.devops-playbook.in;

    ssl_certificate /etc/letsencrypt/live/nishant.devops-playbook.in/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/nishant.devops-playbook.in/privkey.pem;

    # Frontend
    location / {
        proxy_pass http://localhost:5173;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    # Backend API
    location /api/ {
        proxy_pass http://localhost:5002/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

**3. Enable and reload:**
```bash
sudo ln -s /etc/nginx/sites-available/nishant.devops-playbook.in /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

**Step 5: Issue SSL Certificate with Certbot**
```bash
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d nishant.devops-playbook.in
```
Certbot will automatically update the Nginx config and set up auto-renewal. Certificate expires every 90 days and renews automatically.

**Step 6: Update Frontend Environment**
**1. frontend/.env.docker**

```bash 
VITE_API_PATH="https://nishant.devops-playbook.in/api"
```
1. This avoids browser Mixed Content errors (HTTPS frontend calling HTTP backend).
2. Backend .env.docker requires no changes:
```bash
bashMONGODB_URI="mongodb://mongo/wanderlust"
REDIS_URL="redis://redis:6379"
```

**Step 7: Rebuild Docker Containers**
```bash
docker compose down
docker compose up -d --build
```

## Final Architecture
```bash
User → https://nishant.devops-playbook.in
           │
           ▼
      EC2 Nginx :443 (SSL)
           │
           ├── /        → localhost:5173 (Frontend container)
           └── /api/    → localhost:5002 (Backend container)
                              │
                         ┌────┴────┐
                       MongoDB   Redis
                    (container) (container)
```

**Result**

* https://nishant.devops-playbook.in — Frontend ✅
* https://nishant.devops-playbook.in/api — Backend API ✅
* SSL certificate auto-renews via Certbot ✅
