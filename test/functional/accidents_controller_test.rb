require 'test_helper'

class AccidentsControllerTest < ActionController::TestCase
  setup do
    @accident = accidents(:one)
  end

  test "should create accident" do
    assert_difference('Accident.count') do
      post :create, accident: { details: @accident.details, tid: @accident.tid, time: @accident.time }
    end

    assert_redirected_to accident_path(assigns(:accident))
  end

  test "should destroy accident" do
    assert_difference('Accident.count', -1) do
      delete :destroy, id: @accident
    end

    assert_redirected_to accidents_path
  end
end
