package shim

import (
	"github.com/hashicorp/terraform-plugin-framework/provider"
	infisical "github.com/infisical/terraform-provider-infisical"
)

// Provider returns the Infisical provider instance.
func Provider() provider.Provider {
	return infisical.NewProvider("dev")()
}