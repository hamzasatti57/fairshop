require 'test_helper'

class VendersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vender = venders(:one)
  end

  test "should get index" do
    get venders_url
    assert_response :success
  end

  test "should get new" do
    get new_vender_url
    assert_response :success
  end

  test "should create vender" do
    assert_difference('Vender.count') do
      post venders_url, params: { vender: { address: @vender.address, city: @vender.city, cnic: @vender.cnic, contact: @vender.contact, country: @vender.country, dob: @vender.dob, email: @vender.email, gender: @vender.gender, name: @vender.name } }
    end

    assert_redirected_to vender_url(Vender.last)
  end

  test "should show vender" do
    get vender_url(@vender)
    assert_response :success
  end

  test "should get edit" do
    get edit_vender_url(@vender)
    assert_response :success
  end

  test "should update vender" do
    patch vender_url(@vender), params: { vender: { address: @vender.address, city: @vender.city, cnic: @vender.cnic, contact: @vender.contact, country: @vender.country, dob: @vender.dob, email: @vender.email, gender: @vender.gender, name: @vender.name } }
    assert_redirected_to vender_url(@vender)
  end

  test "should destroy vender" do
    assert_difference('Vender.count', -1) do
      delete vender_url(@vender)
    end

    assert_redirected_to venders_url
  end
end
