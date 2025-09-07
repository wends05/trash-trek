from typing import Optional
from pydantic import BaseModel, Field

class Player(BaseModel):
    device_id: str
    name: str
    coins: int
    
class PlayerIn(Player):
    pass

class PlayerOut(PlayerIn):
    pass
