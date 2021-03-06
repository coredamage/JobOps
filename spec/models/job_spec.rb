require 'spec_helper'

describe Job do
  before do
    stub_request(:get, "http://maps.googleapis.com/maps/api/geocode/json?address=San%20Francisco,%20CA&language=en&sensor=false").
      to_return(:status => 200, :body => fixture("google_map_location_sfca.json"), :headers => {})
    @company = Factory(:company, :location => "San Francisco, CA")
    @location = Factory(:location, :location => "San Francisco, CA")
    @job=Factory(:job, :location => @location, :company => Factory(:company, :location => "San Francisco, CA"))
  end

  context "validations" do
    it 'presence of title' do
      @job.title = nil
      @job.should have(1).error_on(:title)
    end

    it 'presence of job_source' do
      @job.job_source = nil
      @job.should have(1).error_on(:job_source)
    end

    it 'presence of location' do
      @job.location = nil
      @job.should have(1).error_on(:location)

    end

    it 'presence of company' do
      @job.company = nil
      @job.should have(1).error_on(:company)

    end

    it 'presence of url' do
      @job.url = nil
      @job.should have(1).error_on(:url)
    end

  end

  context "relationships" do
    it 'has many job searches' do
      @job.respond_to?(:job_searches).should be_true
    end
    it 'belongs to location' do
      @job.respond_to?(:location).should be_true
    end
    it 'belongs to company' do
      @job.respond_to?(:company).should be_true
    end
    it 'has many job searches jobs' do
      @job.respond_to?(:job_searches_jobs).should be_true
    end
    it 'has many jobs' do
      @job.respond_to?(:job_searches).should be_true
    end
    it 'has many user flags' do
      @job.respond_to?(:users).should be_true
    end
  end

  context "job specific checks" do
      it 'doesnt error out on improper redirect' do
        @job.follow_and_update_redirect
      end
  end
end
