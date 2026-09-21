{ pkgs, ... }:
let
  submapMainPatch =
    pkgs.writers.writePython3Bin "submap-main-patch"
      {
        libraries = [
          pkgs.python3Packages.evdev
          pkgs.python3Packages.pyudev
        ];
      }
      ''
        import asyncio
        import pyudev
        import evdev
        import subprocess


        class App:
            def __init__(self):
                self.kbd_event_tasks = set()
                self.kbd_event_queue = asyncio.Queue()
                self.kbds = {}
                self.keys_pressed = set()
                self.flag = False
                self.ctx = pyudev.Context()
                self.monitor = pyudev.Monitor.from_netlink(self.ctx)

            async def run(self):
                self.monitor.filter_by(subsystem="input")
                self.monitor.start()
                loop = asyncio.get_running_loop()
                loop.add_reader(self.monitor.fileno(), self.handle_udev_event)
                nodes = self.find_kbds()
                for node in nodes:
                    self.new_kbd_task(node)
                try:
                    while True:
                        await self.handle_key_event()
                finally:
                    loop.remove_reader(self.monitor.fileno())

            async def read_kbd_loop(self, node):
                kbd = evdev.InputDevice(node)
                async for raw in kbd.async_read_loop():
                    if raw.type != evdev.ecodes.EV_KEY:
                        continue
                    await self.kbd_event_queue.put(evdev.categorize(raw))

            async def handle_key_event(self):
                event = await self.kbd_event_queue.get()
                if event.keystate == 0:
                    self.keys_pressed.discard(event.keycode)
                    if self.flag and event.keycode == "KEY_SPACE":
                        self.flag = False
                        subprocess.run(
                            ["hyprctl", "eval", 'hl.dispatch(hl.dsp.submap("reset"))']
                        )
                elif event.keystate == 1:
                    self.keys_pressed.add(event.keycode)
                    if not self.flag and (
                        {"KEY_SPACE", "KEY_CAPSLOCK"}.issubset(self.keys_pressed) or
                        {"KEY_SPACE", "KEY_LEFTCTRL"}.issubset(self.keys_pressed) or
                        {"KEY_SPACE", "KEY_RIGHTCTRL"}.issubset(self.keys_pressed)
                    ):
                        self.flag = True
                        subprocess.run(
                            ["hyprctl", "eval", 'hl.dispatch(hl.dsp.submap("main"))']
                        )
                    if self.flag and event.keycode == "KEY_ESC":
                        self.flag = False
                        subprocess.run(
                            ["hyprctl", "eval", 'hl.dispatch(hl.dsp.submap("reset"))']
                        )
                elif event.keystate == 2:
                    return

            def new_kbd_task(self, node):
                task = asyncio.create_task(self.read_kbd_loop(node))
                self.kbd_event_tasks.add(task)
                task.add_done_callback(self.kbd_event_tasks.discard)

            def handle_udev_event(self):
                dev = self.monitor.poll()
                if dev.get("ID_INPUT_KEYBOARD") != "1" or not dev.device_node:
                    return
                if dev.action != "add":
                    return
                self.new_kbd_task(dev.device_node)

            def find_kbds(self):
                nodes = []
                devs = self.ctx.list_devices(subsystem="input", ID_INPUT_KEYBOARD=True)
                for dev in devs:
                    if dev.device_node:
                        nodes.append(dev.device_node)
                return nodes


        async def main():
            app = App()
            await app.run()


        if __name__ == "__main__":
            asyncio.run(main())
      '';
in
{
  hjem.users.saya.packages = with pkgs; [
    hyprland
    hyprpolkitagent
    hyprpaper
    waylock
    hypridle
    rofi
    mako
    wl-kbptr
    wlrctl
    wl-clipboard
    grimblast
    brightnessctl
    libnotify
    rose-pine-hyprcursor
    adwaita-icon-theme
    wiremix
    bluetuith
    submapMainPatch
  ];

  users.users.saya.extraGroups = [ "input" ];

  systemd.user.targets.graphical-session = {
    wants = [
      "hypridle.service"
      "hyprpolkitagent.service"
      "hyprpaper.service"
    ];
  };

  systemd.user.tmpfiles.rules = [
    "d %h/Desktop 0755 - - -"
    "d %h/Downloads 0755 - - -"
    "d %h/Templates 0755 - - -"
    "d %h/Public 0755 - - -"
    "d %h/Documents 0755 - - -"
    "d %h/Music 0755 - - -"
    "d %h/Pictures/Screenshots 0755 - - -"
    "d %h/Videos 0755 - - -"
  ];

  hjem.users.saya = {
    files = {
      ".bashrc.d/uwsm.sh".text = ''
        if [[ "$(tty)" = "/dev/tty1" ]] && uwsm check may-start && uwsm select; then
          exec uwsm start default
        fi
      '';
      ".config/hypr/hyprland.lua".source = ./hyprland.lua;
      ".config/hypr/hypridle.conf".source = ./hypridle.conf;
      ".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;
      ".config/hypr/hyprland/autostart.lua".source = ./hyprland/autostart.lua;
      ".config/hypr/hyprland/binds.lua".source = ./hyprland/binds.lua;
      ".config/hypr/hyprland/env.lua".source = ./hyprland/env.lua;
      ".config/hypr/hyprland/input.lua".source = ./hyprland/input.lua;
      ".config/hypr/hyprland/submap-cursor.lua".source = ./hyprland/submap-cursor.lua;
      ".config/hypr/hyprland/submap-main.lua".source = ./hyprland/submap-main.lua;
    };
  };
}
