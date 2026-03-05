import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: account
    objectName: "accoutPage"
    allowedOrientations: Orientation.All

    PageHeader {
        id: ph
        objectName: "pageHeader"
        title: qsTr("Данные аккаунта")
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
            id: soname
            width: parent.width
            placeholderText: qsTr("Фамилия")
            label: qsTr("Фамилия")
            font.bold: true
            acceptableInput: text.length > 0
            EnterKey.iconSource: "image://theme/icon-m-enter-next"
            EnterKey.onClicked: name.focus = true
        }
        TextField {
            id: name
            width: parent.width
            placeholderText: qsTr("Имя")
            label: qsTr("Имя")
            font.bold: true
            acceptableInput: text.length > 0
            EnterKey.iconSource: "image://theme/icon-m-enter-next"
            EnterKey.onClicked: secondName.focus = true
        }
        TextField {
            id: secondName
            width: parent.width
            placeholderText: qsTr("Отчество")
            label: qsTr("Отчество")
            EnterKey.iconSource: "image://theme/icon-m-enter-next"
            EnterKey.onClicked: topic.focus = true
        }
        TextField {
            id: topic
            width: parent.width
            placeholderText: qsTr("Темы")
            label: qsTr("Темы")
            inputMethodHints: Qt.ImhNoAutoUppercase
            EnterKey.iconSource: "image://theme/icon-m-enter-next"
            EnterKey.onClicked: mail.focus = true
        }

        TextField {
            id: mail
            width: parent.width
            placeholderText: qsTr("Почта(username@mail.ru)")
            label: qsTr("Почта")
            EnterKey.iconSource: "image://theme/icon-m-enter-next"
            inputMethodHints: Qt.ImhNoAutoUppercase
            validator: RegExpValidator {
                id: mailValidator
                regExp: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
            }
        }

        TextSwitch {
            id: acceptCheck
            width: page.width
            text: checked ? qsTr("Я даю согласие на обработку персональных данных") :
                            qsTr("Я не даю согласия на обработку персональных данных")
            checked: false
        }

        TextSwitch {
            width: page.width
            text: checked ? qsTr("Я даю согласие на рассылку уведомлений") :
                            qsTr("Я не даю согласия на рассылку уведомлений")
            checked: true
        }

        Button {
            width: parent.width
            id: enter
            enabled: acceptCheck.checked && soname.length > 0 && name.length > 0
            text: qsTr("Регистрация")
            onClicked: {
                status.text = "Аккаунт успешно зарегистрирован!"
                delayTimer.start()
            }
        }
        Timer {
            id:delayTimer
            interval: 2000
            repeat: false
            onTriggered: {
                pageStack.clear();
                pageStack.push("MainPage.qml");
            }
        }



        Label {
            width: parent.width
            id: status
            font.pixelSize: Theme.fontSizeExtraSmallBase
            color: "red"
        }


    }

}
