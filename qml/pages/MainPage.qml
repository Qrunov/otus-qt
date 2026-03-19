import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."

Page {
    objectName: "mainPage"

    StorageModel{
        id: storage
    }

    SilicaListView {
        header: PageHeader {
            objectName: "pageHeader"
            title: qsTr("Notes")
        }
        anchors.fill: parent
        model: storage
        delegate: ListItem {
            Column{
                x: Theme.horizontalPageMargin
                Label {
                    text: noteDate.toLocaleDateString(Qt.locale)
                    color: Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeExtraSmall
                }
                Label {
                    text: note
                }
            }
            menu: ContextMenu{
                MenuItem{
                    text: qsTr("Изменить")
                    onClicked: {
                        var dialog = pageStack.push(Qt.resolvedUrl("NoteDialog.qml"),{note: note, dt: noteDate})
                        dialog.accepted.connect(function () {
                            storage.updateItem(index, dialog.note, dialog.dt)
                        })

                    }
                }
                MenuItem{
                    text: qsTr("Удалить")
                    //onClicked: storage.deleteItem(id)
                    onClicked: storage.deleteItem(index)
                }
            }
        }

        PullDownMenu {
            MenuItem {
                text: "Добавить заметку"
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("NoteDialog.qml"))
                    dialog.accepted.connect(function () {
                        storage.addItem(dialog.note, dialog.dt)
                    })
                }
            }
        }
    }
}
