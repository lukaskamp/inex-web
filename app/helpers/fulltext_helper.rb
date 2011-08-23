module FulltextHelper

  def render_result_list(n_displayed, list_name)
    s = "<p class=\"fulltext_result_set_head\" id=\"fulltext_result_set_head_#{@result_set_name}\">\n" +
        bt("fulltext_results_#{@result_set_name}_head") + " " +
        number_of_results(@result_set.size) +
        "</p>\n" 
    @result_set[0...n_displayed].each_with_index do |result, i|
      @result_set_formatted.push self.send(result.fulltext_formatter_name, result, @terms) unless @result_set_formatted[i]
      formatted_result = @result_set_formatted[i]
      s += display_formatted_result(formatted_result, i+1)
    end
    s += links_to_more_results(n_displayed, list_name)
    s += "<p class=\"fulltext_result\">"+bt("fulltext_results_notfound")+"</p>" if @result_set.empty?
    s
  end

  private
  
  def format_cz_project_for_fulltext(cz_project, terms)
    {:head => highlight_terms(cz_project.title, terms),
      :body => excerpt_terms(cz_project.description_short||""+cz_project.description_long||"", terms),
      :link_text => bt("fulltext_result_link_cz_project"),
      :link_target => cz_projects_path(lng(:id => cz_project.kind.id)) }
  end
  
  def format_evs_project_for_fulltext(evs_project, terms)
    {:head => highlight_terms(evs_project.title, terms),
      :body => excerpt_terms(evs_project.description, terms),
      :link_text => bt("fulltext_result_link_evs_project"),
      :link_target => evs_path(lng({})) }
  end
  
  def format_ltv_project_for_fulltext(ltv_project, terms)
    {:head => highlight_terms(ltv_project.title, terms),
      :body => excerpt_terms(ltv_project.description, terms),
      :link_text => bt("fulltext_result_link_ltv_project"),
      :link_target => ltv_path(lng({})) }
  end

  def format_headline_for_fulltext(headline, terms)
    {:head => highlight_terms(headline.title, terms),
      :body => excerpt_terms(headline.annotation, terms),
      :link_text => bt("fulltext_result_link_headline"),
      :link_target => headlines_path(lng({})) }
  end

  def format_article_for_fulltext(article, terms)
    result = { :head => highlight_terms(article.title,terms), 
               :body => excerpt_terms(article.body,terms) }
    result[:link_target] = smart_article_url(article)
    if sa = article.special_article
      result[:link_text] = bt("fulltext_result_link_menu_item")
    else
      result[:link_text] = bt("fulltext_result_link_article")
    end
    result
  end
  
  def format_menu_item_for_fulltext(menu_item, terms)
      {:head => highlight_terms(menu_item.title,terms),
       :body => "", :link_text => bt("fulltext_result_link_menu_item"), 
       :link_target => construct_url(menu_item.target_url) }
  end

  def format_media_album_for_fulltext(media_album, terms)
    { :head => highlight_terms(media_album.title,terms),
      :body => excerpt_terms(media_album.description,terms), 
      :link_text => bt("fulltext_result_link_media_album"),
      :link_target => album_path(lng(:id => media_album.id)) }
  end

  def format_media_file_for_fulltext(media_file, terms)
    { :head => highlight_terms(media_file.name,terms),
      :body => excerpt_terms(media_file.description,terms), 
      :link_text => bt("fulltext_result_link_media_file"), 
      :link_target => "/#{@current_language.code}/gallery/browse/#{media_file.media_album.id}?index=#{media_file.get_index_in_album}"}
  end
        
  # encapsulate terms in text by a <span>
  def highlight_terms(text = nil, terms = nil, span_class="fulltext_result_head_highlight")
    # prepare downcase, non-cs variants of everything
    lowtext = InexUtils::strip_cs_chars(text||"").downcase
    terms = (terms||[]).map{|t| InexUtils::strip_cs_chars(t).downcase}
    # find indices of all terms to mark them afterwards
    found = []
    for t in terms
      # something like 'scan' for indices
      cutoff = 0
      while i = lowtext.index(Regexp::new("(#{t})",true), cutoff)
        found << [i, i + t.chars.length]
        cutoff = i + t.chars.length
      end
    end
    
    # process the indices - sort and bail out if nothing found
    return text if found.size == 0
    found.sort!{|a,b| a[0] <=> b[0]}
    
    # part before anything found
    result = text.chars[0...found.first[0]]
    found.each_with_index do |f, i|
      # highlighted term
      result << "<span class=\"#{span_class}\">" + text.chars[f[0]...f[1]]  + "</span>"
      # from after-term to next term (if there is any)
      result << text.chars[found[i][1]...found[i+1][0]] unless i == found.size-1
    end
    # last part and we're done
    result << text.chars[found.last[1]..-1]
    result
  end
  
  def display_formatted_result(formatted_result, i)
    "<p class=\"fulltext_result\" id=\"fulltext_result_#{@result_set_name}_#{i}\">\n" +
    "<span class=\"fulltext_result_head\">\n" + 
    formatted_result[:head] + "\n" +
    "</span>\n" + 
    formatted_result[:body] + "\n" +
    ((formatted_result[:link_text])?(link_to(formatted_result[:link_text], formatted_result[:link_target], :class => "fulltext_result_link")):("")) +
    "\n</p>\n"
  end
  
  def number_of_results(n)
    return "" if n <= 0
    "(#{n} "+
    if n > 4
      bt("results_word_5plus")
    elsif n > 1
      bt("results_word_2to4")
    elsif n > 0
      bt("results_word_1")
    end + ")"
  end

   
  def links_to_more_results(n_displayed, list_name)
    s = ""
    if @max_total > n_displayed
      if @result_set.size > @max_extended
        s+="<p class=\"fulltext_result\">\n" +
          link_to_function(
            icon('fulltext_more') + 
            "&nbsp;" + 
            bt("fulltext_display_extended_results", :params => [([@max_extended, @result_set.size].min - n_displayed).to_s]), "Element.hide('#{@result_set_name}_#{list_name}');Element.show('#{@result_set_name}_extended');") +
          "\n</p>\n"
      end
      s += "<p class=\"fulltext_result\">\n" +
      link_to_function(
          icon('fulltext_all') + "&nbsp;" + 
          bt("fulltext_display_all_results",:params => [@result_set.size.to_s]),
          "Element.hide('#{@result_set_name}_#{list_name}');Element.show('#{@result_set_name}_total');"
        ) + "\n</p>\n"
    end
    s
  end
  
  def find_one_of(text, terms, r)
    terms = terms.map{|t| InexUtils::strip_cs_chars(t).downcase}
    candidates = []
    for t in terms
      continue if t.length < 3
      index = text.index(Regexp.new("[^a-z]"+t+"[^a-z]")) 
      if index
        index += 1
        # cutoff positions
        start = index-r
        final = index+t.length+r
        # cut the start value to positive
        start = [start, 0].max
        candidates.push([index, start, final])
      end
      break if candidates.size >= 2
    end
    candidates
  end
  
  # join start..final blocks if they touch or overlap
  def join_overlaps(start, final)
    (1...start.size).each do |i|
      if start[i] <= final[i-1]
        start[i] = start [i-1]
        start[i-1], final[i-1] = nil, nil
      end
    end
    start.compact!
    final.compact!
  end
  
  # pull out terms of text, cut a part of text around and highlight the terms
  # this is for fulltext result from a longer text
  def excerpt_terms(text = nil,terms = nil)
    # fix possibly empty variables
    text ||= ""
    terms ||= []
    # convert rich to plain text
    plain_cs = strip_tags(text).gsub("\n"," ")
    plain = InexUtils::strip_cs_chars(plain_cs).downcase
    # excerpt half-size
    excerpt_radius = par("fulltext_excerpt_radius")
    # number of excerpts
    excerpt_number = par("fulltext_excerpt_number")
    # fields for start/end of an excerpt block
    start = []
    final = []

    temp = plain.dup
    higher_candidates = []
    excerpt_number.times do
      if temp
        if higher_candidates.size > 0 and false
          start << higher_candidates.first[1]
          final << higher_candidates.first[2]
          higher_candidates = []
        else
          candidates = find_one_of(temp, terms, excerpt_radius)
          if candidates.size > 0 
            candidates.sort!{|x,y| x[0] <=> y[0] }
            start << candidates.first[1]
            final << candidates.first[2]
            higher_candidates = candidates.reject{|x| x[1] <= final[-1]}
          end
        end
        if start.size > 0
          temp = temp.chars[final[-1]..-1]
        end
        if start.size > 1
          start[-1] += final[-2]
          final[-1] += final[-2]
        end
      end
    end

    # fix the ranges
    join_overlaps(start, final)
    # shift starts left to nearest non-word char
    start.each_index do |i|
      blank_index = plain.rindex(" ",start[i])
      if blank_index 
        start[i] = blank_index+1
      else
        start[i] = 0
      end
    end
    # shift ends right to nearest non-word char
    final.each_index do |i|
      if final[i] < plain.length
        blank_index = plain.index(" ", final[i]-1)
        if blank_index 
          final[i] = blank_index
        else
          final[i] = plain.length
        end
      end
    end
    # fix the ranges
    join_overlaps(start, final)

    if start.size > 0
      result = ""
      start.each_index do |i|
        result << " ... " if start[i]>0
        result << (plain_cs.chars[start[i]...final[i]] || "")
        last_final = final[i]
      end
      result << " ... " if final[-1] < plain_cs.chars.length
    else
      result = truncate(plain_cs.chars, par("fulltext_truncate_length"))
    end
    
    highlight_terms(result, terms, "fulltext_result_highlight")
  end


end
