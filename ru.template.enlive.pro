TARGET = ru.template.enlive

CONFIG += \
    auroraapp

PKGCONFIG += \

SOURCES += \
    src/main.cpp \

HEADERS += \

DISTFILES += \
    qml/pages/BaseWordPage.qml \
    qml/pages/LearningWordPage.qml \
    qml/pages/MarkingWordPage.qml \
    rpm/ru.template.enlive.spec \

AURORAAPP_ICONS = 86x86 108x108 128x128 172x172

CONFIG += auroraapp_i18n

TRANSLATIONS += \
    translations/ru.template.enlive.ts \
    translations/ru.template.enlive-ru.ts \
