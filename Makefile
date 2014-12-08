all:

FC      = mpif90
ANALYSE = ${FC} -diag-enable sc3 -diag-enable sc-full -diag-sc-dir=analyse
MKDIR   = mkdir -p

FCFLAGS = -g -traceback -xHost -warn all -warn error

.SUFFIXES:
.PHONY: all clean check analyse

all:     bin/haloexchange
analyse: bin/haloexchange-analyse

clean:
	${RM} -r build bin

build/%.o: src/%.f90
	@ ${MKDIR} $(dir $@)
	${FC} ${FCFLAGS} -c -o $@ $<

bin/%: build/%.o
	@ ${MKDIR} $(dir $@)
	${FC} ${LDFLAGS} -o $@ $^ ${LDLIBS}

build/%.ao: src/%.f90
	@ ${MKDIR} $(dir $@)
	@ ${MKDIR} analyse
	${ANALYSE} ${FCFLAGS} -c -o $@ $<

bin/%-analyse: build/%.ao
	@ ${MKDIR} analyse
	${ANALYSE} ${LDFLAGS} -o $@ $^ ${LDLIBS}
