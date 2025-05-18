# 🧰 Peteware Developer Toolbox

Welcome to the **Peteware Developer Toolbox**, a powerful open-sourced script designed to assist script developers in creating, testing, and debugging game-breaking Roblox scripts. Whether you're reverse-engineering remotes, monitoring exploit environments, or simply looking for quick access to utilities like Dex or Hydroxide, this toolbox is your one-stop solution.

---

## 📌 Features

### 🔧 Developer Utilities
- **Dex Explorer** – Visual hierarchy explorer.
- **Remote Spy (SimpleSpy)** – Analyze remote calls in real time.
- **Infinite Yield** – Popular admin command script.
- **Hydroxide** – Deep dive into Lua environment, closures, constants, and more.
- **Advanced Anti-Cheat Scanner** – Detect advanced anti-cheat implementations in any game.

### 🪛 Debugging Tools
- **Print Global Variables**
  - `_G` and `getgenv()` full dumps.
  - Recent changes detection for exploit safety and monitoring.
- **Global Variable Manipulation**
  - Create, copy, and export global variables.
- **Environment Inspection**
  - Executor name and thread context.
  - Device type detection (PC/Mobile).

### 🔁 Session Control
- **Rejoin Current Server** with notification.
- **Server Hop** to a new instance.
- **Auto-Reexecution on Teleport** – Automatically re-run toolbox after teleporting or server-hopping.

---

## 🚀 How to Use

Paste the following into your executor:
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/PetewareScripts/Developers-Toolbox-Peteware/refs/heads/main/main.lua", true))()
