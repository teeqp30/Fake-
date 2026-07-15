#!/bin/bash

# سكريبت استخراج ملف DEB
# Extract DEB Package Script

set -e

echo "==========================================="
echo "  📦 استخراج ملف DEB"
echo "  DEB Package Extraction Tool"
echo "==========================================="
echo ""

# المتغيرات
PACKAGE_NAME="location-spoofer"
VERSION="1.0.0"
ARCH="iphoneos-arm"
DEB_FILE="${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"
EXTRACT_DIR="${PACKAGE_NAME}_extracted_${VERSION}"

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# الدوال
print_step() {
    echo -e "${BLUE}→${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

# التحقق من وجود ملف DEB
echo -e "${BLUE}[ 1/5 ]${NC} التحقق من ملف DEB..."
echo ""

if [ ! -f "$DEB_FILE" ]; then
    print_error "ملف $DEB_FILE غير موجود!"
    echo ""
    echo "الخطوات المطلوبة:"
    echo "  1. بناء الحزمة أولاً:"
    echo "     ./build.sh"
    echo "  أو"
    echo "     make build"
    echo ""
    exit 1
fi

FILE_SIZE=$(du -h "$DEB_FILE" | cut -f1)
print_success "ملف DEB موجود (الحجم: $FILE_SIZE)"

# إنشاء مجلد الاستخراج
echo ""
echo -e "${BLUE}[ 2/5 ]${NC} إنشاء مجلد الاستخراج..."
echo ""

if [ -d "$EXTRACT_DIR" ]; then
    print_step "حذف المجلد القديم..."
    rm -rf "$EXTRACT_DIR"
fi

mkdir -p "$EXTRACT_DIR"
cd "$EXTRACT_DIR"
print_success "تم إنشاء مجلد: $EXTRACT_DIR"

# استخراج الملفات
echo ""
echo -e "${BLUE}[ 3/5 ]${NC} استخراج محتويات DEB..."
echo ""

print_step "استخراج البيانات الوصفية (control)..."
ar x "../$DEB_FILE" control.tar.gz
tar xzf control.tar.gz
print_success "تم استخراج control"

print_step "استخراج البيانات (data)..."
ar x "../$DEB_FILE" data.tar.gz
tar xzf data.tar.gz
print_success "تم استخراج data"

# إنشاء هيكل منظم
echo ""
echo -e "${BLUE}[ 4/5 ]${NC} تنظيم الملفات..."
echo ""

# حذف ملفات التجميع
rm -f control.tar.gz data.tar.gz

# إنشاء ملف معلومات
cat > EXTRACT_INFO.txt << 'EOF'
# معلومات استخراج DEB
# DEB Extraction Information

اسم الحزمة: location-spoofer
الإصدار: 1.0.0
المعمارية: iphoneos-arm
تاريخ الاستخراج: $(date)

## محتويات المجلد:

DEBIAN/           - ملفات الحزمة الوصفية
  ├── control     - معلومات الحزمة
  ├── postinst    - سكريبت التثبيت
  ├── prerm       - سكريبت الإزالة
  └── md5sums     - تجزئات التحقق

data/             - محتويات الحزمة
  ├── opt/        - البرامج الثابتة
  ├── usr/        - البرامج والأدوات
  └── var/        - البيانات المتغيرة

## الملفات الرئيسية:

opt/location-spoofer/spoofer.m
  الكود الأساسي لـ Method Swizzling

usr/local/bin/location-spoofer.sh
  أداة سطر الأوامر

var/mobile/Library/LocationSpoofer/
  مجلد البيانات

## الاستخدام:

لإعادة بناء DEB من هذه الملفات:
  cd ..
  fakeroot dpkg-deb -b location-spoofer_extracted_1.0.0 location-spoofer_1.0.0_iphoneos-arm.deb

---
تم الاستخراج بواسطة: extract.sh
EOF

print_success "تم إنشاء ملف EXTRACT_INFO.txt"

# عرض ملخص الاستخراج
echo ""
echo -e "${BLUE}[ 5/5 ]${NC} عرض ملخص الاستخراج..."
echo ""

cd ..

echo -e "${BLUE}📁 هيكل المجلدات المستخرجة:${NC}"
echo ""
tree "$EXTRACT_DIR" 2>/dev/null || find "$EXTRACT_DIR" -type f | sed 's|^|  |'

echo ""
echo "==========================================="
echo -e "${GREEN}✅ تم الاستخراج بنجاح!${NC}"
echo "==========================================="
echo ""
echo "📊 ملخص الاستخراج:"
echo ""
echo "  📂 مجلد الاستخراج: $EXTRACT_DIR"
echo "  📦 ملف DEB الأصلي: $DEB_FILE"
echo "  💾 حجم DEB: $FILE_SIZE"
echo ""

# عد الملفات
TOTAL_FILES=$(find "$EXTRACT_DIR" -type f | wc -l)
echo "  📄 عدد الملفات: $TOTAL_FILES"

TOTAL_DIRS=$(find "$EXTRACT_DIR" -type d | wc -l)
echo "  📁 عدد المجلدات: $TOTAL_DIRS"

echo ""
echo "📝 الملفات المستخرجة:"
echo ""
find "$EXTRACT_DIR" -type f -exec ls -lh {} \; | awk '{print "  " $9 " (" $5 ")"}'

echo ""
echo "🔍 معلومات التحكم (control):"
echo ""
cat "$EXTRACT_DIR/DEBIAN/control" | sed 's/^/  /'

echo ""
echo "📝 الخطوات التالية:"
echo ""
echo "  1️⃣  فحص الملفات:"
echo "     ls -la $EXTRACT_DIR/"
echo "     tree $EXTRACT_DIR/"
echo ""
echo "  2️⃣  تعديل الملفات إذا لزم الأمر:"
echo "     nano $EXTRACT_DIR/DEBIAN/control"
echo ""
echo "  3️⃣  إعادة بناء DEB:"
echo "     fakeroot dpkg-deb -b $EXTRACT_DIR location-spoofer_modified.deb"
echo ""
echo "  4️⃣  التحقق من الملفات:"
echo "     cat $EXTRACT_DIR/EXTRACT_INFO.txt"
echo "     cat $EXTRACT_DIR/DEBIAN/control"
echo "     cat $EXTRACT_DIR/DEBIAN/postinst"
echo ""
echo "==========================================="
echo ""
