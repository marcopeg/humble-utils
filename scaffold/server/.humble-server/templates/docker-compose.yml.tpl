version: '2'
services:
    proxy:
        image: nginx
        volumes:
            - ./nginx.conf:/etc/nginx/nginx.conf
            - ./sites-enabled:/etc/nginx/sites-enabled
            - ./default-website:/etc/nginx/default-website
        ports:
            - ${SERVER_PORT}:80
