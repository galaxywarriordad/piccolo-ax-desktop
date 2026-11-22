#pragma once

#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fcntl.h>
#include <fstream>
#include <string>
#include <sys/file.h>
#include <unistd.h>
#include <vector>

namespace ax::tui {

// Coffee / Espresso 24-bit ANSI TrueColor palette matching piccolo-ax GRUB & LXQt themes
constexpr const char* kBgEspresso   = "\033[48;2;11;8;6m";     // #0B0806
constexpr const char* kBgPanel      = "\033[48;2;20;15;12m";   // #140F0C
constexpr const char* kBgHighlight  = "\033[48;2;200;138;85m"; // #C88A55
constexpr const char* kFgCream      = "\033[38;2;244;237;228m";// #F4EDE4
constexpr const char* kFgCoffee     = "\033[38;2;200;138;85m"; // #C88A55
constexpr const char* kFgMuted      = "\033[38;2;156;132;112m";// #9C8470
constexpr const char* kFgEspresso   = "\033[38;2;11;8;6m";     // #0B0806
constexpr const char* kReset        = "\033[0m";
constexpr const char* kBold         = "\033[1m";

struct SystemTelemetry {
    bool dac_present = false;
    bool dac_locked  = false;
    std::string dac_summary = "HiBy FC3 [USB 0x32BB] • STANDBY";
    std::string ram_summary = "RAM: -- / -- MB";
    int temp_c = 0;
};

inline SystemTelemetry ProbeTelemetry() {
    SystemTelemetry t;

    // 1. Check /proc/asound/cards for USB DAC (HiBy FC3 / UAC2)
    std::ifstream cards("/proc/asound/cards");
    std::string line;
    while (std::getline(cards, line)) {
        if (line.find("FC3") != std::string::npos ||
            line.find("HiBy") != std::string::npos ||
            line.find("USB-Audio") != std::string::npos) {
            t.dac_present = true;
            break;
        }
    }

    // 2. Non-blocking probe of /run/lock/ax-dac.lock
    int lock_fd = ::open("/run/lock/ax-dac.lock", O_RDONLY | O_CREAT, 0666);
    if (lock_fd >= 0) {
        if (::flock(lock_fd, LOCK_EX | LOCK_NB) == 0) {
            ::flock(lock_fd, LOCK_UN);
            t.dac_locked = false;
        } else {
            t.dac_locked = true;
        }
        ::close(lock_fd);
    }

    if (t.dac_present) {
        t.dac_summary = t.dac_locked
            ? "HiBy FC3 [USB 0x32BB] • 32-bit S32_LE @ 192kHz • 2.00ms [LOCKED]"
            : "HiBy FC3 [USB 0x32BB] • 32-bit S32_LE Ready [UNLOCKED]";
    } else {
        t.dac_summary = "USB Audio DAC [0x32BB] • Not Connected";
    }

    // 3. Probe RAM usage from /proc/meminfo
    std::ifstream meminfo("/proc/meminfo");
    uint64_t mem_total_kb = 0, mem_avail_kb = 0;
    while (std::getline(meminfo, line)) {
        if (line.rfind("MemTotal:", 0) == 0) {
            mem_total_kb = std::strtoull(line.c_str() + 9, nullptr, 10);
        } else if (line.rfind("MemAvailable:", 0) == 0) {
            mem_avail_kb = std::strtoull(line.c_str() + 13, nullptr, 10);
        }
    }
    if (mem_total_kb > 0) {
        uint64_t used_mb  = (mem_total_kb - mem_avail_kb) / 1024;
        uint64_t total_mb = mem_total_kb / 1024;
        char buf[64];
        std::snprintf(buf, sizeof(buf), "EROFS TORAM  |  RAM: %llu / %llu MB",
                      static_cast<unsigned long long>(used_mb),
                      static_cast<unsigned long long>(total_mb));
        t.ram_summary = buf;
    }

    // 4. Probe CPU package temperature
    std::ifstream temp("/sys/class/thermal/thermal_zone0/temp");
    int milli_c = 0;
    if (temp >> milli_c) {
        t.temp_c = milli_c / 1000;
    }

    return t;
}

struct MenuItem {
    const char* title;
    const char* subtitle;
    const char* command;
};

inline void RenderScreen(const std::vector<MenuItem>& items,
                         size_t selected_idx,
                         const SystemTelemetry& tel) {
    // Clear screen & home cursor on espresso background
    std::printf("%s\033[2J\033[H", kBgEspresso);

    // Header bar
    std::printf("\n  %s%sPICCOLO [AX] REAL-TIME APPLIANCE%s  %s|  Core 5 UI Plane (0x20)%s\n",
                kBold, kFgCream, kReset, kFgMuted, kReset);
    std::printf("  %s──────────────────────────────────────────────────────────────────────────%s\n",
                kFgCoffee, kReset);

    // Hardware & RT Status Badges
    std::printf("  %s[ CORES 0-4: RT LOCKSTEP ]%s   %s[ CORE 5: CAPTURE / IO ]%s\n",
                kFgCoffee, kReset, kFgMuted, kReset);
    std::printf("  %s%s%s\n", kFgCream, tel.dac_summary.c_str(), kReset);
    if (tel.temp_c > 0) {
        std::printf("  %s%s  |  TEMP: %d°C%s\n", kFgMuted, tel.ram_summary.c_str(), tel.temp_c, kReset);
    } else {
        std::printf("  %s%s%s\n", kFgMuted, tel.ram_summary.c_str(), kReset);
    }

    std::printf("\n  %s%sAPPLIANCE LAUNCHER%s\n", kBold, kFgCoffee, kReset);
    std::printf("  %s──────────────────────────────────────────────────────────────────────────%s\n",
                kFgMuted, kReset);

    for (size_t i = 0; i < items.size(); ++i) {
        if (i == selected_idx) {
            std::printf("  %s%s > [%zu] %-26s — %-34s %s\n",
                        kBgHighlight, kFgEspresso, i + 1,
                        items[i].title, items[i].subtitle, kReset);
        } else {
            std::printf("  %s%s   [%zu] %s%-26s%s %s— %-34s%s\n",
                        kBgEspresso, kFgMuted, i + 1,
                        kFgCream, items[i].title, kReset,
                        kFgMuted, items[i].subtitle, kReset);
        }
    }

    std::printf("  %s──────────────────────────────────────────────────────────────────────────%s\n",
                kFgMuted, kReset);
    std::printf("  %s↑/↓%s SELECT   %s|%s   %sENTER%s LAUNCH   %s|%s   %sR%s REFRESH   %s|%s   %sQ%s SHELL\n",
                kFgCoffee, kReset, kFgMuted, kReset,
                kFgCoffee, kReset, kFgMuted, kReset,
                kFgCoffee, kReset, kFgMuted, kReset,
                kFgCoffee, kReset);
    std::fflush(stdout);
}

} // namespace ax::tui
