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

### Python TK app

You will not be able to get an X11-based docker container to display on a non-X11 display. If you want this docker container to be able to open windows to your display, you'll need to be running X11. There are server implementations for both Windows and OSX.

There is no universal display protocol where a server can send information to any display on any OS. X11 does a great job of solving this in the *nix word -- any docker container can open windows on any other *nix system (which uses X11), but both windows and the mac use different display technologies. 

&nbsp;
## R
For the R ecosystem the Rocker project has a list of previous R versions packed up into docker images:
https://hub.docker.com/layers/rocker/r-ver/4.2.2/images/sha256-6d025464b936c92b0e159a847b153464aac90ce13dd7cfe91073ebaa7babfb04?context=explore


## 03 minimal R 
Very similar setup to 01_python... from above. Just used a rocker base image and another entrypoint (Rscript in linux).

```docker
C:\dev\devops\test_docker\03-docker_minimal>docker build -t 03-docker_r_minimal .
[+] Building 11.8s (8/8) FINISHED
 => [internal] load build definition from Dockerfile                                                                                                                       0.0s
 => => transferring dockerfile: 123B                                                                                                                                       0.0s
 => [internal] load .dockerignore                                                                                                                                          0.0s
 => => transferring context: 2B                                                                                                                                            0.0s
 => [internal] load metadata for docker.io/rocker/r-ver:4.2.2                                                                                                             11.5s
 => [internal] load build context                                                                                                                                          0.0s
 => => transferring context: 175B                                                                                                                                          0.0s
 => [1/3] FROM docker.io/rocker/r-ver:4.2.2@sha256:39696cf75761315d12d969643a7cc6e4430273b4f4f1044b04dc52a20956244c                                                        0.0s
 => CACHED [2/3] WORKDIR /app                                                                                                                                              0.0s
 => [3/3] COPY . .                                                                                                                                                         0.0s
 => exporting to image                                                                                                                                                     0.1s
 => => exporting layers                                                                                                                                                    0.0s
 => => writing image sha256:bc54259ca6f22a41575ee0ddeca5017eccfcfe502bfa8ad0cd7ebdd2647130a6                                                                               0.0s
 => => naming to docker.io/library/03-docker_r_minimal                                                                                                                     0.0s

Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them

C:\dev\devops\test_docker\03-docker_minimal>docker run 03-docker_r_minimal
[1] "R says hello from within my docker world!"
```

## 04 R project with RENV requirements
This time we have a minimalistic R project with RENV setup (only data.table is tracked by renv) in our windows dev environment and we want to dockerize it.

The docker file has some specific sections for this:
```
COPY ./src/renv.lock .

RUN mkdir -p renv
COPY ./src/.Rprofile .Rprofile
COPY ./src/renv/activate.R renv/activate.R
#COPY ./src/renv/settings.json renv/settings.json # not needed
RUN R -e "renv::restore()"
```

Note that simply setting the RENV_LIBRARIES_PATH did not work in my case. RENV did not restore to the proper folder.

The build caches the RENV as long as the renv.lock sha does not change. However, if it does, it restores the ENTIRE RENV which can be painfully slow.

```docker
C:\dev\devops\test_docker\04_r_renv>docker build -t 04_r_renv .
[+] Building 1.0s (14/14) FINISHED
 => [internal] load build definition from Dockerfile                                                                                                                       0.0s
 => => transferring dockerfile: 446B                                                                                                                                       0.0s
 => [internal] load .dockerignore                                                                                                                                          0.0s
 => => transferring context: 2B                                                                                                                                            0.0s
 => [internal] load metadata for docker.io/rocker/r-ver:4.2.2                                                                                                              0.6s
 => [1/9] FROM docker.io/rocker/r-ver:4.2.2@sha256:39696cf75761315d12d969643a7cc6e4430273b4f4f1044b04dc52a20956244c                                                        0.0s
 => [internal] load build context                                                                                                                                          0.1s
 => => transferring context: 2.27MB                                                                                                                                        0.1s
 => CACHED [2/9] RUN R -e "install.packages('renv', repos = c(CRAN = 'https://cloud.r-project.org'))"                                                                      0.0s
 => CACHED [3/9] WORKDIR /app                                                                                                                                              0.0s
 => CACHED [4/9] COPY ./src/renv.lock .                                                                                                                                    0.0s
 => CACHED [5/9] RUN mkdir -p renv                                                                                                                                         0.0s
 => CACHED [6/9] COPY ./src/.Rprofile .Rprofile                                                                                                                            0.0s
 => CACHED [7/9] COPY ./src/renv/activate.R renv/activate.R                                                                                                                0.0s
 => CACHED [8/9] RUN R -e "renv::restore()"                                                                                                                                0.0s
 => [9/9] COPY ./src/* .                                                                                                                                                   0.1s
 => exporting to image                                                                                                                                                     0.1s
 => => exporting layers                                                                                                                                                    0.1s
 => => writing image sha256:541aa865f92cc6e80e5269d9aaf33aeb18104fca7b977bc891610a31e53ef762                                                                               0.0s
 => => naming to docker.io/library/04_r_renv                                                                                                                               0.0s

Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them

C:\dev\devops\test_docker\04_r_renv>docker run 04_r_renv
[1] "I did some data.table stuff and am now showing the lowest mpg car:"
[1] "Cadillac Fleetwood"
```