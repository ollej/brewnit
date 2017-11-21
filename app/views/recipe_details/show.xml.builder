xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
xml.RECIPES do
  xml.RECIPE do
    xml.VERSION 1
    xml.NAME @recipe.name
    xml.TYPE 'All Grain'
    xml.BREWER @recipe.brewer_name
    xml.BATCH_SIZE @details.batch_size
    xml.BOIL_SIZE @details.boil_size
    xml.BOIL_TIME @details.boil_time
    xml.EFFICIENCY @details.efficiency
    xml.DATE I18n.l(@recipe.created_at)
    #xml.OG ...
    #xml.FG ...
    xml.STYLE do
      xml.VERSION 1
      xml.NAME 'IPA'
      xml.CATEGORY 'Kraftig ale'
      xml.CATEGORY_NUMBER '5'
      xml.STYLE_LETTER 'C'
      xml.STYLE_GUIDE 'SHBF 2017'
      xml.TYPE 'Ale'
      xml.OG_MIN '1.056'
      xml.OG_MAX '1.070'
      xml.FG_MIN '1.010'
      xml.FG_MAX '1.016'
      xml.IBU_MIN '50'
      xml.IBU_MAX '75'
      xml.COLOR_MIN '7.62'
      xml.COLOR_MAX '12.7'
      xml.ABV_MIN '5.9'
      xml.ABV_MAX '7.5'
    end
    xml.FERMENTABLES do
      @fermentables&.each do |fermentable|
        xml.FERMENTABLE do
          xml.VERSION 1
          xml.NAME fermentable.name
          xml.AMOUNT fermentable.amount
          xml.YIELD fermentable.yield
          xml.POTENTIAL fermentable.potential
          xml.COLOR BeerRecipe::Formula.new.ebc_to_srm(fermentable.ebc)
          xml.TYPE Fermentable.grain_types[fermentable.grain_type]
          xml.ADD_AFTER_BOIL fermentable.after_boil.to_s.upcase
          xml.FERMENTABLE fermentable.fermentable.to_s.upcase
        end
      end
    end
    xml.HOPS do
      @hops&.each do |hop|
        xml.HOP do
          xml.VERSION 1
          xml.NAME hop.name
          xml.AMOUNT hop.amount
          xml.USE Hop.uses[hop.use]
          xml.ALPHA hop.alpha_acid
          xml.TIME hop.use_time
          xml.FORM Hop.forms[hop.form]
        end
      end
    end
    xml.MISCS do
      @miscs&.each do |misc|
        xml.MISC do
          xml.VERSION 1
          xml.NAME misc.name
          xml.AMOUNT_IS_WEIGHT misc.weight.to_s.upcase
          xml.AMOUNT misc.amount
          xml.TIME misc.use_time
          xml.USE Misc.uses[misc.use]
          xml.TYPE Misc.misc_types[misc.misc_type]
        end
      end
    end
    xml.YEASTS do
      @yeasts&.each do |yeast|
        xml.YEAST do
          xml.VERSION 1
          xml.NAME yeast.name
          xml.AMOUNT_IS_WEIGHT yeast.weight.to_s.upcase
          xml.AMOUNT yeast.amount
          xml.FORM Yeast.forms[yeast.form]
          xml.TYPE Yeast.yeast_types[yeast.yeast_type]
        end
      end
    end
  end
end
