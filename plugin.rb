# name: rss-poster
# about: Plugin which allows RSS feeds to post to the forum
# version: 0.1
# authors: Leo McArdle

load File.expand_path('../lib/rss_poster.rb', __FILE__)
load File.expand_path('../lib/rss_poster/engine.rb', __FILE__)

after_initialize do
  load File.expand_path('../jobs/rss_poster_poll.rb', __FILE__)
  RssPoster::Feed.all.each do |feed|
    Jobs.enqueue(:rss_poster_poll, feed_id: feed.id)
  end
end

add_admin_route 'rss_poster.title', 'rss-poster.feeds'

Discourse::Application.routes.append do
  mount RssPoster::Engine => '/admin/plugins/rss-poster', constraints: StaffConstraint.new
end