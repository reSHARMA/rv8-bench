#
# rv8-bench
#

CFLAGS = -fPIE -g
LDFLAGS = -static

RV32 = riscv32-linux-musl-
RV64 = riscv64-linux-musl-

RV_GCC = /rvtc/gnu_install/bin/riscv32-unknown-elf-gcc
RV_GPP = /rvtc/gnu_install/bin/riscv32-unknown-elf-g++
GNU_SYSROOT =  --target=riscv32 --gcc-toolchain=/rvtc/gnu_install/ --sysroot=/rvtc/gnu_install/riscv32-unknown-elf/
GNU_LD_FLAGS = -march=rv32imac -mabi=ilp32
PROGRAMS = aes bigint dhrystone miniz norx primes qsort sha512

RV32_PROGS = $(addprefix bin/riscv32/, $(PROGRAMS))
RV64_PROGS = $(addprefix bin/riscv64/, $(PROGRAMS))

ALL_PROGS = $(RV32_PROGS)
O3_PROGS = $(addsuffix .O3, $(ALL_PROGS)) $(addsuffix .O3.stripped, $(ALL_PROGS))
O2_PROGS = $(addsuffix .O2, $(ALL_PROGS)) $(addsuffix .O2.stripped, $(ALL_PROGS))
OS_PROGS = $(addsuffix .Os, $(ALL_PROGS)) $(addsuffix .Os.stripped, $(ALL_PROGS))

all: $(O3_PROGS) $(O2_PROGS) $(OS_PROGS) | npm

npm: ; npm install

clean: ; rm -fr bin


bin/riscv32/%.O3: src/%.c
        @echo CC $@ ; mkdir -p $(@D) ; $(RV32)gcc $(LDFLAGS) -O3 $(CFLAGS) -O -c $< -o $@.o $(GNU_SYSROOT) ; $(RV_GCC) $@.o -o $@ $(GNU_LD_FLAGS)
bin/riscv32/%.O3: src/%.cc
        @echo CC $@ ; mkdir -p $(@D) ; $(RV32)g++ $(LDFLAGS) -O3 $(CFLAGS) -O -c $< -o $@.o $(GNU_SYSROOT) ; $(RV_GPP) $@.o -o $@ $(GNU_LD_FLAGS)
bin/riscv32/%.O3.stripped: bin/riscv32/%.O3
        @echo STRIP $@ ; $(RV32)strip --strip-all $< -o $@
bin/riscv32/%.O2: src/%.c
        @echo CC $@ ; mkdir -p $(@D) ; $(RV32)gcc $(LDFLAGS) -O2 $(CFLAGS) -O -c $< -o $@.o $(GNU_SYSROOT) ; $(RV_GCC) $@.o -o $@ $(GNU_LD_FLAGS)
bin/riscv32/%.O2: src/%.cc
        @echo CC $@ ; mkdir -p $(@D) ; $(RV32)g++ $(LDFLAGS) -O2 $(CFLAGS) -O -c $< -o $@.o $(GNU_SYSROOT) ; $(RV_GPP) $@.o -o $@ $(GNU_LD_FLAGS)
bin/riscv32/%.O2.stripped: bin/riscv32/%.O2
        @echo STRIP $@ ; $(RV32)strip --strip-all $< -o $@
bin/riscv32/%.Os: src/%.c
        @echo CC $@ ; mkdir -p $(@D) ; $(RV32)gcc $(LDFLAGS) -Os $(CFLAGS) -O -c $< -o $@.o $(GNU_SYSROOT) ; $(RV_GCC) $@.o -o $@ $(GNU_LD_FLAGS)
bin/riscv32/%.Os: src/%.cc
        @echo CC $@ ; mkdir -p $(@D) ; $(RV32)g++ $(LDFLAGS) -Os $(CFLAGS) -O -c $< -o $@.o $(GNU_SYSROOT) ; $(RV_GPP) $@.o -o $@ $(GNU_LD_FLAGS)
bin/riscv32/%.Os.stripped: bin/riscv32/%.Os
        @echo STRIP $@ ; $(RV32)strip --strip-all $< -o $@
