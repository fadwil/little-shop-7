class Admin::InvoicesController < ApplicationController

  def index
    @invoices = Invoice.all
  end

  def show
    @invoice = Invoice.find(params[:id])
    @invoice_items = @invoice.invoice_items.includes(:item)
    @total_revenue = @invoice_items.sum { |item| item.quantity * item.unit_price }
  end

  def update
    @invoice = Invoice.find(params[:id])
    if @invoice.update(invoice_params)
      redirect_to "/admin/invoices/#{@invoice.id}", notice: "Invoice status updated successfully."
    else
      render :show
    end
  end

  private

  def invoice_params
    params.require(:invoice).permit(:status)
  end

end