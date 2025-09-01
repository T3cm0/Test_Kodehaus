from fastapi import FastAPI
from pydantic import BaseModel
import os

app = FastAPI(title="Demo FastAPI CI/CD", version="0.1.0")

class Ping(BaseModel):
    message: str = "pong"

@app.get("/healthz")
def healthz():
    # Endpoint para liveness probes
    return {"status": "ok"}

@app.get("/readyz")
def readyz():
    # Endpoint para readiness probes (aquí podrías chequear DB, etc.)
    return {"ready": True}

@app.get("/version")
def version():
    return {
        "app": app.title,
        "version": app.version,
        "env": os.getenv("APP_ENV", "local")
    }

@app.post("/ping", response_model=Ping)
def ping():
    return Ping()

