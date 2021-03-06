# mcbroken-dashboard <img src="https://i.imgur.com/tyKUBDv.png" height="5%" width="5%" align="left"/>

Entry for digitalocean app platform hackathon. Deploy your own by clicking the button below!

[![Deploy to DO](https://mp-assets1.sfo2.digitaloceanspaces.com/deploy-to-do/do-btn-blue.svg)](https://cloud.digitalocean.com/apps/new?repo=https://github.com/circa10a/mcbroken-dashboard/tree/main)

![Build Status](https://github.com/circa10a/digitalocean-hackathon/workflows/deploy/badge.svg)

<img src="https://i.imgur.com/4Ib3Z8G.jpg" height="50%" width="50%" align="right"/>

## Mcbroken Dashboard Overview

The mcbroken dashboard is an app template of 3 applications(listed below) which pre-configure a dashboard that is powered by [mcbroken.com](https://mcbroken.com). It's purpose is to provide availability information of all the broken Mcdonald's ice cream machines in the United States.

Stats include:

- Current broken percentage of mcdonald's ice cream machines in the US
- City with the most broken machines and it's outage percentage
- Outage percentage of most major US cities

## Screenshots

### Desktop view

<img src="https://i.imgur.com/okz3zQO.png" height="70%" width="70%"/>

### Mobile view

<img src="https://i.imgur.com/I5tkTQi.png" height="30%" width="30%"/>

## Components

There are 3 components(services) that make up this application.

- [mcbroken exporter](#mcbroken-exporter)
- [prometheus](#prometheus)
- [grafana](#grafana)

### Mcbroken exporter

Access the exporter metrics here: https://mcbroken-dashboard-t7vfw.ondigitalocean.app/mcbroken/metrics

The primary component is a custom prometheus exporter that collects data from [mcbroken.com](https://mcbroken.com)

Technical components(go files) are located in the root of the repo and is deployed via the go buildpack.

#### Development

```bash
# build
make build
# run (listens on 8080)
make run
# docker build
make docker-build
# docker run
make docker-run
```

Accessible at http://localhost:8080/metrics

### Prometheus

Access prometheus here: https://mcbroken-dashboard-t7vfw.ondigitalocean.app/

> It's worth nothing that stateful workloads such as prometheus are not ideal for the digitalocean app platform in its current state as of 12/2020. This is due to prometheus needing persistent storage to reliably hold data. The app platform currently only supports ephemeral storage. Prometheus would be better served on a droplet, but it was a good learning experience to wire up all of these componentes together on the app platform.

[Prometheus](https://prometheus.io/) is an an open source time series database that scrapes our custom exporter on short intervals and holds the data for 15 days by default.

Prometheus application and deployment configuration is housed in the [prometheus directory](/prometheus) and is deployed via [Dockerfile](/prometheus/Dockerfile).

### Grafana

Access Grafana here: https://mcbroken-dashboard-t7vfw.ondigitalocean.app/grafana

[Grafana](https://grafana.com/) is an open source dashboard front end that has the ability to connect to a variety of different data sources such as prometheus. Grafan application and deployment configuration is housed in the [grafana directory](/grafana) and is deployed via [Dockerfile](/grafana/Dockerfile).

## Deployment

Deployments are handled by github actions in the [.github/workflows directory](/.github/workflows) by using the [digitalocean CLI(doctl)](https://www.digitalocean.com/docs/apis-clis/doctl/how-to/install/) to update [the app template](/deployment.yaml) for all of the components.

<img src="https://i.imgur.com/t1N6bjH.png" height="80%" width="80%"/>
