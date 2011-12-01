dead simple notifier 
===

### reqs
- local smtp MSA (amazon ec2 default)
- ruby 1.8 or newer


### usage

start server: 

	ruby server.rb example@gmail.com

then it listen on 8888. use "nohup" to be background.

Next, to send message:

	curl http://server.addr:8888/?msg=anymessage

Then an email'll be sent to the address through localhost:25. 

Be careful it has no domain auth key so gmail may put it into spam folder. 