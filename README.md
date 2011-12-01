dead simple notifier 
===

### reqs
- local smtp MSA (amazon ec2 default)
- ruby 1.8 or newer


### usage

1. start server 

	ruby server.rb example@gmail.com

then it listen on 8888. use "nohup" to be background


2. message

	curl http://server.addr:8888/?msg=anymessage
