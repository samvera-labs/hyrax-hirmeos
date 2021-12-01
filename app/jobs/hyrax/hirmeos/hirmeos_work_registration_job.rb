# frozen_string_literal: true
module Hyrax
  module Hirmeos
    class HirmeosWorkRegistrationJob < ApplicationJob
      def perform(work_id)
        work = ActiveFedora::Base.find(work_id)
        work_json = service.work_to_hirmeos_json(work)
        service.submit_works_to_hirmeos(work_id, work_json)
      end

      private

      def service
        @_service ||= Hyrax::Hirmeos::MetricsTracker.new
      end
    end
  end
end
