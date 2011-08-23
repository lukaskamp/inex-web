atom_feed(:url => atom_url) do |feed|
  feed.title("#{bt('rss_title',:edit_allowed => false)}")
  feed.updated(@headlines.first ? @headlines.first.created_at : Time.now.utc)
  
  @headlines.each do |headline|
    # FIXME headline_url not defined
    feed.entry(headline, :url => headline_url(headline) ) do |entry|
      entry.title(headline.title)
      entry.content(headline.annotation, :type => 'html')
      
      entry.author do |author|
        author.name("INEX - SDA")
        # TODO - email should be taken from admin user?
        author.email("#{bt('contact_email',:edit_allowed => false)}")
      end
    end
  end
end
