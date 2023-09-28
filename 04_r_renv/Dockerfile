FROM rocker/r-ver:4.2.2

RUN R -e "install.packages('renv', repos = c(CRAN = 'https://cloud.r-project.org'))"

WORKDIR /app

COPY ./src/renv.lock .

RUN mkdir -p renv
COPY ./src/.Rprofile .Rprofile
COPY ./src/renv/activate.R renv/activate.R
#COPY ./src/renv/settings.json renv/settings.json # not needed
RUN R -e "renv::restore()"

COPY ./src/* .

#CMD /bin/bash
CMD [ "Rscript", "main.R" ]