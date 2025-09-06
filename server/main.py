from fastapi import FastAPI
from player.routes import player_router

app = FastAPI()

@app.get("/")
def root():
    return {
        "hello": "world"
    }

app.include_router(player_router)
