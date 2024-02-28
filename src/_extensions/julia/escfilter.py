import sys
f = sys.stdin.read()
g = f.replace('\\u001b[','ꍟ⦃')
sys.stdout.write(g)
