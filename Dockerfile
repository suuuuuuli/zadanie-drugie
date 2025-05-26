# -----------------------
# Etap 1: Budowanie zależności
# -----------------------
    FROM python:3.10-slim as builder

    LABEL org.opencontainers.image.authors="Jakuv Kozak <cozzac@example.com>"
    
    WORKDIR /app
    
    COPY requirements.txt .
    RUN pip install --upgrade pip && pip install --prefix=/install -r requirements.txt
    
    # -----------------------
    # Etap 2: Finalny obraz
    # -----------------------
    FROM python:3.10-slim
    
    LABEL org.opencontainers.image.authors="Jakub Kozak <cozzac@example.com>"
    LABEL org.opencontainers.image.source="https://github.com/TwojeRepozytorium/weather"
    LABEL org.opencontainers.image.description="Prosta aplikacja pogodowa Flask uruchamiana w kontenerze Docker."
    
    WORKDIR /app
    
    COPY --from=builder /install /usr/local
    COPY . .
    
    ENV PORT=5000
    EXPOSE 5000
    
    HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
      CMD curl -f http://localhost:5000 || exit 1
    
    CMD ["python", "wthr.py"]
    