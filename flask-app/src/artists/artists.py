from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


artists = Blueprint('artists', __name__)

# Get all the products from the database
@artists.route('/artists', methods=['GET'])
def get_artists():
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of products
    cursor.execute('SELECT * FROM ARTISTS')

    # grab the column headers from the returned data
    column_headers = [x[0] for x in cursor.description]

    # create an empty dictionary object to use in 
    # putting column headers together with data
    json_data = []

    # fetch all the data from the cursor
    theData = cursor.fetchall()

    # for each of the rows, zip the data elements together with
    # the column headers. 
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)

# Get all genres associated with artist
@artists.route('/artists/<id>/genres', methods=['GET', 'POST'])
def manage_genres(id):
    if request.method == 'GET':
        # get a cursor object from the database
        cursor = db.get_db().cursor()

        # use cursor to query the database for a list of products
        cursor.execute('SELECT DISTINCT genre_name FROM Genre_Artist JOIN Genre ON Genre.genre_id = Genre_Artist.genre_id WHERE Genre_Artist.artist_id = ' 
                    + str(id))

        # grab the column headers from the returned data
        column_headers = [x[0] for x in cursor.description]

        # create an empty dictionary object to use in 
        # putting column headers together with data
        json_data = []

        # fetch all the data from the cursor
        theData = cursor.fetchall()

        # for each of the rows, zip the data elements together with
        # the column headers. 
        for row in theData:
            json_data.append(dict(zip(column_headers, row)))

        return jsonify(json_data)
    elif request.method == 'POST':
        data = request.json
        
        # get a cursor object from the database
        cursor = db.get_db().cursor()
        cursor.execute('SELECT genre_id from Genre where genre_name = \'' + str(data['genre_name']) + '\' LIMIT 1')

        # grab the column headers from the returned data
        column_headers = [x[0] for x in cursor.description]

        # create an empty dictionary object to use in 
        # putting column headers together with data
        json_data = []
        theData = cursor.fetchall()
        genreId = theData[0][0]

        # get the artist name from id
        cursor.execute('SELECT artist_name from Artist_Profile where artist_id = ' + str(id) + ' LIMIT 1')

        # grab the column headers from the returned data
        column_headers = [x[0] for x in cursor.description]

        # create an empty dictionary object to use in 
        # putting column headers together with data
        json_data = []
        theData = cursor.fetchall()
        artistName = theData[0][0]

        # now we can do the final query
        cursor.execute('INSERT INTO Genre_Artist VALUES (' + genreId + ', ' + id + ', ' + artistName + ')')
        db.get_db().commit()



# Manage artist posts
@artists.route('/artists/<id>/posts', methods=['GET', 'POST'])
def getPosts(id):
    # get a cursor object from the database
    cursor = db.get_db().cursor()
    if request.method == 'GET':
        # use cursor to query the database for a list of products
        cursor.execute('SELECT * FROM Post WHERE artist_id = ' + id)

        # grab the column headers from the returned data
        column_headers = [x[0] for x in cursor.description]

        # create an empty dictionary object to use in 
        # putting column headers together with data
        json_data = []

        # fetch all the data from the cursor
        theData = cursor.fetchall()

        # for each of the rows, zip the data elements together with
        # the column headers. 
        for row in theData:
            json_data.append(dict(zip(column_headers, row)))

        return jsonify(json_data)
    elif request.method == 'POST':
        data = request.json
        artist_id = data['artist_id']
        artist_name = data['artist_name']
        title = data['title']
        content = data['content']

        cursor.execute('INSERT INTO Post (artist_id, artist_name, title, content, likes) VALUES (' 
                       + artist_id + ', ' 
                       + artist_name + ', ' 
                       + title + ', ' 
                       + content + ', 0)')
        
        db.get_db().commit()
    

# Manage artist post with given ID
@artists.route('/artists/<id>/posts/<postID>', methods=['GET', 'DELETE', 'PUT'])
def getPostFromID(id, postID):
    # get a cursor object from the database
    cursor = db.get_db().cursor()
    if request.method == 'GET':
        # use cursor to query the database for a list of products
        cursor.execute('SELECT * FROM Post WHERE post_id = ' + postID)

        # grab the column headers from the returned data
        column_headers = [x[0] for x in cursor.description]

        # create an empty dictionary object to use in 
        # putting column headers together with data
        json_data = []

        # fetch all the data from the cursor
        theData = cursor.fetchall()

        # for each of the rows, zip the data elements together with
        # the column headers. 
        for row in theData:
            json_data.append(dict(zip(column_headers, row)))

        return jsonify(json_data)
    elif request.method == 'DELETE':
        cursor.execute("DELETE FROM Post WHERE post_id = " + postID)
        db.getdb().commit()
    elif request.method == 'PUT':
        data = request.json
        artist_id = data['artist_id']
        artist_name = data['artist_name']
        title = data['title']
        content = data['content']

        cursor.execute('UPDATE Post SET ' 
                       + 'artist_id = '+ str(artist_id) + ', ' 
                       + 'artist_name = \'' + artist_name + '\', ' 
                       + 'title = \'' + title + '\', '  
                       + 'content = \'' + content + '\'' 
                       + ' where post_id = ' + str(postID))
        db.getdb().commit()
    