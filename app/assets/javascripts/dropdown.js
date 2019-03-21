class Dropdown {
  constructor(dropdownSelector, inputSelector, menuSelector) {
    this.dropdownSelector = dropdownSelector;
    this.input = $(inputSelector);
    this.menuSelector = menuSelector;
    $(document).on('click', this.click.bind(this));
    $(document).on('keydown', this.escape.bind(this));
  }

  click(event) {
    if (!$(event.target).closest(this.dropdownSelector).length ||
      $(event.target).closest(this.menuSelector).length) {
      // Close when clicking outside dropdown, or when clicking on menu
      this.close();
    }
  }

  escape(event) {
    if (this.escapePressed(event || window.event)) {
      this.close();
    }
  }

  escapePressed(event) {
    if (("key" in event) && (event.key === "Escape" || event.key === "Esc")) {
      return true;
    } else if (event.keyCode === 27) {
      return true;
    } else {
      return false;
    }
  }

  close() {
    this.input.attr('checked', false);
  }
}
