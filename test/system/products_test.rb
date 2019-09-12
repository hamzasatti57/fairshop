require "application_system_test_case"

class ProductsTest < ApplicationSystemTestCase
  setup do
    @product = products(:one)
  end

  test "visiting the index" do
    visit products_url
    assert_selector "h1", text: "Products"
  end

  test "creating a Product" do
    visit products_url
    click_on "New Product"

    fill_in "Product brand", with: @product.product_brand
    check "Product cash on delivery" if @product.product_cash_on_delivery
    fill_in "Product category", with: @product.product_category
    fill_in "Product color", with: @product.product_color
    fill_in "Product discount", with: @product.product_discount
    check "Product home delivery" if @product.product_home_delivery
    check "Product isview" if @product.product_isview
    fill_in "Product material", with: @product.product_material
    fill_in "Product model", with: @product.product_model
    fill_in "Product name", with: @product.product_name
    fill_in "Product purchase price", with: @product.product_purchase_price
    fill_in "Product quantity", with: @product.product_quantity
    fill_in "Product return days", with: @product.product_return_days
    fill_in "Product sale price", with: @product.product_sale_price
    check "Product sale status" if @product.product_sale_status
    fill_in "Product warranty", with: @product.product_warranty
    fill_in "Store", with: @product.store_id
    click_on "Create Product"

    assert_text "Product was successfully created"
    click_on "Back"
  end

  test "updating a Product" do
    visit products_url
    click_on "Edit", match: :first

    fill_in "Product brand", with: @product.product_brand
    check "Product cash on delivery" if @product.product_cash_on_delivery
    fill_in "Product category", with: @product.product_category
    fill_in "Product color", with: @product.product_color
    fill_in "Product discount", with: @product.product_discount
    check "Product home delivery" if @product.product_home_delivery
    check "Product isview" if @product.product_isview
    fill_in "Product material", with: @product.product_material
    fill_in "Product model", with: @product.product_model
    fill_in "Product name", with: @product.product_name
    fill_in "Product purchase price", with: @product.product_purchase_price
    fill_in "Product quantity", with: @product.product_quantity
    fill_in "Product return days", with: @product.product_return_days
    fill_in "Product sale price", with: @product.product_sale_price
    check "Product sale status" if @product.product_sale_status
    fill_in "Product warranty", with: @product.product_warranty
    fill_in "Store", with: @product.store_id
    click_on "Update Product"

    assert_text "Product was successfully updated"
    click_on "Back"
  end

  test "destroying a Product" do
    visit products_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Product was successfully destroyed"
  end
end
