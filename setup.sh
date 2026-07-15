#!/bin/bash

# سكريبت إعداد البيئة
# Environment Setup Script

echo "========================================="
echo "  🛠️ إعداد بيئة البناء"
echo "  Build Environment Setup"
echo "========================================="
echo ""

# الألوان
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# التحقق من النظام
echo -e "${BLUE}التحقق من النظام...${NC}"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo -e "${GREEN}✅ نظام Linux مكتشف${NC}"
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${GREEN}✅ نظام macOS مكتشف${NC}"
    OS="macos"
else
    echo -e "${RED}❌ نظام غير مدعوم${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}التحقق من المتطلبات...${NC}"

# متطلبات عامة
REQUIREMENTS=("dpkg" "tar" "gzip")

for cmd in "${REQUIREMENTS[@]}"; do
    if command -v "$cmd" &> /dev/null; then
        echo -e "${GREEN}✅${NC} $cmd موجود"
    else
        echo -e "${RED}❌${NC} $cmd غير موجود"
        if [ "$OS" = "linux" ]; then
            echo -e "   ${YELLOW}تثبيت: sudo apt-get install $cmd${NC}"
        fi
    fi
done

echo ""
echo -e "${BLUE}التحقق من الأدوات الاختيارية...${NC}"

# أدوات اختيارية
OPTIONAL=("fakeroot" "dpkg-deb" "ar" "md5sum")

for cmd in "${OPTIONAL[@]}"; do
    if command -v "$cmd" &> /dev/null; then
        echo -e "${GREEN}✅${NC} $cmd موجود"
    else
        echo -e "${YELLOW}⚠️${NC} $cmd غير موجود (اختياري)"
    fi
done

echo ""
echo -e "${BLUE}إعداد صلاحيات الملفات...${NC}"

# تعيين الأذونات
if [ -f "build.sh" ]; then
    chmod +x build.sh
    echo -e "${GREEN}✅${NC} تم تعيين أذونات build.sh"
fi

if [ -f "DEBIAN/postinst" ]; then
    chmod 755 DEBIAN/postinst
    echo -e "${GREEN}✅${NC} تم تعيين أذونات postinst"
fi

if [ -f "DEBIAN/prerm" ]; then
    chmod 755 DEBIAN/prerm
    echo -e "${GREEN}✅${NC} تم تعيين أذونات prerm"
fi

if [ -f "usr/local/bin/location-spoofer.sh" ]; then
    chmod 755 usr/local/bin/location-spoofer.sh
    echo -e "${GREEN}✅${NC} تم تعيين أذونات location-spoofer.sh"
fi

echo ""
echo "========================================="
echo -e "${GREEN}✅ تم إعداد البيئة بنجاح!${NC}"
echo "========================================="
echo ""
echo -e "${BLUE}الخطوات التالية:${NC}"
echo ""
echo "  1️⃣  بناء الحزمة:"
echo "     make build"
echo "     أو"
echo "     ./build.sh"
echo ""
echo "  2️⃣  التثبيت:"
echo "     make install"
echo ""
echo "  3️⃣  التحقق:"
echo "     make verify"
echo ""
