#define __SETUP_H__
#include <filesystem>
#include <fmt/core.h>
#include <string>

namespace fs = std::filesystem;

int Setup()
{
    static const std::array<std::string, 8> dirs_to_create = {"Develop/personal/scripts",
                                                              "Develop/socialweb",
                                                              "Develop/usm",
                                                              ".config/python"
                                                              ".bin",
                                                              ".lib",
                                                              ".hsts",
                                                              ".zsh"};

    const std::string home_dir = std::string(std::getenv("HOME"));

    // Get HOME environment variable to change directory if not
    // currently there
    if (home_dir.compare(fs::current_path().string()))
        fs::current_path(fs::path(home_dir));

#ifndef DEBUG
    for (std::size_t i = 0; i < dirs_to_create.size(); i++)
    {
        fs::create_directories(home_dir + "/" + dirs_to_create[i]);
    }
#endif

    return 0;
}
