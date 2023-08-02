class UnsplashService
    
    def get_logo
        response = connection.get("/photos/mpwF3Mv2UaU")
        parsed = JSON.parse(response.body)
        Logo.new(parsed)
    end

    def search_image(name)
        response = connection.get "/search/photos/?query=#{name}"
        id = JSON.parse(response.body)["results"].sample["id"]
        response = connection.get("/photos/#{id}")
        parsed = JSON.parse(response.body)
        Logo.new(parsed)
    end

    def random_photo
        response = connection.get("/photos/random")
        parsed = JSON.parse(response.body)
        Logo.new(parsed)
    end

    def connection
        Faraday.new(url: "https://api.unsplash.com", params: {"client_id" => ENV["UNSPLASH_API_KEY"]})
    end
end