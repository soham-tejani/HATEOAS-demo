# typed: true
# frozen_string_literal: true

class HealthService
  attr_reader :healthy

  def call
    @healthy = postgres_connected && postgres_migrations_updated
  end

  def status
    healthy ? :ok : :service_unavailable
  end

  private

  def postgres_connected
    ApplicationRecord.connected?
  end

  def postgres_migrations_updated
    postgres_connected && !ApplicationRecord.connection.migration_context.needs_migration?
  end
end
