# docker_tryouts
 Testing docker with python and R

&nbsp;
## Pre-reading
General docker intro:
- https://docs.docker.com/get-started/

&nbsp;
## Python
Python specific docker information:
- https://docs.docker.com/language/python/
     BuildKit allows you to build Docker images efficiently. If you have installed Docker Desktop, you don’t have to manually enable BuildKit. 

Python docker hub page containing images & instructions:
- https://hub.docker.com/_/python
  

&nbsp;
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

run container interactively:

    λ docker run -it --entrypoint /bin/bash 01-python-command_line-single_container
    root@079973096f60:/app# ls
    Dockerfile  src
    root@079973096f60:/app# python ./src/main.py
    hello from within my docker world!
    root@079973096f60:/app#

- as the docker file has an entrypoint defined you need to define a new one for the interactive terminal

ATTENTION: even this simple image is already quite big: 884MB!

    λ docker image ls
    REPOSITORY                                TAG         IMAGE ID       CREATED          SIZE
    01-python-command_line-single_container   latest      b1dbb410ac3c   2 minutes ago    884MB

&nbsp;
### 02. python flask application with requirements
- makes use of pip install 'requirements'

local development:

    λ python -m venv .venv
    λ .venv\Scripts\activate.bat
    (.venv) λ pip3 install Flask

    --> write code in src/app.py

    (.venv) λ cd src\
    python3 -m flask run

dockerfile:

    FROM python:3.8.11

    WORKDIR /app

    COPY requirements.txt requirements.txt
    RUN pip3 install -r requirements.txt

    COPY . .

    WORKDIR /app/src
    CMD [ "python", "-m", "flask", "run", "--host=0.0.0.0" ]

- copy in the requirements file before the code
- pip the requirements before the code (faster image rebuilts!!!)

build image:

    docker build -t 02-python-flask .

run container:

    λ docker run -d -p 5000:5000 02-python-flask

- run in detached mode -d
- run using port forwarding  

&nbsp;

### Docker TK app

You will not be able to get an X11-based docker container to display on a non-X11 display. If you want this docker container to be able to open windows to your display, you'll need to be running X11. There are server implementations for both Windows and OSX.

There is no universal display protocol where a server can send information to any display on any OS. X11 does a great job of solving this in the *nix word -- any docker container can open windows on any other *nix system (which uses X11), but both windows and the mac use different display technologies. 

&nbsp;
## R
to be completed 