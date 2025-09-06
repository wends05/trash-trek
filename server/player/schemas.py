from typing import Optional
from pydantic import BaseModel

class Player(BaseModel):
    name: str
    coins: int
    
class PlayerIn(BaseModel):
    name: str
    coins: Optional[int] = 0

class PlayerOut(Player):
    _id: str
