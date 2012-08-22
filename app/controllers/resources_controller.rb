class ResourcesController < ApplicationController

  respond_to :html, :json

  expose(:project) { current_account.projects.find(params[:project_id]) }
  expose(:resources) do
    if params[:q].present?
      project.resources.where('name LIKE ?', "%#{params[:q]}%")
    else
      project.resources.includes(:localized_resources)
    end
  end
  expose(:resource)

  def index
    respond_with resource do |format|
      format.json { render :json => resources.map{|res| res.as_json(:include => :localized_resources)} }
    end
  end

  def show
    respond_with resource, :include => :localized_resources
  end

  def find
    resource = resources.find_by_guid(params[:guid])
    respond_with resource, :include => :localized_resources
  end

  def create
    resource.save
    respond_with resource, :include => :localized_resources
  end

  def update
    resource.save
    respond_with resource do |format|
      format.json { render :json => resource, :include => :localized_resources }
    end
  end

  def destroy
    resource.destroy
    render action: :index
  end

end