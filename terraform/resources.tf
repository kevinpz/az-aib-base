# Create the resource group
resource "azurerm_resource_group" "rg_image_builder" {
  name     = var.rg_name
  location = var.location
}

# Create the managed identity
resource "azurerm_user_assigned_identity" "user_id" {
  resource_group_name = azurerm_resource_group.rg_image_builder.name
  location            = azurerm_resource_group.rg_image_builder.location
  name                = var.id_name
}

# Create the custom role for AIB
resource "azurerm_role_definition" "builder" {
  name        = "Azure Image Builder Service Image Creation Role"
  scope       = azurerm_resource_group.rg_image_builder.id
  description = "Image Builder access to create resources for the image build."

  permissions {
    actions     = [
        "Microsoft.Compute/galleries/read",
        "Microsoft.Compute/galleries/images/read",
        "Microsoft.Compute/galleries/images/versions/read",
        "Microsoft.Compute/galleries/images/versions/write",

        "Microsoft.Compute/images/write",
        "Microsoft.Compute/images/read",
        "Microsoft.Compute/images/delete"
    ]
    not_actions = []
  }

  assignable_scopes = [
    azurerm_resource_group.rg_image_builder.id
  ]
}

# Assign the AIB role to the managed identity on the RG
resource "azurerm_role_assignment" "builder" {
  scope                = azurerm_resource_group.rg_image_builder.id
  role_definition_name = "Azure Image Builder Service Image Creation Role"
  principal_id         = azurerm_user_assigned_identity.user_id.principal_id
}

# Create the compute image galery
resource "azurerm_shared_image_gallery" "gallery" {
  name                = var.gallery_name
  resource_group_name = azurerm_resource_group.rg_image_builder.name
  location            = azurerm_resource_group.rg_image_builder.location
  description         = "Shared images and things."
}