module LabelHelper
  def label_svg(label)
    inline_svg(Rails.root.join('app', 'assets', 'labeltemplates', label))
  end
end
