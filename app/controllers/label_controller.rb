class LabelController < ApplicationController
  before_action :load_and_authorize_recipe_by_id!

  def new
    @label_presenter = LabelPresenter.new(@recipe, recipe_url(@recipe), label_params)
  end

  def create
    @label_presenter = LabelPresenter.new(@recipe, recipe_url(@recipe), label_params)
    push_message
    send_data render_pdf, filename: 'etiketter.pdf', type: :pdf, disposition: :attachment
  end

  private
  def push_message
    PushMessage.new(push_values(@label_presenter.recipe_data)).notify
  end

  def push_values(data)
    {
      title: I18n.t(:'common.notification.label.created.title', data),
      message: I18n.t(:'common.notification.label.created.message', data),
      sound: :magic
    }
  end

  def render_pdf
    LabelMaker.new(@label_presenter.template).generate
  end

  def label_params
    params.permit(:name, :description1, :description2, :description3, :description4,
                  :abv, :ibu, :ebc, :og, :fg, :brewdate, :bottlesize, :contactinfo,
                  :brewery, :beerstyle, :malt1, :malt2, :hops1, :hops2, :yeast,
                  :template, :background, :border, :textcolor)
  end
end
