# Imagen base ligera
FROM python:3.12-slim

# Evita .pyc y activa un bufferado sano en logs
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    APP_ENV=container \
    PORT=8080

# Crea user no root
RUN useradd -m appuser

# Instala dependencias del sistema mínimas y limpia
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Instala deps Python
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia el código
COPY app/ ./app/

# Cambia propietario y usuario
RUN chown -R appuser:appuser /app
USER appuser

# Exponer puerto (Cloud Run usa $PORT)
EXPOSE 8080

# Comando: Uvicorn atado a 0.0.0.0:$PORT
CMD ["bash","-lc","uvicorn app.main:app --host 0.0.0.0 --port ${PORT}"]
