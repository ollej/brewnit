class LabelController < ApplicationController
  invisible_captcha only: [:create], on_spam: :redirect_guest_spammers!, on_timestamp_spam: :redirect_guest_spammers!
  skip_before_action :authenticate_user!, only: [:new, :create]
  before_action :deny_spammers!, only: [:new, :create]

  def new
    @label_presenter = LabelPresenter.new(current_user, label_params, root_url)
    @onsubmit = 'setTimeout(function() { location.reload(true) }, 10)' if !user_signed_in?
  end

  def create
    @label_presenter = LabelPresenter.new(current_user, label_params, root_url)
    PushMessage.new(@label_presenter.push_values).notify
    send_data @label_presenter.pdf, filename: 'etiketter.pdf', type: :pdf, disposition: :attachment, status: :created
  end

  private

  def label_params
    params.permit(:name, :description1, :description2, :description3, :description4,
                  :abv, :ibu, :ebc, :og, :fg, :brewdate, :bottlesize, :contactinfo,
                  :brewery, :beerstyle, :malt1, :malt2, :hops1, :hops2, :yeast,
                  :template, :background, :border, :textcolor)
  end
end
