class VmdbTable < ActiveRecord::Base
  belongs_to :vmdb_database

  has_many :vmdb_indexes,                            :dependent => :destroy
  has_many :vmdb_metrics,          :as => :resource, :dependent => :destroy
  has_one  :latest_hourly_metric,  :as => :resource, :class_name => 'VmdbMetric', :conditions => {:capture_interval_name => 'hourly'}, :order => "timestamp DESC"

  include ReportableMixin
  include VmdbDatabaseMetricsMixin

  include_concern 'Seeding'

  serialize :prior_raw_metrics

  def my_metrics
    self.vmdb_metrics
  end
end
