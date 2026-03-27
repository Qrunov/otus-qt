import QtQuick 2.0
import QtQuick.LocalStorage 2.0



ListModel {
    id: storageModel
    property var db
    property bool dirty: true

    function createDB(){
        try{
            db.transaction(function(tx) {
                // tx.executeSql("drop table if exists topic_word");
                // tx.executeSql("drop table if exists word");
                // tx.executeSql("drop table if exists topic");
                tx.executeSql("create table if not exists topic(id integer primary key autoincrement, name text not null);");
                tx.executeSql("create table if not exists word(id integer primary key autoincrement, word text not null unique, transcription text, translation text, learned integer not null default 0
                              ,repeated integer not null default 0);");
                tx.executeSql("create table if not exists topic_word(id integer primary key autoincrement, word_id integer not null, topic_id integer not null, amount integer default 1,
                               foreign key (word_id) references word(id) on delete cascade,
                               foreign key (topic_id) references topic(id) on delete cascade);");
                //tx.executeSql("drop view if exists topic_stat");
                tx.executeSql("create view if not exists topic_stat as
                                select topic.id as id,
                                max(topic.name) as title,
                                sum(topic_word.amount) as total,
                                count(topic_word.id) as unq,
                                sum(word.learned) as known,
                                sum(word.learned * topic_word.amount) as coverage
                                from topic
                                    join topic_word on topic_word.topic_id = topic.id
                                    join word on topic_word.word_id = word.id
                                group by topic.id;");
            });
        }
        catch(error){
            console.error("Error local storage initialization:",error);
        }
    }
    function insertTopic(topic, wd){
        try{
            db.transaction(function(tx) {
                var res = tx.executeSql("insert into topic(name) values(?) returning id", [topic]);
                var id = res.rows.item(0).id;
                tx.executeSql("create temp table if not exists tmp_word(word text not null, count text not null)");
                tx.executeSql("delete from tmp_word");
                var values = "";
                for (var w in wd){
                    values += "," + "(" + "'" + w + "'" + ", " + wd[w] + ")"
                }
                if (values === "")
                    throw "empty word set";
                values = values.substring(1);
                tx.executeSql("insert into tmp_word values " + values);
                tx.executeSql("insert into word(word) select word from tmp_word except select word from word"); //новые слова
                tx.executeSql("insert into topic_word(word_id, topic_id, amount) select word.id, ?, tmp_word.count from word
                               join tmp_word on word.word = tmp_word.word", [id]);
                tx.executeSql("drop table tmp_word");
                dirty = true;
            });
        }
        catch(error){
            console.error("Error inserting topic:",error);

        }
    }
    function fillModel(){
        if (dirty !== true)
            return;
        clear();
        try{
            db.transaction(function(tx) {
                var res = tx.executeSql("select * from topic_stat order by id desc");
                for (var i = 0;i < res.rows.length; i++){
                    append(res.rows.item(i))
                }
            });
        }
        catch(error){
            console.error("Error retreiving information:",error);
        }
        dirty = false;
    }

    function refreshTopic(ind){
        try{
            db.transaction(function(tx) {
                var row = get(ind)
                var res = tx.executeSql("select * from topic_stat where id = ?",[row["id"]]);
                if (res.row.length !== 1){
                    throw "error refreshing topic";
                }
                row = res.rows.item(0);
            });
        }
        catch(error){
            console.error("Error retreiving information:",error);
        }
    }

    function getUnknownForTopic(ind,model){
        try{
            db.transaction(function(tx) {
                var row = get(ind)
                var res = tx.executeSql("select word.id as id, word as en from word
                                        join topic_word on topic_word.word_id = word.id
                                        where learned = 0 and translation is null and topic_id = ?",[row["id"]]);
                model.clear();
                for (var i = 0;i < res.rows.length; i++){
                    model.append(res.rows.item(i));
                }
            });
        }
        catch(error){
            console.error("Error getUnknownForTopic:",error);
        }
    }

    function getLeaningForTopic(ind,model){
        try{
            db.transaction(function(tx) {
                var row = get(ind)
                var res = tx.executeSql("select word.id as id, word as en, translation as ru from word
                                        join topic_word on topic_word.word_id = word.id
                                        where learned = 0 and translation is not null and topic_id = ?
                                        order by topic_word.amount desc",[row["id"]]);
                model.clear();
                for (var i = 0;i < res.rows.length; i++){
                    console.log(res.rows.item(i));
                    model.append(res.rows.item(i));
                }
            });
        }
        catch(error){
            console.error("Error getLearningForTopic:",error);
        }
    }


    function deleteWord(id){
        try{
            db.transaction(function(tx) {
                tx.executeSql('delete from word where id = ?',[id]);
                console.log("removing word ok");
            });
        }
        catch(error){
            console.error("Error deleteWord:",error);
        }
        dirty = true;
    }

    function markWordKnown(id){
        try{
            db.transaction(function(tx) {
                tx.executeSql('update word set learned = 1 where id = ?',[id]);
            });
        }
        catch(error){
            console.error("Error markWordKnown:",error);
        }
        dirty = true;
    }


    function determineWord(id,translate){
        try{
            db.transaction(function(tx) {
                tx.executeSql('update word set translation  = ? where id = ?',[translate, id]);
            });
        }
        catch(error){
            console.error("Error determineWord:",error);
        }
        dirty = true;
    }

    function progressUp(id){
        try{
            db.transaction(function(tx) {
                tx.executeSql('update word set repeated = repeated + 1 where id = ?',[id]);
                tx.executeSql('update word set learned = 1 where id = ? and repeated = 5',[id]);
            });
        }
        catch(error){
            console.error("Error progressUp:",error);
        }
        dirty = true;
    }

    function progressDown(id){
        try{
            db.transaction(function(tx) {
                tx.executeSql('update word set repeated = repeated - 1 where id = ? and repeated > 0',[id]);
            });
        }
        catch(error){
            console.error("Error progressDown:",error);
        }
        dirty = true;
    }
    Component.onCompleted: {
        db = LocalStorage.openDatabaseSync("enlive","1.0");
        createDB();
    }
}

