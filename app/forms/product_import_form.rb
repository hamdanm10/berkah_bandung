# frozen_string_literal: true

class ProductImportForm
  include ActiveModel::Model

  attr_accessor :file

  validates :file, presence: true
  validate :excel_format

  private

  def excel_format
    return if file.blank?

    unless [ ".xls", ".xlsx" ].include?(File.extname(file.original_filename))
      errors.add(:file, "must be an Excel file (.xls or .xlsx)")
    end
  end
end
