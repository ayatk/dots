#!/bin/sh
set -e

DIR=$(cd $(dirname ${0})/.. && pwd)
cd ${DIR}

VERSION=$(grep "const Version " version.go | sed -E 's/.*"(.+)"$/\1/')
REPO="dots"

# Run Compile
XC_OS=${XC_OS:-darwin linux windows}

COMMIT=`git describe --always`

rm -rf pkg/
gox \
  -ldflags "-X main.GitCommit \"${COMMIT}\"" \
  -os="${XC_OS}" \
  -output "pkg/{{.OS}}_{{.Arch}}/{{.Dir}}"

if [ -d pkg ];then
  rm -rf ./pkg/dist
fi

# Package all binary as .zip
mkdir -p ./pkg/dist/${VERSION}
for PLATFORM in $(find ./pkg -mindepth 1 -maxdepth 1 -type d); do
  PLATFORM_NAME=$(basename ${PLATFORM})
  ARCHIVE_NAME=${REPO}_${PLATFORM_NAME}_${VERSION}
  if [ $PLATFORM_NAME = "dist" ]; then
    continue
  fi

  pushd ${PLATFORM}
  zip ${DIR}/pkg/dist/${VERSION}/${ARCHIVE_NAME}.zip ./*
  popd
done

# Generate shasum
pushd ./pkg/dist/${VERSION}
shasum * > ./${VERSION}_SHASUMS
popd
