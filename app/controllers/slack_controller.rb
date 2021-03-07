class SlackController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    if slack_params[:ssl_check].present?
      head :ok
    elsif verified?
      render json: response_message(find_recipes), status: :ok
    else
      head :forbidden
    end
  end

  private
  def verified?
    return true if Rails.env.development?
    if (Time.now.to_i - slack_timestamp.to_i).abs > 5.minutes
      Rails.logger.warn { "Slack timestamp #{slack_timestamp} not within 5 minutes of #{Time.now.to_i}" }
      return false
    end
    if "v0=#{hmac_digest}" != slack_signature
      Rails.logger.warn { "Slack signature #{slack_signature} does not match calculated hmac #{hmac_digest}" }
      return false
    end
    return true
  end

  def hmac_digest
    OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new('sha256'),
      ENV["SLACK_SIGNING_SECRET"],
      slack_sig_basestring
    )
  end

  def slack_sig_basestring
    "v0:#{slack_timestamp}:#{request.raw_post}"
  end

  def slack_signature
    request.headers["X-Slack-Signature"]
  end

  def slack_timestamp
    request.headers['X-Slack-Request-Timestamp']
  end

  def find_recipes
    filter_recipes.resolved.limit(5)
  end

  def query_hash
    { q: slack_params[:text] }
  end

  def slack_params
    params.permit(:command, :text, :response_url, :trigger_id, :user_id, :user_name,
                  :team_id, :enterprise_id, :channel_id, :ssl_check)
  end

  def response_message(recipes)
    if recipes.size == 0
      return {
        response_type: "ephemeral",
        text: "*Brygglogg.se* - Hittade inga recept"
      }
    elsif recipes.size > 1
      # TODO: If one recipe name matches exactly, return that
      return {
        response_type: "ephemeral",
        text: "*Brygglogg.se* - Hittade flera recept:\n#{recipe_names(recipes)}"
      }
    else
      return slack_message(recipes.first)
    end
  end

  def recipe_names(recipes)
    recipes.map { |recipe| "- #{recipe.name_and_brewer}\n" }.join
  end

  def slack_message(recipe)
    # TODO: Change to blocks in response
    {
      response_type: "in_channel",
      attachments: [{
        fallback: "#{recipe.name_and_brewer} - #{full_url_for(recipe)}",
        title: recipe.name_and_brewer,
        title_link: full_url_for(recipe),
        author_name: recipe.brewer_name,
        author_link: full_url_for(recipe.user),
        author_icon: full_url_for(recipe.user.avatar_image(:large)),
        text: recipe.description,
        image_url: full_url_for(recipe.main_image(:large)),
        color: 'warning',
        fields: [
          { title: 'Stiltyp', value: recipe.style_name, short: false },
          { title: 'ABV', value: recipe.abv, short: true },
          { title: 'IBU', value: recipe.ibu, short: true },
        ]
      }]
    }
  end
end
