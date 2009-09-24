require 'spec'

class GoogleMapsAddon    
  def self.geocode(address)   
    opts = {
      :q => address,
      :key => "ABQIAAAA5yO06x91IBr9oKK57xU-kRSWPodhC6wLLpV6xYzSog0legcbhhT0-N3OKUWSa2v_LV_VnVPbd3zgKg",
      :sensor => 'false',
      :output => 'json'
    }
    url = "http://maps.google.com/maps/geo?" + opts.map{|k,v| "#{k}=#{URI.escape(v)}" }.join('&')
    result = JSON.parse(Net::HTTP.get(URI.parse(url)))   # FIXME: error handling please
    return nil unless result["Status"]["code"] == 200    # FIMXE: log error?
    result["Placemark"][0]["Point"]["coordinates"][0..1].join(",")
  end
end                     

class Card::Base
  after_save :update_geocode
  
  def update_geocode           
    if conf = CachedCard.get_real('*geocode')
      if self.junction? && conf.pointees.include?( self.name.tag_name )
        address = conf.pointees.map{|p| System.setting(self.name.trunk_name+"+#{p}")}.compact.join(' ')
        if (geocode = GoogleMapsAddon.geocode(address))
          Card.find_or_create(
              :name=>"#{self.name.trunk_name}+*geocode", 
              :type=>'Phrase'
          ).update_attributes( :content => geocode )
        end
      end
    end
  end
end

##  This spec is here instead of the test suite since it actually connects to the google service
describe GoogleMapsAddon do
  context "geocode" do
    it "returns correct coords for Ethan's House" do
      GoogleMapsAddon.geocode("519 Peterson St., Ft. Collins, CO").should match(/^-105.0\d+,40.5\d+$/)
    end
  end
end