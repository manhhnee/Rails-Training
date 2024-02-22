class DemoPartialController < ApplicationController
  def new
    @zone = 'Zone new action'
    @date = Date.today
  end

  def edit
    @zone = 'Zone edit action'
    @date = Date.today
  end
end
