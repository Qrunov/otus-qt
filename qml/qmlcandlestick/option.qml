import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

Page {
    id: options

    Component.onCompleted: {
        console.log("Qt version:", Qt.version);
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        //Приглашение
        Label {
            id: prompt
            text: qsTr("Введите данные для запроса:")
            font.italic: true
        }

        // Поле для широты
        TextField {
            id: latitudeField
            Layout.fillWidth: true
            placeholderText: qsTr("Широта (например, 55.7558)")
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            color: acceptableInput ? "black" : "red"
            // Валидация: диапазон от -90 до 90
            validator: DoubleValidator {
                bottom: -90
                top: 90
            }
        }

        // Поле для долготы
        TextField {
            id: longitudeField
            Layout.fillWidth: true
            placeholderText: qsTr("Долгота (например, 37.6173)")
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            color: acceptableInput ? "black" : "red"
            // Валидация: диапазон от -180 до 180
            validator: DoubleValidator {
                bottom: -180
                top: 180
            }
        }

        // Поле для даты начала
        TextField {
            id: startDateField
            Layout.fillWidth: true
            placeholderText: qsTr("Дата начала периода (ДД.ММ.ГГГГ)")
            validator: RegExpValidator{ regExp : /^(0[1-9]|[12][0-9]|3[01])\.(0[1-9]|1[0-2])\.(19|20)\d{2}$/}
            color: acceptableInput ? "black" : "red"
        }

        // Поле для даты конца
        TextField {
            id: endDateField
            Layout.fillWidth: true
            placeholderText: "Дата конца периода (ДД.ММ.ГГГГ)"
            validator: RegExpValidator{ regExp : /^(0[1-9]|[12][0-9]|3[01])\.(0[1-9]|1[0-2])\.(19|20)\d{2}$/}
            color: acceptableInput ? "black" : "red"
        }

        Button {
            id: submit
            text: qsTr("Загрузить...")
            Layout.alignment: Qt.AlignHRight

            enabled: startDateField.acceptableInput && endDateField.acceptableInput && latitudeField.acceptableInput && longitudeField.acceptableInput

            onClicked: {
                var aBegin = startDateField.text.split(".");
                var aEnd = endDateField.text.split(".");
                var normBegin = aBegin[2] + "-" +aBegin[1] + "-" + aBegin[0];
                var normEnd = aEnd[2] + "-" +aEnd[1] + "-" + aEnd[0];
                stackView.push("waiting.qml",{
                                   longitude: longitudeField.text,
                                   latitude: latitudeField.text,
                                   start: normBegin,
                                   end: normEnd
                               })
            }
        }
    }
}
