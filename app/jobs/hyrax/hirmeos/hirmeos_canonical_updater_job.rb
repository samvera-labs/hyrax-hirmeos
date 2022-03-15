# frozen_string_literal: true
module Hyrax
  module Hirmeos
    class HirmeosCanonicalUpdaterJob < ApplicationJob
      def perform(resource_id)
        service.patch_canonical_identifier(resource_id)
      end

      private

      def service
        @_service ||= Hyrax::Hirmeos::MetricsTracker.new
      end
    end
  end
end
