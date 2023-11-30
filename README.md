# ☁️ 맞춤형 VMware ESXi ISO 빌드 스크립트

네트워크 드라이버, nvme 드라이버 및 USB nic 드라이버용 VMware Flings의 최종 버전을 ESXi 8, 7 및 6 ISO 이미지에 추가합니다.

### For ESXi 8.x ISO: [esxi8-nvme-usbnic.ps1](https://github.com/itiligent/ESXi-Custom-ISO/blob/main/esxi8-nvme-usbnic.ps1)

- 메뉴에서 특정 ESXi 8 버전을 선택하여 VMWare 커뮤니티 NVME 및 USB NIC 드라이버 + 최신 GhettoVCB 백업을 추가합니다.

### For Esxi 7.x ISO: [esxi7-nvme-nic-usbnic.ps1](https://github.com/itiligent/ESXi-Custom-ISO/blob/main/esxi7-nvme-nic-usbnic.ps1)

- 메뉴에서 특정 ESXi 7 버전을 선택하여 VMWare 커뮤니티 NVME, NIC 및 USB NIC 드라이버 + 최신 GhettoVCB 백업을 추가합니다.

### For ESXi 6.7 ISO (Zimaboard compatible): [esxi6.7-nvme-usbnic-zimanic.ps1](https://raw.githubusercontent.com/itiligent/ESXi-Custom-ISO/main/esxi6.7-nvme-usbnic-zimanic.ps1)

- Zimaboard의 Realtek 1GbE NIC 드라이버, VMware 커뮤니티 NVME 및 USB NIC 드라이버 + 최신 GhettoVCB 백업으로 최신 ESXi 6.7을 빌드합니다.
- Esxi 6.7을 Zimaboard와 함께 사용하는 경우, ESXi NIC 및 물리적 스위치의 전이중 성능이 훨씬 빨라질 수 있습니다.

<p align="center">
  <img src="https://github.com/itiligent/ESXi-Custom-ISO/blob/main/esxi-zimaboard-screenshot.PNG" alt="Screeshot">
</p>

- ESXi 6.7용 Zimaboard의 옵션인 RTL 8125 2.5GbE NIC 드라이버는 [여기](https://github.com/itiligent/ESXi-Custom-ISO/raw/main/6.7-drivers/net-r8125-9.011.00-10.vib)에서 확인할 수 있습니다.
  - 수동으로 설치하려면:`esxcli software vib install -v net-r8125-9.011.00-10.vib`
  - 수동으로 제거하려면: `esxcli software vib remove -n net-r8125`

### 🛠️ ESXi ISO 구축을 위한 사전 요구 사항:

VMWare의 PowerCLI에는 Python이 필요하지만 사용 가능한 Python 버전이 많기 때문에 PowerCLI에서 많은 불일치 및 버그가 나타날 수 있습니다.

1. _specifically_ Python 3.7.9 을 설치하세요 [from here](https://www.python.org/downloads/release/python-379/) (Install with "Add Python to PATH" checked and at the end of the install wizard select "override path length limit"). 옵션 체크하시고요.
2. VMware의 PowerCLI 툴 설치:
   ```
   Install-Module VMware.PowerCLI -AllowClobber
   ```
3. Python PIP 업그레이드:
   ```
   C:\Users\%username%\AppData\Local\Programs\Python\Python37\python.exe -m pip install --upgrade pip
   ```
4. Python 종속성 추가:

   ```
   C:\Users\%username%\AppData\Local\Programs\Python\Python37\Scripts\pip3.7.exe install six psutil lxml pyopenssl
   ```

5. python.exe 경로 설정:

   ```
   Set-PowerCLIConfiguration -PythonPath C:\Users\ino\AppData\Local\Programs\Python\Python37\python.exe
   ```

6. 원하는 스크립트를 실행하여 ISO 빌드를 시작하세요. 🚀

Note: 2023년 10월 Broadcom이 VMWare를 인수한 후, VMware Flings 커뮤니티 다운로드 사이트는 오프라인 상태가 되었으며 그 미래는 불확실합니다. 사이트가 폐쇄되기 직전에 최신 드라이버가 이 리포지토리에 저장되었습니다. 이제 전체 flings.vmware.com 사이트의 사본은 https://archive.org/details/flings.vmware.com 에서 확인할 수 있습니다.
