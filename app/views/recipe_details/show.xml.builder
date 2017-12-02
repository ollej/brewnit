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
    xml.DATE brewed_at(@details)
    xml.NOTES @recipe.description
    xml.OG format_sg(@details.og)
    xml.FG format_sg(@details.fg)
    xml.CARBONATION @details.carbonation
    xml.EQUIPMENT do
      xml.VERSION 1
      xml.NAME @recipe.equipment
    end
    if @style.present?
      xml.STYLE do
        xml.VERSION 1
        xml.NAME @style.name
        xml.CATEGORY @style.category
        xml.CATEGORY_NUMBER @style.number
        xml.STYLE_LETTER @style.letter
        xml.STYLE_GUIDE @style.style_guide
        #xml.TYPE 'Ale'
        xml.OG_MIN @style.og_min
        xml.OG_MAX @style.og_max
        xml.FG_MIN @style.fg_min
        xml.FG_MAX @style.fg_max
        xml.IBU_MIN @style.ibu_min
        xml.IBU_MAX @style.ibu_max
        xml.COLOR_MIN BeerRecipe::Formula.new.ebc_to_srm(@style.ebc_min)
        xml.COLOR_MAX BeerRecipe::Formula.new.ebc_to_srm(@style.ebc_max)
        xml.ABV_MIN @style.abv_min
        xml.ABV_MAX @style.abv_max
      end
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
          xml.AMOUNT hop.amount_in_kilos
          xml.USE Hop.uses[hop.use]
          xml.ALPHA hop.alpha_acid
          xml.TIME hop.use_time_in_seconds
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
          xml.AMOUNT normalize_amount(misc.amount, misc.weight)
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
          xml.AMOUNT normalize_amount(yeast.amount, yeast.weight)
          # Support yeast packages?
          xml.FORM Yeast.forms[yeast.form]
          xml.TYPE Yeast.yeast_types[yeast.yeast_type]
        end
      end
    end
    xml.MASH do
      xml.VERSION 1
      xml.NAME I18n.t(:'recipe_detail.mash_steps')
      xml.GRAIN_TEMP @details.grain_temp
      xml.SPARGE_TEMP @details.sparge_temp
      xml.MASH_STEPS do
        @mash_steps.each do |mash_step|
          xml.MASH_STEP do
            xml.VERSION 1
            xml.NAME mash_step.name
            xml.TYPE MashStep.mash_types[mash_step.mash_type]
            xml.STEP_TEMP mash_step.step_temperature
            xml.STEP_TIME mash_step.step_time
            xml.RAMP_TIME mash_step.ramp_time if mash_step.ramp_time.present?
            xml.END_TEMP mash_step.end_temperature if mash_step.end_temperature.present?
            xml.WATER_GRAiN_RATIO mash_step.water_grain_ratio if mash_step.water_grain_ratio.present?
            xml.INFUSE_AMOUNT mash_step.infuse_amount if mash_step.infuse_amount.present?
            xml.INFUSE_TEMPERATURE mash_step.infuse_temperature if mash_step.infuse_temperature.present?
          end
        end
      end
    end
  end
end
