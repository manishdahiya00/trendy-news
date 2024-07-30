categories = [
  { id: 1, name: "Main News", status: true, image_url: "https://images.pexels.com/photos/10169392/pexels-photo-10169392.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1", color: "#ba9357" },
  { id: 2, name: "Business", status: true, image_url: "https://images.pexels.com/photos/57690/pexels-photo-57690.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1", color: "#ff0000" },
  { id: 3, name: "Entertainment", status: true, image_url: "https://images.pexels.com/photos/1327430/pexels-photo-1327430.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1", color: "#00ff00" },
  { id: 4, name: "Health", status: true, image_url: "https://images.pexels.com/photos/317157/pexels-photo-317157.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1", color: "#0000ff" },
  { id: 5, name: "Sports", status: true, image_url: "https://images.pexels.com/photos/46798/the-ball-stadion-football-the-pitch-46798.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1", color: "#ffff00" },
  { id: 6, name: "Technology", status: true, image_url: "https://images.pexels.com/photos/546819/pexels-photo-546819.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1", color: "#ff00ff" },
  { id: 7, name: "General", status: true, image_url: "https://images.pexels.com/photos/5146450/pexels-photo-5146450.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1", color: "#00ffff" },
  { id: 8, name: "Science", status: true, image_url: "https://images.pexels.com/photos/356040/pexels-photo-356040.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1", color: "#000000" },
]

categories.each do |category|
  Category.find_or_create_by(id: category[:id]) do |cat|
    cat.name = category[:name]
    cat.status = category[:status]
    cat.image_url = category[:image_url]
    cat.color = category[:color]
  end
end
