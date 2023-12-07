from flask import Blueprint, request, jsonify, make_response
import json
from src import db


concerts = Blueprint('concerts', __name__)

# Get all concerts from the DB
@concerts.route('/concerts', methods=['GET', 'POST'])
def get_customers():
    cursor = db.get_db().cursor()
    if request.method == 'GET':
        cursor.execute('select * from Concert_Profile')
        row_headers = [x[0] for x in cursor.description]
        json_data = []
        theData = cursor.fetchall()
        for row in theData:
            json_data.append(dict(zip(row_headers, row)))
        the_response = make_response(jsonify(json_data))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response
    elif request.method == 'POST':
        data = request.json
        concert_id = data['concert_id']
        concert_name = data['concert_name']
        venue_id = data['venue_id']
        price = data['price']
        date = data['date']
        bio = data['bio']
        photo = data['photo']
        ticket_stock = data['ticket_stock']
        #make concert with 0 traffic
        cursor.execute('insert into Concert_Info values(' + concert_id + ", " + "0)")
        #create profile for concert
        cursor.execute('insert into Concert_Profile values(concert_id, concert_name, venue_id, price, date, bio, photo, ticket_stock) '
                       + 'values(' + concert_id + ", "
                       + concert_name + ", "
                       + venue_id + ", "
                       + price + ", "
                       + date + ", "
                       + bio + ", "
                       + photo + ", "
                       + ticket_stock + ")")
        db.get_db().commit()
        

# Get all concerts from the DB
@concerts.route('/concerts/<id>', methods=['GET', 'DELETE', 'PUT'])
def get_customer(id):
    cursor = db.get_db().cursor()
    if request.method == 'GET':
        cursor.execute('select * from Concert_Profile where concert_id = ' + id)
        row_headers = [x[0] for x in cursor.description]
        json_data = []
        theData = cursor.fetchall()
        for row in theData:
            json_data.append(dict(zip(row_headers, row)))
        the_response = make_response(jsonify(json_data))
        the_response.status_code = 200
        the_response.mimetype = 'application/json'
        return the_response
    elif request.method == 'DELETE':
        data = request.json
        #delete from concert_info
        cursor.execute('delete from Concert_Info where concert_id = ' + id + ")")
        #delete profile
        cursor.execute('delete from Concert_Profile where concert_id = ' + id + ")")
        db.get_db().commit()
    elif request.method == 'PUT':
        data = request.json
        concert_id = data['concert_id']
        concert_name = data['concert_name']
        venue_id = data['venue_id']
        price = data['price']
        date = data['date']
        bio = data['bio']
        photo = data['photo']
        ticket_stock = data['ticket_stock']

        cursor.execute('UPDATE Concert_Profile SET '
               + 'concert_id = ' + str(concert_id) + ', '
               + 'concert_name = \'' + concert_name + '\', '
               + 'venue_id = ' + str(venue_id) + ', '
               + 'price = ' + str(price) + ', '
               + 'date = \'' + date + '\', '
               + 'bio = \'' + bio + '\', '
               + 'photo = \'' + photo + '\', '
               + 'ticket_stock = ' + str(ticket_stock)
               + ' WHERE concert_id = ' + str(concert_id))
        
        db.get_db().commit()