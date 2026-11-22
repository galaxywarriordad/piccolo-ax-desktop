#include "tui/appliance_tui.hpp"

#include <csignal>
#include <cstdlib>
#include <sched.h>
#include <termios.h>
#include <unistd.h>
#include <vector>

namespace {

termios g_orig_termios{};
bool g_raw_enabled = false;

void RestoreTerminal() {
    if (g_raw_enabled) {
        ::tcsetattr(STDIN_FILENO, TCSAFLUSH, &g_orig_termios);
        g_raw_enabled = false;
    }
    std::printf("\033[?25h%s\n", ax::tui::kReset);
    std::fflush(stdout);
}

void HandleSignal(int) {
    RestoreTerminal();
    std::_Exit(0);
}

void EnableRawMode() {
    if (::tcgetattr(STDIN_FILENO, &g_orig_termios) == 0) {
        termios raw = g_orig_termios;
        raw.c_lflag &= static_cast<tcflag_t>(~(ECHO | ICANON));
        raw.c_cc[VMIN] = 0;
        raw.c_cc[VTIME] = 5; // 500ms refresh tick for live DAC/RAM telemetry
        ::tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw);
        g_raw_enabled = true;
    }
    std::printf("\033[?25l"); // Hide cursor
}

void PinToCore5() {
    cpu_set_t cpuset;
    CPU_ZERO(&cpuset);
    CPU_SET(5, &cpuset); // Core 5 (0x20) — housekeeping/UI plane
    ::sched_setaffinity(0, sizeof(cpuset), &cpuset);
}

} // namespace

int main() {
    PinToCore5();
    std::atexit(RestoreTerminal);
    std::signal(SIGINT, HandleSignal);
    std::signal(SIGTERM, HandleSignal);

    const std::vector<ax::tui::MenuItem> items = {
        {"flac_ax",           "Bit-Perfect Audio Player (Core 0)",   "flac_ax"},
        {"RetroArch",         "Low-Latency Emulation Core",          "retroarch"},
        {"ax_av_studio",      "Live Capture & MPK Mini Synth",       "ax_av_studio"},
        {"ax_video_upscaler", "720p V4L2/OpenGL Upscaler (Core 1)",  "ax_video_upscaler"},
        {"Desktop Mode",      "Hand off to LXQt / X11 on SHARE",     "/usr/local/bin/launch-desktop.sh"}
    };

    size_t selected = 0;
    EnableRawMode();

    while (true) {
        auto tel = ax::tui::ProbeTelemetry();
        ax::tui::RenderScreen(items, selected, tel);

        char c = 0;
        ssize_t n = ::read(STDIN_FILENO, &c, 1);
        if (n <= 0) {
            continue; // Refresh telemetry every 500ms
        }

        if (c == '\033') {
            char seq[2] = {0, 0};
            if (::read(STDIN_FILENO, &seq[0], 1) == 1 &&
                ::read(STDIN_FILENO, &seq[1], 1) == 1 && seq[0] == '[') {
                if (seq[1] == 'A') { // Up arrow
                    selected = (selected == 0) ? (items.size() - 1) : (selected - 1);
                } else if (seq[1] == 'B') { // Down arrow
                    selected = (selected + 1) % items.size();
                }
            }
        } else if (c == 'k' || c == 'K') {
            selected = (selected == 0) ? (items.size() - 1) : (selected - 1);
        } else if (c == 'j' || c == 'J') {
            selected = (selected + 1) % items.size();
        } else if (c >= '1' && c <= '5') {
            selected = static_cast<size_t>(c - '1');
        } else if (c == '\r' || c == '\n') {
            RestoreTerminal();
            int rc = std::system(items[selected].command);
            (void)rc;
            EnableRawMode();
        } else if (c == 'q' || c == 'Q') {
            break;
        }
    }

    return 0;
}
