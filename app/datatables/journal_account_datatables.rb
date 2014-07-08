class JournalAccountDatatables
  delegate :params, :link_to, :raw, :content_tag, to: :@view
  delegate :url_helpers, to: 'Rails.application.routes'

  def initialize view
    @view = view
  end

  def journal_accounts
    @journal_accounts ||= fetch_journal_accounts
  end

  def journal
    @journal ||= Journal.find(params[:journal_id])
  end

  def as_json opt = {}
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: journal.journal_accounts.count,
      iTotalDisplayRecords: journal_accounts.total_entries,
      aaData: data
    }
  end

  private

  def data
    journal_accounts.map do |journal_account|
      [
        wrap_text(journal_account.username),
        wrap_text(journal_account.password),
        wrap_text(journal_account.other),
        set_status_journal_account(journal_account),
        act(journal_account)
      ]
    end
  end

  def wrap_text text
    content_tag :div, "#{text}", class: "text-center"
  end

  def set_status_journal_account journal_account
    link = if journal_account.enable
             raw(link_to(content_tag(:i, "", class: "fa fa-check"), url_helpers.admin_journal_journal_account_disable_path(journal, journal_account), class: "btn btn-xs btn-success", remote: true, method: :post))
           else
             raw(link_to(content_tag(:i, "", class: "fa fa-times"), url_helpers.admin_journal_journal_account_enable_path(journal, journal_account), class: "btn btn-xs btn-danger", remote: true, method: :post))
           end
    content_tag :div, class: "text-center" do
      link
    end
  end

  def act journal_account
    action = []
    action << raw(link_to(content_tag(:i, "", class: "fa fa-edit"), url_helpers.edit_admin_journal_journal_account_path(journal, journal_account), class: "btn btn-xs btn-info", remote: true))
    action << raw(link_to(content_tag(:i, "", class: "fa fa-trash-o"), url_helpers.admin_journal_journal_account_path(journal, journal_account), class: "btn btn-xs btn-danger", method: :delete, data: {confirm: "Confirm deleting ?"}))
    content_tag :div, class: "text-center" do
      content_tag :div, class: "btn-group" do
        raw(action.join(""))
      end
    end
  end


  def fetch_journal_accounts
    journal_accounts = journal.journal_accounts.order("#{sort_column} #{sort_direction}")
    journal_accounts = journal_accounts.page(page).per_page(per_page)
    if params[:sSearch].present?
      journal_accounts = journal_accounts.where("username like :search or password like :search or other like :search", search: "%#{params[:sSearch]}%")
    end
    journal_accounts
  end

  def page
    params[:iDisplatStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    column = %w[username password other]
    column[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

end
