require 'test_helper'

class StoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @store = stores(:one)
  end

  test "should get index" do
    get stores_url
    assert_response :success
  end

  test "should get new" do
    get new_store_url
    assert_response :success
  end

  test "should create store" do
    assert_difference('Store.count') do
      post stores_url, params: { store: { store_address: @store.store_address, store_area: @store.store_area, store_city: @store.store_city, store_close_time: @store.store_close_time, store_country: @store.store_country, store_map_link: @store.store_map_link, store_name: @store.store_name, store_on_time: @store.store_on_time, store_state: @store.store_state, stroe_active: @store.stroe_active, vender_id: @store.vender_id } }
    end

    assert_redirected_to store_url(Store.last)
  end

  test "should show store" do
    get store_url(@store)
    assert_response :success
  end

  test "should get edit" do
    get edit_store_url(@store)
    assert_response :success
  end

  test "should update store" do
    patch store_url(@store), params: { store: { store_address: @store.store_address, store_area: @store.store_area, store_city: @store.store_city, store_close_time: @store.store_close_time, store_country: @store.store_country, store_map_link: @store.store_map_link, store_name: @store.store_name, store_on_time: @store.store_on_time, store_state: @store.store_state, stroe_active: @store.stroe_active, vender_id: @store.vender_id } }
    assert_redirected_to store_url(@store)
  end

  test "should destroy store" do
    assert_difference('Store.count', -1) do
      delete store_url(@store)
    end

    assert_redirected_to stores_url
  end
end
