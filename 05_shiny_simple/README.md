
# ShinyProxy Hello Image

The demo Shiny app displays some a slider and a histogram
inspired by the [example-01-hello](https://shiny.rstudio.com/gallery/example-01-hello.html)
Shiny example.

To pull the image made in this repository from
[GitLab Container Registry](https://gitlab.com/analythium/shinyproxy-hello/container_registry), use

```bash
docker pull registry.gitlab.com/analythium/shinyproxy-hello/hello
```

To build the image from the Dockerfile, run

```bash
docker build -t registry.gitlab.com/analythium/shinyproxy-hello/hello .
```

Test locally

```bash
docker run -p 4000:3838 registry.gitlab.com/analythium/shinyproxy-hello/hello
```

then visit `127.0.0.1:4000`. Stop the container with Ctrl+C.

(c) Copyright Analythium Solutions Inc, 2019-2020 (MIT).
