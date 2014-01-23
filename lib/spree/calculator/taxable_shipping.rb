class Spree::Calculator::TaxableShipping < Spree::Calculator::DefaultTax
  def self.description
    "Taxable Shipping"
  end

  def self.register
    super
  end

  private
  def compute_order(order)
    matched_line_items = order.line_items.select do |line_item|
      line_item.tax_category == rate.tax_category
    end

    taxable_total = matched_line_items.sum(&:total) + order.ship_total
    if rate.included_in_price
      deduced_total_by_rate(taxable_total, rate)
    else
      round_to_two_places(taxable_total * rate.amount)
    end
  end
end