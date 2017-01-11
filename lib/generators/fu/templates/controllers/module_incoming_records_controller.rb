require 'will_paginate/array'

class <%= name.camelize %>IncomingRecordsController < ApplicationController
  respond_to :json, :html

  def index
    @incoming_file = IncomingFile.find_by_file_name(params[:file_name]) rescue nil
    records = <%= name.camelize %>IncomingRecord.joins(:incoming_file_record).where("<%= name %>_incoming_records.file_name=? and status=?",params[:file_name],params[:status]).order("<%= name %>_incoming_records.id desc")
    @records_count = records.count(:status)
    @records = records.paginate(:per_page => 10, :page => params[:page]) rescue []
  end

  def show
    @record = <%= name.camelize %>IncomingRecord.find_by_id(params[:id])
  end

  def incoming_file_summary
    @summary = <%= name.camelize %>IncomingFile.find_by_file_name(params[:file_name])
  end
end
