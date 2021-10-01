#include <cstdlib>
#include <fmt/core.h>
#include <ftxui/dom/elements.hpp>
#include <ftxui/screen/screen.hpp>

#include "checklist.hpp"
#include "setup.hpp"

namespace ftx = ftxui;

int main(int argc, char *argv[])
{
    /**
     * Steps:
     *   1. Setup
     *   2. Checklist for important things to download
     *      or not (e.g. Xmonad vs Qtile)
     *   3. Run main loop
     *   4. Exit
     */

    int setup_return_value = Setup(argc, argv);

    return EXIT_SUCCESS;
}