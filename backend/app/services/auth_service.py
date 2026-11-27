from fastapi import HTTPException, status
from sqlalchemy.orm import Session
from app.core.security import hash_password, verify_password, create_access_token
from app.models.user import User

from google.oauth2 import id_token
from google.auth.transport import requests as google_requests
from app.core.config import settings

def register_user(db: Session, username: str, password: str) -> User:
    existing = db.query(User).filter(User.username == username).first()
    if existing:
        raise HTTPException(status_code=400, detail="Username đã tồn tại")

    new_user = User(
        username=username,
        hashed_password=hash_password(password),
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user

def authenticate_user(db: Session, username: str, password: str) -> str:
    user = db.query(User).filter(User.username == username).first()
    if not user or not verify_password(password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Sai tài khoản hoặc mật khẩu",
        )
    return create_access_token(user.username)

def get_user_by_username(db: Session, username: str) -> User | None:
    return db.query(User).filter(User.username == username).first()

def authenticate_google_user(db: Session, token: str) -> str:
    try:
        info = id_token.verify_oauth2_token(
            token,
            google_requests.Request(),
            settings.GOOGLE_CLIENT_ID,
        )
    except ValueError:
        raise HTTPException(status_code=401, detail="Google token không hợp lệ")

    google_id = info["sub"]
    email = info.get("email")

    # Tìm theo google_id hoặc email
    user = db.query(User).filter(
        (User.google_id == google_id) | (User.email == email)
    ).first()

    if not user:
        base_username = email.split("@")[0] if email else f"user_{google_id[:8]}"
        user = User(
            username=base_username,
            email=email,
            google_id=google_id,
            hashed_password=None,
        )
        db.add(user)
        db.commit()
        db.refresh(user)
    elif not user.google_id:
        user.google_id = google_id
        db.commit()

    return create_access_token(user.username)