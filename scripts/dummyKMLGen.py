from pymongo import MongoClient 
import glob, os

client = MongoClient()

db = client.smartcitydb

cursor = db.allworks.find()

for document in cursor:
	print (document)

