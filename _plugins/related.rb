require "tokenizer"

TOKENIZER = Tokenizer::WhitespaceTokenizer.new

module Related
  class Generator < Jekyll::Generator
    def generate(site)
      posts_countdata = site.posts.docs.to_h do |post|
        # Placeholder; eventually we will put count vector data here
        tokenized = TOKENIZER.tokenize post.content.downcase
        counts = Hash.new(0)
        tokenized.each do |token|
          counts[token] += 1
        end
        norm = Math.sqrt counts.values.map { |x| x**2 }.sum
        [post, {counts: counts, norm: norm}]
      end

      site.posts.docs.each do |current_post|
        current_post.data["related"] = posts_countdata.filter do |related_post, _|
          related_post != current_post
        end.map do |related_post, length|
          {
            "post" => related_post,
            "score" => similarity(posts_countdata[current_post], posts_countdata[related_post])
          }
        end.sort_by { |item| -item["score"] }
      end
    end

    # Cosine similarity between the two count vectors
    def similarity(current_data, related_data)
      tokens = (current_data[:counts].keys + related_data[:counts].keys).uniq
      dot = tokens.map do |token|
        current_data[:counts][token] * related_data[:counts][token]
      end.sum
      dot / (current_data[:norm] * related_data[:norm])
    end
  end
end
