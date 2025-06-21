module Related
  class Generator < Jekyll::Generator
    def generate(site)
      related_data = site.posts.docs.map do |post|
        # Placeholder; eventually we will put count vector data here
        [post, post.content.length]
      end

      site.posts.docs.each do |current_post|
        similarity_scores = related_data.map do |related_post, length|
          {
            "post" => related_post,
            "score" => -(current_post.content.length - length).abs
          }
        end.sort_by { |item| -item["score"] }
        current_post.data["related"] = similarity_scores
      end
    end
  end
end
