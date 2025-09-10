import os
from pymongo import AsyncMongoClient
from dotenv import load_dotenv

load_dotenv()
# Prefer explicit failure over implicit localhost fallback; also accept MONGODB_URI.
URI = os.getenv("MONGO_URL") or os.getenv("MONGODB_URI")
if not URI:
    raise RuntimeError("MONGO_URL is not set. Please set MONGO_URL in the .env file.")

client = AsyncMongoClient(URI)

db = client["trashtrek"]

# Collections
players_collection = db.players
shop_items_collection = db.shop_items
