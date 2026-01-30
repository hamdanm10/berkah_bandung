# frozen_string_literal: true

class SuperAdmin::InvoicesController < SuperAdminApplicationController
  def index
    limit = RecordLimit.call(params[:limit])

    @q = Invoice.where(deleted_at: nil).ransack(params[:q])

    @invoices = @q
      .result
      .includes(:distributor, :reference_invoice)
      .order(created_at: :desc)

    @pagy, @invoices = pagy(@invoices, limit:)
  end

  def show
    @invoice = show_invoice_scope
  end

  def new
    @invoice = Invoice.new
    @invoice.invoice_items.build
    assign_dropdown_search_labels(@invoice)
  end

  def create
    result = Invoices::Create.call(
      invoice_params: create_invoice_params
    )

    if result.success?
      redirect_to new_super_admin_invoice_path, notice: result.payload[:message]
    else
      @invoice = result.error[:invoice]
      assign_dropdown_search_labels(@invoice)

      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @invoice = edit_invoice_scope
    assign_dropdown_search_labels(@invoice)
  end

  def update
    @invoice = edit_invoice_scope

    result = Invoices::Update.call(
      invoice: @invoice,
      invoice_params: update_invoice_params
    )

    if result.success?
      invoice = result.payload[:invoice]

      redirect_to edit_super_admin_invoice_path(invoice), notice: result.payload[:message]
    else
      @invoice = result.error[:invoice]
      assign_dropdown_search_labels(@invoice)

      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    result = Invoices::SoftDelete.call(
      invoice: post_invoice_scope
    )

    if result.success?
      redirect_to super_admin_invoices_path, notice: result.payload[:message]
    else
      redirect_to super_admin_invoices_path, alert: result.error[:invoice]
    end
  end

  def post
    result = Invoices::Post.call(
      invoice: post_invoice_scope
    )

    if result.success?
      redirect_to super_admin_invoices_path, notice: result.payload[:message]
    else
      redirect_to super_admin_invoices_path, alert: result.error[:invoice]
    end
  end

  def mark_as_paid
    result = Invoices::MarkAsPaid.call(
      invoice: mark_as_paid_invoice_scope
    )

    if result.success?
      redirect_to super_admin_invoices_path, notice: result.payload[:message]
    else
      redirect_to super_admin_invoices_path, alert: result.error[:invoice]
    end
  end

  def search
    q = params[:q].to_s.strip[0, 100]

    invoices = Invoice
      .where(invoice_status: %i[posted paid], deleted_at: nil)
      .where("invoice_number ILIKE ?", "%#{q}%")
      .order(created_at: :desc)
      .limit(15)

    render json: invoices.map { |d|
      {
        value: d.id,
        label: "#{d.invoice_number} | Type: #{d.invoice_type.titleize} | #{d.created_at.strftime("%d/%b/%Y %H:%M:%S")}"
      }
    }
  end

  private

  def invoice_base_fields
    [
      :distributor_id,
      :invoice,
      :entered_amount,
      :invoice_amount,
      :invoice_number,
      :received_date,
      :transfer_amount,
      :total_transfer_amount,
      :transfer_date,
      :remarks
    ]
  end

  def invoice_item_fields
    [
      :id,
      :product_id,
      :adjustment_type,
      :quantity,
      :cost_snapshot,
      :_destroy
    ]
  end

  def create_invoice_params
    params.require(:invoice).permit(
      *invoice_base_fields,
      :invoice_type,
      :reference_invoice_id,
      :copy_from_reference,
      invoice_items_attributes: invoice_item_fields
    )
  end

  def update_invoice_params
    return {} if @invoice.paid?

    if @invoice.draft?
      params.require(:invoice).permit(
        *invoice_base_fields,
        :invoice_type,
        :reference_invoice_id,
        :copy_from_reference,
        invoice_items_attributes: invoice_item_fields
      )
    else
      params.require(:invoice).permit(*invoice_base_fields)
    end
  end

  def invoice_base_scope
    Invoice.includes(:distributor, :reference_invoice)
      .where(deleted_at: nil)
  end

  def edit_invoice_scope
    invoice_base_scope
      .where.not(invoice_status: :paid)
      .find(params[:id])
  end

  def show_invoice_scope
    invoice_base_scope.find(params[:id])
  end

  def mark_as_paid_invoice_scope
    invoice_base_scope
      .where(invoice_status: :posted)
      .find(params[:id])
  end

  def post_invoice_scope
    invoice_base_scope
      .where(invoice_status: :draft)
      .find(params[:id])
  end

  def assign_dropdown_search_labels(invoice)
    @reference_invoice_label = invoice.reference_invoice&.invoice_number
    @distributor_label = invoice.distributor&.name
  end
end
