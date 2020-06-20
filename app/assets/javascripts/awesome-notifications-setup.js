// Override the Rails.confirm dialog with awesome-notification

Rails.confirm = function(message, element) {
  new AWN().confirm(
    message,
    () => {
      // Remove confirm attribute to bypass rails-ujs
      delete element.dataset.confirm;
      // Trigger click on element
      element.click();
    },
    () => {},
    {
      labels: {
        confirm: I18n["confirm"]["title"],
        confirmCancel: I18n["confirm"]["cancel"]
      }
    }
  );

  // Ensure Rails always stops the action
  return false;
};
