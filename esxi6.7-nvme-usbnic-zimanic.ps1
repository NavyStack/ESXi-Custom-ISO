##############################################################################################
# ESXI 6.7 with community usb-nic/nvme drivers + Realtek 8125 (2.5GbE) & 1GbE 8111 (Zimaboard)
# David Harrop
# September 2023
##############################################################################################

# Note: After Broadcom's acquisition of VMWare in October 2023, the Community Drivers download site has been 
# taken down and its future is unclear. The script below now downloads the last available flings from this repo directly.
# A copy of the entire flings.vmware.com site can be found https://archive.org/details/flings.vmware.com.
# Realtek drivers have been copied to GitHub in case they disappear in future
# Originals can be verified at https://vibsdepot.v-front.de & https://github.com/mcr-ksh/r8125-esxi

# Set ESXi depot base version
$baseESXiVer = "6.7"

# Define NIC/USB/NVME driver links and file names
$git67Drv = "https://raw.githubusercontent.com/itiligent/ESXi-Custom-ISO/main/6.7-drivers/"
$usbFling = "ESXi670-VMKUSB-NIC-FLING-39203948-offline_bundle-16780994.zip"
$realtek8168 = "net55-r8168-8.045a-napi-offline_bundle.zip"
$intelnic = "net-igb-5.3.2-99-offline_bundle.zip"
$nvmeFling = "nvme-community-driver_1.0.1.0-1vmw.670.0.0.8169922-offline_bundle-17658145.zip"

# Define Ghetto VCB repo for latest release download via API
$releaseUrl = "https://api.github.com/repos/lamw/ghettoVCB/releases/latest"
$ghettoVCB = "vghetto-ghettoVCB-offline-bundle.zip"
$response = Invoke-RestMethod -Uri $releaseUrl
$ghettoDownloadUrl = $response.assets[0].browser_download_url

echo ""
echo "Retrieving latest ESXi $baseESXiVer bundle, this may take a while..."
echo ""

Add-EsxSoftwareDepot https://hostupdate.vmware.com/software/VUM/PRODUCTION/main/vmw-depot-index.xml
$imageProfile = (Get-EsxImageProfile -Name "ESXi-$baseESXiVer*-standard*" | Sort-Object -Descending -Property @{Expression={$_.Name.Substring(0,10)}},@{Expression={$_.CreationTime.Date}},Name | Select-Object -First 1).Name
if (!(Test-Path "$($imageProfile).zip")){Export-ESXImageProfile -ImageProfile $imageProfile -ExportToBundle -filepath "$($imageProfile).zip"}
Get-EsxSoftwareDepot | Remove-EsxSoftwareDepot

echo ""
echo "Finished retrieving latest ESXi $baseESXiVer bundle"
echo ""

if (!(Test-Path $nvmeFling)){Invoke-WebRequest -Method "GET" $git67Drv$($nvmeFling) -OutFile $($nvmeFling)}
if (!(Test-Path $usbFling)){Invoke-WebRequest -Method "GET" $git67Drv$($usbFling) -OutFile $($usbFling)}
if (!(Test-Path $realtek8168)){Invoke-WebRequest -Method "GET" $git67Drv$($realtek8168) -OutFile $($realtek8168)}
if (!(Test-Path $intelnic)){Invoke-WebRequest -Method "GET" $git67Drv$($intelnic) -OutFile $($intelnic)}
if (!(Test-Path $ghettoVCB)){Invoke-WebRequest -Uri $ghettoDownloadUrl -OutFile $($ghettoVCB)}

echo ""
echo "Adding extra packages to the local depot"
echo ""

Add-EsxSoftwareDepot "$($imageProfile).zip"
Add-EsxSoftwareDepot $nvmeFling
Add-EsxSoftwareDepot $usbFling
Add-EsxSoftwareDepot $realtek8168
Add-EsxSoftwareDepot $intelnic
Add-EsxSoftwareDepot $ghettoVCB

echo ""
echo "Creating a custom profile" 
echo ""

$newProfileName = $($imageProfile.Replace("standard", "nvme-usbnic-zimanic"))
$newProfile = New-EsxImageProfile -CloneProfile $imageProfile -name $newProfileName -Vendor "Itiligent"
Set-EsxImageProfile -ImageProfile $newProfile -AcceptanceLevel CommunitySupported

echo ""
echo "Injecting extra packages into the custom profile"
echo ""

Add-EsxSoftwarePackage -ImageProfile $newProfile -SoftwarePackage "nvme-community" -Force
Add-EsxSoftwarePackage -ImageProfile $newProfile -SoftwarePackage "vmkusb-nic-fling" -Force
Add-EsxSoftwarePackage -ImageProfile $newProfile -SoftwarePackage "net55-r8168" -Force
Add-EsxSoftwarePackage -ImageProfile $newProfile -SoftwarePackage "net-igb" -Force
Add-EsxSoftwarePackage -ImageProfile $newProfile -SoftwarePackage "ghettoVCB" -Force

echo ""
echo "Exporting the custom profile to an ISO..."
echo ""

Export-ESXImageProfile -ImageProfile $newProfile -ExportToIso -filepath "$newProfileName.iso" -Force
Get-EsxSoftwareDepot | Remove-EsxSoftwareDepot

echo ""
echo "Build complete!"
echo ""
