# frozen_string_literal: true
module Hyrax
  module Hirmeos
    class HirmeosFileUpdaterJob < ApplicationJob
      def perform(resource_id)
        resource = ActiveFedora::Base.find(resource_id)
        Hyrax::Hirmeos::MetricsTracker.new.submit_file_links_to_hirmeos_work(resource)
      end
    end
  end
end
