from fastapi.exceptions import HTTPException
from pymongo.asynchronous.collection import AsyncCollection
from player.schemas import PlayerEdit, PlayerIn, PlayerOut

class PlayerService:
    def __init__(self, collection: AsyncCollection):
        self.collection = collection

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

    async def update_player(self, device_id: str, new_player: PlayerEdit):
        player_dict = new_player.model_dump()

        filtered_player_dict = {k: v for k, v in player_dict.items() if v is not None}

        if not filtered_player_dict:
            raise HTTPException(status_code=400, detail={
                "message": "No fields to update",
                "device_id": device_id
            })
        
        res = await self.collection.update_one({"device_id": device_id}, {"$set": filtered_player_dict})

        if not res.modified_count:
            raise HTTPException(status_code=404, detail={
                "message": "Player not modified. Fields may be the same",
                "device_id": device_id
            })

        updated_player = await self.collection.find_one({"device_id": device_id})
        return PlayerOut(**updated_player) if updated_player else None
    
    async def delete_player(self, device_id: str):
        res = await self.collection.delete_one({"device_id": device_id})

        if not res.deleted_count:
            raise HTTPException(status_code=404, detail={
                "message": "Player not deleted",
                "device_id": device_id
            })
        
        return res.deleted_count > 0
