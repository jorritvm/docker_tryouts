# docker_tryouts
 Testing docker

## Pre-reading
General docker intro:
- https://docs.docker.com/get-started/


## Python
Python specific docker information:
- https://docs.docker.com/language/python/
     BuildKit allows you to build Docker images efficiently. If you have installed Docker Desktop, you don’t have to manually enable BuildKit. 

Python docker hub page containing images & instructions:
- https://hub.docker.com/_/python

### 01. python command line application
- Simple hello world commandline application to test docker for python.  
- Has source code in the container

dockerfile:

    FROM python:3.8.11
    WORKDIR /app
    COPY . .
    CMD [ "python", "src/main.py" ]

build image:

    docker build -t 01-python-command_line-single_container .

run container:

    λ docker run 01-python-command_line-single_container
    hello from within my docker world!

it works! and now interactively:

    λ docker run -it --entrypoint /bin/bash 01-python-command_line-single_container
    root@079973096f60:/app# ls
    Dockerfile  src
    root@079973096f60:/app# python ./src/main.py
    hello from within my docker world!
    root@079973096f60:/app#

ATTENTION: even this simple image is already quite big: 884MB!

    λ docker image ls
    REPOSITORY                                TAG         IMAGE ID       CREATED          SIZE
    01-python-command_line-single_container   latest      b1dbb410ac3c   2 minutes ago    884MB

### 02. python flask application with requirements
- makes use of pip install 'requirements'

