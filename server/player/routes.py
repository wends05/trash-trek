from fastapi import APIRouter, Depends
from player.service import PlayerService
from player.schemas import PlayerIn, PlayerEdit
from db import players_collection

player_router = APIRouter(
    tags=["players"]
)

def get_player_service() -> PlayerService:
    return PlayerService(players_collection)

@player_router.post("/player")
async def create_player(player: PlayerIn, service: PlayerService = Depends(get_player_service)):
    return await service.create_player(player)

@player_router.get("/top-five")
async def get_top_five(service: PlayerService = Depends(get_player_service)):
    return await service.get_top_five()

@player_router.get("/player/{device_id}")
async def get_player(device_id: str, service: PlayerService = Depends(get_player_service)):
    return await service.get_player(device_id)

@player_router.patch("/player/{device_id}")
async def update_player(device_id: str, player: PlayerEdit, service: PlayerService = Depends(get_player_service)):
    return await service.update_player(device_id, player)

@player_router.delete("/player/{device_id}")
async def delete_player(device_id: str, service: PlayerService = Depends(get_player_service)):
    return await service.delete_player(device_id)
