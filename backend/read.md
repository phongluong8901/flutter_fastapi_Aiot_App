# --- install
cd backend 

python -m venv venv
.\venv\Scripts\activate
pip install -r requirements.txt

pip install google-auth requests


# --- run
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000