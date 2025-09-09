from fastapi import APIRouter, Depends
from player.service import PlayerService
from player.schemas import PlayerIn, PlayerEdit
from db import players_collection

player_router = APIRouter(
    prefix="/player",
    tags=["players"]
)

def get_player_service() -> PlayerService:
    return PlayerService(players_collection)

@player_router.post("/")
async def create_player(player: PlayerIn, service: PlayerService = Depends(get_player_service)):
    return await service.create_player(player)

@player_router.get("/{device_id}")
async def get_player(device_id: str, service: PlayerService = Depends(get_player_service)):
    return await service.get_player(device_id)

@player_router.patch("/{device_id}")
async def update_player(device_id: str, player: PlayerEdit, service: PlayerService = Depends(get_player_service)):
    return await service.update_player(device_id, player)

@player_router.delete("/{device_id}")
async def delete_player(device_id: str, service: PlayerService = Depends(get_player_service)):
    return await service.delete_player(device_id)

@player_router.get("/top-three")
async def get_top_three(service: PlayerService = Depends(get_player_service)):
    return await service.get_top_three()
