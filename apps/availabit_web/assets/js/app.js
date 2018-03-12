import "phoenix_html";
import { Socket, Presence } from "phoenix";

if (document.querySelector('#event-app')) {
  let socket = new Socket("/socket", {params: {token: window.userToken}});
  let channel = socket.channel(`event:${window.event.id}`, {});

  new Vue({
    el: '#event-app',
    data: {
      user: window.user,
      entries: [],
      presences: {}
    },
    created: function () {
      socket.connect();
      channel.join()
        .receive("ok", resp => { console.log("Joined successfully", resp) })
        .receive("error", resp => { console.log("Unable to join", resp) });

      channel.on('presence_state', state => {
        this.presences = Presence.syncState(this.presences, state);
      });

      channel.on('presence_diff', diff => {
        this.presences = Presence.syncDiff(this.presences, diff);
      });

      channel.on('entries', ({ entries }) => {
        let userEntry = entries.find((entry) => {
          return entry.user.id === window.user.id;
        });

        if (!userEntry) {
          entries.push({user: this.user, slots: [false, false, false, false, false, false, false]});
        }

        this.entries = entries;
      });
    },
    computed: {
      onlineUsers: function () {
        let onlineUsers = Object.keys(this.presences).map((id) => {
          let [first, ...rest] = this.presences[id].metas;
          return first.user;
        });

        return onlineUsers;
      }
    },
    methods: {
      slotChange: function (event, entry, slotIndex) {
        entry.slots[slotIndex] = event.target.checked;
        channel.push('entry-update', {slots: entry.slots})
      },
    }
  });
}
