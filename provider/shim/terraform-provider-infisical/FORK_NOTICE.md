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
