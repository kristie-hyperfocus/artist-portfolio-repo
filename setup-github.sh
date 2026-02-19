#!/bin/bash
# ─────────────────────────────────────────────────────────────
# Artist Portfolio Studio — GitHub Setup Script
# Run this from inside the artist-portfolio-demo folder
# ─────────────────────────────────────────────────────────────

set -e

REPO_NAME="artist-portfolio-demo"
echo ""
echo "🎨  Artist Portfolio Studio — GitHub Deploy"
echo "────────────────────────────────────────────"

# 1. Check for gh CLI
if ! command -v gh &> /dev/null; then
  echo ""
  echo "  GitHub CLI (gh) not found."
  echo "  Install it from: https://cli.github.com"
  echo ""
  echo "  Then re-run this script, or create the repo manually:"
  echo "  1. Go to https://github.com/new"
  echo "  2. Name it: $REPO_NAME"
  echo "  3. Set it to Public"
  echo "  4. Do NOT add README, .gitignore, or license"
  echo "  5. Copy the repo URL and run:"
  echo "     git remote add origin YOUR_REPO_URL"
  echo "     git push -u origin main"
  echo ""
  exit 1
fi

# 2. Authenticate if needed
if ! gh auth status &> /dev/null; then
  echo ""
  echo "  Logging in to GitHub..."
  gh auth login
fi

# 3. Get username
GH_USER=$(gh api user --jq '.login')
echo ""
echo "  Logged in as: $GH_USER"

# 4. Create the public repo
echo ""
echo "  Creating GitHub repository: $GH_USER/$REPO_NAME"
gh repo create "$REPO_NAME" \
  --public \
  --description "Three example artist portfolio websites — Light & Airy, Dark & Dramatic, Warm & Earthy" \
  --source=. \
  --remote=origin \
  --push

echo ""
echo "  ✅  Pushed to: https://github.com/$GH_USER/$REPO_NAME"

# 5. Enable GitHub Pages
echo ""
echo "  Enabling GitHub Pages (main branch / root)..."
gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  /repos/$GH_USER/$REPO_NAME/pages \
  -f source='{"branch":"main","path":"/"}' 2>/dev/null || \
gh api \
  --method PUT \
  -H "Accept: application/vnd.github+json" \
  /repos/$GH_USER/$REPO_NAME/pages \
  -f source='{"branch":"main","path":"/"}' 2>/dev/null || \
echo "  (Pages may need to be enabled manually in Settings → Pages)"

echo ""
echo "────────────────────────────────────────────"
echo "  🌐  Your site will be live at:"
echo "  https://$GH_USER.github.io/$REPO_NAME/"
echo ""
echo "  It may take 1–2 minutes to deploy."
echo "────────────────────────────────────────────"
echo ""
