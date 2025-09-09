from fastapi import FastAPI
from player.routes import player_router
from shop_item.routes import shop_item_router
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
app.include_router(shop_item_router)
