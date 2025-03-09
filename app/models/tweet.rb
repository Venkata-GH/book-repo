class Tweet
  include Mongoid::Document
  include Mongoid::Timestamps
  field :id_str, type: String
  field :screen_name, type: String
  field :profile_image_url, type: String
  field :post, type: String
  field :tweet_at, type: DateTime

  private

  #----------------#
  # self.get_tweet #
  #----------------#
  def self.get_tweet( user )
    TweetStream.configure do |config|
      config.consumer_key       = Settings.twitter_key
      config.consumer_secret    = Settings.twitter_secret
      config.oauth_token        = user.token
      config.oauth_token_secret = user.secret
      config.auth_method        = :oauth
      config.parser             = :json_pure
    end

    EM.run do
      client = TweetStream::Client.new

#      client.track( 'ruby', 'rails' ) do |status|
      client.track( 'rails' ) do |status|
#          print "[ status ] : " ; status.tapp ;
          print "[ status.user.lang ] : " ; status.user.lang.tapp ;
        if status.user.lang == 'ja'
          print "[ status.text ] : " ; p status.text ;
#          tweet = Tweet.create(
          Tweet.create(
            id_str:            status.id_str,
            screen_name:       status.user.screen_name,
            profile_image_url: status.user.profile_image_url,
            post:              status.text,
            tweet_at:          status.created_at,
          )
#          print "[ tweet ] : " ; p tweet ;
        end
      end
    end
  rescue => ex
    print "[ ex ] : " ; p ex ;
  end

end
