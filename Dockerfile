FROM python:3.5-buster

EXPOSE 8080

ARG workspace="none"

RUN apt-get update \
    && apt-get install --assume-yes wget bash-completion unzip

RUN wget https://codejudge-starter-repo-artifacts.s3.ap-south-1.amazonaws.com/backend-project/database/db-setup.sh
RUN chmod 775 ./db-setup.sh
RUN sh db-setup.sh

# Install Workspace for Python 

RUN if [ $workspace = "theia" ] ; then \
	wget -O pre-build-theia.sh https://codejudge-starter-repo-artifacts.s3.ap-south-1.amazonaws.com/theia/pre-build.sh \
    && chmod 775 ./pre-build-theia.sh && sh pre-build-theia.sh ; fi

WORKDIR /var/


RUN if [ $workspace = "theia" ] ; then \
	wget https://codejudge-starter-repo-artifacts.s3.ap-south-1.amazonaws.com/theia/build.sh \
    && chmod 775 ./build.sh && sh build.sh ; fi

# Get RUN Script

WORKDIR /var/theia/

RUN if [ $workspace = "theia" ] ; then \
	wget https://codejudge-starter-repo-artifacts.s3.ap-south-1.amazonaws.com/theia/run.sh \
    && chmod 775 ./run.sh ; fi

# End Install for Workspace  

RUN mkdir -p /var/app

WORKDIR /var/app

ADD requirements.txt /var/app

# Build the app
RUN wget https://codejudge-starter-repo-artifacts.s3.ap-south-1.amazonaws.com/backend-project/python/build.sh
RUN chmod 775 ./build.sh
RUN sh build.sh

ADD . .

# Run the app
RUN wget https://codejudge-starter-repo-artifacts.s3.ap-south-1.amazonaws.com/backend-project/python/run.sh
RUN chmod 775 ./run.sh
CMD sh run.sh
