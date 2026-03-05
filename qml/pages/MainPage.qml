import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    objectName: "mainPage"
    allowedOrientations: Orientation.All

    PageHeader {
        objectName: "pageHeader"
        title: qsTr("Введите учетные данные")
        extraContent.children: [
            IconButton {
                objectName: "aboutButton"
                icon.source: "image://theme/icon-m-about"
                anchors.verticalCenter: parent.verticalCenter

                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        ]
    }
    Column {
        anchors.centerIn: parent
        width: parent.width

        TextField {
            id: login
            width: parent.width
            placeholderText: qsTr("Логин")
            label: qsTr("Логин")
            inputMethodHints: Qt.ImhNoAutoUppercase
            validator: RegExpValidator {
                id: loginValidator
                regExp: /^[a-z][a-z0-9_-]{2,15}$/
            }
            EnterKey.enabled: !errorHighlight
            EnterKey.iconSource: "image://theme/icon-m-enter-next"
            EnterKey.onClicked: phone.focus = true
        }

        TextField {
            id: phone
            width: parent.width
            placeholderText: qsTr("Телефон")
            label: qsTr("Телефон")
            validator: RegExpValidator { regExp: /^(\+7|8)?[\s\-]?\(?[0-9]{3}\)?[\s\-]?[0-9]{3}[\s\-]?[0-9]{2}[\s\-]?[0-9]{2}$/ }
            EnterKey.enabled: !errorHighlight
            EnterKey.iconSource: "image://theme/icon-m-enter-next"
            EnterKey.onClicked: enter.focus = true
        }
        Button {
            width: parent.width
            id: enter
            enabled: phone.text.length && login.text.length && phone.acceptableInput && login.acceptableInput
            text: qsTr("Далее")
            onClicked: {
                pageStack.push(Qt.resolvedUrl("AccountPage.qml"))
            }
        }
    }
}
