class ResponsesController < ApplicationController
  # GET /responses
  # GET /responses.json
  def index
    @responses = Response.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @responses }
    end
  end

  # GET /responses/1
  # GET /responses/1.json
  def show
    @response = Response.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @response }
    end
  end

  # GET /responses/new
  # GET /responses/new.json
  def new
    @response = Response.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @response }
    end
  end

  # GET /responses/1/edit
  def edit
    @response = Response.find(params[:id])
  end

  # POST /responses
  # POST /responses.json
  def create
    @response = Response.new(params[:response])

    respond_to do |format|
      if @response.save
        format.html { redirect_to @response, notice: 'Response was successfully created.' }
        format.json { render json: @response, status: :created, location: @response }
      else
        format.html { render action: "new" }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /responses/1
  # PUT /responses/1.json
  def update
    @response = Response.find(params[:id])

    respond_to do |format|
      if @response.update_attributes(params[:response])
        if @response.run && @response.run.return_url
          # send the data back to the portal
          data = [{
            "type" =>        "open_response",
            "question_id" => "1",
            "answer" =>      params[:response][:answer]
          }]
          bearer_token = 'Bearer %s' % current_user.token
          HTTParty.post(@response.run.return_url, :body => data.to_json, :headers => {"Authorization" => bearer_token, "Content-Type" => 'application/json'})
        end
        format.html { redirect_to @response, notice: 'Response was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /responses/1
  # DELETE /responses/1.json
  def destroy
    @response = Response.find(params[:id])
    @response.destroy

    respond_to do |format|
      format.html { redirect_to responses_url }
      format.json { head :no_content }
    end
  end

  def run
    if current_user.nil?
      session[:auth_return_url] = request.url
      redirect_to user_omniauth_authorize_path(:concord_portal)
    else
      domain = params[:domain]
      external_id = params[:externalId]
      return_url = params[:returnUrl]

      run = Run.find_or_create_by_key(Run.key_for(domain, external_id))
      run.return_url = return_url
      run.response = Response.create unless run.response_id
      run.save

      redirect_to edit_response_path(run.response)
    end
  end
end
