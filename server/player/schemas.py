from typing import Optional
from pydantic import BaseModel, ConfigDict, Field
from datetime import datetime

class Player(BaseModel):
    device_id: str
    name: str = Field(min_length=1)
    coins: int
    high_score: int
    upgrades: list
    lastModified: datetime

    model_config = ConfigDict(extra="forbid")

    
class PlayerIn(Player): 
    coins: Optional[int] = Field(default=0, ge=0)
    high_score: Optional[int] = Field(default=0, ge=0)
    upgrades: Optional[list] = Field(default=[])
    lastModified: Optional[datetime] = Field(default_factory=datetime.now)

class PlayerEdit(BaseModel):
    name: Optional[str] = None
    coins: Optional[int] = Field(default=None, ge=0)
    high_score: Optional[int] = Field(default=None, ge=0)

    model_config = ConfigDict(extra="forbid")


class PlayerOut(BaseModel):
    device_id: str
    name: str
    coins: int
    high_score: int
    upgrades: list
    lastModified: datetime
