class ScheduledCallsController < ApplicationController

  expose(:project) { load_project }
  expose(:scheduled_calls) { project.scheduled_calls }
  expose(:scheduled_call)
  expose(:call_flows) { project.call_flows }
  expose(:channels) { current_account.channels }

  before_filter :load_project, only: [:index]
  before_filter :check_project_admin, only: [:create, :update, :destroy]

  def index
    @variables = project.project_variables.map{|x| {id: x.id, name: x.name} }
  end

  def create
    scheduled_call.save
    render :partial => 'update'
  end

  def update
    scheduled_call.save
    render :partial => 'update'
  end

  def destroy
    scheduled_call.destroy
    redirect_to project_scheduled_calls_path(project), :notice => "Scheduled call #{scheduled_call.name} successfully deleted."
  end
end
