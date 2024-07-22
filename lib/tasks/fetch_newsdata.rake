namespace :fetch_newsdata do
  APIKEYS = ["f4919ce87ada4fda8952163971ed9fb6", "2de3306568914944bb0745a61ba14a8a", "d55d4e04e08a44d0be8cdba587e437a0"]

  desc "Fetch top headlines from news api"
  task fetch_headlines: :environment do
    require "news-api"
    newsapi = News.new(APIKEYS.sample)
    article_list = newsapi.get_top_headlines(language: "en", country: "in")
    puts "top_headlines:article_list_size: #{article_list.size}"

    if article_list.size > 0
      article_list.each do |articleData|
        begin
          if articleData.url.present? && articleData.url.size < 255 && articleData.urlToImage.present? && articleData.urlToImage.size < 255
            article = Article.where(source_url: articleData.url).first_or_initialize
            if article.new_record?
              if article.update(author: (articleData.author || articleData.name), description: articleData.description, published_at: articleData.publishedAt,
                                title: articleData.title, category_id: [1, 7].sample, image_url: articleData.urlToImage, content: articleData.content)
                puts "article_title: #{articleData.title}"
              else
                puts "Error saving article: #{article.errors.full_messages}"
              end
            end
          end
        rescue Exception => e
          puts "top_headlines:exception:#{e}"
          next
        end
      end
    else
      puts "No Article:top_headlines"
      puts "top_headlines:article_list_size: #{article_list.size}"
    end

    newsapi = News.new(APIKEYS.sample)
    article_list = newsapi.get_top_headlines(language: "en", country: "in", page: 2)
    puts "top_headlines2:article_list_size: #{article_list.size}"

    if article_list.size > 0
      article_list.each do |articleData|
        begin
          if articleData.url.present? && articleData.url.size < 255 && articleData.urlToImage.present? && articleData.urlToImage.size < 255
            article = Article.where(source_url: articleData.url).first_or_initialize
            if article.new_record?
              if article.update(author: (articleData.author || articleData.name), description: articleData.description, published_at: articleData.publishedAt,
                                title: articleData.title, category_id: [1, 7].sample, image_url: articleData.urlToImage, content: articleData.content)
                puts "article_title: #{articleData.title}"
              else
                puts "Error saving article: #{article.errors.full_messages}"
              end
            end
          end
        rescue Exception => e
          puts "top_headlines2:exception:#{e}"
          next
        end
      end
    else
      puts "No Article:top_headlines2"
      puts "top_headlines2:article_list_size: #{article_list.size}"
    end
  end

  desc "Fetch Categorynews from news api"
  task fetch_categorynews: :environment do
    require "news-api"
    newsapi = News.new(APIKEYS.sample)
    categories = { business: 2, entertainment: 3, health: 4, sports: 5, technology: 6, general: 7, science: 8 }

    categories.each do |category, category_id|
      article_list = newsapi.get_top_headlines(language: "en", country: "in", category: category.to_s)
      puts "#{category}:article_list_size: #{article_list.size}"

      if article_list.size > 0
        article_list.each do |articleData|
          begin
            if articleData.url.present? && articleData.url.size < 255 && articleData.urlToImage.present? && articleData.urlToImage.size < 255
              article = Article.where(source_url: articleData.url).first_or_initialize
              if article.new_record?
                if article.update(author: (articleData.author || articleData.name), description: articleData.description, published_at: articleData.publishedAt,
                                  title: articleData.title, category_id: category_id, image_url: articleData.urlToImage, content: articleData.content)
                  puts "article_title: #{articleData.title}"
                else
                  puts "Error saving article: #{article.errors.full_messages}"
                end
              end
            end
          rescue Exception => e
            puts "#{category}:exception:#{e}"
            next
          end
        end
      else
        puts "No Article:#{category}"
        puts "#{category}:article_list_size: #{article_list.size}"
      end
    end
  end
end
