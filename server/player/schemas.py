from typing import Optional
from pydantic import BaseModel

class Player(BaseModel):
    device_id: str
    name: str
    coins: int
    
class PlayerIn(BaseModel):
    device_id: str
    name: str
    coins: int

class PlayerEdit(BaseModel):
    name: Optional[str] = None
    coins: Optional[int] = None

class PlayerOut(BaseModel):
    _id: str
    device_id: str
    name: str
    coins: int
