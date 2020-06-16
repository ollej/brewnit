class LabelMailer < ApplicationMailer
  def new_label
    @user = params[:user]
    @creator = params[:creator]
    attachments.inline["label.png"] = params[:label]
    if @user.receive_email?
      mail(to: @user.email, subject: "Ny etikett på Brygglogg.se")
    end
  end

  def new_recipe_label
    @user = params[:user]
    @creator = params[:creator]
    @recipe = params[:recipe]
    attachments.inline["label.png"] = params[:label]
    @url = recipe_url(@recipe)
    if @user.receive_email?
      mail(to: @user.email, subject: "Ny etikett på Brygglogg.se för #{@recipe.name}")
    end
  end
end
