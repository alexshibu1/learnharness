#!/usr/bin/env bash
# Launch LearnHarness from source with AWS Bedrock credentials.
# Uses the default AWS profile from ~/.aws/credentials.
export AWS_PROFILE=default
export AWS_REGION=us-east-1
exec npm run dev
