require "application_system_test_case"

class ProductsSharesTest < ApplicationSystemTestCase
  setup do
    @products_share = products_shares(:one)
  end

  test "visiting the index" do
    visit products_shares_url
    assert_selector "h1", text: "Products Shares"
  end

  test "creating a Products share" do
    visit products_shares_url
    click_on "New Products Share"

    fill_in "Product", with: @products_share.product_id
    fill_in "User", with: @products_share.user_id
    click_on "Create Products share"

    assert_text "Products share was successfully created"
    click_on "Back"
  end

  test "updating a Products share" do
    visit products_shares_url
    click_on "Edit", match: :first

    fill_in "Product", with: @products_share.product_id
    fill_in "User", with: @products_share.user_id
    click_on "Update Products share"

    assert_text "Products share was successfully updated"
    click_on "Back"
  end

  test "destroying a Products share" do
    visit products_shares_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Products share was successfully destroyed"
  end
end
