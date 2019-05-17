class ApprovalGroupsController < ApplicationController
  before_action :set_approval_group, only: [:show, :edit, :update, :destroy]

  # GET /approval_groups
  # GET /approval_groups.json
  def index
    @approval_groups = ApprovalGroup.all
  end

  # GET /approval_groups/1
  # GET /approval_groups/1.json
  def show
  end

  # GET /approval_groups/new
  def new
    @approval_group = ApprovalGroup.new(user: current_user)
  end

  # GET /approval_groups/1/edit
  def edit
  end

  # POST /approval_groups
  # POST /approval_groups.json
  def create
    @approval_group = ApprovalGroup.new(approval_group_params)
    @approval_group.user = current_user

    respond_to do |format|
      if @approval_group.save
        format.html { redirect_to @approval_group, notice: 'Approval group was successfully created.' }
        format.json { render :show, status: :created, location: @approval_group }
      else
        format.html { render :new }
        format.json { render json: @approval_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /approval_groups/1
  # PATCH/PUT /approval_groups/1.json
  def update
    respond_to do |format|
      if @approval_group.update(approval_group_params)
        format.html { redirect_to @approval_group, notice: 'Approval group was successfully updated.' }
        format.json { render :show, status: :ok, location: @approval_group }
      else
        format.html { render :edit }
        format.json { render json: @approval_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /approval_groups/1
  # DELETE /approval_groups/1.json
  def destroy
    @approval_group.destroy
    respond_to do |format|
      format.html { redirect_to approval_groups_url, notice: 'Approval group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_approval_group
    @approval_group = ApprovalGroup.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def approval_group_params
    params.require(:approval_group).permit(:name, :description, approval_group_users_attributes: [:id, :user_id, :_destroy])
  end
end
