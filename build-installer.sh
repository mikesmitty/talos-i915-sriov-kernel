#!/usr/bin/env bash

USERNAME=${USERNAME:-mikesmitty}
VERSION=$1
EXTENSIONS=${2:-i915}

if [ -z "$VERSION" ]; then
  echo "Usage: $0 <talos-version> [ extensions,comma,separated ] [ --extra-kernel-args='arg1 arg2' ]"
  echo "Example: $0 v1.11.0"
  exit 1
fi

# Check if the crane command is available
if ! command -v crane &> /dev/null; then
    echo "crane could not be found, please install it first."
    exit 1
fi

# FIXME
# crane export ghcr.io/${USERNAME}/extensions:${VERSION} | tar x -O image-digests | grep -E "$(sed 's/,/|/g' <<< "${EXTENSIONS}")" > extensions.txt

docker run --rm -t -v $PWD/_out:/out ghcr.io/${USERNAME}/imager:${VERSION} installer --platform=metal \
  --system-extension-image ghcr.io/mikesmitty/i915:20250917-v1.11.2 \
  --system-extension-image ghcr.io/mikesmitty/qemu-guest-agent:10.0.2 \
  "${@:3}"