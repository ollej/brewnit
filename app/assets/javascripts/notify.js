class Notify {
  constructor() {
    this.available = ("Notification" in window);
    this.notifier = new AWN({
      labels: {
        success: I18n["brewtimer"]["notification"]["success"]
      }
    });
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
      if (tag == "done") {
        this.notifier.success(message);
      } else {
        this.notifier.info(message);
      }
    }
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).Notify = Notify;
