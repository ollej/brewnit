class RecipeLabelController < ApplicationController
  before_action :deny_spammers!, only: [:create]
  before_action :load_and_authorize_recipe_by_id!

  def new
    @label_presenter = RecipeLabelPresenter.new(@recipe, recipe_url(@recipe), label_params)
  end

  def create
    @label_presenter = RecipeLabelPresenter.new(@recipe, recipe_url(@recipe), label_params)
    send_notifications
    send_data @label_presenter.pdf, filename: 'etiketter.pdf', type: :pdf, disposition: :attachment, status: :created
  end

  private

  def label_params
    params.permit(:name, :description1, :description2, :description3, :description4,
                  :abv, :ibu, :ebc, :og, :fg, :brewdate, :bottlesize, :contactinfo,
                  :brewery, :beerstyle, :malt1, :malt2, :hops1, :hops2, :yeast,
                  :template, :background, :border, :textcolor)
  end

  def send_notifications
    PushMessage.new(@label_presenter.push_values).notify
    label = @label_presenter.template.generate_png.read
    User.where(admin: true, receive_email: true).each do |admin_user|
      LabelMailer.with(
        user: admin_user,
        creator: current_user,
        recipe: @recipe,
        label: label
      ).new_recipe_label.deliver_later
    end
  end
end
