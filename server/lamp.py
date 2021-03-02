from flask import Flask
import RPi.GPIO as gpio
import time
import json

isOff = False
app = Flask(__name__)
PIN = 7

gpio.setmode(gpio.BOARD)
gpio.setup(PIN, gpio.OUT)
gpio.output(PIN, isOff)

@app.route("/status")
def get_isOff():
	return json.dumps({'status': isOff})

@app.route("/on")
def on():
	isOff = False
	gpio.output(PIN, isOff)
	return json.dumps({'status': isOff})

@app.route("/off")
def off():
	isOff = True
	gpio.output(PIN, isOff)
	return json.dumps({'status': isOff})

@app.after_request
def add_header(response):
	response.headers['content-Type'] = "application/json"
	response.headers['Access-Control-Allow-Origin'] = "*"
	return response

try:
	app.run(host='0.0.0.0', port=5000)
except:
	gpio.cleanup()
