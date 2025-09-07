import os
from pymongo import AsyncMongoClient
from dotenv import load_dotenv

load_dotenv()
URI = os.getenv("MONGO_URL")
print("MongoDB URL: ", URI)

client = AsyncMongoClient(URI)

db = client["trashtrek"]

# Collections
players_collection = db.players
