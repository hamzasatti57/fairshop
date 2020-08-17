class CartController < ApplicationController


  def index
    @cart = current_user.user_carts.where(status: 0).last.user_cart_products.order("created_at DESC") if current_user.user_carts.where(status: 0).present?
    @sum = current_user.user_carts.where(status: 0).last.user_cart_products.pluck(:sub_total).sum if current_user.user_carts.where(status: 0).present? && current_user.user_carts.where(status: 0).last.user_cart_products.present?
  end

  def delete_cart_product
    @user_cart_products = current_user.user_carts.where(status: 0).last.user_cart_products if current_user.user_carts.where(status: 0).present?
    @user_cart_products.where(id: params[:id].to_i).last.destroy
    flash[:info] = "Removed from cart!"
    redirect_back(fallback_location: root_path)
  end
end