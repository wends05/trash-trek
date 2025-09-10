from pydantic import BaseModel, Field
from typing import Literal

class ShopItem(BaseModel):
    name: str
    description: str
    type: Literal["upgrade", "skin"] = Field(default="upgrade")
    base_price: int
    price_per_level: int
    price_per_level_multiplier: float
    max_level: int


class ShopItemIn(ShopItem):
    pass

class ShopItemOut(ShopItem):
    pass
