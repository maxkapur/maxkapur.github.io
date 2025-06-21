module Related
  class Generator < Jekyll::Generator
    def generate(site)
      related_data = site.posts.docs.map do |post|
        # Placeholder; eventually we will put count vector data here
        [post, post.content.length]
      end

      site.posts.docs.each do |current_post|
        current_post.data["related"] = related_data.filter do |related_post, _|
          related_post != current_post
        end.map do |related_post, length|
          {
            "post" => related_post,
            "score" => -(current_post.content.length - length).abs
          }
        end.sort_by { |item| -item["score"] }
      end
    end
  end
end
