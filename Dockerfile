# Dockerfile
FROM nginx:1.27-alpine

# Copy a minimal site
COPY ./site /usr/share/nginx/html

# Nginx config: health endpoint + sensible defaults
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080
