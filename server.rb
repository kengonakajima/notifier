#! /usr/bin/ruby

# using localhost SMTP server (ec2 instance has it)
$from = ""
$to = ""

require "net/smtp"
require "kconv"
require "webrick"
require "net/http"

def send(from,to,msg)
  date = `date`.chop

  text  = "Subject: #{msg}\n"
  text += "From: #{from}\n"
  text += "Content-type: text/plain; charset=iso-2022-jp\n"
  text += "Sender: #{from}\n"
  text += "Date: #{date}\n"
  text += "To: #{to}\n"
  text += "\n\n"
  text += "#{msg}\n"
  text += "-----end of message---------------------\n"

  begin
    STDERR.print "start smtp...\n"
    smtp = Net::SMTP.start( "localhost" , 25 )

    STDERR.print "send_mail:"
    smtp.send_mail( text, from, to )
    smtp.finish
    STDERR.print "finished.\n"
    return true
  rescue
    STDERR.print "SEND ERROR : #{$!}\n"
    STDERR.print "mail text:\n"
    STDERR.print text
    return false
  end
end

class TopServlet < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(req,res)
    res.content_type="text/plain"
    
    msg = req.query["msg"]

    ret = send($from,$to,msg)

    res.body = "result:#{ret}"
  end
end

def main(argv)

  if argv.size != 1 then
    STDERR.print "need MAILADDR\n"
    return 
  end
  $from = argv[0]
  $to = $from

  # start web server
  s = WEBrick::HTTPServer.new(:Port=>8888, :BindAddress=>"0.0.0.0" )

  s.mount("/", TopServlet)

  trap(:INT) do
    s.shutdown
  end
  trap(:TERM) do
    s.shutdown
  end

  s.start
end

#
#
#
main(ARGV)
