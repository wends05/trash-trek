from fastapi import APIRouter
from player.service import PlayerService
from player.schemas import PlayerIn

player_router = APIRouter(
    prefix="/players",
    tags=["players"]
)

@player_router.post("/")
async def create_player(player: PlayerIn):
    return await PlayerService().create_player(player)

@player_router.get("/")
async def get_players():
    return await PlayerService().get_players()

@player_router.get("/{player_id}")
async def get_player(player_id: str):
    return await PlayerService().get_player(player_id)

@player_router.put("/{player_id}")
async def update_player(player_id: str, player: PlayerIn):
    return await PlayerService().update_player(player_id, player)

@player_router.delete("/{player_id}")
async def delete_player(player_id: str):
    return await PlayerService().delete_player(player_id)

@player_router.patch("/{player_id}/coins")
async def add_coins(player_id: str, increment: int):
    return await PlayerService().add_coins(player_id, increment)
