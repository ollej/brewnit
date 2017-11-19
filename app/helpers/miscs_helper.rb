module MiscsHelper
  def misc_weight_options
    {
      I18n.t(:'recipe_detail.weight_option.weight') => '1',
      I18n.t(:'recipe_detail.weight_option.volume') => '0'
    }
  end

  def weight_selection(misc)
    if misc.weight?
      I18n.t(:'recipe_detail.weight_option.weight')
    else
      I18n.t(:'recipe_detail.weight_option.volume')
    end
  end
end
