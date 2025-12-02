import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick.Effects

Item {
    id: root
    
    function refresh(query) {
        if (query === "") {
            model = musicController.getSongs()
        } else {
            model = musicController.search(query)
        }
        listView.model = model
    }

    property var model: musicController.getSongs()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15
        
        RowLayout {
            spacing: 10
            
            Button {
                id: addButton
                text: "+ Add Song"
                font.pixelSize: 14
                font.bold: true
                
                background: Rectangle {
                    radius: 8
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#00BCD4" }
                        GradientStop { position: 1.0; color: "#0097A7" }
                    }
                    
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowColor: "#6000BCD4"
                        shadowHorizontalOffset: 0
                        shadowVerticalOffset: 2
                        shadowBlur: 0.4
                    }
                }
                
                contentItem: Text {
                    text: addButton.text
                    font: addButton.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: fileDialog.open()
            }
            
            Item { Layout.fillWidth: true }
            
            Label {
                text: listView.count + " song" + (listView.count !== 1 ? "s" : "")
                font.pixelSize: 14
                color: "#888888"
            }
        }

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: root.model
            clip: true
            spacing: 8

            delegate: Rectangle {
                width: ListView.view.width
                height: 70
                color: songMouseArea.containsMouse ? "#2D2D2D" : "#252525"
                radius: 10
                
                border.color: songMouseArea.containsMouse ? "#00BCD4" : "transparent"
                border.width: 1
                
                Behavior on color { ColorAnimation { duration: 150 } }
                Behavior on border.color { ColorAnimation { duration: 150 } }
                
                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowColor: "#30000000"
                    shadowHorizontalOffset: 0
                    shadowVerticalOffset: 2
                    shadowBlur: 0.3
                }
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 15
                    
                    // Play Icon
                    Rectangle {
                        width: 46
                        height: 46
                        radius: 8
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#333333" }
                            GradientStop { position: 1.0; color: "#222222" }
                        }
                        
                        Text {
                            anchors.centerIn: parent
                            text: "▶"
                            font.pixelSize: 18
                            color: songMouseArea.containsMouse ? "#00BCD4" : "#888888"
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        
                        Text {
                            text: modelData.title
                            font.pixelSize: 14
                            font.bold: true
                            color: "white"
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                        
                        Text {
                            text: modelData.artist
                            font.pixelSize: 12
                            color: "#AAAAAA"
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }
                    
                    Button {
                        id: menuButton
                        text: "⋮"
                        flat: true
                        font.pixelSize: 20
                        
                        background: Rectangle {
                            radius: 8
                            color: menuButton.hovered ? "#333333" : "transparent"
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }
                        
                        contentItem: Text {
                            text: menuButton.text
                            font: menuButton.font
                            color: menuButton.hovered ? "#00BCD4" : "#888888"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }
                        
                        onClicked: contextMenu.popup()
                        
                        Menu {
                            id: contextMenu
                            
                            background: Rectangle {
                                color: "#2D2D2D"
                                radius: 8
                                border.color: "#444444"
                                border.width: 1
                            }
                            
                            MenuItem { 
                                text: "Add to Playlist..." 
                                onTriggered: addToPlaylistDialog.openWithSong(modelData.id)
                            }
                            MenuItem { 
                                text: "Set Album..." 
                                onTriggered: setAlbumDialog.openWithSong(modelData.id, modelData.title, modelData.artist)
                            }
                            MenuSeparator { 
                                contentItem: Rectangle {
                                    color: "#444444"
                                    height: 1
                                }
                            }
                            MenuItem { 
                                text: "Delete"
                                onTriggered: {
                                    musicController.deleteSong(modelData.id)
                                    root.refresh("")
                                }
                            }
                        }
                    }
                }
                
                MouseArea {
                    id: songMouseArea
                    anchors.fill: parent
                    anchors.rightMargin: 50
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    
                    onClicked: {
                        musicController.playSong(modelData.id)
                    }
                }
            }
        }
    }

    Dialog {
        id: addToPlaylistDialog
        title: "Add to Playlist"
        anchors.centerIn: parent
        width: 350
        
        property int currentSongId: -1
        function openWithSong(id) {
            currentSongId = id
            open()
        }
        
        background: Rectangle {
            color: "#2D2D2D"
            radius: 12
            border.color: "#444444"
            border.width: 1
            
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: "#80000000"
                shadowHorizontalOffset: 0
                shadowVerticalOffset: 4
                shadowBlur: 0.6
            }
        }
        
        header: Rectangle {
            width: parent.width
            height: 50
            color: "transparent"
            
            Label {
                anchors.centerIn: parent
                text: "Add to Playlist"
                font.pixelSize: 18
                font.bold: true
                color: "white"
            }
        }

        ColumnLayout {
            width: parent.width
            spacing: 10
            
            ScrollView {
                Layout.fillWidth: true
                Layout.preferredHeight: 200
                clip: true
                
                ColumnLayout {
                    width: parent.width
                    spacing: 8
                    
                    Repeater {
                        model: musicController.getPlaylists()
                        
                        Button {
                            Layout.fillWidth: true
                            text: modelData.title
                            
                            background: Rectangle {
                                radius: 8
                                color: parent.hovered ? "#3D3D3D" : "#333333"
                                Behavior on color { ColorAnimation { duration: 150 } }
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font.pixelSize: 14
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                musicController.addSongToPlaylist(modelData.id, addToPlaylistDialog.currentSongId)
                                addToPlaylistDialog.close()
                            }
                        }
                    }
                }
            }
            
            Button {
                Layout.fillWidth: true
                text: "Cancel"
                
                background: Rectangle {
                    radius: 8
                    color: parent.hovered ? "#444444" : "#3A3A3A"
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
                
                contentItem: Text {
                    text: parent.text
                    font.pixelSize: 14
                    color: "#AAAAAA"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: addToPlaylistDialog.close()
            }
        }
    }

    Dialog {
        id: setAlbumDialog
        title: "Set Album"
        anchors.centerIn: parent
        width: 350
        
        property int currentSongId: -1
        property string currentTitle: ""
        property string currentArtist: ""
        
        function openWithSong(id, title, artist) {
            currentSongId = id
            currentTitle = title
            currentArtist = artist
            open()
        }
        
        background: Rectangle {
            color: "#2D2D2D"
            radius: 12
            border.color: "#444444"
            border.width: 1
            
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: "#80000000"
                shadowHorizontalOffset: 0
                shadowVerticalOffset: 4
                shadowBlur: 0.6
            }
        }
        
        header: Rectangle {
            width: parent.width
            height: 50
            color: "transparent"
            
            Label {
                anchors.centerIn: parent
                text: "Set Album"
                font.pixelSize: 18
                font.bold: true
                color: "white"
            }
        }

        ColumnLayout {
            width: parent.width
            spacing: 10
            
            ScrollView {
                Layout.fillWidth: true
                Layout.preferredHeight: 200
                clip: true
                
                ColumnLayout {
                    width: parent.width
                    spacing: 8
                    
                    Repeater {
                        model: musicController.getAlbums()
                        
                        Button {
                            Layout.fillWidth: true
                            text: modelData.title
                            
                            background: Rectangle {
                                radius: 8
                                color: parent.hovered ? "#3D3D3D" : "#333333"
                                Behavior on color { ColorAnimation { duration: 150 } }
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font.pixelSize: 14
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                musicController.updateSong(setAlbumDialog.currentSongId, setAlbumDialog.currentTitle, setAlbumDialog.currentArtist, modelData.id)
                                setAlbumDialog.close()
                            }
                        }
                    }
                }
            }
            
            Button {
                Layout.fillWidth: true
                text: "Cancel"
                
                background: Rectangle {
                    radius: 8
                    color: parent.hovered ? "#444444" : "#3A3A3A"
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
                
                contentItem: Text {
                    text: parent.text
                    font.pixelSize: 14
                    color: "#AAAAAA"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: setAlbumDialog.close()
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Select Music File"
        nameFilters: ["Music files (*.mp3 *.wav *.ogg)"]
        onAccepted: {
            musicController.addSong(selectedFile)
            root.refresh("")
        }
    }

    Connections {
        target: musicController
        function onSongsChanged() {
            root.refresh("")
        }
    }
}
