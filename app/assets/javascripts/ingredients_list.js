class IngredientsList {
  constructor(el) {
    this.el = el;
  }

  setup() {
    const ingredientsObserver = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        if (mutation.addedNodes !== null || mutation.removedNodes !== null) {
          this.update($(mutation.target).parents(this.el));
        }
      });
    });

    $(this.el).each(function(index) {
      ingredientsObserver.observe(this, { childList: true, subtree: true });
    });

    const self = this;
    $(this.el).each(function(index) {
      self.update($(this));
    });

    return this;
  }

  update(parent) {
    if (parent.find("tbody > tr").length > 0) {
      this.show(parent);
    } else {
      this.hide(parent);
    }
  }

  hide(parent) {
    parent.find(".ingredients-table").hide();
    parent.find(".empty-table").show();
  }

  show(parent) {
    parent.find(".ingredients-table").show();
    parent.find(".empty-table").hide();
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).IngredientsList = IngredientsList;
