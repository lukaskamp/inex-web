class HeadlineController < PublicController

  layout "public", :except => [:atom, :feed]

  def index
    headlines = []

    for h in Headline.find_newest(@current_language)
      headlines.push({
        :headline => h,
        :length => begin
            l = 0
            l += 50 if h.image_filename
            l += h.annotation.length * 0.25 if h.annotation
            l.to_i
          end
      })
    end


    # FIXME: frantisku ty cune
    # generuje vsechny mozne podmnoziny s decentnim vyuzitim binarni
    # soustavy. banzai!
    allcombs = []
    for i in (0...(1 << headlines.size))
      comb = []
      headlines.each_with_index do |h, j|
        comb.push(h) if (i & (1 << j) > 0)
      end
      allcombs << comb
    end

    totl = headlines.map{|x| x[:length]}.sum
    mindif = 100000
    mincomb = nil
    for c in allcombs
      l = c.map{|x| x[:length]}.sum
      dif = (2*l-totl).abs
      if dif < mindif
        mindif = dif
        mincomb = c
      end
    end

    if mincomb == [] or !mincomb
      mincomb = headlines.dup
    end

    @headlines_l, @headlines_r =
      [mincomb, (headlines - mincomb)].map do |set|
        set.map{|x| x[:headline]}.sort{|x,y| y.valid_from <=> x.valid_from}
    end

    if !(@headlines_l.empty?) and !(@headlines_r.empty?) and (@headlines_l.first.valid_from < @headlines_r.first.valid_from)
      @headlines_l, @headlines_r = @headlines_r, @headlines_l
    end

    if @headlines_l & @headlines_r != []
      logger.warn "Same headline in both columns."
    end
  end

  def atom
    @headlines = Headline.find_newest(@current_language)
    respond_to do |format|
      format.atom
    end
  end

  def feed
    @headlines = Headline.find_newest(@current_language)
    # FIXME - explain, do better .... respond_to is a perfect chunk of trash
    render :action => 'feed.rxml' if params[:format] == :xml
  end

end
