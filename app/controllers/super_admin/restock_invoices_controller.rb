# frozen_string_literal: true

class SuperAdmin::RestockInvoicesController < SuperAdminApplicationController
  def index
    limit = RecordLimit.call(params[:limit])

    @q = Invoice.where(deleted_at: nil).ransack(params[:q])

    @invoices = @q
                .result
                .includes(:distributor, :user_created)
                .order(created_at: :desc)

    @pagy, @invoices = pagy(@invoices, limit:)
  end

  def new
    @invoice = Invoice.new
    @invoice.invoice_items.build
    assign_dropdown_search_labels(@invoice)
  end

  def create
    result = Invoices::Create.call(
      invoice_params: invoice_params
    )

    if result.success?
      redirect_to new_super_admin_restock_invoice_path, notice: result.payload[:message]
    else
      @invoice = result.error[:invoice]
      assign_dropdown_search_labels(@invoice)

      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @invoice = invoice
    assign_dropdown_search_labels(@invoice)
  end

  def update
    result = Invoices::Update.call(
      invoice: invoice,
      invoice_params: invoice_params
    )

    if result.success?
      invoice = result.payload[:invoice]

      redirect_to edit_super_admin_restock_invoice_path(invoice), notice: result.payload[:message]
    else
      @invoice = result.error[:invoice]
      assign_dropdown_search_labels(@invoice)

      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    result = Invoices::SoftDelete.call(
      invoice: invoice
    )

    if result.success?
      redirect_to super_admin_restock_invoices_path, notice: result.payload[:message]
    else
      redirect_to super_admin_restock_invoices_path, alert: result.error[:invoice]
    end
  end

  private

  def invoice_params
    params.require(:invoice).permit(
      :invoice_type,
      :invoice_number,
      :invoice,
      :distributor_id,
      :invoice_amount,
      :entered_amount,
      :transfer_amount,
      :transfer_amount,
      :total_transfer_amount,
      :received_date,
      :transfer_date,
      :remarks,
      invoice_items_attributes: %i[
        id
        product_id
        variant
        quantity
        cost_snapshot
        _destroy
      ]
    )
  end

  def invoice
    Invoice.find(params[:id])
  end

  def assign_dropdown_search_labels(invoice)
    @distributor_label = invoice.distributor&.name
  end
end
