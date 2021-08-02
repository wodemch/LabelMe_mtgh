import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Rectangle {
    width: parent.width
    height: parent.height
    color: "white"
    property int gpointSize: 14

    signal indexChange(int index,string labelname)
    signal addOneLabel(int index,string labelname)
    //外部删除
    signal out_deleteOneLabel(int index,string labelname)
    //内部删除
    signal in_deleteOneLabel(int index)
    // 新增函数
    function addOne(index,labelName) {
        addOneLabel(index,labelName)
    }
    // 删除函数
    function deleteOne(index,labelName) {
        out_deleteOneLabel(index,labelName)
    }
    function clearAll() {
        listView.model.clear()
    }
    // 1.定义header
    Component {
        id: headerView
        Item {
            width: parent.width
            height: 30
            RowLayout {
                anchors.left: parent.left
                //anchors.verticalCenter: parent.verticalCenter
                spacing: 8
                Text {
                    text: "序号"
                    font.bold: true
                    font.pixelSize: gpointSize
                    Layout.preferredWidth: 80
                }
                Text {
                    text: "标签"
                    font.bold: true
                    font.pixelSize: gpointSize
                    Layout.preferredWidth: 120
                }
            }
        }
    }

    // 2. 定义footer
    Component {
        id: footerView
        Text {
            width: parent.width
            font.italic: true
            color: "blue"
            height: 30
            verticalAlignment: Text.AlignVCenter
        }
    }

    // 3. 定义model
    Component {
        id: phoneModel
        ListModel {
            ListElement{
                index: -1
                name: "test"
            }
        }
    }

    // 4. 定义delegate
    Component {
        id: phoneDelegate
        Item {
            id: wrapper
            width: parent.width
            height: 30

            MouseArea {
                anchors.fill: parent
                onClicked: wrapper.ListView.view.currentIndex = index
                onDoubleClicked: {
                    //内部不主动删除 统一外部控制
                    //wrapper.ListView.view.model.remove(index)
                    in_deleteOneLabel(index)
                    mouse.accepted = true
                }
            }

            RowLayout {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8
                Text {
                    id: col1
                    text: index
                    color: wrapper.ListView.isCurrentItem ? "red" : "black"
                    font.pixelSize: wrapper.ListView.isCurrentItem ? gpointSize+2 : gpointSize
                    Layout.preferredWidth: 80
                }
                Text {
                    text: name
                    color: wrapper.ListView.isCurrentItem ? "red" : "black"
                    font.pixelSize: wrapper.ListView.isCurrentItem ? gpointSize+2 : gpointSize
                    Layout.preferredWidth: 120
                }
            }
        }
    }

    // 5.定义ListView
    ListView {
        id: listView
        anchors.fill: parent

        delegate: phoneDelegate
        model: phoneModel.createObject(listView)
        header: headerView
        focus: true
        highlight: Rectangle{
            color: "lightblue"
        }

        onCurrentIndexChanged:{
            if( listView.currentIndex >=0 ){
                var data = listView.model.get(listView.currentIndex)
                if(data.index === -1){
                    model.clear()
                }else{
                    indexChange(data.index,data.name)
                }
            }
        }
        function addOne(index,labelName) {
            model.append({
                             "index":index,
                             "name": labelName
                         })
        }
        function deleteOne(index,labelName) {
            if (count > index){
                model.remove(index)
            }
            //更新序号
            if (listView.count > 0){
                for (var i = 0; i < listView.count; ++i){
                    model.get(i).index=i
                }
            }
        }
        Component.onCompleted: {
            addOneLabel.connect(listView.addOne)
            out_deleteOneLabel.connect(listView.deleteOne)
        }
    }
}
