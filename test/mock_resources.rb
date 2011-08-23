class MockResources

  def self.mock_all
    @ok_form = { :expected => "success" }.to_xml(:root => "apply_form")
    @error_form = { :expected => "failure" }.to_xml(:root => "apply_form")

    ActiveResource::HttpMock.respond_to do |mock|
      mock.post   "/rest/apply-forms.xml",  {}, @dummy_form, 201, "Location" => "/rest/apply_forms/1.xml"

      mock.get    "/rest/countries.xml", {}, resources('countries')
      mock.get    "/rest/countries.xml?code=AT", {}, resources('austria')
      mock.get    "/rest/countries.xml?code=US", {}, resources('us')

      mock.get    "/rest/workcamp_intentions.xml", {}, resources('workcamp_intentions')
      mock.get    "/rest/workcamp_intentions.xml?code=ENVI", {}, resources('envi')

      mock.get    "/rest/workcamps.xml?&page=0&per_page=15", {}, resources('workcamps')
      mock.get    "/rest/workcamps/total.xml?", {}, resources('total')
      mock.get    "/rest/workcamps/1.xml", {}, resources('workcamps.1')
      mock.get    "/rest/workcamps/2.xml", {}, resources('workcamps.2')
      mock.get    "/rest/workcamps/3.xml", {}, resources('workcamps.3')
      mock.get    "/rest/workcamps.xml", {}, resources('workcamps')
    end

  end

  protected

  # Loads XML file from remote_fixtures.  Ussually used as mock responses by HttpMock.
  def self.resources(name)
    path = File.join(RAILS_ROOT, "test", "remote_fixtures", "#{name.to_s}.xml")
    return nil unless File.exists?(path)
    File.read path
  end

end
