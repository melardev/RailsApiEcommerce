class OrderInfo < ApplicationRecord

  self.table_name = 'orders_info'

  belongs_to :order
  # order_shipping_info.ordered? .in_transit? .delivered?
  enum current_status: [:ordered, :in_transit, :delivered]

  after_initialize :set_default_status, :if => :new_record?

  before_save :set_default_status2

  validates :address, presence: true

  def set_default_status
    self.current_status ||= :ordered
  end

  def set_default_status2
    if self.current_status.nil?
      self.current_status = :ordered
    end
  end
end
