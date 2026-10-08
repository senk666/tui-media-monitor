# TTY Media Monitor 🎧

A lightweight, zero-dependency (pure Bash) terminal media monitor designed specifically for Linux TTY consoles, headless servers, and minimalist setups. It fetches metadata from any active system media player via `playerctl` and provides responsive hardware volume control via `amixer`.

---

## 📂 Project Structure

```text
tui-media-monitor/
└── bin/
    └── tty-monitor.sh    # The main executable script
```

---

## 🚀 Features

- **Ultra-lightweight:** Consumes ~0% CPU and RAM due to optimized cycle sleep loops.
- **TTY & SSH Compatible:** Uses only basic standard 8-color ANSI pallete. No modern hex-color or font glitches in pure console.
- **Flicker-Free:** Implements smart cursor routing (`tput cup`) and line clearing (`\e[K`) to prevent screen blinking.
- **Responsive Geometry:** Perfectly handles window resizing on the fly without breaking UI boxes.
- **Hardware Audio Control:** Directly communicates with ALSA mixer to change global system volume.

---

## 🛠 Dependencies & Installation

To run this tool on **Fedora Linux**, you need to install two core packages:

```bash
sudo dnf install playerctl alsa-utils
```

### Installation Steps

1. Clone this repository:
   ```bash
   git clone https://github.com/senk666/tui-media-monitor.git
   cd tui-media-monitor
   ```
3. Grant script execution permissions:
   ```bash
   chmod +x ./bin/tty-monitor.sh
   ```
2. Run the script directly from the `bin` directory:
   ```bash
   ./bin/tty-monitor.sh
   ```
   
---

## 🎛 Keybindings

- `[Space]` — Play / Pause
- `[,]` — Previous Track
- `[.]` — Next Track
- `[-]` — System Volume Down (-5%)
- `[+]` or `[=]` — System Volume Up (+5%)
- `[Ctrl+C]` — Safe Exit (fully restores terminal input and echo)

---

## 📝 License

This project is licensed under the MIT License - feel free to use, modify, and distribute!
