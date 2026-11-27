package tests

import (
	"fmt"
	"testing"

	"github.com/hashicorp/terraform-plugin-testing/helper/resource"
)

func TestAccVolumeResource(t *testing.T) {
	resource.Test(t, resource.TestCase{
		PreCheck:                 func() { testAccPreCheck(t) },
		ProtoV6ProviderFactories: testAccProtoV6ProviderFactories,
		Steps: []resource.TestStep{
			// Create and Read testing
			{
				Config: testAccVolumeResourceConfig("test-volume", 50),
				Check: resource.ComposeAggregateTestCheckFunc(
					resource.TestCheckResourceAttr("airtelcloudgcc_volume.test", "name", "test-volume"),
					resource.TestCheckResourceAttr("airtelcloudgcc_volume.test", "size", "50"),
					resource.TestCheckResourceAttrSet("airtelcloudgcc_volume.test", "id"),
					resource.TestCheckResourceAttrSet("airtelcloudgcc_volume.test", "status"),
					resource.TestCheckResourceAttrSet("airtelcloudgcc_volume.test", "provider_volume_id"),
				),
			},
			// ImportState testing
			{
				ResourceName:      "airtelcloudgcc_volume.test",
				ImportState:       true,
				ImportStateVerify: true,
			},
			// Update and Read testing (increase size)
			{
				Config: testAccVolumeResourceConfig("test-volume-updated", 100),
				Check: resource.ComposeAggregateTestCheckFunc(
					resource.TestCheckResourceAttr("airtelcloudgcc_volume.test", "name", "test-volume-updated"),
					resource.TestCheckResourceAttr("airtelcloudgcc_volume.test", "size", "100"),
				),
			},
			// Delete testing automatically occurs in TestCase
		},
	})
}

func testAccVolumeResourceConfig(name string, size int) string {
	return fmt.Sprintf(`
resource "airtelcloudgcc_volume" "test" {
  name              = %[1]q
  size              = %[2]d
  availability_zone = "S1"
  type              = "Standard Performance"
  vpc_name          = "test-vpc"
  subnet_name       = "test-subnet"
}
`, name, size)
}

func TestAccVolumeResourceFull(t *testing.T) {
	resource.Test(t, resource.TestCase{
		PreCheck:                 func() { testAccPreCheck(t) },
		ProtoV6ProviderFactories: testAccProtoV6ProviderFactories,
		Steps: []resource.TestStep{
			{
				Config: testAccVolumeResourceFullConfig(),
				Check: resource.ComposeAggregateTestCheckFunc(
					resource.TestCheckResourceAttr("airtelcloudgcc_volume.test", "name", "test-full-volume"),
					resource.TestCheckResourceAttr("airtelcloudgcc_volume.test", "size", "50"),
					resource.TestCheckResourceAttr("airtelcloudgcc_volume.test", "availability_zone", "S1"),
					resource.TestCheckResourceAttr("airtelcloudgcc_volume.test", "is_encrypted", "true"),
					resource.TestCheckResourceAttr("airtelcloudgcc_volume.test", "bootable", "false"),
					resource.TestCheckResourceAttr("airtelcloudgcc_volume.test", "enable_backup", "false"),
					resource.TestCheckResourceAttrSet("airtelcloudgcc_volume.test", "id"),
					resource.TestCheckResourceAttrSet("airtelcloudgcc_volume.test", "status"),
					resource.TestCheckResourceAttrSet("airtelcloudgcc_volume.test", "provider_volume_id"),
				),
			},
			// ImportState testing
			{
				ResourceName:      "airtelcloudgcc_volume.test",
				ImportState:       true,
				ImportStateVerify: true,
				ImportStateVerifyIgnore: []string{
					"compute_name",
					"vpc_name",
					"subnet_name",
				},
			},
		},
	})
}

func testAccVolumeResourceFullConfig() string {
	return `
resource "airtelcloudgcc_vpc" "test" {
  name       = "test-vpc"
  cidr_block = "10.0.0.0/16"
}

resource "airtelcloudgcc_subnet" "test" {
  name              = "test-subnet"
  vpc_id            = airtelcloudgcc_vpc.test.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "S1"
}

resource "airtelcloudgcc_volume" "test" {
  name              = "test-full-volume"
  size              = 50
  availability_zone = "S1"
  type              = "Standard Performance"
  vpc_name          = airtelcloudgcc_vpc.test.name
  subnet_name       = airtelcloudgcc_subnet.test.name
  is_encrypted      = true
  bootable          = false
  enable_backup     = false
}
`
}

func TestAccVolumeResourceWithAttachment(t *testing.T) {
	resource.Test(t, resource.TestCase{
		PreCheck:                 func() { testAccPreCheck(t) },
		ProtoV6ProviderFactories: testAccProtoV6ProviderFactories,
		Steps: []resource.TestStep{
			// Create volume and VM, then test attachment
			{
				Config: testAccVolumeWithComputeConfig(),
				Check: resource.ComposeAggregateTestCheckFunc(
					resource.TestCheckResourceAttr("airtelcloudgcc_volume.test", "name", "test-attached-volume"),
					resource.TestCheckResourceAttr("airtelcloudgcc_vm.test", "instance_name", "test-compute-for-volume"),
					resource.TestCheckResourceAttrSet("airtelcloudgcc_volume.test", "id"),
					resource.TestCheckResourceAttrSet("airtelcloudgcc_vm.test", "id"),
				),
			},
		},
	})
}

func testAccVolumeWithComputeConfig() string {
	return `
# Create dependencies for compute instance
resource "airtelcloudgcc_vpc" "test" {
  name       = "test-vpc"
  cidr_block = "10.0.0.0/16"
}

resource "airtelcloudgcc_subnet" "test" {
  name              = "test-subnet"
  vpc_id            = airtelcloudgcc_vpc.test.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "south-1a"
}

# Create compute instance
resource "airtelcloudgcc_vm" "test" {
  instance_name    = "test-compute-for-volume"
  compute_type     = "t2.micro"
  image_id         = "ubuntu-20.04"
  network_id       = airtelcloudgcc_vpc.test.id
  subnet_id        = airtelcloudgcc_subnet.test.id
  disk_size        = 20
}

# Create volume attached to compute
resource "airtelcloudgcc_volume" "test" {
  name              = "test-attached-volume"
  size              = 10
  availability_zone = "S1"
  type              = "Standard Performance"
  vpc_name          = airtelcloudgcc_vpc.test.name
  subnet_name       = airtelcloudgcc_subnet.test.name
  compute_name      = airtelcloudgcc_vm.test.instance_name
  is_encrypted      = true
}
`
}
