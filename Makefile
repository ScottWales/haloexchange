all:

FC      = mpif90
ANALYSE = ${FC} -diag-enable sc3 -diag-enable sc-full -diag-sc-dir=analyse
MKDIR   = mkdir -p

FCFLAGS = -fpp -g -traceback -xHost -warn all -warn error -mod include

SRC    := $(shell find src -name '*.f90')
OBJ    := $(patsubst src/%.f90,build/%.o,${SRC})
DEP    := $(patsubst src/%.f90,build/%.dep,${SRC})


.SUFFIXES:
.PHONY: all clean check analyse

all:     bin/haloexchange
analyse: bin/haloexchange-analyse

clean:
	${RM} -r build bin analyse include/*.mod

build/%.o: src/%.f90
	@ ${MKDIR} $(dir $@)
	@ ${MKDIR} include
	${FC} ${FCFLAGS} -c -o $@ $<

include/%_mod.mod: build/%.o
	@ true

bin/%: build/%.o ${OBJ}
	@ ${MKDIR} $(dir $@)
	${FC} ${LDFLAGS} -o $@ $^ ${LDLIBS}

build/%.ao: src/%.f90
	@ ${MKDIR} $(dir $@)
	@ ${MKDIR} analyse
	${ANALYSE} ${FCFLAGS} -c -o $@ $<

bin/%-analyse: build/%.ao
	@ ${MKDIR} analyse
	${ANALYSE} ${LDFLAGS} -o $@ $^ ${LDLIBS}

build/haloexchange.o: include/mpi_helper_mod.mod include/field_mod.mod
build/field.o: include/error_mod.mod
