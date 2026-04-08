import QtQuick 2.0
import Sailfish.Silica 1.0
import ru.template.resolution 1.0
Page {
    objectName: "mainPage"
    allowedOrientations: Orientation.All

    Resolution {
        id: rs
    }

    PageHeader {
        objectName: "pageHeader"
        title: qsTr("Template")
        id: ph
        extraContent.children: [
            IconButton {
                objectName: "aboutButton"
                icon.source: "image://theme/icon-m-about"
                anchors.verticalCenter: parent.verticalCenter

                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        ]        anchors.top: ph.bottom

    }
    Column{
        anchors{
            top: ph.bottom
        }
        width: parent.width
        Label{
            width: parent.width
            text: qsTr("Разрешение экрана: ") +  rs.resolution
            id: tf
            //       placeholder: "input hostname here"
            anchors.top: prompt.bottom
            horizontalAlignment: "AlignHCenter"
        }
    }
    // Component.onCompleted:
    // {
    //     rs.getResolution()
    // }
}
