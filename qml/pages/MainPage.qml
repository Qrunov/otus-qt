import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0

Page {
    objectName: "mainPage"
    allowedOrientations: Orientation.All


    ListModel {
        id: storageModel
        property var db

        function createDB(){
            try{
                db.transaction(function(tx) {
                    tx.executeSql("create table if not exists note(id integer primary key autoincrement, note text not null);");
                    console.log("database was successfully initialized");
                });
            }
            catch(error){
                console.error("Error local storage initialization:",error);
            }
        }
        function updateData(){
            clear()
            try{
                db.readTransaction(function(tx) {
                    var res = tx.executeSql('select id,note from note order by id');
                    for (var i = 0;i < res.rows.length; i++){
                        append(res.rows.item(i))
                    }
                });
            }
            catch(error){
                console.error("Error receiving data:",error);
            }

        }

        function updateItem(id, note){
            console.log("updating ", id)

            try{
                db.transaction(function(tx) {
                    var res = tx.executeSql('update note set note = ? where id = ?',[note, id]);
                    console.log("updating ok");
                });
            }
            catch(error){
                console.error("Error update data:",error);
            }
            updateData();
        }



        function addItem(note){
            console.log("adding ", note)

            try{
                db.transaction(function(tx) {
                    var res = tx.executeSql('insert into note(note) values(?)',[note]);
                    console.log("inserting ok");
                });
            }
            catch(error){
                console.error("Error inserting data:",error);
            }
            updateData();

        }

        function deleteItem(id){
            console.log("removing ", id)
            try{
                db.transaction(function(tx) {
                    var res = tx.executeSql('delete from note where id = ?',[id]);
                    console.log("removing ok");
                });
            }
            catch(error){
                console.error("Error inserting data:",error);
            }
            updateData();
        }


        Component.onCompleted: {
            db = LocalStorage.openDatabaseSync("notes","1.0");
            createDB();
        }
    }



    SilicaListView {
        header: PageHeader {
            objectName: "pageHeader"
            title: qsTr("Notes")
        }
        anchors.fill: parent
        model: storageModel
        delegate: ListItem {
            Label {
                x: Theme.horizontalPageMargin
                text: note
            }
            menu: ContextMenu{
                MenuItem{
                    text: qsTr("Изменить")
                    onClicked: {
                        var dialog = pageStack.push(Qt.resolvedUrl("NoteDialog.qml"),{note: note})
                        dialog.accepted.connect(function () {
                            storageModel.updateItem(id, dialog.note)
                        })

                    }
                }
                MenuItem{
                    text: qsTr("Удалить")
                    onClicked: storageModel.deleteItem(id)
                }
            }
        }

        PullDownMenu {
            MenuItem {
                text: "Добавить заметку"
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("NoteDialog.qml"))
                    dialog.accepted.connect(function () {
                        storageModel.addItem(dialog.note)
                    })
                }
            }
        }
    }
}
