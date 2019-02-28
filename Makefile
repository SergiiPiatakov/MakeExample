CXX           = g++
INCLUDES      = -I include
OPTIMIZATION ?= O0

CXXFLAGS      = -c \
                -MMD \
                -std=c++11 -march=native -mtune=native \
                -Wall -Wextra \
                -fprofile-arcs -ftest-coverage \
                -$(OPTIMIZATION) \
                -fverbose-asm -Wa,-ahlms=$(<:.cpp=.lst)
LDPATH        =
LDADD         = -lgcov
SRC           = main.cpp
OBJ           = $(SRC:.cpp=.o)
DEP           = $(wildcard $(SRC:.cpp=.d))
EXE           = main

COV_DATA      = $(shell find . -type f -name '*.d' -o -name '*.gcov' -o -name '*.gcda' -o -name '*.gcno' -o -name 'coverage' -o -name 'coverage.info')
LST_DATA      = $(shell find . -type f -name '*.lst')
TMP_DATA      = $(shell find . -type f -name '*~')

.PHONY: all clean coverage

all: $(EXE)

$(EXE): $(OBJ)
	$(CXX) $(OBJ) $(LDPATH) $(LDADD) -o $@

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) $< -o $@

clean:
	rm -rf $(OBJ) $(EXE) $(TMP_DATA) $(LST_DATA) $(COV_DATA) $(LOG_DATA)

coverage:
	lcov -q -c -f -b . -d . -o coverage.info && genhtml coverage.info --legend --demangle-cpp -f -q -o coverage

include $(DEP)
