from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

users = Blueprint('users', __name__)

# define routes :>P
#get all users
@products.route('/users', methods=['GET'])
def get_users():
    #obtain cursor
    cursor = db.get_db().cursor()

    cursor.execute('SELECT * FROM USERS')
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()

    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)
