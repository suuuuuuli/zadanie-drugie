# -----------------------
# Etap 1: Budowanie zależności
# -----------------------
FROM python:3.11-alpine AS builder

LABEL org.opencontainers.image.authors="Jakub Kozak <cozzac@example.com>"

RUN apk update \
    && apk add --no-cache --virtual .build-deps \
       build-base \
       libffi-dev \
       openssl-dev \
    && rm -rf /var/cache/apk/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --prefix=/install -r requirements.txt

# -----------------------
# Etap 2: Finalny obraz
# -----------------------
FROM python:3.11-alpine

LABEL org.opencontainers.image.authors="Jakub Kozak <cozzac@example.com>"
LABEL org.opencontainers.image.source="https://github.com/TwojeRepozytorium/weather"
LABEL org.opencontainers.image.description="Prosta aplikacja pogodowa Flask uruchamiana w kontenerze Docker."

RUN apk update \
    && apk add --no-cache curl \
    && rm -rf /var/cache/apk/*

WORKDIR /app

COPY --from=builder /install /usr/local
COPY . .

ENV PORT=5000
EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/ || exit 1

CMD ["python", "wthr.py"]
