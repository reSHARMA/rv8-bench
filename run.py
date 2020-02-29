#!/usr/bin/env python3

from argparse import ArgumentParser
import sys
import os
import subprocess
import re

def main():

    parser = ArgumentParser(description="Run rv8-bench")
    parser.add_argument('-cc', '--c_compiler',
            action='store',
            help='Name of the compiler',
            required=False)
    parser.add_argument('-cxx', '--cxx_compiler',
            action='store',
            help='Name of the compiler',
            required=False)
    try:
        args = parser.parse_args()
        print(args)

    except:
        parser.error("Invalid Options.")
        sys.exit(1)

    cCompiler = os.environ.get('CC')
    cxxCompiler = os.environ.get('CXX')
    if args.c_compiler:
        cCompiler= args.c_compiler
    if args.cxx_compiler:
        cxxCompiler= args.cxx_compiler

    if cCompiler is None or cxxCompiler is None:
        print("Compiler not set in the environment, try passing the compiler as a cli arg")
        sys.exit(1)

    runrv8Bench(cCompiler, cxxCompiler)

def setupSymlinks(cc, cxx):
    toolchains = ["riscv32-linux-musl-", "riscv64-linux-musl-", "i386-linux-musl-", "x86_64-linux-musl-", "arm-linux-musleabihf-", "aarch64-linux-musl-"]
    prefix = cc.split("/")
    prefix.pop()
    strip = "/".join(prefix) + "/llvm-strip"
    for toolchain in toolchains:
            subprocess.run(["ln", "-sf", cc, "/usr/bin/" + toolchain + "gcc"], check = True)
            subprocess.run(["ln", "-sf", cxx, "/usr/bin/" + toolchain + "g++"], check = True)
            subprocess.run(["ln", "-sf", strip, "/usr/bin/" + toolchain + "strip"], check = True)

def writeToFile(p, fileName):
    fileName.write(p.stdout)

def formatPerfResult(p, fileName):
    p = p.split("\n")[12:]
    res = []
    for x in p:
        result = re.sub(re.escape("      | qemu-riscv64    | O3  | "), ",", x)
        result1 = re.sub("\s", "", result)
        res.append(result1 + "\n")

    with open(fileName, 'a') as fout:
        fout.writelines(res)

def formatSizeResult(p, fileName):
    p = p.split("\n")[12:]
    res = []
    for x in p:
        result = re.sub(re.escape("      | size-riscv64    | Os  | "), ",", x)
        result1 = re.sub("\s", "", result)
        res.append(result1 + "\n")

    with open(fileName, 'a') as fout:
        fout.writelines(res)
 
def runrv8Bench(cCompiler, cxxCompiler):
    subprocess.run(['apt-get', '-y', 'install', 'nodejs', 'npm'], check=True)
    subprocess.run("curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -", shell=True, check = True)
    subprocess.run(['git', 'clone', 'https://github.com/rv8-io/rv8.git'], check = True)
    subprocess.run(['git', 'submodule', 'update', '--init'], check = True, cwd = "rv8")
    subprocess.run(['make', '-j24'], check = True, cwd = "rv8")
    subprocess.run(['make', 'install'], check = True, cwd = "rv8")
    subprocess.run(['make'], check = True)

    setupSymlinks(cCompiler, cxxCompiler)
    perfFileName = "/rvtc/perf.csv"
    p = subprocess.check_output(['npm', 'start', 'bench', 'all', 'qemu-riscv64', 'O3', '1'], encoding="utf-8")
    formatPerfResult(p, perfFileName)
    sizeFileName = "/rvtc/size.csv"
    p = subprocess.check_output(['npm', 'start', 'bench', 'all', 'size-riscv64', 'Os', '1'], encoding="utf-8")
    formatSizeResult(p, sizeFileName)

if __name__ == "__main__":
    main()
