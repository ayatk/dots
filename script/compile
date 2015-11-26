#!/bin/sh
set -e

DIR=$(cd $(dirname ${0})/.. && pwd)
cd ${DIR}

# Run Compile
XC_OS=${XC_OS:-darwin linux windows}

COMMIT=`git describe --always`

rm -rf pkg/
gox \
  -ldflags "-X main.GitCommit \"${COMMIT}\"" \
  -os="${XC_OS}" \
  -output "pkg/{{.OS}}_{{.Arch}}/{{.Dir}}"
