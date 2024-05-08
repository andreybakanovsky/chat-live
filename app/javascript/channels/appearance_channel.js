import consumer from "./consumer"

let targetElements = []

const appearanceChannel = consumer.subscriptions.create({ channel: "AppearanceChannel" }, {
  initialized() {
    this.update = this.update.bind(this)
  },

  connected() {
    this.install()
    this.update()
    newMessagesObserver()
  },

  disconnected() {
    this.uninstall()
  },

  rejected() {
    this.uninstall()
  },

  update() {
    newMessagesObserver()
    document.visibilityState === "visible" && document.hasFocus() ? this.online() : this.away()
  },

  online() {
    this.perform("online")
  },

  away() {
    this.perform("away")
  },

  received(data) {
    // set new messages number
    var turgetNumber = document.getElementById("user_" + data["sender_id"] + "_new_messages_number")
    turgetNumber.innerHTML = data["new_messages_number"]

    // check the chat
    var userChat = document.querySelector("#messages[user=" + `"${data["sender_id"]}"` + "]");
    if (!userChat) {
      return
    }

    // add the new message to the oserver
    function waitForMessage(callback) {
      if (document.getElementById(data["new_message"])) {
        callback();
      } else {
        setTimeout(function () {
          waitForMessage(callback);
        }, 1000);
      }
    }
    waitForMessage(function () {
      newMessagesObserver()
    });
  },

  install() {
    window.addEventListener("focus", this.update)
    window.addEventListener("blur", this.update)
    document.addEventListener("turbo:load", this.update)
    document.addEventListener("visibilitychange", this.update)
  },

  uninstall() {
    window.removeEventListener("focus", this.update)
    window.removeEventListener("blur", this.update)
    document.removeEventListener("turbo:load", this.update)
    document.removeEventListener("visibilitychange", this.update)
  }
})

function newMessagesObserver() {
  targetElements = document.querySelectorAll('[status="unread"]');

  if (targetElements) {
    const observer = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const message_id = entry.target.id.replace("message_", "")
          appearanceChannel.send({ message_id: message_id, body: "This message was read." })
        }
      });
    }, {
      rootMargin: "0px 0px -110px 0px"
    });

    targetElements.forEach(element => {
      observer.observe(element);
    });
  }
}
