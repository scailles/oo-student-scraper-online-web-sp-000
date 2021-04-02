require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper
  
  attr_accessor :student

  def self.scrape_index_page(index_url)
    
    
    html = open(index_url)

    page = Nokogiri::HTML(html)

    students = []
    
    
    
    page.css("div.student-card").each do |student|
      student_info= {
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.children[1].attributes["href"].value
        
      }
      
      students << student_info
    end
    students
  end
  
  
  

  def self.scrape_profile_page(profile_url)
    
    page = Nokogiri::HTML(open(profile_url))
    
    student={}
    
    social_media = page.css(".social-icon-container").css('a').collect {|e| e.attributes["href"].value}
    
    
    social_media.each do |social|
      
      student[:twitter]= social if social.include?("twitter")
      student[:linkedin]= social if social.include?("linkedin")
      student[:github]= social if social.include?("github")
   
    end
    
    student[:blog] = social_media[3] if social_media[3] != nil
    student[:profile_quote] = page.css(".profile-quote").text if page.css(".profile-quote")
    
    student[:bio] = page.css("div.bio-content.content-holder div.description-holder p").text if page.css("div.bio-content.content-holder div.description-holder p")

    student
  end

      

end

