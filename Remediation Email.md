**Subject:** Vulnerability Remediation Scripts for Testing and Deployment

Hi Luca,

Based on our initial vulnerability scan and assessment, we have created a set of scripts to assist with the first wave of remediation efforts. These scripts address critical findings and can be deployed using your standard configuration management tools (e.g., SCCM, Intune, or Ansible).  

Please ensure all scripts are tested in a controlled environment prior to production deployment.

### Vulnerabilities and Remediations:
1. [**Third-Party Software Removal (Wireshark)**](https://github.com/DannyInTheShell/Cybersecurity-Projects/blob/main/remediation-wireshark-uninstall.ps1)
2. [**Windows OS Secure Configuration (Insecure Protocols)**](https://github.com/joshmadakor1/lognpacific-public/blob/main/automation/toggle-protocols.ps1)
3. [**Windows OS Secure Configuration (Insecure Ciphersuites)**](https://github.com/joshmadakor1/lognpacific-public/blob/main/automation/toggle-cipher-suites.ps1)
4. [**Windows OS Secure Configuration (Guest Account Group Membership)**](https://github.com/joshmadakor1/lognpacific-public/blob/main/automation/toggle-guest-local-administrators.ps1)
5. [**CVE-2013-3900 (Enable certificate padding check)**](https://github.com/DannyInTheShell/Cybersecurity-Projects/blob/main/remediation-cve-2013-3900.ps1)
6. [**ICMP Timestamp (Filter ICMP timestamp requests/replies)**]()

Please review and provide feedback once testing is complete. Let me know if any adjustments or additional scripts are needed.

Best regards,

Danny Cologero<br/>
Threat and Vulnerability Management Analyst<br/>
Governance, Risk, and Compliance
