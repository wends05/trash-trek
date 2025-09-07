from os import getenv
from pymongo import AsyncMongoClient

URI = getenv("MONGO_URL")
client = AsyncMongoClient(URI)

db = client["trashtrek"]

# Collections
players_collection = db.players
