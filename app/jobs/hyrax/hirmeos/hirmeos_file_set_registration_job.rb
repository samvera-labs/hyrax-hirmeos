# frozen_string_literal: true
module Hyrax
  module Hirmeos
    class HirmeosFileSetRegistrationJob < ApplicationJob
      def perform(file_set_id)
        file_set = ActiveFedora::Base.find(file_set_id)
        file_set_json = service.file_set_to_hirmeos_json(file_set)
        service.submit_to_hirmeos(file_set_id, file_set_json)
      end

      private

      def service
        @_service ||= Hyrax::Hirmeos::MetricsTracker.new
      end
    end
  end
end
