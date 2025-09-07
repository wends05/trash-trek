from typing import Optional
from pydantic import BaseModel, ConfigDict, Field

class Player(BaseModel):
    device_id: str
    name: str
    coins: int
    
class PlayerIn(Player):
    pass

class PlayerEdit(BaseModel):
    name: Optional[str] = None
    coins: Optional[int] = Field(default=None, ge=0)
    model_config = ConfigDict(extra="forbid")



class PlayerOut(BaseModel):
    device_id: str
    name: str
    coins: int
