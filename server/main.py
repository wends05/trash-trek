from fastapi import FastAPI
from fastapi.responses import JSONResponse
from player.routes import player_router
from fastapi.exceptions import HTTPException
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def root():
    return {
        "hello": "world"
    }

app.include_router(player_router)
