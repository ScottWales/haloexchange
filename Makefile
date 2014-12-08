all: bin/haloexchange

FC      = mpif90
LD      = ${FC}
MKDIR   = mkdir -p

FCFLAGS = -g -traceback -xHost -warn all -warn error

.SUFFIXES:
.PHONY: all clean check

clean:
	${RM} -r build bin

build/%.o: src/%.f90
	@ ${MKDIR} $(dir $@)
	${FC} ${FCFLAGS} -c -o $@ $<

bin/%: build/%.o
	@ ${MKDIR} $(dir $@)
	${LD} ${LDFLAGS} -o $@ $< ${LDLIBS}
