from typing import Optional
from pydantic import BaseModel, ConfigDict, Field
from datetime import datetime

class Player(BaseModel):
    device_id: str
    name: str = Field(min_length=1)
    coins: int
    high_score: int
    upgrades: dict
    skins: list
    lastModified: Optional[datetime] = Field(default_factory=datetime.now)

    model_config = ConfigDict(extra="forbid")

    
class PlayerIn(Player): 
    coins: Optional[int] = Field(default=0, ge=0)
    high_score: Optional[int] = Field(default=0, ge=0)
    upgrades: Optional[dict] = Field(default={})
    skins: Optional[list] = Field(default=[])


class PlayerEdit(BaseModel):
    name: Optional[str] = Field(default=None, min_length=1)
    coins: Optional[int] = Field(default=None, ge=0)
    high_score: Optional[int] = Field(default=None, ge=0)
    upgrades: Optional[dict] = Field(default=None)
    skins: Optional[list] = Field(default=None)

    model_config = ConfigDict(extra="forbid")


class PlayerOut(BaseModel):
    device_id: str
    name: str
    coins: int
    high_score: int
    upgrades: dict
    lastModified: datetime
