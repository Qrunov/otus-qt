import QtQuick 2.0
import QtQuick.LocalStorage 2.0



ListModel {
    id: storageModel
    property var db

    function createDB(){
        try{
            db.transaction(function(tx) {
                tx.executeSql("create table if not exists note(id integer primary key autoincrement, note text not null, noteDate text not null);");
                console.log("database was successfully initialized");
            });
        }
        catch(error){
            console.error("Error local storage initialization:",error);
        }
    }
    // function updateData(){
    //     clear()
    //     try{
    //         db.readTransaction(function(tx) {
    //             var res = tx.executeSql('select id,note,noteDate from note order by id');
    //             for (var i = 0;i < res.rows.length; i++){
    //                 append(res.rows.item(i))
    //             }
    //         });
    //     }
    //     catch(error){
    //         console.error("Error receiving data:",error);
    //     }
    // }

    function updateItem(Index, note, dt){
        var record = get(Index)
        console.log("updating ", record.id)
        try{
            db.transaction(function(tx) {
                tx.executeSql('update note set note = ?, noteDate = ? where id = ?',[note, dt, record.id]);
                console.log("updating ok");
                record.note = note
                record.noteDate = dt
            });
        }
        catch(error){
            console.error("Error update data:",error);
        }
    }



    function addItem(note, dt){
        try{
            db.transaction(function(tx) {
                tx.executeSql('insert into note(note, noteDate) values(?,?)',[note, dt]);
                console.log("inserting ok");
                var _res = tx.executeSql('select last_insert_rowid() as id');
                append({ id: _res.rows.item(0)["id"], note: note, noteDate: dt})
            });
        }
        catch(error){
            console.error("Error inserting data:",error);
        }
        //updateData();
    }

    function deleteItem(Index){
        var record = get(Index)
        console.log("removing ", record.id)
        try{
            db.transaction(function(tx) {
                var res = tx.executeSql('delete from note where id = ?',[record.id]);
                console.log("removing ok");
            });
            remove(Index)
        }
        catch(error){
            console.error("Error inserting data:",error);
        }

    }

    Component.onCompleted: {
        db = LocalStorage.openDatabaseSync("notes","1.0");
        createDB();
    }
}

