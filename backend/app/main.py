from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api import auth
from app.core.database import Base, engine
from app.models import user  # Import để SQLAlchemy nhận diện bảng users

# Tự động tạo bảng trên Neon nếu chưa có
Base.metadata.create_all(bind=engine)

app = FastAPI(title="AIoT Hub Backend")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)

@app.get("/health")
def health_check():
    return {"status": "ok"}