# Git History Cleanup Guide - Removing Exposed Secrets

## 🚨 Current Situation
GitGuardian detected a **Base64 Encoded RSA Private Key** exposed in your repository:
- **Repository**: JyotiDixit172/terraform-drift-detect-tool
- **File**: `tf-kubernetes/scripts/kind_binary/drift-demo-config`
- **Pushed date**: January 28th, 2026, 20:51:11 UTC

## ✅ Steps Completed
1. ✓ Secret has been revoked
2. ✓ .gitignore files updated to prevent future exposure

## 🔧 Next Steps: Clean Git History

### Why This Matters
Even after revoking the secret and adding it to .gitignore, the secret **still exists in your git history**. Anyone who has cloned or forked your repository can access previous commits and extract the exposed keys. You must rewrite git history to completely remove the secret.

---

## Option 1: Using BFG Repo-Cleaner (RECOMMENDED - Fastest & Easiest)

BFG is specifically designed for removing sensitive data from git history.

### Step 1: Install BFG
```powershell
# Download BFG from https://rtyley.github.io/bfg-repo-cleaner/
# Or use Chocolatey:
choco install bfg-repo-cleaner
```

### Step 2: Create a backup
```powershell
cd "c:\Users\jyotidix\OneDrive - AMDOCS\Desktop\terraform-drift-tool"
# Create a complete backup
xcopy /E /I terraform-drift-detect-tool terraform-drift-detect-tool-backup
```

### Step 3: Remove the sensitive file from history
```powershell
cd terraform-drift-detect-tool

# Remove the specific file containing secrets
bfg --delete-files drift-demo-config

# Alternative: Remove all files matching pattern
bfg --delete-files "*-config"

# Or remove specific text patterns (the actual keys)
# Create a file passwords.txt with the exposed keys and run:
# bfg --replace-text passwords.txt
```

### Step 4: Clean up the repository
```powershell
git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

### Step 5: Force push to GitHub
```powershell
git push origin --force --all
git push origin --force --tags
```

---

## Option 2: Using git filter-repo (Modern Alternative)

### Step 1: Install git filter-repo
```powershell
pip install git-filter-repo
```

### Step 2: Create a backup
```powershell
cd "c:\Users\jyotidix\OneDrive - AMDOCS\Desktop\terraform-drift-tool"
xcopy /E /I terraform-drift-detect-tool terraform-drift-detect-tool-backup
```

### Step 3: Remove sensitive files
```powershell
cd terraform-drift-detect-tool

# Remove specific file from all history
git filter-repo --path tf-kind/drift-demo-config --invert-paths

# Or remove multiple patterns
git filter-repo --path-glob '**/*-config' --invert-paths
git filter-repo --path-glob '**/*.tfstate' --invert-paths
```

### Step 4: Force push
```powershell
# Re-add the remote (filter-repo removes it for safety)
git remote add origin https://github.com/JyotiDixit172/terraform-drift-detect-tool.git

git push origin --force --all
git push origin --force --tags
```

---

## Option 3: Using git filter-branch (Traditional Method - Slower)

### ⚠️ Warning: This method is deprecated but still works

```powershell
cd "c:\Users\jyotidix\OneDrive - AMDOCS\Desktop\terraform-drift-tool\terraform-drift-detect-tool"

# Remove specific file from all commits
git filter-branch --force --index-filter `
  "git rm --cached --ignore-unmatch tf-kind/drift-demo-config" `
  --prune-empty --tag-name-filter cat -- --all

# Clean up
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Force push
git push origin --force --all
git push origin --force --tags
```

---

## 📋 Post-Cleanup Checklist

After rewriting history, you MUST:

### 1. Verify the Secret is Removed
```powershell
# Search entire history for the exposed key
git log --all --full-history --source --pretty=format:'%H' -- '*drift-demo-config*'

# If empty output = success!
```

### 2. Notify Collaborators
⚠️ **CRITICAL**: Anyone who has cloned your repository needs to:
```powershell
# Delete their local copy
cd ..
rm -rf terraform-drift-detect-tool

# Re-clone fresh copy
git clone https://github.com/JyotiDixit172/terraform-drift-detect-tool.git
```

**DO NOT** have them pull/merge - they must delete and re-clone!

### 3. Remove Cached Files from GitHub
GitHub may cache old commits. After force pushing:
- Go to: https://github.com/JyotiDixit172/terraform-drift-detect-tool/settings
- Contact GitHub Support to clear cached views if needed
- Or use GitGuardian's "remove evidence" feature

### 4. Verify .gitignore is Working
```powershell
# This should show nothing (files are ignored)
git status

# Test adding the file - should be ignored
echo "test" > tf-kind/drift-demo-config
git status  # Should not show the file
```

### 5. Rotate All Related Credentials
Even after cleaning history, rotate:
- ✓ The exposed RSA key (already done)
- [ ] Any Kubernetes cluster certificates
- [ ] Azure credentials in terraform.tfstate files
- [ ] Any other secrets that might have been in those commits

---

## 🛡️ Sensitive Files Now Protected

Your updated .gitignore files now exclude:

### Terraform Files
- `*.tfstate` - Contains cloud credentials, passwords, etc.
- `*.tfstate.backup`
- `*.tfplan` - May contain sensitive variables
- `.terraform/` - Provider binaries

### Kubernetes Files
- `*-config` files (like drift-demo-config)
- `*kubeconfig*`
- Certificate and key files

### Secrets & Credentials
- `*.pem`, `*.key`, `*.pub` - SSH/RSA keys
- `*.env`, `.env.*` - Environment files
- `*.tfvars` - Terraform variable files
- `*credential*`, `*secret*` - Any credential files

---

## 🚀 Recommended Approach for Your Repo

Based on your folder structure, I recommend:

```powershell
# 1. Backup
cd "c:\Users\jyotidix\OneDrive - AMDOCS\Desktop\terraform-drift-tool"
xcopy /E /I terraform-drift-detect-tool terraform-drift-detect-tool-backup

# 2. Enter repo
cd terraform-drift-detect-tool

# 3. Remove ALL sensitive files from history (using git filter-repo)
pip install git-filter-repo

git filter-repo --path tf-kind/drift-demo-config --invert-paths
git filter-repo --path-glob '**/*.tfstate' --invert-paths  
git filter-repo --path-glob '**/*.tfstate.*' --invert-paths

# 4. Re-add remote and force push
git remote add origin https://github.com/JyotiDixit172/terraform-drift-detect-tool.git
git push origin --force --all
git push origin --force --tags

# 5. Verify
git log --all --oneline | head -20
```

---

## ⚠️ Important Warnings

1. **Force pushing rewrites history** - Anyone with a clone must re-clone
2. **This is destructive** - Always backup first
3. **Pull requests may break** - Open PRs will need to be recreated
4. **Forks will still have the data** - Contact fork owners or file DMCA
5. **Already cloned?** - The secret is already exposed; rotation was essential

---

## 📚 Additional Resources

- [GitGuardian - Rewriting Git History](https://blog.gitguardian.com/rewriting-git-history-cheatsheet/)
- [BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/)
- [git-filter-repo](https://github.com/newren/git-filter-repo)
- [GitHub - Removing Sensitive Data](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)

---

## Need Help?

If you encounter issues:
1. Check the backup is complete
2. Try the BFG method (simplest)
3. Reach out to GitGuardian support
4. GitHub support can help clear caches
