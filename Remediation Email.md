**Subject:** Vulnerability Remediation Scripts for Testing and Deployment

**Hi [Team],**

Based on our initial vulnerability scan and assessment, we have created a set of scripts to assist with the first wave of remediation efforts. These scripts address critical findings and can be deployed using your standard configuration management tools (e.g., SCCM, Intune, or Ansible).  

Please ensure all scripts are tested in a controlled environment prior to production deployment.

### Vulnerabilities and Remediations:
1. [**Third-Party Software Removal (Wireshark)**](https://github.com/DannyInTheShell/Cybersecurity-Projects/blob/main/remediation-wireshark-uninstall.ps1)
2. [**Windows OS Secure Configuration (Insecure Protocols)**](https://github.com/joshmadakor1/lognpacific-public/blob/main/automation/toggle-protocols.ps1)
3. [**Windows OS Secure Configuration (Insecure Ciphersuites)**](https://github.com/joshmadakor1/lognpacific-public/blob/main/automation/toggle-cipher-suites.ps1)
4. [**Windows OS Secure Configuration (Guest Account Group Membership)**](https://github.com/joshmadakor1/lognpacific-public/blob/main/automation/toggle-guest-local-administrators.ps1)
5. [**CVE-2013-3900 (Enable certificate padding check)**]()
6. [**ICMP Timestamp (Filter ICMP timestamp requests/replies)**]()

Let me know if you have any questions or need any adjustments!

Best regards,

**[Your Name], Security Analyst**<br/>
**Governance, Risk, and Compliance**
