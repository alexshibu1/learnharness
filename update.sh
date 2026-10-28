#!/usr/bin/env bash
set -euo pipefail

REPO="$HOME/code/learnharness"
AGENT_LABEL="com.alexshibu.learnharness"
NODE="/opt/homebrew/opt/node@22/bin/node"
NPM="/opt/homebrew/opt/node@22/bin/npm"

cd "$REPO"

echo "Stopping LearnHarness..."
launchctl bootout "gui/$(id -u)/$AGENT_LABEL" 2>/dev/null || true
sleep 2

echo "Fetching upstream..."
git fetch origin

echo "Rebasing bedrock onto latest upstream..."
git rebase origin/main

echo "Installing dependencies..."
"$NPM" install --prefer-offline 2>&1 | tail -3

echo "Building production (standalone)..."
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
export LH_DATA_DIR="$HOME/Library/Application Support/LearnHarness-source/data"
export AWS_PROFILE=default
export AWS_REGION=us-east-1
"$NPM" run build 2>&1 | tail -5

echo "Copying static assets into standalone..."
cp -r .next/static .next/standalone/.next/static 2>/dev/null || true
cp -r public .next/standalone/public 2>/dev/null || true

echo "Starting LearnHarness..."
launchctl bootstrap "gui/$(id -u)" "$HOME/Library/LaunchAgents/$AGENT_LABEL.plist"

echo "Done. Check: open http://localhost:3000"
