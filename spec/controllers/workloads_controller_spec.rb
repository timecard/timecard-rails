require 'spec_helper'

describe WorkloadsController do

#   let(:valid_attributes) { { "start_at" => "2013-10-01 16:06:34" } }

#   # This should return the minimal set of values that should be in the session
#   # in order to pass any filters (e.g. authentication) defined in
#   # WorkLogsController. Be sure to keep this updated too.
#   let(:valid_session) { {} }

#   describe "GET index" do
#     it "assigns all work_logs as @work_logs" do
#       work_log = WorkLog.create! valid_attributes
#       get :index, {}, valid_session
#       assigns(:work_logs).should eq([work_log])
#     end
#   end

#   describe "GET show" do
#     it "assigns the requested work_log as @work_log" do
#       work_log = WorkLog.create! valid_attributes
#       get :show, {:id => work_log.to_param}, valid_session
#       assigns(:work_log).should eq(work_log)
#     end
#   end

#   describe "GET new" do
#     it "assigns a new work_log as @work_log" do
#       get :new, {}, valid_session
#       assigns(:work_log).should be_a_new(WorkLog)
#     end
#   end

#   describe "GET edit" do
#     it "assigns the requested work_log as @work_log" do
#       work_log = WorkLog.create! valid_attributes
#       get :edit, {:id => work_log.to_param}, valid_session
#       assigns(:work_log).should eq(work_log)
#     end
#   end

#   describe "POST create" do
#     describe "with valid params" do
#       it "creates a new WorkLog" do
#         expect {
#           post :create, {:work_log => valid_attributes}, valid_session
#         }.to change(WorkLog, :count).by(1)
#       end

#       it "assigns a newly created work_log as @work_log" do
#         post :create, {:work_log => valid_attributes}, valid_session
#         assigns(:work_log).should be_a(WorkLog)
#         assigns(:work_log).should be_persisted
#       end

#       it "redirects to the created work_log" do
#         post :create, {:work_log => valid_attributes}, valid_session
#         response.should redirect_to(WorkLog.last)
#       end
#     end

#     describe "with invalid params" do
#       it "assigns a newly created but unsaved work_log as @work_log" do
#         # Trigger the behavior that occurs when invalid params are submitted
#         WorkLog.any_instance.stub(:save).and_return(false)
#         post :create, {:work_log => { "start_at" => "invalid value" }}, valid_session
#         assigns(:work_log).should be_a_new(WorkLog)
#       end

#       it "re-renders the 'new' template" do
#         # Trigger the behavior that occurs when invalid params are submitted
#         WorkLog.any_instance.stub(:save).and_return(false)
#         post :create, {:work_log => { "start_at" => "invalid value" }}, valid_session
#         response.should render_template("new")
#       end
#     end
#   end

#   describe "PUT update" do
#     describe "with valid params" do
#       it "updates the requested work_log" do
#         work_log = WorkLog.create! valid_attributes
#         # Assuming there are no other work_logs in the database, this
#         # specifies that the WorkLog created on the previous line
#         # receives the :update_attributes message with whatever params are
#         # submitted in the request.
#         WorkLog.any_instance.should_receive(:update).with({ "start_at" => "2013-10-01 16:06:34" })
#         put :update, {:id => work_log.to_param, :work_log => { "start_at" => "2013-10-01 16:06:34" }}, valid_session
#       end

#       it "assigns the requested work_log as @work_log" do
#         work_log = WorkLog.create! valid_attributes
#         put :update, {:id => work_log.to_param, :work_log => valid_attributes}, valid_session
#         assigns(:work_log).should eq(work_log)
#       end

#       it "redirects to the work_log" do
#         work_log = WorkLog.create! valid_attributes
#         put :update, {:id => work_log.to_param, :work_log => valid_attributes}, valid_session
#         response.should redirect_to(work_log)
#       end
#     end

#     describe "with invalid params" do
#       it "assigns the work_log as @work_log" do
#         work_log = WorkLog.create! valid_attributes
#         # Trigger the behavior that occurs when invalid params are submitted
#         WorkLog.any_instance.stub(:save).and_return(false)
#         put :update, {:id => work_log.to_param, :work_log => { "start_at" => "invalid value" }}, valid_session
#         assigns(:work_log).should eq(work_log)
#       end

#       it "re-renders the 'edit' template" do
#         work_log = WorkLog.create! valid_attributes
#         # Trigger the behavior that occurs when invalid params are submitted
#         WorkLog.any_instance.stub(:save).and_return(false)
#         put :update, {:id => work_log.to_param, :work_log => { "start_at" => "invalid value" }}, valid_session
#         response.should render_template("edit")
#       end
#     end
#   end

#   describe "DELETE destroy" do
#     it "destroys the requested work_log" do
#       work_log = WorkLog.create! valid_attributes
#       expect {
#         delete :destroy, {:id => work_log.to_param}, valid_session
#       }.to change(WorkLog, :count).by(-1)
#     end

#     it "redirects to the work_logs list" do
#       work_log = WorkLog.create! valid_attributes
#       delete :destroy, {:id => work_log.to_param}, valid_session
#       response.should redirect_to(work_logs_url)
#     end
#   end

end
