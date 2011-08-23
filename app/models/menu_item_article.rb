class MenuItemArticle < MenuItem

  belongs_to :article, :foreign_key => :target_id
 
  def target
    target_id
  end

  def target=(x)
    self.target_id = x
  end
  
  def target_label
    article.title if article
  end

  def self.targets_for_as(language)
    set = [["--none--"=>nil]]
    Article.find(:all,:conditions=>["language_id = ?", language.id],:order=>:title).each do |article|
      set.push([article.to_label,article.id])
    end
    set
  end  

  def self.menu_type_description
    "This menu points to an article."
  end
  
  def target_url
    {:route => :article, :url_atom => article ? article.url_atom : "_"}
  end
  
  def edit_target_url
    {:route => :edit_article, :id => target_id}
  end
  
end