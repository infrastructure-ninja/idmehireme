"""
This file contains all functions that directly interact with a database,
so this dependency can be more flexible in the future
"""

from datetime import datetime, timezone
import os

from pymongo import MongoClient


MONGO_URL    = os.environ['APP_MONGO_URL']
MONGO_DBNAME = os.environ['APP_MONGO_DBNAME']

client = MongoClient(MONGO_URL)
db_collection = client[MONGO_DBNAME]['urls']


def fetch_url_record(short_url = None):
    """
    Database abstraction Helper function to fetch a single record from a database
    service for a specific short URL
    """

    if short_url:
        url_record = db_collection.find_one({'name': short_url, 'deleted': False})

        if url_record:
            return url_record

    return None


def fetch_all_url_records():
    """
    Database abstraction Helper function to fetch all URL records that are not set as deleted
    """
    db_cursor = db_collection.find({'deleted': False})
    result = list(db_cursor)
    db_cursor.close()

    return result


def update_url_record(short_url, long_url, sidecar_text = None, owner = None):
    """
    Database abstraction Helper function to update a single record based using the "short url"
    """
    updated_record = {}
    updated_record['deleted']      = False
    updated_record['long_url']     = long_url
    updated_record['sidecar_text'] = sidecar_text
    updated_record['owner']        = owner
    updated_record['last_updated'] = datetime.now(timezone.utc)

    db_filter = {'name': short_url }

    db_collection.update_one(db_filter, { "$set": updated_record }, upsert=True)


def update_hit_counter(url_id):
    """
    Database abstraction helper function to increment the hit counter on specific URL record using
    internal atomic functions of the database system
    """
    result = db_collection.update_one( {'_id': url_id }, {'$inc': {'hit_count': 1}} )
    return result
