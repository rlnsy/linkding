# Step 1: build static ui files
FROM node:12 as static
WORKDIR /app
COPY . .
RUN ls
RUN npm install
RUN npm run build

FROM python:3.7-slim-stretch

# Install packages required for uswgi
RUN apt-get update
RUN apt-get -y install build-essential
RUN apt-get -y install mime-support

# Install requirements and uwsgi server for running python web apps
WORKDIR /etc/linkding
COPY requirements.prod.txt ./requirements.prod.txt
COPY requirements.txt ./requirements.txt
RUN pip install -U pip
RUN pip install -Ur requirements.txt
RUN pip install -Ur requirements.prod.txt

# Copy and collect static files
COPY --from=static /app .
RUN ls
RUN python manage.py compilescss
RUN python manage.py collectstatic --ignore=*.scss
RUN python manage.py compilescss --delete-files

# Expose uwsgi server at port 9090
EXPOSE 9090

# Run bootstrap logic
RUN ["chmod", "+x", "./bootstrap.sh"]
CMD ["./bootstrap.sh"]
