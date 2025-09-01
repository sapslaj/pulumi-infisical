#!/bin/bash
set -euo pipefail

# Configuration
UPSTREAM_REPO="https://github.com/Infisical/terraform-provider-infisical.git"
UPSTREAM_VERSION="${1:-v0.15.32}"
FORK_DIR="terraform-provider-infisical"

echo "🔄 Updating terraform-provider-infisical fork to ${UPSTREAM_VERSION}"

# Clean up existing fork
if [ -d "$FORK_DIR" ]; then
    echo "🧹 Cleaning up existing fork directory"
    rm -rf "$FORK_DIR"
fi

# Clone the upstream repository
echo "📥 Cloning upstream repository"
git clone --depth 1 --branch "$UPSTREAM_VERSION" "$UPSTREAM_REPO" "$FORK_DIR"

# Enter the fork directory
cd "$FORK_DIR"

echo "🔧 Applying patches to expose internal provider"

# Create public provider wrapper
cat > provider.go << 'EOF'
// Package infisical provides a public API wrapper around the internal terraform-provider-infisical.
// This file exposes the internal provider functionality for use in external projects.
package infisical

import (
	"github.com/hashicorp/terraform-plugin-framework/provider"
	internalprovider "github.com/infisical/terraform-provider-infisical/internal/provider"
)

// NewProvider creates a new instance of the Infisical provider.
// This function wraps the internal provider and makes it accessible from external packages.
func NewProvider(version string) func() provider.Provider {
	return internalprovider.New(version)
}
EOF

# Update go.mod to expose the provider as a library
echo "📝 Updating go.mod"
sed -i '1s/.*/module github.com\/infisical\/terraform-provider-infisical/' go.mod

# Remove main.go to make this a library instead of a program
echo "🗑️  Removing main.go to convert to library"
rm -f main.go

# Fix internal imports by replacing module paths throughout the codebase
echo "🔧 Fixing internal imports throughout codebase"
find . -name "*.go" -type f -exec sed -i 's|"terraform-provider-infisical/|"github.com/infisical/terraform-provider-infisical/|g' {} \;

# Add a note about this being a patched version
cat > FORK_NOTICE.md << 'EOF'
# Fork Notice

This is a patched version of the original terraform-provider-infisical that exposes
the internal provider functionality through a public API.

## Changes Made

1. Added `provider.go` with `NewProvider()` function that wraps `internal/provider.New()`
2. Modified go.mod module path to match the canonical name

## Original Repository

https://github.com/Infisical/terraform-provider-infisical

## Purpose

This fork exists solely to work around Go's internal package restrictions when
bridging this provider to Pulumi. All provider functionality remains unchanged.
EOF

echo "✅ Fork updated successfully!"
echo "📁 Fork location: $(pwd)"
echo "🏷️  Version: $UPSTREAM_VERSION"