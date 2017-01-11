require_dependency "fu/application_controller"
require 'will_paginate/array'

module Fu
  class IncomingFileRecordsController < ApplicationController
    respond_to :json, :html

    def index
      records = Fu::IncomingFileRecord.where("incoming_file_id =? and status =?",params[:incoming_file_id],params[:status]).order("id desc")
      @records_count = records.count(:id)
      @records = records.paginate(:per_page => 10, :page => params[:page]) rescue []
    end

    def show_modal
      file_record = Fu::IncomingFileRecord.unscoped.find(params[:id])
      @flag = params[:flag]
      @fault = file_record# report responds to fault
      respond_to do |format|
        format.js
      end    
    end
  end
end