from fastapi import APIRouter
from player.service import PlayerService
from player.schemas import PlayerIn

player_router = APIRouter(
    prefix="/player",
    tags=["players"]
)

@player_router.post("/")
async def create_player(player: PlayerIn):
    return await PlayerService().create_player(player)

@player_router.get("/{device_id}")
async def get_player(device_id: str):
    return await PlayerService().get_player(device_id)

@player_router.put("/{device_id}")
async def update_player(device_id: str, player: PlayerIn):
    return await PlayerService().update_player(device_id, player)

@player_router.delete("/{device_id}")
async def delete_player(device_id: str):
    return await PlayerService().delete_player(device_id)

@player_router.patch("/{device_id}/coins")
async def add_coins(device_id: str, increment: int):
    return await PlayerService().add_coins(device_id, increment)
