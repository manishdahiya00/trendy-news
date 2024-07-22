categories = [
  { id: 1, name: "Main News", status: true, image_url: "https://cdn-icons-png.flaticon.com/512/219/219986.png", color: "#ba9357" },
  { id: 2, name: "Business", status: true, image_url: "https://cdn-icons-png.flaticon.com/128/3135/3135727.png", color: "#ff0000" },
  { id: 3, name: "Entertainment", status: true, image_url: "https://cdn-icons-png.flaticon.com/128/3163/3163478.png", color: "#00ff00" },
  { id: 4, name: "Health", status: true, image_url: "https://cdn-icons-png.flaticon.com/128/2382/2382533.png", color: "#0000ff" },
  { id: 5, name: "Sports", status: true, image_url: "https://cdn-icons-png.flaticon.com/128/4645/4645268.png", color: "#ffff00" },
  { id: 6, name: "Technology", status: true, image_url: "https://cdn-icons-png.flaticon.com/128/8055/8055545.png", color: "#ff00ff" },
  { id: 7, name: "General", status: true, image_url: "https://cdn-icons-png.flaticon.com/128/13565/13565345.png", color: "#00ffff" },
  { id: 8, name: "Science", status: true, image_url: "https://cdn-icons-png.flaticon.com/128/2022/2022299.png", color: "#000000" },
]

categories.each do |category|
  Category.find_or_create_by(id: category[:id]) do |cat|
    cat.name = category[:name]
    cat.status = category[:status]
    cat.image_url = category[:image_url]
    cat.color = category[:color]
  end
end
