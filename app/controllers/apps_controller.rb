##
## Copyright [2013-2015] [Megam Systems]
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
class AppsController < ApplicationController
  respond_to :html, :js
  include Packable
  include AppsHelper

  def logs
  end

  def index
    assem = Assemblies.new.list(params)
    assem.assemblies
    assem.apps_spun
    assem_vms_spun
    assem_services_spun
  end

  ###This method should be renamed or better yet refer SCRP.
  ##SCRP: I think the methods should be a separate controller GitHubController in which this a "create method"
  ## This pulls the repos from github and sends it to the app new screen.
  def authorize_scm
    logger.debug ">----apps> github repos: entry"
    auth_token = request.env['omniauth.auth']['credentials']['token']
    github = Github.new oauth_token: auth_token
    git_array = github.repos.all.collect { |repo| repo.clone_url }
    @repos = git_array
    render :template => "apps/new", :locals => {:repos => @repos}
  end

  ##This method should be renamed as callback_github
  ## as i presume it traps of the oauth credentials after an user authenticates with Github.
  ## if a session doesn't exists then redirect to session creation (signin)
  ##SCRP: I think the methods should be a separate controller GitHubController in which this a "new method"
  def github_scm
    logger.debug ">----apps> callback github: entry"
    if user_in_session?
      session[:info] = request.env['omniauth.auth']['credentials']
    else
      auth = request.env['omniauth.auth']
      session[:auth] = { :uid => auth['uid'], :provider => auth['provider'], :email => auth['info']["email"] }
      redirect_to :controller=>'sessions', :action=>'create'
    end
  end


  def dash(book)
    book_source = Rails.configuration.metric_source
    book_source = "demo" unless apply_to_cloud
    @widget=@book.widgets.create(:name=>"graph", :kind=>"datapoints", :source=>book_source, :widget_type=>"pernode", :range=>"hour", :targets => ["cpu_system"])
    @widget=@book.widgets.create(:name=>"networks", :kind=>"networks_datapoints", :source=>book_source, :widget_type=>"pernode", :range=>"hour", :targets => ["pkts_out"])
    @widget=@book.widgets.create(:name=>"runningbooks", :kind=>"runningbooks", :source=>book_source, :widget_type=>"summary", :range=>"hour")
    @widget=@book.widgets.create(:name=>"cumulativeuptime", :kind=>"cumulativeuptime", :source=>book_source, :widget_type=>"summary", :range=>"hour")
    @widget=@book.widgets.create(:name=>"queuetraffic", :kind=>"queuetraffic", :source=>book_source, :widget_type=>"summary", :range=>"hour")
  end

end
