require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  @user = User.new( phone: )
  
  test "user has a valid phone number" do
    @user.phone = 555
    assert !user.save

    @user.phone = 613-293-8463
    assert !user.save

    @user.phone = nil
    assert !user.save
  end
  
  test "user has a street_orig" do
    @user.street_orig = "730 Oakglade Ave."
    assert user.save?

    @user.street_orig = ""
    assert !user.save?
  end
  
  test "user has a street_dest" do
    @user.street_dest = ""
    assert !user.save?
  end
  
  test "user password is between 6 and 20 characters" do
    @user.password = "short"
    assert !user.save?

    @user.password = "nowthisisastoryallabouthowmylifegottwisturnedupsidedown"
    assert !user.save?

    @user.password = "justright"
    asset user.save?

  end
end

