#!/bin/bash

set -e

VERSION="$1"
SHOULD_RESTORE_MODINFO=false
SHOULD_DELETE_TAG=false

if ! [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+(-b[0-9]+)?$ ]]; then
    echo 'Invalid version "'"${VERSION}"'"! Use 1.2.3 or 1.2.3-b4 for betas.'
    exit 1
fi

TMPDIR="$(mktemp -d)"

cleanup_tmp() {
    if $SHOULD_RESTORE_MODINFO; then
        cp "${TMPDIR}/modinfo.lua.bak" dist/modinfo.lua
    fi

    rm -rf "$TMPDIR"

    if $SHOULD_DELETE_TAG; then
        git tag -d "v${VERSION}"
    fi
}
trap cleanup_tmp EXIT

cat > "${TMPDIR}/annotation" << EOF
v${VERSION}

EDIT THIS CHANGELOG!!!
EOF

git tag -a -F "${TMPDIR}/annotation" -e "v${VERSION}"
SHOULD_DELETE_TAG=true

git show -s "v${VERSION}"

echo
echo -n 'Does this look good? (Press Ctrl-C to abort) '
read

git push --tags
SHOULD_DELETE_TAG=false

is_beta() {
    [[ $VERSION =~ b ]]
}

cp dist/modinfo.lua "${TMPDIR}/modinfo.lua.bak"
SHOULD_RESTORE_MODINFO=true

if is_beta; then
    sed -i '/^name = /c\name = "Boss Attack Predictor (Beta)"' dist/modinfo.lua
fi
sed -i '/^version = /c\version = "'"$VERSION"'"' dist/modinfo.lua

if is_beta; then
    PUBLISHEDFILEID=3244008418
else
    PUBLISHEDFILEID=2510473186
fi

git for-each-ref refs/tags/"v${VERSION}" --format='%(contents)' > "${TMPDIR}/annotation"

build/dst-workshop-tool "$PUBLISHEDFILEID" "$(realpath dist)" "$(< "${TMPDIR}/annotation")" interface utility tweak all_clients_require_mod "version:${VERSION}"
