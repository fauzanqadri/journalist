class Admin::JournalsController < ApplicationController
  before_action :admin_user!
  before_action :set_journal, only: [:show, :edit, :update, :destroy]

  # GET /journals
  # GET /journals.json
  def index
    respond_to do |format|
      format.html
      format.json {render json: JournalDatatables.new(view_context)}
    end
  end

  # GET /journals/new
  def new
    @journal = Journal.new
    respond_to do |format|
      format.js
    end
  end

  # GET /journals/1/edit
  def edit
    respond_to do |format|
      format.js
    end
  end

  # POST /journals
  # POST /journals.json
  def create
    @journal = Journal.new(journal_params)

    respond_to do |format|
      if @journal.save
        flash[:notice] = "Jounal resource was successfully created."
        format.js
      else
        format.js { render :new }
      end
    end
  end

  # PATCH/PUT /journals/1
  # PATCH/PUT /journals/1.json
  def update
    respond_to do |format|
      if @journal.update(journal_params)
        flash[:notice] = "Journal resource was successfuly updated"
        format.js
      else
        format.js { render :edit }
      end
    end
  end

  # DELETE /journals/1
  # DELETE /journals/1.json
  def destroy
    @journal.destroy
    respond_to do |format|
      format.html { redirect_to admin_journals_url, notice: 'Journal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_journal
      @journal = Journal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def journal_params
      params.require(:journal).permit(:name, :driver)
    end
end
