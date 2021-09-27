#include <fmt/core.h>
#include <ftxui/dom/elements.hpp>
#include <ftxui/screen/screen.hpp>

namespace ftx=ftxui;

int main(int argc, char* argv[]) {
    fmt::print("Starting FTXUI lib test...\n");
    
    // Define document
    ftx::Element doc = ftx::hbox({
        ftx::text("left") | ftx::border,
        ftx::text("middle") | ftx::border | ftx::flex,
        ftx::text("right") | ftx::border,
    });
    
    auto screen = ftx::Screen::Create(
        ftx::Dimension::Full(),
        ftx::Dimension::Fit(doc)
    );

    ftx::Render(screen, doc);
    screen.Print();
    
    return EXIT_SUCCESS;
}