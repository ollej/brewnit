class BrewStepsPresenter
  include ActionView::Helpers::NumberHelper

  def initialize(recipe, beerxml = nil)
    @beerxml = beerxml || BeerxmlParser.new(recipe.beerxml).recipe
  end

  def hops_sorted
    @beerxml.hops.sort_by { |hop| hop.time }
  end

  def boil_hops
    hops_sorted.select { |hop| hop.use == 'Boil' }
  end

  def whirlpool_hops
    hops_sorted.select { |hop| hop.use == 'Aroma' }
  end

  def hop_steps
    boil_hops.map do |step|
      {
        name: RecipePresenter::hop_addition_name(step),
        description: RecipePresenter::hop_info(step),
        addition_time: step.time.to_i,
        type: "hops"
      }
    end
  end

  def misc_info(misc)
    "#{misc.formatted_amount} #{I18n.t("beerxml.#{misc.unit}", default: 'grams')} #{misc.name} @ #{misc.formatted_time} #{I18n.t("beerxml.#{misc.time_unit}", default: misc.time_unit)}"
  end

  def miscs_sorted
    @beerxml.miscs.sort_by { |misc| misc.time }
  end

  def boil_miscs
    miscs_sorted.select { |misc| misc.use == 'Boil' }
  end

  def misc_steps
    boil_miscs.map do |step|
      {
        name: step.type,
        description: misc_info(step),
        addition_time: step.time.to_i,
        type: "misc"
      }
    end
  end

  def calculate_step_times(steps)
    step_times = 0
    steps.map do |step|
      step_time = step[:addition_time] - step_times
      step_times += step_time
      step[:time] = step_time * 60
    end
    time = 0
    index = 0
    steps.reverse.map do |step|
      step[:starttime] = time
      step[:endtime] = time += step[:time]
      step[:index] = index
      index += 1
      step
    end

    steps
  end

  def add_boil_step(steps)
    highest_step_time = steps.map { |step| step[:addition_time] }.max || 0
    boil_time = @beerxml.boil_time - highest_step_time
    if highest_step_time < @beerxml.boil_time
      steps << {
        name: I18n.t(:'beerxml.Boil'),
        description: I18n.t(:'beerxml.brew_step.boil_time', boil_time: boil_time),
        addition_time: @beerxml.boil_time.to_i,
        type: "boil"
      }
    end
    steps
  end

  def merge_steps(steps)
    additions = {}
    steps.sort_by! { |step| step[:addition_time] }
    steps.each do |step|
      if additions[step[:addition_time]]
        description = [
          additions[step[:addition_time]][:description],
          step[:description]
        ].join("\n")
        additions[step[:addition_time]][:description] = description
      else
        additions[step[:addition_time]] = step
      end
    end
    additions.values
  end

  def add_addition_time_to_names(steps)
    steps.each do |step|
      step[:name] = step[:name] + " (#{step[:addition_time]} #{I18n.t("beerxml.time_unit.min")})"
    end
  end

  def boil_step_list
    steps = hop_steps + misc_steps
    steps = merge_steps(steps)
    steps = add_boil_step(steps)
    steps = calculate_step_times(steps)
    steps = add_addition_time_to_names(steps)

    # TODO: Add whirlpool additions

    steps.reverse
  end

  def mash_step_list
    steps = []
    time = 0
    index = 0
    @beerxml.mash.steps.each do |step|
      steps.push({
        name: step.name,
        description: I18n.t(:'beerxml.brew_step.raise_temperature', {
          temperature: number_with_precision(step.step_temp, precision: 1)
        }),
        type: "raise",
        time: step.ramp_time * 60,
        starttime: time,
        endtime: time += step.ramp_time * 60,
        index: index
      })
      index += 1
      steps.push({
        name: step.name,
        description: I18n.t(:'beerxml.brew_step.hold_temperature', {
          temperature: number_with_precision(step.step_temp, precision: 1),
          minutes: step.step_time
        }),
        type: "mash",
        time: step.step_time * 60,
        starttime: time,
        endtime: time += step.step_time * 60,
        index: index
      })
      index += 1
    end
    steps
  end
end
