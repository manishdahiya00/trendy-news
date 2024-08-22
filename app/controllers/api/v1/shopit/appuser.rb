module API
  module V1
    module Shopit
      class Appuser < Grape::API
        include API::V1::Shopit::Defaults

        ##################################################################
        # => Product-List-Page
        ##################################################################
        resource :productList do
          desc "Product List API"
          before { api_params }
          params do
            use :common_params
            requires :categoryId, type: Integer, allow_blank: true
            requires :query, type: String, allow_blank: true
            requires :productId, type: Integer, allow_blank: true
          end
          post do
            begin
              @account = valid_user(params[:userId], params[:securityToken])
              if @account
                data = []
                if params[:categoryId].present?
                  @products = ShopitCategory.find(params[:categoryId]).products.where("Name LIKE ?", "%#{params[:query]}%")
                elsif params[:query].present?
                  @products = Product.where("Name LIKE ?", "%#{params[:query]}%")
                elsif params[:productId].present?
                  product = Product.find(params[:productId])
                  data <<
                  {
                    Pid: product.id,
                    Pname: product.name,
                    Pimage: product.image_url,
                    Pprice: product.price,
                    Pitems: product.no_of_items,
                    Pdescription: product.description,
                  }
                else
                  @products = Product.all
                end
                if @products.present?
                  @products.each do |product|
                    data << {
                      Pid: product.id,
                      Pname: product.name,
                      Pimage: product.image_url,
                      Pprice: product.price,
                      Pitems: product.no_of_items,
                    }
                  end
                end
                { message: MSG_SUCCESS, status: 200, productData: data }
              else
                { message: INVALID_USER, status: 500 }
              end
            rescue Exception => e
              Rails.logger.info "API Exception-#{Time.now}-productList-#{params.inspect}-Error-#{e}"
              { message: MSG_ERROR, status: 500 }
            end
          end
        end

        ##################################################################
        # => APP Banners
        ##################################################################
        resource :appBanners do
          before { api_params }
          params do
            use :common_params
          end
          post do
            begin
              @account = valid_user(params[:userId], params[:securityToken])
              if @account
                data = [
                  {
                    productId: Product.first.id,
                    image: Product.first.image_url,
                    name: Product.first.name,
                  },
                  {
                    productId: Product.second.id,
                    image: Product.second.image_url,
                    name: Product.second.name,
                  },
                  {
                    productId: Product.last.id,
                    image: Product.last.image_url,
                    name: Product.last.name,
                  },
                ]

                { message: MSG_SUCCESS, status: 200, banners: data }
              else
                { message: INVALID_USER, status: 500 }
              end
            rescue Exception => e
              Rails.logger.info "API Exception-#{Time.now}-appBanners-#{params.inspect}-Error-#{e}"
              { message: MSG_ERROR, status: 500 }
            end
          end
        end
        ##################################################################
        # => ShopitCategory
        ##################################################################
        resource :categoryList do
          desc "ShopitCategory List API"
          params do
            use :common_params
            requires :catSearch, type: String, allow_blank: true
          end
          post do
            begin
              @account = valid_user(params[:userId], params[:securityToken])
              if @account
                data = []
                if params[:catSearch].present?
                  category = ShopitCategory.where("Name LIKE ?", "%#{params[:catSearch]}%")
                  category.each do |cat|
                    data << {
                      Cid: cat.id,
                      Cname: cat.name,
                      Cimage: cat.image_url,
                      Citems: cat.products.count,
                    }
                  end
                else
                  @category = ShopitCategory.all
                  @category.each do |cat|
                    data << {
                      Cid: cat.id,
                      Cname: cat.name,
                      Cimage: cat.image_url,
                      Citems: cat.products.count,
                    }
                  end
                end
                { message: MSG_SUCCESS, status: 200, ShopitCategoryListData: data }
              else
                { message: INVALID_USER, status: 500 }
              end
            rescue Exception => e
              Rails.logger.info "API Exception-#{Time.now}-CategoriesData-#{params.inspect}-Error-#{e}"
              { message: MSG_ERROR, status: 500 }
            end
          end
        end

        ##################################################################
        # => Add to Cart
        ##################################################################
        resource :addToCart do
          desc "Add items in Cart api"
          before { api_params }
          params do
            use :common_params
            requires :productId, type: Integer, allow_blank: false
            requires :noOfProducts, type: Integer, allow_blank: false
          end
          post do
            begin
              @account = valid_user(params[:userId], params[:securityToken])
              if @account
                c = Cart.find_by(shopit_user_id: @account.id, product_id: params[:productId], checkout_id: nil)

                if c.present?
                  product = Product.find params[:productId]
                  if product.no_of_items >= params[:noOfProducts]
                    c.update(no_of_products: (c.no_of_products.to_i + params[:noOfProducts]))
                    product.update(no_of_items: (product.no_of_items.to_i - params[:noOfProducts]))
                    { message: MSG_SUCCESS, status: 200, addedToCartData: "Item Added To Cart" }
                  else
                    { message: MSG_SUCCESS, status: 200, addedToCartData: "Product quantity is greater than available quantity" }
                  end
                else
                  product = Product.find params[:productId]
                  if product.no_of_items >= params[:noOfProducts]
                    Cart.create(shopit_user_id: @account.id, product_id: params[:productId], no_of_products: params[:noOfProducts])

                    product.update(no_of_items: (product.no_of_items.to_i - params[:noOfProducts]))
                    { message: MSG_SUCCESS, status: 200, addedToCartData: "Item Added To Cart" }
                  else
                    { message: MSG_SUCCESS, status: 200, addedToCartData: "Product quantity is greater than available quantity" }
                  end
                end
              else
                { message: INVALID_USER, status: 500 }
              end
            rescue Exception => e
              Rails.logger.info "API Exception-#{Time.now}-AddToCart-#{params.inspect}-Error-#{e}"
              { message: MSG_ERROR, status: 500 }
            end
          end
        end

        ##################################################################
        # => Shopping Cart
        ##################################################################
        resource :shoppingCart do
          desc "Shopping items api"
          before { api_params }
          params do
            use :common_params
            requires :productId, type: Integer, allow_blank: true
            requires :clear, type: String, allow_blank: true
          end
          post do
            begin
              @account = valid_user(params[:userId], params[:securityToken])
              if @account
                if params[:productId].present? && @account.carts.find_by(product_id: params[:productId]).present?
                  product = Product.find params[:productId]
                  cartProduct = Cart.find_by(product_id: params[:productId])
                  product.no_of_items = product.no_of_items.to_i + cartProduct.no_of_products.to_i
                  cartProduct = Cart.find_by(product_id: params[:productId])
                  cartProduct.destroy
                  product.save
                elsif params[:clear] == "clear"
                  carts = @account.carts
                  carts.each do |item|
                    item.product.no_of_items = item.product.no_of_items.to_i + item.no_of_products.to_i
                    item.product.save
                    item.destroy
                  end
                end

                carts = @account.carts
                data = []
                total = 0
                carts.each do |item|
                  data << {
                    Pid: item.product.id,
                    Pname: item.product.name,
                    Pimage: item.product.image_url,
                    price: item.product.price.to_i,
                    no_of_products: item.no_of_products,
                    totalUnitPrice: item.product.price.to_i * item.no_of_products,
                  }
                  total = total + (item.product.price.to_i * item.no_of_products)
                end
                data << { total_price: "#{(total + (total) * 0.1)} INR" }

                { message: MSG_SUCCESS, status: 200, ShoppingCartData: data }
              else
                { message: INVALID_USER, status: 500 }
              end
            rescue Exception => e
              Rails.logger.info "API Exception-#{Time.now}-ShoppingCart-#{params.inspect}-Error-#{e}"
              { message: MSG_ERROR, status: 500 }
            end
          end
        end

        ##################################################################
        # => Checkout
        ##################################################################
        resource :checkout do
          desc "Checkout Shopping items API"
          before { api_params }
          params do
            use :common_params
            requires :name, type: String, allow_blank: false
            requires :email, type: String, allow_blank: false
            requires :mobile, type: String, allow_blank: false
            requires :address, type: String, allow_blank: false
            requires :shipping, type: String, allow_blank: false
            requires :comment, type: String, allow_blank: true
          end
          post do
            begin
              @account = valid_user(params[:userId], params[:securityToken])
              if @account
                cart_items = @account.carts
                orders = @account.orders

                if cart_items.present?
                  checkout = Checkout.create(
                    name: params[:name],
                    email: params[:email],
                    mobile: params[:mobile],
                    address: params[:address],
                    shipping: params[:shipping],
                    comment: params[:comment],
                    order_status: "placed",
                    shopit_user_id: @account.id,
                    order_id: SecureRandom.hex(10),
                  )

                  cart_items.each do |cart_item|
                    order = Order.create(
                      product_id: cart_item.product_id,
                      shopit_user_id: @account.id,
                      no_of_products: cart_item.no_of_products,
                      checkout_id: checkout.id,
                    )
                  end
                  @account.carts.destroy_all

                  { message: MSG_SUCCESS, status: 200, CheckoutShoppingCartData: "Order Placed" }
                else
                  { message: MSG_SUCCESS, status: 200, orderStatus: "Order-Not-Placed / No Checked-Out Items" }
                end
              else
                { message: INVALID_USER, status: 500 }
              end
            rescue Exception => e
              Rails.logger.info "API Exception-#{Time.now}-CheckoutShoppingCartData-#{params.inspect}-Error-#{e}"
              { message: MSG_ERROR, status: 500 }
            end
          end
        end

        ##################################################################
        # => user Profile
        ##################################################################
        resource :UserProfile do
          desc "User Profile"
          before { api_params }
          params do
            use :common_params
            requires :name, type: String, allow_blank: true
            requires :email, type: String, allow_blank: true
            requires :mobile, type: String, allow_blank: true
            requires :address, type: String, allow_blank: true
          end
          post do
            begin
              @account = valid_user(params[:userId], params[:securityToken])
              if @account
                if params[:name].present?
                  @account.update(social_name: params[:name])
                end
                if params[:email].present?
                  @account.update(social_email: params[:email])
                end
                if params[:mobile].present?
                  @account.update(mobile_number: params[:mobile])
                end
                if params[:address].present?
                  @account.update(address: params[:address])
                end

                data = []
                data << {
                  Uname: @account.social_name,
                  Uemail: @account.social_email,
                  Umobile: @account.mobile_number,
                  Uaddress: @account.address,
                }
                { message: MSG_SUCCESS, status: 200, userProfileData: data }
              else
                { message: INVALID_USER, status: 500 }
              end
            rescue Exception => e
              Rails.logger.info "API Exception-#{Time.now}-UserProfile-#{params.inspect}-Error-#{e}"
              { message: MSG_ERROR, status: 500 }
            end
          end
        end

        ##################################################################
        # => Order History Index
        ##################################################################
        resource :orderHistory do
          desc "Order History API"
          before { api_params }
          params do
            use :common_params
            requires :clear, type: String, allow_blank: true
          end
          post do
            begin
              @account = valid_user(params[:userId], params[:securityToken])
              if @account
                data = []

                if params[:clear] == "clear"
                  # checkouts = @account.checkouts
                  # checkouts.each do |checkout|
                  #   carts = Cart.where(checkout_id: checkout.id)
                  #   carts.destroy_all
                  #   checkout.destroy
                  #   checkout.save
                  # end
                else
                  checkouts = @account.checkouts.order(created_at: :desc)
                  checkouts.each do |checkout|
                    allcheckedOutOrder = Order.where(checkout_id: checkout.id)
                    total = 0
                    allcheckedOutOrder.each do |order|
                      total = (order.product.price.to_i * order.no_of_products.to_i) + total
                    end
                    data << {
                      checkoutId: checkout.order_id,
                      orderDate: checkout.created_at.to_date,
                      totalCheckoutPrice: "#{total}  INR",
                      status: checkout.order_status,
                    }
                  end
                end
                { message: MSG_SUCCESS, status: 200, orderHistoryListData: data }
              else
                { message: INVALID_USER, status: 500 }
              end
            rescue Exception => e
              Rails.logger.info "API Exception-#{Time.now}-orderHistoryList-#{params.inspect}-Error-#{e}"
              { message: MSG_ERROR, status: 500 }
            end
          end
        end

        ##################################################################
        # => Order History Show
        ##################################################################
        resource :orderHistoryShow do
          desc "Order History Show Page API"
          before { api_params }
          params do
            use :common_params
            requires :checkoutId, type: String, allow_blank: false
          end
          post do
            begin
              @account = valid_user(params[:userId], params[:securityToken])
              if @account
                checkout = Checkout.find_by(order_id: params[:checkoutId])
                orders = Order.where(checkout_id: checkout.id)
                data = []
                total = 0
                product = []
                orders.each do |order|
                  total = (order.product.price.to_i * order.no_of_products.to_i) + total
                  product << "#{order.no_of_products} - #{order.product.name} - #{(order.product.price.to_i * order.no_of_products.to_i)} INR"
                end
                data << {
                  orderId: checkout.order_id,
                  totalOrderPrice: "#{total + (total * 0.1)} INR",
                  date: checkout.created_at.strftime("%Y-%m-%d"),
                  products: product,
                  orderPrice: "#{total} INR",
                  tax: "10% :#{total / 10} INR",
                }
                { message: MSG_SUCCESS, status: 200, orderHistoryShowData: data }
              else
                { message: INVALID_USER, status: 500 }
              end
            rescue Exception => e
              Rails.logger.info "API Exception-#{Time.now}-orderHistoryShow-#{params.inspect}-Error-#{e}"
              { message: MSG_ERROR, status: 500 }
            end
          end
        end
      end
    end
  end
end
