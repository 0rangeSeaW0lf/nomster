# encoding: utf-8

class Comment < ActiveRecord::Base
    belongs_to :user
    belongs_to :place
    after_create :send_comment_email
    
    RATINGS = {
        'one star' => '1_star',
        'two stars' => '2_stars',
        'three stars' => '3_stars',
        'four stars' => '4_stars',
        'five stars' => '5_stars'
    }
    
    include Rails.application.routes.url_helpers
    
    # Show Human friendly, readable rating
    def humanized_rating
        RATINGS.invert[self.rating]
    end
    
    def send_comment_email
        @place = self.place
        @place_owner = @place.user
        
        require 'mandrill'
        mandrill = Mandrill::API.new ENV['MANDRILL_API_KEY']
        message = {"html"=>"<p>Hey There!</p> <p>Congrats!  <b>A comment has been added on Nomster</b><br /> Check it out <a style={text-decoration: none; color: black;} href='#{place_url(@place)}'>here</a>!</p><br />Cheers,<br />José",
     "text"=>"Hey There!\nCongrats! A comment has been added on Nomster.\nCheck it out, #{place_url(@place)}\nCheers,\nJosé",
     "subject"=>"A comment has been added to your place",
     "from_email"=>"do-not-reply@pakaraimaic.com",
     "from_name"=>"Nomster",
     "to"=>
        [{"email"=> @place_owner.email,
            "name"=>"Owner",
            "type"=>"to"}],
     "headers"=>{"Reply-To"=>"message.reply@example.com"},
     }
    async = false
    result = mandrill.messages.send message, async
    puts result
    end
    
end
