#!/bin/sh

docker run -i --rm -v $(pwd)/vale.sh/styles:/styles --rm -v $(pwd):/docs -w /docs jdkato/vale content/
