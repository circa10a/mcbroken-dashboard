FROM grafana/grafana
RUN mkdir -p /etc/grafana/provisioning/datasources/
COPY ./grafana/datasources.yaml /etc/grafana/provisioning/datasources/datasources.yaml
COPY ./grafana/grafana.ini /var/lib/grafana/grafana.ini