# get a base image
FROM rocker/r-ver:4.2.2

# update system dependencies required for shiny
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    && rm -rf /var/lib/apt/lists/*

# make sure RENV is installed
RUN R -e "install.packages('renv', repos = c(CRAN = 'https://cloud.r-project.org'))"

# set the workdir
WORKDIR /app

# restore the RENV as the root user still, but make sure the cache does not end up in the root user home folder
COPY renv.lock .

RUN mkdir -p renv/cache
ENV RENV_PATHS_ROOT=./renv/cache

COPY .Rprofile .Rprofile
COPY ./renv/activate.R renv/activate.R

RUN R -e "renv::restore()"

# copy the source data 
COPY app app

# create a non root user to run the app
RUN addgroup --system app \
    && adduser --system --ingroup app app
RUN chown app:app -R /app
USER app

EXPOSE 3838
CMD ["R", "-e", "shiny::runApp('app', port=3838, host='0.0.0.0')"]
