from flask import Flask, request, render_template, jsonify
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address

import redis
import re
import uuid

app = Flask(__name__,template_folder="/app")

limiter = Limiter(
    app,
    key_func=get_remote_address,
    default_limits=["500 per day", "100 per hour"]
)

redis = redis.Redis(charset="utf-8", decode_responses=True)

@app.route("/postNew", methods=['POST'])
@limiter.limit("10 per minute")
def postNew():
    postdata = request.form.get("postdata")
    keyname = "TestStorage"
    #Try and somewhat get rid of garbage
    postdata=re.sub(r'[^a-zA-Z0-9 ]', '', postdata)
    redis.lpush(keyname, postdata)
    return {}

@app.route("/getAll", methods=['POST'])
@limiter.limit("1000 per minute")
def getAll():
    #really really never do this in prod
    items = []
    keyname = "TestStorage"
    # remove any old keys
    if redis.llen(keyname) >= 10:
        redis.lrem(keyname,1)
    return jsonify(redis.lrange(keyname,0,-1))

@app.route("/")
def index():
    return render_template('index.html')



if __name__ == '__main__':
   app.run()
