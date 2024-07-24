module API
  module V1
    class Appuser < Grape::API
      include API::V1::Defaults

      resource :home do
        before { api_params }
        params do
          use :common_params
        end
        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            app_banners = []
            news = []
            Article.all.limit(5).active.each do |news|
              app_banners << {
                newsId: news.id,
                newsTitle: news.title,
                author: news.author,
                imageUrl: news.image_url,
              }
            end
            Category.active.each do |category|
              if category.name == "Main News"
                category_news = Article.all.active
                news << {
                  categoryName: category.name,
                  news: category_news.map do |news|
                    {
                      newsId: news.id,
                      newsTitle: news.title,
                      author: news.author,
                      imageUrl: news.image_url,
                      publishedAt: news.published_at,
                    }
                  end,
                }
              else
                category_news = category.articles.active
                news << {
                  categoryName: category.name,
                  news: category_news.map do |news|
                    {
                      newsId: news.id,
                      newsTitle: news.title,
                      author: news.author,
                      imageUrl: news.image_url,
                      publishedAt: news.published_at,
                    }
                  end,
                }
              end
            end
            { status: 200, message: MSG_SUCCESS, appBanners: app_banners || [], news: news || [] }
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-home-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR }
          end
        end
      end

      resource :videoNews do
        before { api_params }
        params do
          use :common_params
        end
        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            news_data = []
            Article.all.limit(30).active.each do |news|
              news_data << {
                newsId: news.id,
                newsTitle: news.title,
                author: news.author,
                imageUrl: news.image_url,
                category: news.category.name,
                publishedAt: news.published_at,
              }
            end
            { status: 200, message: MSG_SUCCESS, news: news_data || [] }
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-allNews-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR }
          end
        end
      end

      resource :customAds do
        before { api_params }
        params do
          use :common_params
        end
        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            custom_ads = []
            AppBanner.active.all.each do |custom_ad|
              custom_ads << {
                imageUrl: custom_ad.image_url,
                actionUrl: custom_ad.action_url,
              }
            end
            { status: 200, message: MSG_SUCCESS, customAds: custom_ads || [] }
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-allNews-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR }
          end
        end
      end

      resource :categoryDetails do
        before { api_params }
        params do
          use :common_params
          requires :categoryId, type: String, allow_blank: false
        end
        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            news = []
            category = Category.find(params[:categoryId])
            return { status: 500, message: "NO CATEGORY FOUND" } unless category.present?
            if category.name == "Main News"
              Article.all.active.each do |article|
                news << {
                  newsId: article.id,
                  newsTitle: article.title,
                  author: article.author,
                  imageUrl: article.image_url,
                  publishedAt: article.published_at,
                }
              end
            else
              category.articles.active.each do |article|
                news << {
                  newsId: article.id,
                  newsTitle: article.title,
                  author: article.author,
                  imageUrl: article.image_url,
                  publishedAt: article.published_at,
                }
              end
            end

            { status: 200, message: MSG_SUCCESS, news: news || [] }
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-categoryDetails-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR }
          end
        end
      end

      resource :newsDetails do
        before { api_params }
        params do
          use :common_params
          requires :newsId, type: String, allow_blank: false
        end
        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?

            news = Article.find(params[:newsId])
            return { status: 500, message: "INVALID NEWS" } unless news.present?
            related_news = []
            news_data = {
              newsTitle: news.title,
              imageUrl: news.image_url,
              description: news.description,
              content: news.content,
              sourceUrl: news.source_url,
              author: news.author,
              publishedAt: news.published_at,
            }
            relatedNews = Article.where(category_id: news.category_id).order("RAND()").active
            relatedNews.each do |news|
              related_news << {
                newsId: news.id,
                newsTitle: news.title,
                author: news.author,
                imageUrl: news.image_url,
                publishedAt: news.published_at,
              }
            end
            { status: 200, message: MSG_SUCCESS, newsData: news_data || {}, relatedNews: related_news || [] }
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-newsDetails-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR }
          end
        end
      end

      resource :categories do
        before { api_params }
        params do
          use :common_params
        end
        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            categories = []
            Category.active.all.each do |category|
              categories << { categoryId: category.id, name: category.name, image: category.image_url }
            end
            { status: 200, message: MSG_SUCCESS, categories: categories || [] }
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-categories-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR }
          end
        end
      end

      resource :search do
        before { api_params }
        params do
          use :common_params
          optional :query, type: String, allow_blank: true
        end
        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            news = []
            if params[:query].present?
              articles = Article.active.where("title LIKE ?", "%#{params[:query]}%")
              articles.each do |article|
                news << {
                  newsId: article.id,
                  newsTitle: article.title,
                  author: article.author,
                  imageUrl: article.image_url,
                  publishedAt: article.published_at,
                }
              end
            end
            { status: 200, message: MSG_SUCCESS, news: news || [] }
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-search-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR }
          end
        end
      end

      resource :saveNews do
        before { api_params }
        params do
          use :common_params
          requires :newsId, type: String, allow_blank: false
        end
        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            is_saved = user.saved.find_by(article_id: params[:newsId].to_i).present?
            if is_saved
              user.saved.find_by(article_id: params[:newsId].to_i).destroy
            else
              user.saved.create(article_id: params[:newsId].to_i)
            end
            { status: 200, message: MSG_SUCCESS, success: true }
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-saveNews-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR }
          end
        end
      end

      resource :savedNews do
        before { api_params }
        params do
          use :common_params
        end
        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            news = []
            user.saved.all.order(created_at: :desc).each do |saved|
              news << {
                newsId: saved.article.id,
                newsTitle: saved.article.title,
                author: saved.article.author,
                imageUrl: saved.article.image_url,
              }
            end
            { status: 200, message: MSG_SUCCESS, news: news || [] }
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-savedNews-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR }
          end
        end
      end

      resource :profile do
        before { api_params }
        params do
          use :common_params
        end
        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            { status: 200, message: MSG_SUCCESS, userName: user.social_name, userEmail: user.social_email, userImage: user.social_img_url }
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-profile-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR }
          end
        end
      end
    end
  end
end
