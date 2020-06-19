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
    if (!this.granted() && !this.denied()) {
      Notification.requestPermission((permission) => {
        this.permission = permission;
      }).then((permission) => {
        this.permission = permission;
      });
    }
  }

  send(message, tag = "step") {
    if (this.available && this.granted()) {
      var n = new Notification("Bryggklocka", { body: message, tag: tag });
    } else {
      // Fallback to html toast
    }
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).Notify = Notify;
