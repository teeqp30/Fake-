#!/bin/bash

# سكريبت الاختبار
# Test Script for DEB Package

echo "========================================="
echo "  🧪 اختبار حزمة DEB"
echo "  DEB Package Test Suite"
echo "========================================="
echo ""

# الألوان
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

TEST_PASSED=0
TEST_FAILED=0

# دالة اختبار
run_test() {
    local test_name=$1
    local command=$2
    
    echo -e "${BLUE}→${NC} اختبار: $test_name"
    
    if eval "$command" &> /dev/null; then
        echo -e "${GREEN}✅ نجح${NC}"
        ((TEST_PASSED++))
    else
        echo -e "${RED}❌ فشل${NC}"
        ((TEST_FAILED++))
    fi
    echo ""
}

echo -e "${BLUE}[ 1/5 ]${NC} اختبار وجود ملفات DEBIAN..."
run_test "ملف control" "[ -f DEBIAN/control ]"
run_test "ملف postinst" "[ -f DEBIAN/postinst ]"
run_test "ملف prerm" "[ -f DEBIAN/prerm ]"
run_test "ملف md5sums" "[ -f DEBIAN/md5sums ]"

echo -e "${BLUE}[ 2/5 ]${NC} اختبار وجود ملفات البرنامج..."
run_test "ملف spoofer.m" "[ -f opt/location-spoofer/spoofer.m ]"
run_test "ملف location-spoofer.sh" "[ -f usr/local/bin/location-spoofer.sh ]"

echo -e "${BLUE}[ 3/5 ]${NC} اختبار الملفات الإضافية..."
run_test "ملف README-AR.md" "[ -f README-AR.md ]"
run_test "ملف BUILD.md" "[ -f BUILD.md ]"
run_test "ملف build.sh" "[ -f build.sh ]"

echo -e "${BLUE}[ 4/5 ]${NC} اختبار الأذونات..."
run_test "أذونات postinst" "[ -x DEBIAN/postinst ]"
run_test "أذونات prerm" "[ -x DEBIAN/prerm ]"
run_test "أذونات build.sh" "[ -x build.sh ]"

echo -e "${BLUE}[ 5/5 ]${NC} اختبار صيغة الملفات..."
run_test "صيغة control" "grep -q 'Package:' DEBIAN/control"
run_test "صيغة postinst" "head -1 DEBIAN/postinst | grep -q 'bin/bash'"
run_test "صيغة BUILD.md" "head -1 BUILD.md | grep -q '#'"

echo ""
echo "========================================="
echo -e "${BLUE}📊 ملخص الاختبار:${NC}"
echo "========================================="
echo -e "${GREEN}✅ نجح: $TEST_PASSED${NC}"
echo -e "${RED}❌ فشل: $TEST_FAILED${NC}"
echo ""

if [ $TEST_FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 جميع الاختبارات نجحت!${NC}"
    exit 0
else
    echo -e "${RED}⚠️ بعض الاختبارات فشلت!${NC}"
    exit 1
fi
