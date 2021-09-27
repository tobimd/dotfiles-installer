# Compiler settings
CXX       := gcc
CXX_STD   := c++20
CXXFLAGS  := -W -Wall -Wextra -pedantic -Wno-vla -std=$(CXX_STD)
LDFLAGS   := -L@/usr/lib -lstdc++ -lm -Llib -lfmt -lftxui-component -lftxui-dom -lftxui-screen

# Directories
BIN_DIR   := bin
BUILD_DIR := build

# Set the target name
TARGET_NAME := installer
ifeq ($(OS), Windows_NT)
	TARGET_NAME := $(addsuffix .exe, $(TARGET_NAME))
endif
TARGET    := $(BIN_DIR)/$(TARGET_NAME)

# Files
SRC_FILES := $(shell find src -name '*.c[cpx]*')
OBJECTS   := $(addsuffix .o, $(basename $(SRC_FILES:src/%=$(BUILD_DIR)/%)))
DEPENDENCIES := $(OBJECTS:.o=.d)

# Include directories for locating headers
INCLUDE      := -Iinclude/

# For development, debug is the default rule
default: debug

all: clean mkdirs $(TARGET)

$(BUILD_DIR)/%.o: src/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(INCLUDE) -c $< -MMD -o $@

$(TARGET): $(OBJECTS)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $^ $(LDFLAGS)

-include $(DEPENDENCIES)

mkdirs:
	@mkdir -p $(BIN_DIR)
	@mkdir -p $(BUILD_DIR)

debug: CXXFLAGS += -DDEBUG -g
debug: all

release: CXXFLAGS += -O3
release: all

clean:
	@echo "Cleaning project"
	@echo ""
	-@rm -rvf $(BUILD_DIR)/
	-@rm -vf $(BIN_DIR)

info:
	@echo "[*] Target:          ${TARGET}      "
	@echo "[*] Object dir:      ${BUILD_DIR}/  "
	@echo "[*] Sources:         ${SRC_FILES}   "
	@echo "[*] Objects:         ${OBJECTS}     "
	@echo "[*] Dependencies:    ${DEPENDENCIES}"
	@echo "[*] Included dirs:   ${INCLUDE}     "

.PHONY: all build clean debug release info
