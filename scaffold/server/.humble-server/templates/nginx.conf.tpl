
events {}

http {

    # Include the apps configuration files
    include /etc/nginx/sites-enabled/*.conf;

    # Default Server
    server {
        listen 80 default_server;
        location / {
            root /etc/nginx/default-website;
        }
    }

}
