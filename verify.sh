#!/bin/bash
set -e
echo "=== Augur Crowdsale Bytecode Verification ==="
echo "Contract: 0xe28e72fcf78647adce1f1252f240bbfaebd63bcc"
echo ""

docker run --rm --platform linux/amd64 -v "$PWD:/work" \
  $(docker images -q serpent-compiler 2>/dev/null | head -1 || echo "serpent-compiler") \
  bash -c "
cd /serpent && git checkout 6ace8a6 -q 2>/dev/null
python2 setup.py install -q 2>&1 | tail -1
python2 - << 'PY'
import serpent, binascii
code = serpent.compile(open('/work/AugurCrowdsale.se').read())
h = binascii.hexlify(code)
b = bytearray.fromhex(h)
# Read CODECOPY size from init section (PUSH2 at bytes 31-33)
size = b[32]*256 + b[33]
offset = b[36]*256 + b[37]
rt = h[offset*2:(offset+size)*2]
onchain = open('/work/onchain-runtime.hex').read().strip()
if rt == onchain:
    print('EXACT MATCH: {} bytes'.format(size))
else:
    print('MISMATCH - compiled={} onchain={}'.format(size, len(onchain)//2))
PY
"
