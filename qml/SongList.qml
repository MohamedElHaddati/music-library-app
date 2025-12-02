import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import MusicManager

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
        anchors.margins: Theme.spacing4
        spacing: Theme.spacing4
        
        // Modern "Add Song" button with gradient
        Rectangle {
            Layout.preferredWidth: 140
            Layout.preferredHeight: 44
            radius: Theme.radiusRound
            gradient: Gradient {
                GradientStop { position: 0.0; color: Theme.primary }
                GradientStop { position: 1.0; color: Theme.primaryHover }
            }
            
            Behavior on opacity {
                NumberAnimation { duration: Theme.durationFast }
            }
            
            opacity: addButtonMouse.containsMouse ? 0.9 : 1.0
            
            RowLayout {
                anchors.centerIn: parent
                spacing: Theme.spacing2
                
                Text {
                    text: "+"
                    font.pixelSize: Theme.fontSizeLarge
                    font.bold: true
                    color: Theme.background
                }
                
                Text {
                    text: "Add Song"
                    font.pixelSize: Theme.fontSizeBody
                    font.bold: true
                    color: Theme.background
                }
            }
            
            MouseArea {
                id: addButtonMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: fileDialog.open()
            }
        }

        // Modern song list with cards
        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: root.model
            clip: true
            spacing: Theme.spacing2

            delegate: Rectangle {
                width: ListView.view.width
                height: 72
                radius: Theme.radiusMedium
                color: songMouseArea.containsMouse ? Theme.surfaceHover : Theme.surface
                
                Behavior on color {
                    ColorAnimation { duration: Theme.durationFast }
                }
                
                Behavior on scale {
                    NumberAnimation { duration: Theme.durationFast }
                }
                
                scale: songMouseArea.pressed ? 0.98 : 1.0
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.spacing3
                    spacing: Theme.spacing3
                    
                    // Album art placeholder
                    Rectangle {
                        width: Theme.albumArtSmall
                        height: Theme.albumArtSmall
                        radius: Theme.radiusSmall
                        color: Theme.surfaceElevated
                        
                        Text {
                            anchors.centerIn: parent
                            text: "♫"
                            font.pixelSize: Theme.fontSizeLarge
                            color: Theme.textSecondary
                        }
                        
                        // Play button overlay on hover
                        Rectangle {
                            anchors.fill: parent
                            radius: Theme.radiusSmall
                            color: Theme.primary
                            opacity: songMouseArea.containsMouse ? 0.9 : 0
                            
                            Behavior on opacity {
                                NumberAnimation { duration: Theme.durationFast }
                            }
                            
                            Text {
                                anchors.centerIn: parent
                                text: "▶"
                                font.pixelSize: Theme.fontSizeMedium
                                color: Theme.background
                            }
                        }
                    }
                    
                    // Song info
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: Theme.spacing1
                        
                        Text {
                            text: modelData.title
                            font.pixelSize: Theme.fontSizeBody
                            font.bold: true
                            color: Theme.textPrimary
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                        
                        Text {
                            text: modelData.artist
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.textSecondary
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }
                    
                    // Duration placeholder
                    Text {
                        text: "3:45"
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.textSecondary
                    }
                    
                    // More options button
                    Rectangle {
                        width: Theme.minTouchTarget
                        height: Theme.minTouchTarget
                        radius: Theme.radiusRound
                        color: moreButtonMouse.containsMouse ? Theme.surfaceElevated : "transparent"
                        
                        Behavior on color {
                            ColorAnimation { duration: Theme.durationFast }
                        }
                        
                        Text {
                            anchors.centerIn: parent
                            text: "⋮"
                            font.pixelSize: Theme.fontSizeLarge
                            color: Theme.textPrimary
                        }
                        
                        MouseArea {
                            id: moreButtonMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                contextMenu.songId = modelData.id
                                contextMenu.songTitle = modelData.title
                                contextMenu.songArtist = modelData.artist
                                contextMenu.popup()
                            }
                        }
                    }
                }
                
                MouseArea {
                    id: songMouseArea
                    anchors.fill: parent
                    anchors.rightMargin: Theme.minTouchTarget + Theme.spacing3
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: musicController.playSong(modelData.id)
                }
                
                Menu {
                    id: contextMenu
                    property int songId: -1
                    property string songTitle: ""
                    property string songArtist: ""
                    
                    Material.theme: Material.Dark
                    
                    MenuItem { 
                        text: "Add to Playlist..." 
                        onTriggered: addToPlaylistDialog.openWithSong(contextMenu.songId)
                    }
                    MenuItem { 
                        text: "Set Album..." 
                        onTriggered: setAlbumDialog.openWithSong(contextMenu.songId, contextMenu.songTitle, contextMenu.songArtist)
                    }
                    MenuItem { 
                        text: "Delete" 
                        onTriggered: {
                            musicController.deleteSong(contextMenu.songId)
                            root.refresh("")
                        }
                    }
                }
            }
        }
    }

    // Modern styled dialogs
    Dialog {
        id: addToPlaylistDialog
        title: "Add to Playlist"
        anchors.centerIn: parent
        standardButtons: Dialog.Cancel
        Material.theme: Material.Dark
        
        property int currentSongId: -1
        function openWithSong(id) {
            currentSongId = id
            open()
        }

        background: Rectangle {
            color: Theme.surface
            radius: Theme.radiusLarge
        }

        ColumnLayout {
            spacing: Theme.spacing3
            
            Label { 
                text: "Select Playlist:" 
                font.pixelSize: Theme.fontSizeBody
                color: Theme.textPrimary
            }
            
            Repeater {
                model: musicController.getPlaylists()
                
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 44
                    radius: Theme.radiusMedium
                    color: playlistMouseArea.containsMouse ? Theme.surfaceHover : Theme.surfaceElevated
                    
                    Text {
                        anchors.centerIn: parent
                        text: modelData.title
                        font.pixelSize: Theme.fontSizeBody
                        color: Theme.textPrimary
                    }
                    
                    MouseArea {
                        id: playlistMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            musicController.addSongToPlaylist(modelData.id, addToPlaylistDialog.currentSongId)
                            addToPlaylistDialog.close()
                        }
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
        Material.theme: Material.Dark
        
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
            color: Theme.surface
            radius: Theme.radiusLarge
        }

        ColumnLayout {
            spacing: Theme.spacing3
            
            Label { 
                text: "Select Album:" 
                font.pixelSize: Theme.fontSizeBody
                color: Theme.textPrimary
            }
            
            Repeater {
                model: musicController.getAlbums()
                
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 44
                    radius: Theme.radiusMedium
                    color: albumMouseArea.containsMouse ? Theme.surfaceHover : Theme.surfaceElevated
                    
                    Text {
                        anchors.centerIn: parent
                        text: modelData.title
                        font.pixelSize: Theme.fontSizeBody
                        color: Theme.textPrimary
                    }
                    
                    MouseArea {
                        id: albumMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            musicController.updateSong(setAlbumDialog.currentSongId, setAlbumDialog.currentTitle, setAlbumDialog.currentArtist, modelData.id)
                            setAlbumDialog.close()
                        }
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
