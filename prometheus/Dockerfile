FROM prom/prometheus
COPY ./prometheus/prometheus.yml /etc/prometheus/prometheus.yml
CMD [ "--web.external-url=$PROM_URL", \
      "--web.route-prefix=/prometheus", \
      "--storage.tsdb.path=/prometheus", \
      "--web.console.libraries=/usr/share/prometheus/console_libraries", \
      "--web.console.templates=/usr/share/prometheus/consoles"]