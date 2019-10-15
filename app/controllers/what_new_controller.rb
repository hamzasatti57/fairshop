class WhatNewController < ApplicationController
  def index
    @categories = Category.all
    @products = Product.all.order( 'id  DESC' ).limit(9)
    @projects = Project.all.order( 'id  DESC' ).limit(9)
  end

end
