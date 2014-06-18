class CrowdworksContractsController < ApplicationController
  def new
    @project = Project.find(params[:project_id])
    @contract = @project.crowdworks_contracts.build
  end

  def edit
    @contract = CrowdworksContract.find(params[:id])
  end

  def create
    @project = Project.find(params[:project_id])
    @contract = @project.crowdworks_contracts.build(crowdworks_contract_params)
    @contract.user = current_user

    respond_to do |format|
      if @contract.save
        format.html { redirect_to @project }
      else
        format.html { render "new" }
      end
    end
  end

  def update
    @contract = CrowdworksContract.find(params[:id])

    respond_to do |format|
      if @contract.update(crowdworks_contract_params)
        format.html { redirect_to @contract.project }
      else
        format.html { render "edit" }
      end
    end
  end

  def destroy
    @cwcontract = CrowdworksContract.find(params[:id])
    @cwcontract.destroy
    redirect_to @cwcontract.project
  end

  private

  def crowdworks_contract_params
    params.require(:crowdworks_contract).permit(:contract_id)
  end
end
