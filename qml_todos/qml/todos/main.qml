import QtQuick 2.0
import io.engin 1.0 as Enginio
import "applicationconfig.js" as AppConfig

Rectangle {
    width: 360
    height: 360

    Enginio.Client {
        id: client
        backendId: AppConfig.backendData.id
        backendSecret: AppConfig.backendData.secret
        apiUrl: AppConfig.backendData.apiUrl
    }

    Enginio.ObjectModel {
        id: todos
    }

    Enginio.QueryOperation {
        id: queryOperation
        client: client
        model: todos
        objectType: "objects.todos"
        onFinished: {
            console.log("Query finished");
            console.log("Model rows: " + model.rowCount);
        }
        onError: {
            status.text = error.errorString + ", HTTP: " + error.httpCode;
            console.log("HTTP status code: " + error.httpCode);
            console.log("Network error code: " + error.networkError);
        }
    }

    Component.onCompleted: {
        queryOperation.execute();
    }

    Rectangle {
        id: newTodoRow
        height: 30
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        color: "#eee"
        z: 10

        TextInput {
            id: newTodoInput
            anchors.left: parent.left
            anchors.right: newTodoButton.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 10
            text: "What needs to be done?"
            color: "#ccc"
            font.pixelSize: parent.height * 0.5

            onFocusChanged: {
                if (focus) {
                    newTodoInput.text = ""
                    newTodoInput.color = "black"
                }
            }

            Keys.onReturnPressed: {
                newTodoButtonArea.clicked({});
            }
        }

        Rectangle {
            id: newTodoButton
            width: 30
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            color: newTodoButtonArea.containsMouse ? "#27b039" : "#37c049"

            Text {
                anchors.centerIn: parent
                text: "+"
                color: "white"
            }

            MouseArea {
                id: newTodoButtonArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    if (newTodoInput.text.length === 0)
                        return;

                    var obj = {objectType: "objects.todos", completed: false};
                    obj.title = newTodoInput.text;

                    var createOp = client.createObjectOperation(todos);
                    createOp.create(obj);

                    createOp.error.connect(function(error) {
                        console.log("Create op error");
                        status.text = error.errorString + ", HTTP: " + error.httpCode;
                    });
                    createOp.finished.connect(function() {
                        console.log("Create op finished");
                        createOp.destroy();
                    });
                    createOp.execute();

                    newTodoInput.text = "";
                }
            }
        }
    }

    ListView {
        id: todoListView
        model: todos
        delegate: todoListDelegate
        anchors.top: newTodoRow.bottom
        anchors.bottom: statusarea.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
    }

    Component {
        id: todoListDelegate

        Rectangle {
            height: 30
            width: parent.width
            color: rowHoverArea.containsMouse ? "#dddddd" : "transparent"

            Row {
                height: parent.height
                width: parent.width
                z: rowHoverArea.z + 1

                Text {
                    text: jsondata.title
                    font.strikeout: jsondata.completed
                    font.pixelSize: parent.height * 0.5
                    width: parent.width - parent.height
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            var obj = todos.objectFromRow(index);
                            obj.completed = !obj.completed;

                            var updateOp = client.createObjectOperation(todos);
                            updateOp.update(obj);

                            updateOp.error.connect(function(error) {
                                console.log("Update op error");
                                status.text = error.errorString + ", HTTP: " + error.httpCode;
                            });
                            updateOp.finished.connect(function() {
                                console.log("Update op finished");
                                updateOp.destroy();
                            });
                            updateOp.execute();
                        }
                    }
                }

                Rectangle {
                    id: deleteButton
                    height: parent.height
                    width: parent.height
                    color: rowHoverArea.containsMouse ? "#f00" : "transparent"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            var obj = todos.objectFromRow(index);
                            obj.completed = !obj.completed;

                            var removeOp = client.createObjectOperation(todos);
                            removeOp.remove(obj);

                            removeOp.error.connect(function(error) {
                                console.log("Remove op error");
                                status.text = error.errorString + ", HTTP: " + error.httpCode;
                            });
                            removeOp.finished.connect(function() {
                                console.log("Remove op finished");
                                removeOp.destroy();
                            });
                            removeOp.execute();
                        }
                    }
                }
            }

            MouseArea {
                id: rowHoverArea
                anchors.fill: parent
                hoverEnabled: true
            }

        }
    }

    Rectangle {
        id: statusarea
        color: "#ffffff"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        height: 20

        Text {
            id: status
            text: "Rows: " + todos.rowCount
            color: "#666666"
            font.pixelSize: parent.height * 0.7
        }
    }
}
