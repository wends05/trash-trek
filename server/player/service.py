from fastapi.exceptions import HTTPException
from pymongo import ReturnDocument
from pymongo.asynchronous.collection import AsyncCollection
from player.schemas import PlayerEdit, PlayerIn

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
        print(player_dict)

        created_player = await self.collection.insert_one(player_dict)
        new_player = await self.collection.find_one({"_id": created_player.inserted_id})
        
        if not new_player:
            raise HTTPException(status_code=404, detail={
                "message": "Player not found",
                "device_id": player.device_id
            })

        new_player["_id"] = str(new_player["_id"])

        return new_player

    async def get_player(self, device_id: str):
        player = await self.collection.find_one({"device_id": device_id})

        if not player:
            raise HTTPException(status_code=404, detail={
                "message": "Player not found",
                "device_id": device_id
            })
        
        player["_id"] = str(player["_id"])

        return player

    async def update_player(self, device_id: str, new_player: PlayerEdit):
        player_dict = new_player.model_dump(exclude_none=True)

        if not player_dict:
            raise HTTPException(status_code=400, detail={
                "message": "No fields to update",
                "device_id": device_id
            })
        
        existing_player = await self.collection.find_one({"device_id": device_id})
        if not existing_player:
            raise HTTPException(status_code=404, detail={
                "message": "Player not found",
                "device_id": device_id
            })
        
        update_fields = player_dict

        updated_player = await self.collection.find_one_and_update(
            {"device_id": device_id},
            {"$set": update_fields, "$currentDate": {"lastModified": True}},
            return_document=ReturnDocument.AFTER,
        )
        if not updated_player:
            raise HTTPException(status_code=404, detail={
                "message": "Player not found",
                "device_id": device_id
            })
        
        updated_player["_id"] = str(updated_player["_id"])

        return updated_player
    
    async def delete_player(self, device_id: str):
        res = await self.collection.delete_one({"device_id": device_id})

        if not res.deleted_count:
            raise HTTPException(status_code=404, detail={
                "message": "Player not found",
                "device_id": device_id
            })
        
        return res.deleted_count > 0
    
    async def get_top_five(self):
        
        players = []
        async for player in self.collection.find().sort("high_score", -1).limit(5):
            player_copy = {
                "_id": str(player["_id"]),
                "name": player["name"],
                "high_score": player["high_score"],
            }
            players.append(player_copy)
            

        return players
