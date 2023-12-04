from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

users = Blueprint('users', __name__)

# define routes :>P
#get all users
@products.route('/users', methods=['GET'])
def get_users():
    #obtain cursor
    print("hi")
