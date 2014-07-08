class Admin::JournalAccountsController < ApplicationController
  before_action :admin_user!
  before_action :set_journal
  before_action :set_journal_account, only: [:show, :edit, :update, :destroy]

  # GET /admin/journal_accounts
  # GET /admin/journal_accounts.json
  def index
    respond_to do |format|
      format.html
      format.json {render json: JournalAccountDatatables.new(view_context)}
    end
  end

  # GET /admin/journal_accounts/new
  def new
    @journal_account = @journal.journal_accounts.new
    respond_to do |format|
      format.js
    end
  end

  # GET /admin/journal_accounts/1/edit
  def edit
  end

  # POST /admin/journal_accounts
  # POST /admin/journal_accounts.json
  def create
    @journal_account = @journal.journal_accounts.new(journal_account_params)
    respond_to do |format|
      if @journal_account.save
        flash[:notice] = "Journal account was successfully created."
        format.js
      else
        format.js { render :new }
      end
    end
  end

  # PATCH/PUT /admin/journal_accounts/1
  # PATCH/PUT /admin/journal_accounts/1.json
  def update
    respond_to do |format|
      if @journal_account.update(journal_account_params)
        flash[:notice] = "Journal account was successfully updated."
        format.js
      else
        format.js { render :edit }
      end
    end
  end

  # DELETE /admin/journal_accounts/1
  # DELETE /admin/journal_accounts/1.json
  def destroy
    @journal_account.destroy
    respond_to do |format|
      if @journal_account.errors.any?
        format.html { redirect_to admin_journal_journal_accounts_url(@journal), alert: "You can't deleting enabled account" }
      else
        format.html { redirect_to admin_journal_journal_accounts_url(@journal), notice: 'Journal account was successfully destroyed.' }
      end
    end
  end

  def set_status
    @journal_account = @journal.journal_accounts.find(params[:journal_account_id])
    @journal_account.toggle_enable
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_journal_account
      @journal_account = @journal.journal_accounts.find(params[:id])
    end

    def set_journal
      @journal = Journal.find(params[:journal_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def journal_account_params
      params.require(:journal_account).permit(:username, :password, :other)
    end
end
