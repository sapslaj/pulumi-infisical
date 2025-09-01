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
