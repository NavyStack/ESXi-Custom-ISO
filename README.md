# ☁️ Custom VMware ESXi ISO build scripts

Add final versions of VMware Flings for network drivers, nvme drivers & usb nic drivers to ESXi 8, 7 & 6 ISO images.

### For ESXi 8.x ISO: [esxi8-nvme-usbnic.ps1](https://github.com/itiligent/ESXi-Custom-ISO/blob/main/esxi8-nvme-usbnic.ps1) 
- Choose a specific ESXi 8 version from the menu to add VMWare Community NVME & USB NIC drivers + latest GhettoVCB backup.

### For Esxi 7.x ISO: [esxi7-nvme-nic-usbnic.ps1](https://github.com/itiligent/ESXi-Custom-ISO/blob/main/esxi7-nvme-nic-usbnic.ps1)
- Choose a specific ESXi 7 version from the menu to add VMWare Community NVME, NIC & USB NIC driver + latest GhettoVCB backup.

### For ESXi 6.7 ISO (Zimaboard compatible): [esxi6.7-nvme-usbnic-zimanic.ps1](https://raw.githubusercontent.com/itiligent/ESXi-Custom-ISO/main/esxi6.7-nvme-usbnic-zimanic.ps1)
- Builds latest ESXi 6.7 with Zimaboard's Realtek 1GbE NIC driver, VMware Community NVME & USB NIC drivers + latest GhettoVCB backup.
- If using Esxi 6.7 with Zimaboard, full duplex on ESXi NIC & physical switch may perform much faster.

<p align="center">
  <img src="https://github.com/itiligent/ESXi-Custom-ISO/blob/main/esxi-zimaboard-screenshot.PNG" alt="Screeshot">
</p>

- Zimaboard's optional RTL 8125 2.5GbE NIC driver for ESXi 6.7 can be found [here](https://github.com/itiligent/ESXi-Custom-ISO/raw/main/6.7-drivers/net-r8125-9.011.00-10.vib)
  - To manually install:`esxcli software vib install -v net-r8125-9.011.00-10.vib` 
  - To manually remove: `esxcli software vib remove -n net-r8125`
  

### 🛠️ Prerequisites for building ESXi ISOs:

VMWare's PowerCLI requires Python, but due to the large number of Python versions available, many inconsistencies and bugs with PowerCLI can surface. Stick to what works...

1. Install *specifically* Python 3.7.9 [from here](https://www.python.org/downloads/release/python-379/) (Install with "Add Python to PATH" checked and at the end of the install wizard select "override path length limit").
2. Install VMware's PowerCLI tool:
   ```
   Install-Module VMware.PowerCLI
   ```
3. Upgrade Python PIP:
   ```
   C:\Users\%username%\AppData\Local\Programs\Python\Python37\python.exe -m pip install --upgrade pip
   ```
4. Add extra Python dependencies:
   ```
   C:\Users\%username%\AppData\Local\Programs\Python\Python37\Scripts\pip3.7.exe install six psutil lxml pyopenssl
   ```

5. Set the python.exe path:
   ```
   Set-PowerCLIConfiguration -PythonPath C:\Users\%username%\AppData\Local\Programs\Python\Python37\python.exe
   ```

6. Run the desired script to start building your ISO 🚀

Note: After Broadcom's acquisition of VMWare in October 2023, the VMware Flings community download site has been taken offline and its future is uncertain. The latest driver vibs were saved to this repo just before the site was closed down. A copy of the entire flings.vmware.com site now can be found at https://archive.org/details/flings.vmware.com.
