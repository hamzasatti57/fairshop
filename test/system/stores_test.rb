require "application_system_test_case"

class StoresTest < ApplicationSystemTestCase
  setup do
    @store = stores(:one)
  end

  test "visiting the index" do
    visit stores_url
    assert_selector "h1", text: "Stores"
  end

  test "creating a Store" do
    visit stores_url
    click_on "New Store"

    fill_in "Store address", with: @store.store_address
    fill_in "Store area", with: @store.store_area
    fill_in "Store city", with: @store.store_city
    fill_in "Store close time", with: @store.store_close_time
    fill_in "Store country", with: @store.store_country
    fill_in "Store map link", with: @store.store_map_link
    fill_in "Store name", with: @store.store_name
    fill_in "Store on time", with: @store.store_on_time
    fill_in "Store state", with: @store.store_state
    check "Stroe active" if @store.stroe_active
    fill_in "Vender", with: @store.vender_id
    click_on "Create Store"

    assert_text "Store was successfully created"
    click_on "Back"
  end

  test "updating a Store" do
    visit stores_url
    click_on "Edit", match: :first

    fill_in "Store address", with: @store.store_address
    fill_in "Store area", with: @store.store_area
    fill_in "Store city", with: @store.store_city
    fill_in "Store close time", with: @store.store_close_time
    fill_in "Store country", with: @store.store_country
    fill_in "Store map link", with: @store.store_map_link
    fill_in "Store name", with: @store.store_name
    fill_in "Store on time", with: @store.store_on_time
    fill_in "Store state", with: @store.store_state
    check "Stroe active" if @store.stroe_active
    fill_in "Vender", with: @store.vender_id
    click_on "Update Store"

    assert_text "Store was successfully updated"
    click_on "Back"
  end

  test "destroying a Store" do
    visit stores_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Store was successfully destroyed"
  end
end
