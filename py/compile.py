import argparse
import os
import sys

from boa.compiler import Compiler

parser = argparse.ArgumentParser("simple_example")
parser.add_argument("input", help="Input python file.", type=str)
parser.add_argument("output", help="Output avm file.", type=str)
args = parser.parse_args()

path = os.path.dirname(os.path.abspath(args.input))
sys.path = [path] + sys.path

print('Compiling {0} to {1}'.format(args.input, args.output))
Compiler.load_and_save(path=args.input, output_path=args.output)
