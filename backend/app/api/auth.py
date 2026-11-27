from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.core.security import decode_access_token
from app.schemas.auth import UserRegister, UserLogin, TokenResponse
from app.services import auth_service

from app.schemas.auth import UserRegister, UserLogin, TokenResponse, GoogleAuthRequest

router = APIRouter(prefix="/auth", tags=["Auth"])
bearer_scheme = HTTPBearer()

@router.post("/register", status_code=status.HTTP_201_CREATED)
def register(data: UserRegister, db: Session = Depends(get_db)):
    user = auth_service.register_user(db, data.username, data.password)
    return {"message": "Đăng ký thành công", "id": user.id, "username": user.username}

@router.post("/login", response_model=TokenResponse)
def login(data: UserLogin, db: Session = Depends(get_db)):
    token = auth_service.authenticate_user(db, data.username, data.password)
    return TokenResponse(access_token=token)

@router.get("/me")
def get_me(
    credentials: HTTPAuthorizationCredentials = Depends(bearer_scheme),
    db: Session = Depends(get_db),
):
    username = decode_access_token(credentials.credentials)
    if not username:
        raise HTTPException(status_code=401, detail="Token không hợp lệ")

    user = auth_service.get_user_by_username(db, username)
    if not user:
        raise HTTPException(status_code=401, detail="Tài khoản không tồn tại")

    return {"id": user.id, "username": user.username, "created_at": user.created_at}


@router.post("/google", response_model=TokenResponse)
def google_login(data: GoogleAuthRequest, db: Session = Depends(get_db)):
    token = auth_service.authenticate_google_user(db, data.id_token)
    return TokenResponse(access_token=token)