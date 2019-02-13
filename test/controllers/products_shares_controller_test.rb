require 'test_helper'

class ProductsSharesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @products_share = products_shares(:one)
  end

  test "should get index" do
    get products_shares_url
    assert_response :success
  end

  test "should get new" do
    get new_products_share_url
    assert_response :success
  end

  test "should create products_share" do
    assert_difference('ProductsShare.count') do
      post products_shares_url, params: { products_share: { product_id: @products_share.product_id, user_id: @products_share.user_id } }
    end

    assert_redirected_to products_share_url(ProductsShare.last)
  end

  test "should show products_share" do
    get products_share_url(@products_share)
    assert_response :success
  end

  test "should get edit" do
    get edit_products_share_url(@products_share)
    assert_response :success
  end

  test "should update products_share" do
    patch products_share_url(@products_share), params: { products_share: { product_id: @products_share.product_id, user_id: @products_share.user_id } }
    assert_redirected_to products_share_url(@products_share)
  end

  test "should destroy products_share" do
    assert_difference('ProductsShare.count', -1) do
      delete products_share_url(@products_share)
    end

    assert_redirected_to products_shares_url
  end
end
