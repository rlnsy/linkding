FROM nginx:1.15-alpine
COPY ./nginx.local.conf /etc/nginx/nginx.conf
COPY ./uwsgi_params /uwsgi_params
RUN mkdir /etc/ssl/linkding
