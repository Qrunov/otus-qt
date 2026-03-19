import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    property string note
    property date dt: new Date()
    DialogHeader {
        id: hdr
        acceptText: "Сохранить"
        cancelText: "Отменить"
    }
    Column
    {
        anchors{
            right: parent.right
            left: parent.left
            top: hdr.bottom
            bottom: parent.bottom
        }

        Button{
            anchors{
                right: parent.right
                left: parent.left
                top: hdr.bottom
            }

            id: date_id
            text: dt.toLocaleDateString(Qt.locale)
            width: parent.width
            onClicked:{
                var dialog = pageStack.push("Sailfish.Silica.DatePickerDialog", {date: dt});

                dialog.accepted.connect(function(){
                    dt = dialog.date;
                })
            }
        }

        TextArea {
            anchors{
                right: parent.right
                left: parent.left
                top: date_id.bottom
                bottom: parent.bottom
                centerIn: parent
            }
            id: noteArea
            width: parent.width
            placeholderText: "Текст заметки"
            label: "Текст заметки"
            text: note
        }


    }
    onAccepted: note = noteArea.text
}
