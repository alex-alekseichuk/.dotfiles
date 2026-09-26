#!/usr/bin/env bash

set -euo pipefail

usage() {
    echo "Usage: $0 <git-folder-url> [destination]"
    echo
    echo "Examples:"
    echo "  $0 https://github.com/larchanka/web-dev-remind/tree/master/Presentations/pdf"
    echo "  $0 https://github.com/larchanka/web-dev-remind/tree/master/Presentations/pdf my-pdfs"
    echo "  $0 https://github.com/larchanka/web-dev-remind"
    exit 1
}

[[ $# -lt 1 || $# -gt 2 ]] && usage

URL="$1"
DEST="${2:-}"

# Remove trailing slash.
URL="${URL%/}"

# Parse repository URL and sparse-checkout path.
#
# Supported forms:
#
#   https://github.com/user/repo
#   https://github.com/user/repo/tree/master/path/to/folder
#
#   https://gitlab.com/user/repo
#   https://gitlab.com/user/repo/-/tree/master/path/to/folder
#
if [[ "$URL" =~ ^(https?://[^/]+/[^/]+/[^/]+)(/tree/([^/]+)(/(.*))?)$ ]]; then
    REPO_URL="${BASH_REMATCH[1]}"
    BRANCH="${BASH_REMATCH[3]}"
    SPARSE_PATH="${BASH_REMATCH[5]}"

elif [[ "$URL" =~ ^(https?://[^/]+/[^/]+/[^/]+)(/-/tree/([^/]+)(/(.*))?)$ ]]; then
    REPO_URL="${BASH_REMATCH[1]}"
    BRANCH="${BASH_REMATCH[3]}"
    SPARSE_PATH="${BASH_REMATCH[5]}"

elif [[ "$URL" =~ ^https?://[^/]+/[^/]+/[^/]+$ ]]; then
    # Repository root.
    REPO_URL="$URL"
    BRANCH=""
    SPARSE_PATH=""

else
    echo "Error: unsupported Git repository URL:"
    echo "  $URL"
    exit 1
fi

# Derive destination name if it wasn't specified.
if [[ -z "$DEST" ]]; then
    if [[ -n "$SPARSE_PATH" ]]; then
        DEST="${SPARSE_PATH##*/}"
    else
        REPO_URL="${REPO_URL%/}"
        DEST="${REPO_URL##*/}"
        DEST="${DEST%.git}"
    fi
fi

# Prevent accidentally copying into an existing directory.
if [[ -e "$DEST" ]]; then
    echo "Error: destination already exists: $DEST"
    exit 1
fi

TMP_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TMP_DIR"
}

trap cleanup EXIT

echo "Repository : $REPO_URL"
[[ -n "$BRANCH" ]] && echo "Branch     : $BRANCH"
[[ -n "$SPARSE_PATH" ]] && echo "Path       : $SPARSE_PATH"
echo "Destination: $DEST"
echo

# Clone only Git metadata initially.
if [[ -n "$BRANCH" ]]; then
    git clone \
        --depth 1 \
        --filter=blob:none \
        --sparse \
        --branch "$BRANCH" \
        "$REPO_URL" \
        "$TMP_DIR/repo"
else
    git clone \
        --depth 1 \
        --filter=blob:none \
        --sparse \
        "$REPO_URL" \
        "$TMP_DIR/repo"
fi

cd "$TMP_DIR/repo"

if [[ -n "$SPARSE_PATH" ]]; then
    git sparse-checkout set "$SPARSE_PATH"

    mkdir "$OLDPWD/$DEST"
    cp -a "$SPARSE_PATH/." "$OLDPWD/$DEST/"
else
    # Repository root: sparse checkout the whole repository.
    git sparse-checkout disable

    mkdir "$OLDPWD/$DEST"
    cp -a . "$OLDPWD/$DEST/"
fi

echo
echo "Downloaded to: $DEST"
