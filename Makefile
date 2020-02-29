#
# rv8-bench
#

CFLAGS = -fPIE -g
LDFLAGS = -static

RV32 = riscv32-linux-musl-
RV64 = riscv64-linux-musl-

PROGRAMS = aes bigint dhrystone miniz norx primes qsort sha512

RV32_PROGS = $(addprefix bin/riscv32/, $(PROGRAMS))
RV64_PROGS = $(addprefix bin/riscv64/, $(PROGRAMS))

ALL_PROGS = $(RV32_PROGS) $(RV64_PROGS)
O3_PROGS = $(addsuffix .O3, $(ALL_PROGS)) $(addsuffix .O3.stripped, $(ALL_PROGS))
O2_PROGS = $(addsuffix .O2, $(ALL_PROGS)) $(addsuffix .O2.stripped, $(ALL_PROGS))
OS_PROGS = $(addsuffix .Os, $(ALL_PROGS)) $(addsuffix .Os.stripped, $(ALL_PROGS))

all: $(O3_PROGS) $(O2_PROGS) $(OS_PROGS) | npm

npm: ; npm install

clean: ; rm -fr bin

bin/riscv32/%.O3: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(RV32)gcc $(LDFLAGS) -O3 $(CFLAGS) $< -o $@
bin/riscv32/%.O3: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(RV32)g++ $(LDFLAGS) -O3 $(CFLAGS) $< -o $@
bin/riscv32/%.O3.stripped: bin/riscv32/%.O3
	@echo STRIP $@ ; $(RV32)strip --strip-all $< -o $@
bin/riscv32/%.O2: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(RV32)gcc $(LDFLAGS) -O2 $(CFLAGS) $< -o $@
bin/riscv32/%.O2: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(RV32)g++ $(LDFLAGS) -O2 $(CFLAGS) $< -o $@
bin/riscv32/%.O2.stripped: bin/riscv32/%.O2
	@echo STRIP $@ ; $(RV32)strip --strip-all $< -o $@
bin/riscv32/%.Os: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(RV32)gcc $(LDFLAGS) -Os $(CFLAGS) $< -o $@
bin/riscv32/%.Os: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(RV32)g++ $(LDFLAGS) -Os $(CFLAGS) $< -o $@
bin/riscv32/%.Os.stripped: bin/riscv32/%.Os
	@echo STRIP $@ ; $(RV32)strip --strip-all $< -o $@

bin/riscv64/%.O3: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(RV64)gcc $(LDFLAGS) -O3 $(CFLAGS) $< -o $@
bin/riscv64/%.O3: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(RV64)g++ $(LDFLAGS) -O3 $(CFLAGS) $< -o $@
bin/riscv64/%.O3.stripped: bin/riscv64/%.O3
	@echo STRIP $@ ; $(RV64)strip --strip-all $< -o $@
bin/riscv64/%.O2: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(RV64)gcc $(LDFLAGS) -O2 $(CFLAGS) $< -o $@
bin/riscv64/%.O2: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(RV64)g++ $(LDFLAGS) -O2 $(CFLAGS) $< -o $@
bin/riscv64/%.O2.stripped: bin/riscv64/%.O2
	@echo STRIP $@ ; $(RV64)strip --strip-all $< -o $@
bin/riscv64/%.Os: src/%.c
	@echo CC $@ ; mkdir -p $(@D) ; $(RV64)gcc $(LDFLAGS) -Os $(CFLAGS) $< -o $@
bin/riscv64/%.Os: src/%.cc
	@echo CC $@ ; mkdir -p $(@D) ; $(RV64)g++ $(LDFLAGS) -Os $(CFLAGS) $< -o $@
bin/riscv64/%.Os.stripped: bin/riscv64/%.Os
	@echo STRIP $@ ; $(RV64)strip --strip-all $< -o $@

