FROM golang:alpine AS build

WORKDIR /go/src/app

ENV USER=go \
    UID=1000 \
    GID=1000 \
    GOOS=linux \
    GOARCH=amd64 \
    CGO_ENABLED=0

COPY . .

RUN go build -ldflags="-w -s" -o mcbroken-exporter && \
  addgroup --gid "$GID" "$USER" && \
  adduser \
  --disabled-password \
  --gecos "" \
  --home "$(pwd)" \
  --ingroup "$USER" \
  --no-create-home \
  --uid "$UID" \
  "$USER" && \
  chown "$UID":"$GID" /go/src/app/mcbroken-exporter

FROM scratch
COPY --from=build /etc/passwd /etc/group /etc/
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /go/src/app/mcbroken-exporter /
USER 1000
ENTRYPOINT ["/mcbroken-exporter"]