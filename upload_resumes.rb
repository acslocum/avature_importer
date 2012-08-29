require 'rubygems'
require 'avature_resume'
require 'parse_csv'
require 'net/http'
require 'net/https'
require 'json'


class UploadResumes
  def initialize(csv_name, start_id, session_id, p, version, username, password)
    @csv_name = csv_name
    @start_id = start_id
    @session_id = session_id
    @p = p
    @version = version
    
    @http = Net::HTTP.new('jobs.thoughtworks.com', 443, nil, username, password)
    @http.use_ssl = true
  end
  
  def convert
    parser = ParseCsv.new(@csv_name)
    candidates = parser.parse
    @resumes = []
    candidates.each{ | candidate | 
      @resumes << AvatureResume.new(parser.headers, candidate, @p)
    }
  end
  
  def upload
    @resumes.each{ |resume| 
      save_person(resume)
      save_notes(resume)
    }
  end
    
  def save_person(resume)
    data = post(resume.person_content)
    resume.contact_id = get_contact_id(data)
    puts "contact created: #{resume.name} #{resume.contact_id}"
  end
  
  def get_contact_id(data)
    data_hash = JSON.parse(data)
    messages = data_hash["msg"]
    first_message = messages.select { |hash| hash["actionNumber"] == 0}
    puts "first: #{first_message}, #{first_message.first["msg"]}"
    puts messages if first_message.empty?
    first_message.first["msg"]
  end
  
  def save_note(resume,note)
    post(resume.note_content(note))
  end
  
  def save_notes(resume)
    resume.notes.each { |note| save_note(resume, note)}
  end
  
  def post(message)
    puts message.to_json
    path = "/synapserWait?applicationCode=iats&version=#{@version}&pageSessionId=#{@session_id}"
    headers = {
    'Cookie' => "hsfirstvisit=http%3A%2F%2Fwww.thoughtworks.com%2F||2012-07-13%2011%3A20%3A29; SESS06ea2a41f72d31b93a5853105dc11e35=p3gc8p982svnjhd8pt2sip51q6; hubspotvm=a1ba202e2f26c8bd352dd013ef413a4c; __utma=90591199.121073808.1342192823.1344441875.1345059808.3; __utmc=90591199; __utmz=90591199.1345059808.3.2.utmcsr=reddit.com|utmccn=(referral)|utmcmd=referral|utmcct=/r/technology/comments/y9ypp/from_bits_to_gits_github_thoughtworks_ny_august/; __ptca=161445794.cYMBtHfFuRxq.1342210829.1344459879.1345074210.3; __ptv_64rZ77=cYMBtHfFuRxq; __pti_64rZ77=cYMBtHfFuRxq; __ptcc=1; __ptcz=161445794.1342210829.1.0.ptmcsr=thoughtworks.com|ptmcmd=referral|ptmccn=(referral)|ptmctr=%2F; __hstc=161445794.a1ba202e2f26c8bd352dd013ef413a4c.1342192829329.1344441878714.1345059809892.3; __hssrc=1; hubspotutk=a1ba202e2f26c8bd352dd013ef413a4c; formCompletionSESSID=mg91m98p2kja3jbdp5mgce1550; formCompletionPublicSessionName=UWInnlXfPh8bdalazr5QQ36Ch2D1KkMp7vvj7APolETHLy2e0AbdHaJL2VLrg0NCKigInoV5b1MVlaGGdXuPk8BwS8JOzM5YDDYF46jQNjOxB956vCBYW3vMdWWCHKHX; relayState=; iatsSharedSESSID=3i39ilt7ek3j97fq1iuf8pkqs6; iatsSharedPublicSessionName=#{@p}",
    'Content-Type' => 'application/json'
    }
    data=nil
    begin
      response, data = @http.post(path, message.to_json, headers)
      puts "adding contact: #{response}"
    rescue Net::HTTPBadResponse => e
      puts e.exception
    end
    data
  end
  
end

#the cookie and these magic strings come from inspecting the polled request for synapserWait on avature. (chrome dev tools)
# if you're logged in this should work fine. note that the session id changes periodically, the version changes less often. daily? "p" changes on login I think.
# you'll probably also want a fresh copy of the cookie.
#arg 0 is the csv
#note: you'll need to clear out all previously imported resumes. 2012: RES-12-742 (Ruchi Goel) was the last processed
uploader = UploadResumes.new(ARGV[0], ARGV[1], "1549845839", "zsxN_zisefA2uuv0sMVX4WKFwe7s", "755aa1", "username", "password")
uploader.convert
uploader.upload
