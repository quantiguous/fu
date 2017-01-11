Fu::Engine.routes.draw do
  resources :incoming_files do
    member do
      get :download_file
      get :generate_response_file
      get :approve_restart
      get :skip_records
      get :reject
      get :process_file
      get :reset
      get :show_fault
      get :show_audit_modal
    end
  end

  get 'override_records' => 'incoming_files#override_records'
  get 'incoming_files/:id/audit_steps/:step_name' => 'incoming_files#audit_steps'
  put '/incoming_file/:id/approve' => "incoming_files#approve"
  get '/view_raw_content/:id' => "incoming_files#view_raw_content"
  get 'incoming_file_records/:id/audit_steps/:step_name' => 'incoming_file_records#audit_steps'
  
  resources :incoming_file_records do
    member do
      get :show_modal
    end
  end
end
