server {
    listen 80;
    server_name $PROJECT_HOST;
    location / {
        proxy_set_header        Host $host;
        proxy_set_header        X-Real-IP $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header        X-Forwarded-Proto $scheme;
        proxy_pass http://$SERVER_IP:$PROJECT_PORT;
    }
}
