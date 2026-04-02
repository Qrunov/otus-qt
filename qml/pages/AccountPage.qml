import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: account
    objectName: "accoutPage"
    allowedOrientations: Orientation.All

    PageHeader {
        id: ph
        objectName: "pageHeader"
        title: qsTr("Account information")
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
            placeholderText: qsTr("Last name")
            label: qsTr("Last name")
            font.bold: true
            acceptableInput: text.length > 0
            EnterKey.iconSource: "image://theme/icon-m-enter-next"
            EnterKey.onClicked: name.focus = true
        }
        TextField {
            id: name
            width: parent.width
            placeholderText: qsTr("First name")
            label: qsTr("First name")
            font.bold: true
            acceptableInput: text.length > 0
            EnterKey.iconSource: "image://theme/icon-m-enter-next"
            EnterKey.onClicked: secondName.focus = true
        }
        TextField {
            id: secondName
            width: parent.width
            placeholderText: qsTr("Middle name")
            label: qsTr("Middle name")
            EnterKey.iconSource: "image://theme/icon-m-enter-next"
            EnterKey.onClicked: topic.focus = true
        }
        TextField {
            id: topic
            width: parent.width
            placeholderText: qsTr("Topics")
            label: qsTr("Topics")
            inputMethodHints: Qt.ImhNoAutoUppercase
            EnterKey.iconSource: "image://theme/icon-m-enter-next"
            EnterKey.onClicked: mail.focus = true
        }

        TextField {
            id: mail
            width: parent.width
            placeholderText: qsTr("Mail(username@mail.ru)")
            label: qsTr("Mail")
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
            text: checked ? qsTr("I agree to data processing") :
                            qsTr("I NOT agree to data processing")
            checked: false
        }

        TextSwitch {
            width: page.width
            text: checked ? qsTr("I agree to receive notifications") :
                            qsTr("I NOT agree to receive notifications")
            checked: true
        }

        Button {
            width: parent.width
            id: enter
            enabled: acceptCheck.checked && soname.length > 0 && name.length > 0
            text: qsTr("Registration")
            onClicked: {
                status.text = qsTr("Account successfuly registered! ")
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
