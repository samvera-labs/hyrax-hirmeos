# frozen_string_literal: true
module Hyrax
  module Hirmeos
    class ApplicationJob < ActiveJob::Base
      retry_on Faraday::TimeoutError, wait: 60.seconds
      retry_on Ldp::Gone, wait: 60.seconds
    end
  end
end
