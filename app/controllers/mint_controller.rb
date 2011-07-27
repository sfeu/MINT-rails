
class MintController < ApplicationController
  include MINT

  def index
    @cui_elements= CIO.all.select {|c| c.is_in? :positioned or c.is_in? :presenting or c.is_in? :hidden}
  end

  def Button
    @field =params[:id]
    # control = Control.first(:name=>@field.to_s)
    @aio, @button = retrieve_from_store @field.to_s
    displayed(@button)
    if request.xhr?
      logger.info ">>>>>>>>>>>>>>>>>>>>>XHR #{params.inspect}"
      #control.update(:state=>"pressed")
      render :nothing => true
    else
#      @description = @button.description
      #control.update(:state=>"rendered")
      render :layout =>false
    end
  end

  def CIC
    @field =params[:id]
    @aic, @cic = retrieve_from_store @field.to_s
    displayed(@cic)
    render :layout =>false
  end

  def SingleHighlight
     @field =params[:id]
     @aic, @cic = retrieve_from_store @field.to_s
     displayed(@cic)
     render :layout =>false
   end

  def CIO
    @field =params[:id]
    @aio, @cio = retrieve_from_store @field.to_s
    displayed(@cio)
    render :layout =>false
  end

  def BasicText
    @field =params[:id]
    @aio, @cio = retrieve_from_store @field.to_s
    displayed(@cio)
    render :layout =>false
  end

  def Label
    @field =params[:id]

    @aic, @cio = retrieve_from_store @field.to_s

    displayed(@cio)
    render :layout =>false
  end

  def CheckBox
    @field =params[:id]
    @aio, @cio = retrieve_from_store @field.to_s

    displayed(@cio)
    render :layout =>false
  end

  def CheckBoxGroup
    @field =params[:id]
    @aio, @cio = retrieve_from_store @field.to_s
    displayed(@cio)
    render :layout =>false
  end

  def RadioButton
    @field =params[:id]
    @aio, @cio = retrieve_from_store @field.to_s
    displayed(@cio)
    render :layout =>false
  end

  def MarkableRadioButton
    @field =params[:id]
    @aio, @cio = retrieve_from_store @field.to_s
    displayed(@cio)
    render :layout =>false
  end

  def FurnitureItem
    @field =params[:id]
    @aio, @cio = retrieve_from_store @field.to_s
    displayed(@cio)
    render :layout =>false
  end

  def Image
    @field =params[:id]
    @aio, @cio = retrieve_from_store @field.to_s
    displayed(@cio)
    render :layout =>false
  end

  def ARFrame
    @field =params[:id]
    @aio, @cio = retrieve_from_store @field.to_s
    displayed(@cio)
    render :layout =>false
  end

  def RadioButtonGroup
    @field =params[:id]
    @aio, @cio = retrieve_from_store @field.to_s
    displayed(@cio)
    render :layout =>false
  end

  def send_data
    logger.info "send data #{params.inspect}"

    if not session[:nr] or session[:nr]>3
      session[:nr]=0
    end
    render :juggernaut do |page|
      page[@@elements[session[:nr]]].visual_effect(:highlight,:duration=> 5)
      session[:nr]=session[:nr]+1
    end
    render :nothing => true
  end

  def to_class
    Kernel.const_get(self)
  end

  def render_to_s(opts={ })
    render_to_string(opts)
  end

  private

  # TODO - synchronization problem with nil reads in tuple space -
  # this methods implements dirty workaround!
  def retrieve_from_store field
    @aio = nil
    @cio = nil
    while not @cio do
      @cio = CIO.first(:name=>field)
      sleep 0.1 if not @cio
    end

    while not @aio do
      @aio = AIO.first(:name=>field)
      sleep 0.1 if not @aio
    end
    return @aio,@cio
  end

  # set state of cio to displayed
  def displayed(cio)
    cio.process_event("display") if not cio.is_in? :hidden
  end
end
