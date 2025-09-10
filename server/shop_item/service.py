from fastapi.exceptions import HTTPException
from pymongo.asynchronous.collection import AsyncCollection

class ShopItemService:
    def __init__(self, shop_item_collection: AsyncCollection, players_collection: AsyncCollection):
        self.shop_item_collection = shop_item_collection
        self.player_collection = players_collection
    
    async def get_shop_items(self):
        items = []
        
        async for item in self.shop_item_collection.find().limit(10):
            item["_id"] = str(item["_id"])
            items.append(item)

        if not items:
            raise HTTPException(status_code=404, detail={
                "message": "No shop items found"
            })


        return items

    async def get_all_upgrades(self):
        upgrades = []
        
        async for upgrade in self.shop_item_collection.find({
            "type": "upgrade"
        }).limit(10):
            upgrade["_id"] = str(upgrade["_id"])
            upgrades.append(upgrade)

        if not upgrades:
            raise HTTPException(status_code=404, detail={
                "message": "No upgrades found"
            })

        return upgrades
    
    async def buy_upgrade(self, device_id: str, upgrade_id: str):
        player = await self.player_collection.find_one({"device_id": device_id})
        upgrade = await self.shop_item_collection.find_one({"_id": upgrade_id})

        if not player:
            raise HTTPException(status_code=404, detail={
                "message": "Player not found",
                "device_id": device_id
            })
        
        if not upgrade:
            raise HTTPException(status_code=404, detail={
                "message": "Upgrade not found",
                "upgrade_id": upgrade_id
            })
            
        player_dict = player

        if player_dict["coins"] < upgrade["base_price"]:
            raise HTTPException(status_code=400, detail={
                "message": "Not enough coins",
                "device_id": device_id
            })
        
        player_dict["coins"] -= upgrade["base_price"]

        if player_dict["upgrades"] is None:
            player_dict["upgrades"] = []

        if upgrade["name"] not in player_dict["upgrades"]:
            player_dict["upgrades"][upgrade["name"]] = {
                "level": 1,

            }

        player_dict["upgrades"][upgrade["name"]] += 0

        updated_player = await self.player_service.update_player(device_id, player_dict)

        return updated_player
    
    async def get_all_skins(self):
        skins = []
        
        async for skin in self.shop_item_collection.find({
            "type": "skin"
        }).limit(10):
            skin["_id"] = str(skin["_id"])
            skins.append(skin)
        
        if not skins:
            raise HTTPException(status_code=404, detail={
                "message": "No skins found"
            })
        
        return skins
        
