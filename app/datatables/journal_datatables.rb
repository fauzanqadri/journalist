class JournalDatatables
  delegate :params, :link_to, :raw, :content_tag, to: :@view
  delegate :url_helpers, to: 'Rails.application.routes'

  def initialize view
    @view = view
  end

  def journals
    @journals ||= fetch_journals
  end

  def as_json opt = {}
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Journal.count,
      iTotalDisplayRecords: journals.total_entries,
      aaData: data
    }
  end

  private

  def data
    journals.map do |journal|
      [
        wrap_text(journal.name),
        wrap_text(journal.driver),
        wrap_text(journal.journal_accounts_count),
        manage_journal_account(journal),
        act(journal)
      ]
    end
  end

  def wrap_text text
    content_tag :div, "#{text}", class: "text-center"
  end

  def manage_journal_account journal
    content_tag :div, class: "text-center" do
      raw(link_to(content_tag(:i, "", class: "fa fa-rocket"), url_helpers.admin_journal_journal_accounts_path(journal), class: "btn btn-xs btn-primary"))
    end
  end

  def act journal
    action = []
    action << raw(link_to(content_tag(:i, "", class: "fa fa-edit"), url_helpers.edit_admin_journal_path(journal), class: "btn btn-xs btn-info", remote: true))
    action << raw(link_to(content_tag(:i, "", class: "fa fa-trash-o"), url_helpers.admin_journal_path(journal), class: "btn btn-xs btn-danger", method: :delete, data: {confirm: "Confirm deleting ?"}))
    content_tag :div, class: "text-center" do
      content_tag :div, class: "btn-group" do
        raw(action.join(""))
      end
    end
  end


  def fetch_journals
    journals = Journal.order("#{sort_column} #{sort_direction}")
    journals = journals.page(page).per_page(per_page)
    if params[:sSearch].present?
      journals = journals.where("name like :search or driver like :search", search: "%#{params[:sSearch]}%")
    end
    journals
  end

  def page
    params[:iDisplatStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    column = %w[name driver journal_accounts_count]
    column[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
