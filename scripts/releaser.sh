GOOS=darwin GOARCH=arm64 go build -o terraform-provider-airtelcloudgcc
zip ../build/terraform-provider-airtelcloudgcc_$1_darwin_arm64.zip terraform-provider-airtelcloudgcc

GOOS=darwin GOARCH=amd64 go build -o terraform-provider-airtelcloudgcc
zip ../build/terraform-provider-airtelcloudgcc_$1_darwin_amd64.zip terraform-provider-airtelcloudgcc

GOOS=freebsd GOARCH=386 go build -o terraform-provider-airtelcloudgcc
zip ../build/terraform-provider-airtelcloudgcc_$1_freebsd_386.zip terraform-provider-airtelcloudgcc

GOOS=freebsd GOARCH=amd64 go build -o terraform-provider-airtelcloudgcc
zip ../build/terraform-provider-airtelcloudgcc_$1_freebsd_amd64.zip terraform-provider-airtelcloudgcc


GOOS=freebsd GOARCH=arm go build -o terraform-provider-airtelcloudgcc
zip ../build/terraform-provider-airtelcloudgcc_$1_freebsd_arm.zip terraform-provider-airtelcloudgcc

GOOS=linux GOARCH=386 go build -o terraform-provider-airtelcloudgcc
zip ../build/terraform-provider-airtelcloudgcc_$1_linux_386.zip terraform-provider-airtelcloudgcc

GOOS=linux GOARCH=amd64 go build -o terraform-provider-airtelcloudgcc
zip ../build/terraform-provider-airtelcloudgcc_$1_linux_amd64.zip terraform-provider-airtelcloudgcc

GOOS=linux GOARCH=arm go build -o terraform-provider-airtelcloudgcc
zip ../build/terraform-provider-airtelcloudgcc_$1_linux_arm.zip terraform-provider-airtelcloudgcc

GOOS=openbsd GOARCH=386 go build -o terraform-provider-airtelcloudgcc
zip ../build/terraform-provider-airtelcloudgcc_$1_openbsd_386.zip terraform-provider-airtelcloudgcc

GOOS=openbsd GOARCH=amd64 go build -o terraform-provider-airtelcloudgcc
zip ../build/terraform-provider-airtelcloudgcc_$1_openbsd_amd64.zip terraform-provider-airtelcloudgcc


GOOS=solaris GOARCH=amd64 go build -o terraform-provider-airtelcloudgcc
zip ../build/terraform-provider-airtelcloudgcc_$1_solaris_amd64.zip terraform-provider-airtelcloudgcc


GOOS=windows GOARCH=386 go build -o terraform-provider-airtelcloudgcc
zip ../build/terraform-provider-airtelcloudgcc_$1_windows_386.zip terraform-provider-airtelcloudgcc

GOOS=windows GOARCH=amd64 go build -o terraform-provider-airtelcloudgcc
zip ../build/terraform-provider-airtelcloudgcc_$1_windows_amd64.zip terraform-provider-airtelcloudgcc


cd ../build

shasum -a 256 *.zip > terraform-provider-airtelcloudgcc_$1_SHA256SUMS
gpg --detach-sign terraform-provider-airtelcloudgcc_$1_SHA256SUMS 