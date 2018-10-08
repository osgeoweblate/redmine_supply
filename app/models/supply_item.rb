# frozen_string_literal: true

class SupplyItem < ActiveRecord::Base
  belongs_to :project
  has_many :issue_supply_items
  has_many :issues, through: :issue_supply_items

  has_many :journals, class_name: 'SupplyItemJournal', dependent: :delete_all

  validates :project, presence: true
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false,
                                 scope: :project_id }
  validates :stock, presence: true, numericality: true

  scope :sorted, ->{ order name: :asc}

  enum unit: RedmineSupply::Unit.all


  scope :like, ->(q){
    if q.present?
      pattern = "%#{q.downcase}%"
      sql = %w(name description).map {|column| "LOWER(#{table_name}.#{column}) LIKE :p"}.join(" OR ")
      where(sql, p: pattern)
    else
      all
    end
  }

  def stock_text(amount = self.stock)
    "#{amount} #{unit_name}"
  end

  def unit_name
    I18n.t :"label_supply_item_unit_#{unit}"
  end

end
