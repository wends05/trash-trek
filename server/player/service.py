from fastapi.exceptions import HTTPException
from bson.objectid import ObjectId
from db import players_collection
from player.schemas import PlayerIn, PlayerOut

class PlayerService:
    def __init__(self):
        self.collection = players_collection

    async def create_player(self, player: PlayerIn):

        existing_player = await self.collection.find_one({"device_id": player.device_id})

        if existing_player:
            raise HTTPException(status_code=400, detail={
                "message": "Player already exists",
                "device_id": player.device_id
            })
        
        player_dict = player.model_dump()

        created_player = await self.collection.insert_one(player_dict)
        new_player = await self.collection.find_one({"_id": created_player.inserted_id})
        
        return PlayerOut(**new_player) if new_player else None

    async def get_player(self, device_id: str):
        player = await self.collection.find_one({"device_id": device_id})

        if not player:
            raise HTTPException(status_code=404, detail={
                "message": "Player not found",
                "device_id": device_id
            })
        
        return PlayerOut(**player)

    async def update_player(self, device_id: str, new_player: PlayerIn):
        player_dict = new_player.model_dump()

        res = await self.collection.update_one({"device_id": device_id}, {"$set": player_dict})
        updated_player = await self.collection.find_one({"device_id": device_id})
        return PlayerOut(**updated_player) if updated_player else None
    
    async def delete_player(self, device_id: str):
        res = await self.collection.delete_one({"device_id": device_id})
        return res.deleted_count > 0
    
    async def add_coins(self, device_id: str, increment: int):
        res = await self.collection.update_one({"device_id": device_id}, {"$inc": {"coins": increment}})
        updated_player = await self.collection.find_one({"device_id": device_id})
        return PlayerOut(**updated_player) if updated_player else None
