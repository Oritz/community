class SearchController < ApplicationController
  layout false
  def index
    if params[:q].present?
      @first_page_users = internal_search_users(params[:q] , 1)
      @first_page_groups = internal_search_groups(params[:q] , 1)
      @first_page_posts = internal_search_groups(params[:q] , 1)
    end
  end
  
  # search users
  def users
    if params[:q].present?
      page = params[:page].to_i || 1
      @page_users = internal_search_users(params[:q], page)
    end
  end
  
  # search posts
  def posts
    if params[:q].present?
      page = params[:page].to_i || 1
      @page_posts = internal_search_posts(params[:q], page)
    end    
  end
  
  # search groups
  def groups
    if params[:q].present?
      page = params[:page].to_i || 1
      @page_groups = internal_search_groups(params[:q], page)
    end    
  end
  
  def internal_search_users(query_keyword, page)
    page = (page >= 1) ? page : 1
    if query_keyword
      Account.solr_search do
        fulltext query_keyword do
          highlight :nick_name
        end
        paginate :page => page, :per_page => Settings.search.accounts_per_page 
      end
    end
  end
  
  def internal_search_groups(query_keyword, page)
    page = (page >= 1) ? page : 1
    if query_keyword
      Group.solr_search do
        fulltext query_keyword do 
          highlight :name, :description
        end
        paginate :page => page , :per_page => Settings.search.groups_per_page 
      end
    end    
  end
  
  def internal_search_posts(query_keyword, page, &block)
    # TODO  
  end
end
