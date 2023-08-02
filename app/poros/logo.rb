class Logo
    attr_reader :url, :likes
    def initialize(data)
        @url = data["urls"]
        @likes = data["likes"]
    end
end