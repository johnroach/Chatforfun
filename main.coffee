fs = require 'fs'

express = require 'express'
app = express.createServer()

app.get '/', (req, res) ->
	fs.readFile 'index.html', (err, html) ->
		res.contentType 'text/html'
		res.send html
		res.end

app.listen 3000

everyone = require('now').initialize app
number_of_users=0
everyone.connected = () ->
	console.log("Joined: " + this.now.name)
	number_of_users=number_of_users+1
	everyone.now.receiveMessage("",this.now.name + " has joined the fun!" )
	#we don't more than 2 players playing
	if number_of_users>2		
		everyone.now.receiveMessage("",this.now.name + " movements have been disabled since there is already two people playing" )
		muted_users = muted_users+"|"+this.now.name
		everyone.now.receiveMessage("","@op@muted_users@"+muted_users)
	
everyone.disconnected = () ->
	number_of_users=number_of_users-1
	console.log("Left: " + this.now.name)
	everyone.now.receiveMessage("",this.now.name + " has left the fun!" )

everyone.now.distributeMessage = (message)-> 
	everyone.now.receiveMessage(this.now.name, message)
