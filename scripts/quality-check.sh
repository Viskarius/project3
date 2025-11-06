#!/bin/bash

set -e

echo "🚀 Starting quality checks..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
    exit 1
}

# Check required files
echo "📁 Checking required files..."
[ -f "index.html" ] || print_error "index.html not found"
[ -s "index.html" ] || print_error "index.html is empty"
[ -f "Dockerfile" ] || print_error "Dockerfile not found"
print_status "All required files present"

# HTML structure validation
echo "🔍 Validating HTML structure..."
grep -q "<!DOCTYPE html>" index.html || print_warning "Missing DOCTYPE declaration"
grep -q "<html" index.html || print_error "Missing <html> tag"
grep -q "<head" index.html || print_error "Missing <head> tag"
grep -q "<body" index.html || print_error "Missing <body> tag"
grep -q "<title" index.html || print_warning "Missing <title> tag"
print_status "HTML structure validation passed"

# Dockerfile validation
echo "🐳 Validating Dockerfile..."
grep -q "FROM" Dockerfile || print_error "Dockerfile missing FROM instruction"
grep -q "COPY.*index.html" Dockerfile || print_error "Dockerfile missing COPY for index.html"
print_status "Dockerfile validation passed"

# Security checks
echo "🔒 Running security checks..."
if grep -r "innerHTML" . --include="*.js" --include="*.html" | grep -v "innerHTML.*=.*''"; then
    print_warning "Found innerHTML usage - potential XSS risk"
fi

if grep -r "eval(" . --include="*.js"; then
    print_error "Found eval() usage - security risk"
fi
print_status "Security checks passed"

echo ""
echo -e "${GREEN}🎉 All quality checks completed successfully!${NC}"
