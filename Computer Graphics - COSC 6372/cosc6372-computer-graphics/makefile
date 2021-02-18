SRC_DIR = src
SOURCES = $(wildcard $(SRC_DIR)/*.cpp)
OBJECTS = $(SOURCES:$(SRC_DIR)/%.cpp=%.o)
EXEC = hw
CXX = g++
CXXFLAGS = --std=c++17
DELETE = rm

$(EXEC) : $(OBJECTS)
	$(CXX) $(OBJECTS) -o $(EXEC)

%.o : $(SRC_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -c $<

.PHONY : all
all : $(EXEC)

.PHONY : clean
clean :
	-$(DELETE) $(OBJECTS) ${EXEC}
