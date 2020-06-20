class Notify {
  constructor() {
    this.available = ("Notification" in window);
  }

  granted() {
    return (this.permission || Notification.permission) === "granted";
  }

  denied() {
    return (this.permission || Notification.permission) === "denied";
  }

  requestPermission() {
    if (this.available && !this.granted() && !this.denied()) {
      Promise.resolve(Notification.requestPermission()).then((permission) => {
        this.permission = permission;
      });
    }
  }

  send(message, tag = "step") {
    if (this.available && this.granted()) {
      var n = new Notification(I18n["brewtimer"]["notification"]["title"], { body: message, tag: tag });
    } else {
      // Fallback to html toast
    }
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).Notify = Notify;
