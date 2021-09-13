# Compiler settings
CXX       := -clang++
CXX_STD   := -std=c++2a
CXXFLAGS  := -W -Wall -Wextra -pedantic -Wno-vla $(CXX_STD)
LDFLAGS   := -L@/usr/lib -lstdc++ -lm

# Directories
BIN_DIR   := ./bin
BUILD_DIR := ./build

# Set the target name
TARGET_NAME := installer
ifeq ($(OS), Windows_NT)
	TARGET_NAME := $(addsuffix .exe, $(TARGET_NAME))
endif
TARGET    := $(BIN_DIR)/$(TARGET_NAME)

# Include directories when building
INCLUDE_DIRS    := external/fmt/include/fmt/ external/ftxui/include/ftxui/ include/

# Source files
SRC_FILES := $(shell find src -name '*.c[cpx]*')

OBJECTS   := $(addsuffix .o, $(basename $(SRC_FILES:src/%=$(BUILD_DIR)/%)))

DEPENDENCIES := $(OBJECTS:.o=.d)
INCLUDE      := $(addprefix -I, $(INCLUDE_DIRS))

# For development, debug is the default rule
default: debug

all: clean mkdirs $(TARGET)

$(BUILD_DIR)/%.o: src/%
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(INCLUDE) -c $< -MMD -o $@

$(TARGET): $(OBJECTS)
	$(CXX) $(CXXFLAGS) -o $(APP_DIR)/$(TARGET) $^ $(LDFLAGS)

-include $(DEPENDENCIES)

mkdirs:
	@mkdir -p $(BIN_DIR)
	@mkdir -p $(BUILD_DIR)

debug: CXXFLAGS += -DDEBUG -g
debug: all

release: CXXFLAGS += -O3
release: all

info:
	@echo "[*] Target:          ${TARGET}      "
	@echo "[*] Object dir:      ${BUILD_DIR}   "
	@echo "[*] Sources:         ${SRC_FILES}   "
	@echo "[*] Objects:         ${OBJECTS}     "
	@echo "[*] Dependencies:    ${DEPENDENCIES}"
	@echo "[*] Included dirs:   ${INCLUDE}     "

.PHONY: all build clean debug release info
