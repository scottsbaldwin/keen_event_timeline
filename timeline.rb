require 'rubygems'
require 'keen'
require 'time'

Keen.project_id = ENV['KEEN_PROJECT_ID']
Keen.read_key = ENV['KEEN_READ_KEY']

USER_ID = ARGV[0] || '65bba5fb79d7da91ae92183a56d4e2c1b326d04d4276c364de41f725ee779065'

def build_timeline_for_member(id)
  events = []
  filters = []
  filters << { property_name: 'user.id', operator: 'eq', property_value: id }

  puts "Gathering timeline data for #{id}"

  events.concat(extraction("Signed_up", filters))
  events.concat(extraction("Signed_in", filters))
  events.concat(extraction("procedure_searched", filters))
  events.concat(extraction("Visited_Url", filters))

  events.sort! { |a,b| a["keen"]["timestamp"] <=> b["keen"]["timestamp"] }
end

def extraction(collection, filters)
  puts "extracting #{collection} events..."
  events = Keen.extraction(collection, filters: filters)
  events.cycle(1) { |event| event["collection"] = collection }
  events
end

def event_details(event)
  return registration_details(event) if event['collection'] == 'Signed_up'
  return login_details(event) if event['collection'] == 'Signed_in'
  return pageview_details(event) if event['collection'] == 'Visited_Url'
  return search_details(event) if event['collection'] == 'procedure_searched'
end

def registration_details(event)
  <<END
#{event_banner(event, "Member registered")}
#{' ' * 11}Plan sponsor: #{event["user"]["plan_sponsor"]}
#{' ' * 11}Plan:         #{event["user"]["benefit_plan"]["name"] if event["user"]["benefit_plan"].has_key?("name")}
END
end

def login_details(event)
  <<END
#{event_banner(event, "Member logged in")}
#{' ' * 11}Platform:   #{event["Platform"]}
#{' ' * 11}Browser:    #{event["Browser"]}
#{' ' * 11}Resolution: #{event["Resolution"]}
END
end

def search_details(event)
  <<END
#{event_banner(event, "Member searched")}
#{' ' * 11}Specialty:           #{event["specialtyName"] if event["specialtyName"]}
#{' ' * 11}Procedure:           #{event["procedureName"] if event["procedureName"]}
#{' ' * 11}Provider:            #{event["providerName"] if event["providerName"]}
#{' ' * 11}% results w/ prices: #{event["providers"]["percent_with_prices"] if event["providers"]}
END
end

def pageview_details(event)
  <<END
#{event_banner(event, "Member visited " + event["url"]["tracked"])}
#{' ' * 11}URI:      #{event["url"]["visited"]}
#{' ' * 11}Referrer: #{event["url"]["referrer"]}
END
end

def event_banner(event, title)
  "#{'-' * 60}\n#{Time.parse(event["keen"]["timestamp"]).to_s}\t#{title}"
end

events = build_timeline_for_member USER_ID

events.each do |event|
  details = event_details(event)
  puts details if details
end
