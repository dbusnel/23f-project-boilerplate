
from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

users = Blueprint('users', __name__)

# define routes :>P
# get all users -- admin functionality, not needed for project
@users.route('/users', methods=['GET'])
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



# get user with id
@users.route('/users/<id>', methods=['GET', 'POST'])
def get_user_with_id(id):
    if request.method == 'GET':
        #obtain cursor
        cursor = db.get_db().cursor()
        cursor.execute('SELECT * FROM USERS WHERE id = ' + str(id))
        column_headers = [x[0] for x in cursor.description]
        json_data = []
        theData = cursor.fetchall()

        for row in theData:
            json_data.append(dict(zip(column_headers, row)))

        return jsonify(json_data)
    else:
        return 'CONDUCTOR WE HAVE A PROBLEM', 405
    
# report a user
@users.route('/users/<userid>/warnings/', methods=['POST'])
def issue_report(userid):
    if request.method == 'POST':
        data = request.json

        flag_id = data['flag_id']
        description = data['description']
        user_id = userid

        query = 'insert into flags (flag_id, description, user_id) values ('
        query += flag_id + ', '
        query += description + ', '
        query += user_id + ')'

        current_app.logger.info(query)


        cursor = db.get_db().cursor()
        cursor.execute(query)
        db.get_db().commit()

# get user likes
@users.route('/users/<userid>/likes/', methods=['GET', 'POST', 'DELETE'])
def get_likes(userid):
    data = request.json
    current_app.logger.info(data)
    if request.method == 'GET':
        cursor = db.get_db().cursor()
        cursor.execute('SELECT * FROM user_likes WHERE id = ' + str(userid))
        column_headers = [x[0] for x in cursor.description]
        json_data = []
        theData = cursor.fetchall()

        for row in theData:
            json_data.append(dict(zip(column_headers, row)))

        return jsonify(json_data)
    elif request.method == 'POST':
        user_id = userid
        liked_id = data['liked_id']

        query = 'insert into user_likes (user_id, liked_id) values ('
        query += user_id + ', '
        query += liked_id + ')'

        current_app.logger.info(query)

        cursor = db.get_db().cursor()
        cursor.execute(query)
        db.get_db().commit()
    elif request.method == 'DELETE':
        liked_id = data['liked_id']

        query = 'DELETE FROM User_Likes where liked_id = ' + liked_id
        cursor.execute(query)
        db.get_db().commit()


# get users who like the given user
@users.route('/users/<id>/liked-by', methods=['GET'])
def get_users_liked_by(id):
    #obtain cursor
    cursor = db.get_db().cursor()

    if request.method == 'GET':
        cursor.execute('SELECT * from ' +
        'User JOIN Symphony.User_Likes ON User.user_id = User_Likes.user_id '
        + 'WHERE liked_id = ;' + str(id))
        column_headers = [x[0] for x in cursor.description]
        json_data = []
        theData = cursor.fetchall()

        for row in theData:
            json_data.append(dict(zip(column_headers, row)))

        return jsonify(json_data)

# get 'matches' -- users who liked each other. Return the other users
# get users who like the given user
@users.route('/users/<id>/matches', methods=['GET'])
def get_matches(id):
    #obtain cursor
    cursor = db.get_db().cursor()
    if request.method == 'GET':
        cursor.execute('SELECT u1.liked_id from User_Likes u1 JOIN User_Likes u2 '
         + 'ON u1.liked_id = u2.user_id where u1.user_id = ' + str(id) + ' and u1.user_id = u2.liked_id '
         'and u2.user_id = u1.liked_id;')
        column_headers = [x[0] for x in cursor.description]
        json_data = []
        theData = cursor.fetchall()

        for row in theData:
            json_data.append(dict(zip(column_headers, row)))

        return jsonify(json_data)
