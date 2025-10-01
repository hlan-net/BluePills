#!/bin/bash

# Security check script for BluePills
# Run this before committing to ensure no secrets are included

set -e

echo "🔒 Running security checks..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Check for common secret patterns in staged files
check_secrets() {
    print_status $YELLOW "🔍 Checking for secrets in staged files..."
    
    # Get staged files
    staged_files=$(git diff --cached --name-only 2>/dev/null || echo "")
    
    if [ -z "$staged_files" ]; then
        print_status $GREEN "✅ No staged files to check"
        return 0
    fi
    
    # Patterns to search for (case insensitive)
    secret_patterns=(
        "password\s*[:=]\s*['\"][^'\"]{3,}['\"]"
        "secret\s*[:=]\s*['\"][^'\"]{3,}['\"]"
        "token\s*[:=]\s*['\"][^'\"]{10,}['\"]"
        "api_key\s*[:=]\s*['\"][^'\"]{10,}['\"]"
        "private_key"
        "-----BEGIN.*PRIVATE KEY-----"
        "-----BEGIN.*CERTIFICATE-----"
        "[0-9a-fA-F]{32,}" # Long hex strings (potential keys)
    )
    
    secrets_found=false
    
    for file in $staged_files; do
        if [ -f "$file" ]; then
            for pattern in "${secret_patterns[@]}"; do
                if grep -iE "$pattern" "$file" >/dev/null 2>&1; then
                    print_status $RED "❌ Potential secret found in $file:"
                    grep -inE "$pattern" "$file" | head -3
                    secrets_found=true
                fi
            done
        fi
    done
    
    if [ "$secrets_found" = true ]; then
        print_status $RED "❌ Potential secrets detected! Please review and remove them."
        return 1
    else
        print_status $GREEN "✅ No secrets detected in staged files"
        return 0
    fi
}

# Check for accidentally staged keystore/certificate files
check_binary_secrets() {
    print_status $YELLOW "🔑 Checking for keystore and certificate files..."
    
    # File patterns that should never be committed
    secret_files=(
        "*.keystore"
        "*.jks"
        "*.p12"
        "*.pem"
        "*.key"
        "*.crt"
        "*.pfx"
        "key.properties"
        "google-services.json"
        "GoogleService-Info.plist"
    )
    
    secrets_found=false
    
    for pattern in "${secret_files[@]}"; do
        if git diff --cached --name-only | grep -E "$pattern" >/dev/null 2>&1; then
            print_status $RED "❌ Secret file pattern found: $pattern"
            git diff --cached --name-only | grep -E "$pattern"
            secrets_found=true
        fi
    done
    
    if [ "$secrets_found" = true ]; then
        print_status $RED "❌ Secret files detected! These should not be committed."
        print_status $YELLOW "💡 Add these to .gitignore and remove from staging."
        return 1
    else
        print_status $GREEN "✅ No secret files detected"
        return 0
    fi
}

# Main execution
main() {
    echo "🔒 BluePills Security Check"
    echo "=========================="
    echo ""
    
    # Run all checks
    check_secrets || exit 1
    check_binary_secrets || exit 1
    
    echo ""
    print_status $GREEN "🎉 Security check completed successfully!"
    print_status $GREEN "✅ Safe to commit - no secrets detected"
    echo ""
}

# Run the security check
main "$@"