# diggibyte-iam-gitops

GitOps-driven Identity and Access Management (IAM) for multi-cloud environments.

This repository implements **Access as Code** using GitHub Pull Requests as the
single approval mechanism for granting and revoking cloud access across:

- Azure (Microsoft Entra ID + RBAC)
- AWS (IAM / IAM Identity Center)
- GCP (Cloud IAM)

All access changes are:
- Reviewable
- Auditable
- Reversible
- Automated

---

## 🎯 Why This Repository Exists

Manual IAM changes do not scale and are difficult to audit.

This project enforces:
- Least privilege
- Separation of duties
- Approval-based access
- Infrastructure-as-Code for identity

**If it is not approved in GitHub, it does not exist in the cloud.**

---

## 🧠 Core Principles

- GitHub is the **source of truth**
- Access is granted to **groups, not individuals**
- All changes require **Pull Request approval**
- Automation applies changes consistently across clouds
- Rollback is done by reverting a commit

---

## 🏗️ Architecture Overview

User → Pull Request → Review → Merge  
→ GitHub Actions → Terraform  
→ Cloud IAM (Azure / AWS / GCP)

---

## 📁 Repository Structure

diggibyte-iam-gitops/
├── config/ # User and access definitions
│ ├── azure-users.yaml
│ ├── aws-users.yaml
│ └── gcp-users.yaml
│
├── terraform/
│ ├── azure/ # Azure AD + RBAC
│ ├── aws/ # AWS IAM / Identity Center
│ └── gcp/ # GCP IAM
│
├── .github/
│ └── workflows/
│ └── apply-access.yml
│
└── README.md


---

## 🧩 How Access Is Requested

1. User edits the relevant config file (example: `config/azure-users.yaml`)
2. User creates a Pull Request
3. Reviewers approve the change
4. PR is merged
5. Automation applies IAM changes
6. Access is granted in the cloud

No direct IAM changes are allowed outside this process.

---

## 🔐 Security & Governance

- Access is group-based
- No long-lived secrets in pipelines
- OIDC is used for cloud authentication
- Full audit trail via GitHub history and cloud logs
- Drift detection via Terraform plan

---

## 🛣️ Roadmap

- [ ] Azure IAM GitOps (Phase 1)
- [ ] AWS IAM / Identity Center
- [ ] GCP IAM
- [ ] Time-bound access (auto-expiry)
- [ ] Access review automation

---

## ⚠️ Important Rules

- Never grant access directly in the cloud portal
- Never add users directly to groups manually
- All access changes must go through Pull Requests
- Reverting a PR revokes access
