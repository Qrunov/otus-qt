TARGET = ru.template.hw6

CONFIG += \
    auroraapp

PKGCONFIG += \

SOURCES += \
    src/main.cpp \

HEADERS += \

DISTFILES += \
    qml/pages/AccountPage.qml \
    rpm/ru.template.hw6.spec \

AURORAAPP_ICONS = 86x86 108x108 128x128 172x172

CONFIG += auroraapp_i18n

TRANSLATIONS += \
    translations/ru.template.hw6.ts \
    translations/ru.template.hw6-ru.ts \
