#!/bin/bash

# سكريبت بناء حزمة DEB كاملة
# Build Script for Location Spoofer DEB Package
# ==================================================

set -e

echo "==============================================="
echo "  🔨 بناء حزمة DEB - أداة تزييف الموقع الجغرافي"
echo "  DEB Package Builder - Location Spoofer"
echo "==============================================="
echo ""

# المتغيرات الأساسية
PACKAGE_NAME="location-spoofer"
VERSION="1.0.0"
ARCH="iphoneos-arm"
WORK_DIR="$(pwd)"
OUTPUT_FILE="${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"

# الألوان للطباعة
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# الدوال المساعدة
print_step() {
    echo -e "${BLUE}→${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

# التحقق من المتطلبات
echo ""
echo -e "${BLUE}[ 1/6 ]${NC} التحقق من المتطلبات..."
echo ""

if ! command -v dpkg-deb &> /dev/null; then
    print_error "dpkg-deb غير مثبت. يرجى تثبيته أولاً:"
    echo "  apt-get install dpkg"
    exit 1
fi
print_success "dpkg-deb موجود"

if ! command -v fakeroot &> /dev/null; then
    print_warning "fakeroot غير مثبت. قد لا تعمل بعض الميزات"
else
    print_success "fakeroot موجود"
fi

# التحقق من وجود ملفات DEBIAN
echo ""
echo -e "${BLUE}[ 2/6 ]${NC} التحقق من ملفات DEBIAN..."
echo ""

if [ ! -f "DEBIAN/control" ]; then
    print_error "ملف DEBIAN/control غير موجود!"
    exit 1
fi
print_success "ملف control موجود"

if [ ! -f "DEBIAN/postinst" ]; then
    print_error "ملف DEBIAN/postinst غير موجود!"
    exit 1
fi
print_success "ملف postinst موجود"

if [ ! -f "DEBIAN/prerm" ]; then
    print_error "ملف DEBIAN/prerm غير موجود!"
    exit 1
fi
print_success "ملف prerm موجود"

# تعيين الأذونات
echo ""
echo -e "${BLUE}[ 3/6 ]${NC} تعيين الأذونات..."
echo ""

chmod 755 DEBIAN/postinst
print_success "تم تعيين أذونات postinst"

chmod 755 DEBIAN/prerm
print_success "تم تعيين أذونات prerm"

chmod 755 usr/local/bin/location-spoofer.sh 2>/dev/null || print_warning "ملف location-spoofer.sh قد لا يكون موجوداً"

# إنشاء ملف md5sums
echo ""
echo -e "${BLUE}[ 4/6 ]${NC} إنشاء تجزئات md5sums..."
echo ""

if [ -d "DEBIAN" ]; then
    cd DEBIAN
    find .. -type f ! -path "./DEBIAN/*" ! -path "./.git/*" -exec md5sum {} \; > md5sums.tmp 2>/dev/null || true
    if [ -f md5sums.tmp ]; then
        mv md5sums.tmp md5sums
    fi
    cd ..
    print_success "تم إنشاء ملف md5sums"
fi

# بناء الحزمة
echo ""
echo -e "${BLUE}[ 5/6 ]${NC} بناء حزمة DEB..."
echo ""

if command -v fakeroot &> /dev/null; then
    print_step "استخدام fakeroot للبناء الآمن..."
    fakeroot dpkg-deb -b . "${OUTPUT_FILE}"
else
    print_step "استخدام dpkg-deb المباشر..."
    dpkg-deb --build . "${OUTPUT_FILE}"
fi

if [ $? -eq 0 ]; then
    print_success "تم بناء الحزمة بنجاح!"
else
    print_error "فشل بناء الحزمة!"
    exit 1
fi

# التحقق من الحزمة
echo ""
echo -e "${BLUE}[ 6/6 ]${NC} التحقق من الحزمة..."
echo ""

if [ -f "${OUTPUT_FILE}" ]; then
    FILE_SIZE=$(du -h "${OUTPUT_FILE}" | cut -f1)
    print_success "ملف الحزمة: ${OUTPUT_FILE} (الحجم: ${FILE_SIZE})"
    
    echo ""
    echo -e "${BLUE}معلومات الحزمة:${NC}"
    dpkg-deb --info "${OUTPUT_FILE}" 2>/dev/null | head -10 || echo "لم يتمكن من عرض المعلومات"
    
    echo ""
    echo -e "${BLUE}محتويات الحزمة (أول 10 ملفات):${NC}"
    dpkg-deb --contents "${OUTPUT_FILE}" 2>/dev/null | head -10 || echo "لم يتمكن من عرض المحتويات"
else
    print_error "لم يتم إنشاء ملف الحزمة!"
    exit 1
fi

# الملخص النهائي
echo ""
echo "==============================================="
echo -e "${GREEN}✅ تم البناء بنجاح!${NC}"
echo "==============================================="
echo ""
echo "📦 اسم الحزمة: $PACKAGE_NAME"
echo "📌 الإصدار: $VERSION"
echo "🏗️ المعمارية: $ARCH"
echo "📁 ملف الحزمة: ${OUTPUT_FILE}"
echo "💾 الحجم: $(du -h ${OUTPUT_FILE} | cut -f1)"
echo ""
echo "📝 الخطوات التالية:"
echo ""
echo "  1️⃣  عرض معلومات الحزمة:"
echo "     dpkg-deb --info ${OUTPUT_FILE}"
echo ""
echo "  2️⃣  التثبيت:"
echo "     sudo dpkg -i ${OUTPUT_FILE}"
echo ""
echo "  3️⃣  التحقق من التثبيت:"
echo "     dpkg -l | grep location-spoofer"
echo ""
echo "  4️⃣  تشغيل الأداة:"
echo "     location-spoofer status"
echo ""
echo "  5️⃣  الإزالة:"
echo "     sudo dpkg -r location-spoofer"
echo ""
echo "==============================================="
echo ""
