# -*- encoding : utf-8 -*-

format :html do

  view :watch do |args|
    wrap :watch, args do
      #type_link = card.watching_type? ? "#{watching_type_cards} | " : ""
      link_args = if card.watching?
        ["following", :off, "stop sending emails about changes to #{card.cardname}", { :hover_content=> 'unfollow' } ]
      else
        ["follow all", :on, "send emails about changes to #{card.cardname}"]
      end
      link_args[2] += ' cards'
      #type_link + 
      watch_link( *link_args )
    end
  end
end

include Card::Set::Type::Basic

def on_type_change
  custom_validate_delete
end

def validate_type_change
  custom_validate_delete
end

def cards_of_type_exist?
  Account.as_bot { Card.count_by_wql :type_id=>id } > 0
end

def custom_validate_delete
  if cards_of_type_exist?
    errors.add :cardtype, "can't be altered because #{name} is a Cardtype and cards of this type still exist"
    false
  else
    true
  end
end
