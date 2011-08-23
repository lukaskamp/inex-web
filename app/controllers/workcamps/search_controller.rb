class Workcamps::SearchController < Workcamps::BaseController

  def index
    redirect_to :action => :search
  end

  def search
    # @google_maps_info = GoogleMapsInfo.new('load_world_map', 'load_world_map()')
    # @countries = Country.find(:all)
    @google_maps_info = GoogleMapsInfo.new('load_world_map', '')
    @aims = WorkcampIntention.find(:all, :order => 'code')
    @countries = Country.find(:all, :order => 'name_cz')
  end

  def map
    Countries.all
    render :layout => false
  end

  def list
    query = (params[:query] || {}).update(:countries => @cart.country_codes)
    page = params[:page] || 1
    per_page = 25

    query.reject! { |key,value| value.blank? }
    query.delete(:free_only) if query[:free_only] == '0'

    @workcamps = WillPaginate::Collection.create(page, per_page, 0) do |pager|
      wcs = WorkcampSearch.find_by_query(query, page, per_page)
      pager.replace(wcs)
      pager.total_entries = WorkcampSearch.total(query)
    end
  end

end
