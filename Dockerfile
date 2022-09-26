# syntax=docker/dockerfile:1
FROM --platform=${BUILDPLATFORM:-linux/amd64} golang:1.18 as builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH

WORKDIR /app/
COPY . .
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags="-w -s" -o main main.go

FROM --platform=${TARGETPLATFORM:-linux/amd64} scratch
WORKDIR /app/
COPY --from=builder /app/main /app/main
ENTRYPOINT ["/app/main"]
