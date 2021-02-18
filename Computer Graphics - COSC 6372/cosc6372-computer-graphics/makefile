# References https://stackoverflow.com/a/30142139/5007662
CXX = g++
# CXX_FLAGS = -Wfatal-errors -Wall -Wextra -Wpedantic -Wconversion -Wshadow --std=c++17
CXX_FLAGS = --std=c++17
# Final binary
BIN = hw
# Put all auto generated stuff to this build dir.
BUILD_DIR = ./out

# List of all .cpp source files.
CPP = $(wildcard src/*.cpp)

# All .o files go to build dir.
OBJ = $(CPP:%.cpp=$(BUILD_DIR)/%.o)
# Gcc/Clang will create these .d files containing dependencies.
DEP = $(OBJ:%.o=%.d)

# Default target named after the binary.
$(BIN) : $(BUILD_DIR)/$(BIN)

# Actual target of the binary - depends on all .o files.
$(BUILD_DIR)/$(BIN) : $(OBJ)
	echo $(@D)
	mkdir -p $(@D)  # Create build directories - same structure as sources.
	$(CXX) $(CXX_FLAGS) $^ -o $@ # Just link all the object files.

# Include all .d files
-include $(DEP)

# Build target for every single object file.
# The potential dependency on header files is covered
# by calling `-include $(DEP)`.
# The -MMD flags additionaly creates a .d file with the same name as the .o file.
$(BUILD_DIR)/%.o : %.cpp
	mkdir -p $(@D)
	$(CXX) $(CXX_FLAGS) -MMD -c $< -o $@

# This should remove all generated files.
.PHONY : clean
clean :
	-rm $(BUILD_DIR)/$(BIN) $(OBJ) $(DEP)