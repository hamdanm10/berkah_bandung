# frozen_string_literal: true

class SuperAdmin::InvoicesController < SuperAdminApplicationController
  def index
    limit = RecordLimit.call(params[:limit])

    @q = Invoice.ransack(params[:q])

    @invoices = @q
      .result
      .includes(:distributor)
      .order(created_at: :desc)

    @pagy, @invoices = pagy(@invoices, limit:)
  end

  def new
    @invoice = Invoice.new
    assign_dropdown_search_labels(@invoice)
  end

  def create
    result = Invoices::Create.call(
      invoice_params: invoice_params
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
    @invoice = invoice_scope
    assign_dropdown_search_labels(@invoice)
  end

  def update
    result = Invoices::Update.call(
      invoice: invoice_scope,
      invoice_params: invoice_params
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

  private

  def invoice_params
    params.require(:invoice).permit(
      :distributor_id,
      :invoice,
      :entered_amount,
      :invoice_amount,
      :invoice_number,
      :received_date,
      :transfer_amount,
      :total_transfer_amount,
      :transfer_date,
      :remarks,
      :invoice_type,
      :reference_invoice_id
    )
  end

  def invoice_scope
    Invoice.includes(:distributor).find(params[:id])
  end

  def assign_dropdown_search_labels(invoice)
    @distributor_label = invoice.distributor&.name
  end
end
