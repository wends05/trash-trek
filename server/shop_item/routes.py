from fastapi import APIRouter


shop_item_router = APIRouter(
    prefix="/shop-item",
    tags=["shop-items"]
)


