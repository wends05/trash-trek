from bson.objectid import ObjectId
from db import players_collection
from player.schemas import PlayerIn, PlayerOut

class PlayerService:
    def __init__(self):
        self.collection = players_collection

    async def create_player(self, player: PlayerIn):
        player_dict = player.model_dump()
        res = await self.collection.insert_one(player_dict)
        new_player = await self.collection.find_one({"_id": res.inserted_id})
        return PlayerOut(**new_player) if new_player else None

    async def get_players(self):
        players = self.collection.find()
        return [PlayerOut(**player) for player in await players.to_list()]

    async def get_player(self, player_id: str):
        object_id = ObjectId(player_id)
        player = await self.collection.find_one({"_id": object_id})
        print("RECEIVED PLAYER: ", player)
        return PlayerOut(**player) if player else None

    async def update_player(self, player_id: str, new_player: PlayerIn):
        player_dict = new_player.model_dump()
        object_id = ObjectId(player_id)

        res = await self.collection.update_one({"_id": object_id}, {"$set": player_dict})
        updated_player = await self.collection.find_one({"_id": object_id})
        return PlayerOut(**updated_player) if updated_player else None
    
    async def delete_player(self, player_id: str):
        object_id = ObjectId(player_id)
        res = await self.collection.delete_one({"_id": object_id})
        return res.deleted_count > 0
    
    async def add_coins(self, player_id: str, increment: int):
        object_id = ObjectId(player_id)
        res = await self.collection.update_one({"_id": object_id}, {"$inc": {"coins": increment}})
        updated_player = await self.collection.find_one({"_id": object_id})
        return PlayerOut(**updated_player) if updated_player else None

