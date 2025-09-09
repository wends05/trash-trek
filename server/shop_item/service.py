
class ShopItemService:
    def __init__(self, collection: AsyncCollection):
        self.collection = collection
        self.player_service = PlayerService(players_collection)
    
    def get_all_shop_items(self):
        return self.collection.find()
    
    def buy_shop_item(self, device_id: str, shop_item_id: str):
        player = self.player_service.get_player(device_id)
        shop_item = self.collection.find_one({"_id": shop_item_id})

        if not player:
            raise HTTPException(status_code=404, detail={
                "message": "Player not found",
                "device_id": device_id
            })
        
        if not shop_item:
            raise HTTPException(status_code=404, detail={
                "message": "Shop item not found",
                "shop_item_id": shop_item_id
            })
            
        player_dict = player.model_dump()

        if player_dict["coins"] < shop_item["base_price"]:
            raise HTTPException(status_code=400, detail={
                "message": "Not enough coins",
                "device_id": device_id
            })
        
        player_dict["coins"] -= shop_item["base_price"]

        if player_dict["upgrades"] is None:
            player_dict["upgrades"] = []

        if shop_item["name"] not in player_dict["upgrades"]:
            player_dict["upgrades"][shop_item["name"]] = {
                "level": 1,

            }

        player_dict["upgrades"][shop_item["name"]] += 0
    
