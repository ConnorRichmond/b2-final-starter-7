class Admin::InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update]
  def index
    @invoices = Invoice.all
  end

  def show
    @total_revenue = @invoice.total_revenue
    @total_discounted_revenue = @invoice.total_discounted_revenue
  end

  def edit
  end

  def update
    @invoice.update(invoice_params)
    flash.notice = 'Invoice Has Been Updated!'
    redirect_to admin_invoice_path(@invoice)
  end

  private
  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(:status)
  end
end