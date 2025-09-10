from fastapi import APIRouter, Depends
from shop_item.service import ShopItemService
from db import shop_items_collection, players_collection

shop_item_router = APIRouter(
    prefix="/shop",
    tags=["shop-items"]
)

def get_shop_item_service() -> ShopItemService:
    return ShopItemService(shop_items_collection, players_collection)

@shop_item_router.get("/items")
async def get_items(service: ShopItemService = Depends(get_shop_item_service)):
    return await service.get_shop_items()

@shop_item_router.get("/upgrades")
async def get_upgrades(service: ShopItemService = Depends(get_shop_item_service)):
    return await service.get_all_upgrades()

@shop_item_router.get("/skins")
async def get_skins(service: ShopItemService = Depends(get_shop_item_service)):
    return await service.get_all_skins()
