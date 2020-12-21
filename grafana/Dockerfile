FROM grafana/grafana
RUN mkdir -p /etc/grafana/provisioning/datasources/ && \
    mkdir -p /etc/grafana/provisioning/dashboards/
# Dashboards provisioning config
COPY ./grafana/dashboards.yaml /etc/grafana/provisioning/dashboards/dashboards.yaml
# Copy dashboards
# COPY ./grafana/dashboards/*.json /etc/grafana/provisioning/dashboards/
# Datasources provisioning config
COPY ./grafana/datasources.yaml /etc/grafana/provisioning/datasources/datasources.yaml
# Grafana config
COPY ./grafana/grafana.ini /var/lib/grafana/grafana.ini