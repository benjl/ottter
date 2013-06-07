require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "user has a phone number" do
    user = User.new
    assert user.phone?
  end
  
  test "user has a valid phone number" do
    user = User.new
    assert user.phone.length === "10"
  end
  
  test "user has a street_orig" do
    user = User.new
    assert user.street_dest?
  end
  
  test "user has a street_dest" do
    user = User.new
    assert_match user.street_orig?
  end
  
  test "user password is between 6 and 20 characters" do
    user = User.new
  end
end

