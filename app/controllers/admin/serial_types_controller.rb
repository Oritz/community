# -*- encoding : utf-8 -*-
class Admin::SerialTypesController < AdminController
  layout false, except: [:index, :edit]

  # GET /admin_serial_types
  # GET /admin_serial_types.xml
  def index
    @serial_types = SerialType.all

    respond_to do |format|
      format.html # index.html.slim
      format.xml  { render :xml => @serial_types }
    end
  end

  # GET /admin_serial_types/1
  # GET /admin_serial_types/1.xml
  def show
    @serial_type = SerialType.find(params[:id])

    respond_to do |format|
      format.html # show.html.slim
      format.xml  { render :xml => @serial_type }
    end
  end

  # GET /admin_serial_types/new
  # GET /admin_serial_types/new.xml
  def new
    @serial_type = SerialType.new
    @serial_type.type_cat = SerialType::TYPE_PRIVATE

    respond_to do |format|
      format.html # new.html.slim
      format.xml  { render :xml => @serial_type }
    end
  end

  # GET /admin_serial_types/1/edit
  def edit
    @serial_type = SerialType.find(params[:id])
  end

  # POST /admin_serial_types
  # POST /admin_serial_types.xml
  def create
    @serial_type = SerialType.new(
        params[:serial_type]
    )

    respond_to do |format|
      if @serial_type.save
        format.html { redirect_to(admin_serial_types_path, :notice => t('admin.msg.success')) }
        format.xml  { render :xml => @serial_type, :status => :created, :location => @serial_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @serial_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin_serial_types/1
  # PUT /admin_serial_types/1.xml
  def update
    @serial_type = SerialType.find(params[:id])

    respond_to do |format|
      if @serial_type.update_attributes(params[:serial_type])
        format.html { redirect_to(admin_serial_types_path, :notice => t('admin.msg.success'))}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @serial_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_serial_types/1
  # DELETE /admin_serial_types/1.xml
  def destroy
    @serial_type = SerialType.find(params[:id])
    @serial_type.destroy

    respond_to do |format|
      format.html { redirect_to(admin_serial_types_url) }
      format.xml  { head :ok }
    end
  end
end
