import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

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
        
        RowLayout {
            Button {
                text: "Add Song"
                onClicked: fileDialog.open()
            }
        }

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: root.model
            clip: true

            delegate: ItemDelegate {
                width: parent.width
                text: modelData.title + " - " + modelData.artist
                onClicked: {
                    window.currentSong = modelData
                }
                
                Button {
                    text: "⋮"
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: contextMenu.popup()
                    
                    Menu {
                        id: contextMenu
                        MenuItem { 
                            text: "Add to Playlist..." 
                            onTriggered: addToPlaylistDialog.openWithSong(modelData.id)
                        }
                        MenuItem { 
                            text: "Set Album..." 
                            onTriggered: setAlbumDialog.openWithSong(modelData.id, modelData.title, modelData.artist)
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
        }
    }

    Dialog {
        id: addToPlaylistDialog
        title: "Add to Playlist"
        anchors.centerIn: parent
        standardButtons: Dialog.Cancel
        
        property int currentSongId: -1
        function openWithSong(id) {
            currentSongId = id
            open()
        }

        ColumnLayout {
            Label { text: "Select Playlist:" }
            Repeater {
                model: musicController.getPlaylists()
                Button {
                    text: modelData.title
                    onClicked: {
                        musicController.addSongToPlaylist(modelData.id, addToPlaylistDialog.currentSongId)
                        addToPlaylistDialog.close()
                    }
                }
            }
        }
    }

    Dialog {
        id: setAlbumDialog
        title: "Set Album"
        anchors.centerIn: parent
        standardButtons: Dialog.Cancel
        
        property int currentSongId: -1
        property string currentTitle: ""
        property string currentArtist: ""
        
        function openWithSong(id, title, artist) {
            currentSongId = id
            currentTitle = title
            currentArtist = artist
            open()
        }

        ColumnLayout {
            Label { text: "Select Album:" }
            Repeater {
                model: musicController.getAlbums()
                Button {
                    text: modelData.title
                    onClicked: {
                        musicController.updateSong(setAlbumDialog.currentSongId, setAlbumDialog.currentTitle, setAlbumDialog.currentArtist, modelData.id)
                        setAlbumDialog.close()
                    }
                }
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
