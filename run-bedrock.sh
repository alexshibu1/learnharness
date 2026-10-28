#!/usr/bin/env bash
# Launch LearnHarness from source (production mode) with AWS Bedrock credentials.
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
export AWS_PROFILE=default
export AWS_REGION=us-east-1
export LH_DATA_DIR="$HOME/Library/Application Support/LearnHarness-source/data"

cd "$(dirname "$0")"

if [ "${1:-}" = "--dev" ]; then
    exec npm run dev
else
    npm run build 2>&1 | tail -3
    cp -r .next/static .next/standalone/.next/static 2>/dev/null || true
    cp -r public .next/standalone/public 2>/dev/null || true
    exec node .next/standalone/server.js
fi
