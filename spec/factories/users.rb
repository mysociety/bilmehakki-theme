# -*- encoding : utf-8 -*-
FactoryGirl.modify do

  factory :user do
    identity_card_number '12345678901'
    address <<-EOF.strip_heredoc
    12 The Street
    The Town
    Istanbul
    123891
    EOF
  end

end
