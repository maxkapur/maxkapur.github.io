module Related
  class Generator < Jekyll::Generator
    def generate(site)
      site.posts.docs.filter { |post| !post.data["hidden"] }.each do |post|
        post.data["related"] = ["placeholder1", "placeholder2"]
      end
    end
  end
end
