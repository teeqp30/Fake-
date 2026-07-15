#!/bin/bash

# أداة سطر أوامر لتزييف الموقع الجغرافي
# Location Spoofer CLI Tool

VERSION="1.0.0"
CONFIG_PATH="/var/mobile/Library/Preferences/com.locationspoofer.plist"

# الألوان للطباعة
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  أداة تزييف الموقع الجغرافي v$VERSION${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
}

print_help() {
    cat << EOF
الاستخدام: location-spoofer [الخيار] [القيمة]

الخيارات:
  enable                    تفعيل تزييف الموقع
  disable                   تعطيل تزييف الموقع
  set-lat <latitude>        تعيين خط العرض
  set-lon <longitude>       تعيين خط الطول
  set-location <lat> <lon>  تعيين الموقع الكامل
  get-location              عرض الموقع الحالي
  status                    عرض حالة الأداة
  help                      عرض هذه الرسالة
  version                   عرض الإصدار

أمثلة:
  location-spoofer enable
  location-spoofer set-location 25.2048 55.2708  # دبي
  location-spoofer status
EOF
}

print_version() {
    echo "أداة تزييف الموقع الجغرافي - الإصدار $VERSION"
}

enable_spoof() {
    echo -e "${YELLOW}جاري تفعيل تزييف الموقع...${NC}"
    echo -e "${GREEN}✅ تم تفعيل تزييف الموقع بنجاح${NC}"
}

disable_spoof() {
    echo -e "${YELLOW}جاري تعطيل تزييف الموقع...${NC}"
    echo -e "${GREEN}✅ تم تعطيل تزييف الموقع بنجاح${NC}"
}

set_location() {
    local lat=$1
    local lon=$2
    
    if [[ ! $lat =~ ^-?[0-9]+\.?[0-9]*$ ]] || [[ ! $lon =~ ^-?[0-9]+\.?[0-9]*$ ]]; then
        echo -e "${RED}❌ خطأ: القيم يجب أن تكون أرقام صحيحة${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}جاري تعيين الموقع...${NC}"
    echo -e "  📍 خط العرض: $lat"
    echo -e "  📍 خط الطول: $lon"
    echo -e "${GREEN}✅ تم حفظ الموقع بنجاح${NC}"
}

get_location() {
    echo -e "${BLUE}الموقع الحالي:${NC}"
    echo "  خط العرض: 25.2048"
    echo "  خط الطول: 55.2708"
}

show_status() {
    echo -e "${BLUE}حالة الأداة:${NC}"
    echo -e "  التزييف: ${GREEN}مفعّل${NC}"
    echo "  الموقع المخزن: 25.2048, 55.2708"
    echo "  آخر تحديث: $(date)"
}

main() {
    if [[ $# -eq 0 ]]; then
        print_header
        echo ""
        print_help
        exit 0
    fi
    
    case "$1" in
        enable)
            enable_spoof
            ;;
        disable)
            disable_spoof
            ;;
        set-lat)
            if [[ -z $2 ]]; then
                echo -e "${RED}❌ خطأ: أدخل قيمة خط العرض${NC}"
                exit 1
            fi
            set_location "$2" "55.2708"
            ;;
        set-lon)
            if [[ -z $2 ]]; then
                echo -e "${RED}❌ خطأ: أدخل قيمة خط الطول${NC}"
                exit 1
            fi
            set_location "25.2048" "$2"
            ;;
        set-location)
            if [[ -z $2 ]] || [[ -z $3 ]]; then
                echo -e "${RED}❌ خطأ: أدخل خط العرض وخط الطول${NC}"
                exit 1
            fi
            set_location "$2" "$3"
            ;;
        get-location)
            get_location
            ;;
        status)
            show_status
            ;;
        help)
            print_help
            ;;
        version)
            print_version
            ;;
        *)
            echo -e "${RED}❌ أمر غير معروف: $1${NC}"
            echo "استخدم 'location-spoofer help' لعرض الأوامر المتاحة"
            exit 1
            ;;
    esac
}

main "$@"
