from pydantic import BaseModel


class ShopItem(BaseModel):
    name: str
    base_price: int
    price_per_level: int
    max_level: int


class ShopItemIn(ShopItem):
    pass

class ShopItemOut(ShopItem):
    pass


