class ClientController < ApplicationController

	def login

		if session[:user] then
			render :json => {:response => "ok"}
		else
			begin

				session[:user], session[:password] = params[:username], params[:password]
				PivotalTracker::Client.token(session[:user], session[:password])
				render :json => {:response => "ok"}

			rescue Exception => e
				render :json => e
			end
		end

	end

	def get_project_by_id

		id = params[:id]
		project = PivotalTracker::Project.find(id)
		render :json => project

	end

	def get_all_activity

		activity = PivotalTracker::Activity.all
		render :json => activity

	end

	def get_project_activity

		id = params[:id]
		project = PivotalTracker::Project.find(id)
		render :json => project.activities.all

	end

	def get_all_stories

		id = params[:id]
		project = PivotalTracker::Project.find(id)
		render :json => project.stories.all

	end

	def get_icebox_stories

		id = params[:id]
		project = PivotalTracker::Project.find(id)
		render :json => project.stories.all(:current_state => 'unscheduled')

	end

	def get_bugs_chores

		id = params[:id]
		project = PivotalTracker::Project.find(id)
		render :json => project.stories.all(:story_type => ['chore', 'bug'])

	end

	def add_task_story

		id_project, id_story, description = params[:id_project], params[:id_story], params[:description]

		project = PivotalTracker::Project.find(id_project)
		story = project.stories.find(id_story)

		story.tasks.create(:description => description)

		render :json => {:response => "ok"}

	end

	def delete_task_story

		id_project, id_story, id_task = params[:id_project], params[:id_story], params[:id_task]

		project = PivotalTracker::Project.find(id_project)
		story = project.stories.find(id_story)

		story.tasks.find(id_task).delete

		render :json => {:response => "ok"}

	end

	def complete_task_story

		id_project, id_story, id_task = params[:id_project], params[:id_story], params[:id_task]

		project = PivotalTracker::Project.find(id_project)
		story = project.stories.find(id_story)

		story.tasks.find(id_task).update(:complete => true)

		render :json => {:response => "ok"}

	end

	def add_note_story

		id_project, id_story, text = params[:id_project], params[:id_story], params[:text]

		project = PivotalTracker::Project.find(id_project)
		story = project.stories.find(id_story)

		story.notes.create(:text => text)

		render :json => {:response => "ok"}

	end

end
