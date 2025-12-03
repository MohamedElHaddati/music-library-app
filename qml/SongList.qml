import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
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
        anchors.margins: AppTheme.spacing4
        spacing: AppTheme.spacing4
        
        // Modern "Add Song" button with gradient
        Rectangle {
            Layout.preferredWidth: 140
            Layout.preferredHeight: 44
            radius: AppTheme.radiusRound
            gradient: Gradient {
                GradientStop { position: 0.0; color: AppTheme.primary }
                GradientStop { position: 1.0; color: AppTheme.primaryHover }
            }
            
            Behavior on opacity {
                NumberAnimation { duration: AppTheme.durationFast }
            }
            
            opacity: addButtonMouse.containsMouse ? 0.9 : 1.0
            
            RowLayout {
                anchors.centerIn: parent
                spacing: AppTheme.spacing2
                
                Text {
                    text: "+"
                    font.pixelSize: AppTheme.fontSizeLarge
                    font.bold: true
                    color: AppTheme.background
                }
                
                Text {
                    text: "Add Song"
                    font.pixelSize: AppTheme.fontSizeBody
                    font.bold: true
                    color: AppTheme.background
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
            spacing: AppTheme.spacing2

            delegate: Rectangle {
                width: ListView.view.width
                height: 72
                radius: AppTheme.radiusMedium
                color: songMouseArea.containsMouse ? AppTheme.surfaceHover : AppTheme.surface
                
                Behavior on color {
                    ColorAnimation { duration: AppTheme.durationFast }
                }
                
                Behavior on scale {
                    NumberAnimation { duration: AppTheme.durationFast }
                }
                
                scale: songMouseArea.pressed ? 0.98 : 1.0
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: AppTheme.spacing3
                    spacing: AppTheme.spacing3
                    
                    // Album art placeholder
                    Rectangle {
                        width: AppTheme.albumArtSmall
                        height: AppTheme.albumArtSmall
                        radius: AppTheme.radiusSmall
                        color: AppTheme.surfaceElevated
                        
                        Text {
                            anchors.centerIn: parent
                            text: "♫"
                            font.pixelSize: AppTheme.fontSizeLarge
                            color: AppTheme.textSecondary
                        }
                        
                        // Play button overlay on hover
                        Rectangle {
                            anchors.fill: parent
                            radius: AppTheme.radiusSmall
                            color: AppTheme.primary
                            opacity: songMouseArea.containsMouse ? 0.9 : 0
                            
                            Behavior on opacity {
                                NumberAnimation { duration: AppTheme.durationFast }
                            }
                            
                            Text {
                                anchors.centerIn: parent
                                text: "▶"
                                font.pixelSize: AppTheme.fontSizeMedium
                                color: AppTheme.background
                            }
                        }
                    }
                    
                    // Song info
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: AppTheme.spacing1
                        
                        Text {
                            text: modelData.title
                            font.pixelSize: AppTheme.fontSizeBody
                            font.bold: true
                            color: AppTheme.textPrimary
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                        
                        Text {
                            text: modelData.artist
                            font.pixelSize: AppTheme.fontSizeSmall
                            color: AppTheme.textSecondary
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }
                    
                    // Duration
                    Text {
                        text: {
                            if (modelData.duration && modelData.duration > 0) {
                                var minutes = Math.floor(modelData.duration / 60)
                                var seconds = modelData.duration % 60
                                return minutes + ":" + (seconds < 10 ? "0" : "") + seconds
                            }
                            return "--:--"
                        }
                        font.pixelSize: AppTheme.fontSizeSmall
                        color: AppTheme.textSecondary
                    }
                    
                    // More options button
                    Rectangle {
                        width: AppTheme.minTouchTarget
                        height: AppTheme.minTouchTarget
                        radius: AppTheme.radiusRound
                        color: moreButtonMouse.containsMouse ? AppTheme.surfaceElevated : "transparent"
                        
                        Behavior on color {
                            ColorAnimation { duration: AppTheme.durationFast }
                        }
                        
                        Text {
                            anchors.centerIn: parent
                            text: "⋮"
                            font.pixelSize: AppTheme.fontSizeLarge
                            color: AppTheme.textPrimary
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
                    anchors.rightMargin: AppTheme.minTouchTarget + AppTheme.spacing3
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
        width: 400  // Increased width
        height: 500  // Add explicit height
        standardButtons: Dialog.Cancel
        Material.theme: Material.Dark
        
        property int currentSongId: -1
        property var playlistModel: []
        
        function openWithSong(id) {
            currentSongId = id
            playlistModel = musicController.getPlaylists()
            open()
        }

        background: Rectangle {
            color: AppTheme.surface
            radius: AppTheme.radiusLarge
            border.color: AppTheme.border
            border.width: 1
        }

        contentItem: ColumnLayout {
            spacing: AppTheme.spacing3
            
            Label { 
                text: "Select Playlist:" 
                font.pixelSize: AppTheme.fontSizeBody
                font.bold: true
                color: AppTheme.textPrimary
            }
            
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                
                ColumnLayout {
                    width: parent.width - 20  // Account for scrollbar
                    spacing: AppTheme.spacing2
                    
                    Repeater {
                        model: addToPlaylistDialog.playlistModel
                        
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 50
                            radius: AppTheme.radiusMedium
                            color: playlistMouseArea.containsMouse ? AppTheme.surfaceHover : AppTheme.surfaceElevated
                            
                            Behavior on color {
                                ColorAnimation { duration: AppTheme.durationFast }
                            }
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: AppTheme.spacing3
                                spacing: AppTheme.spacing2
                                
                                Text {
                                    text: "🎵"
                                    font.pixelSize: 20
                                }
                                
                                Text {
                                    text: modelData.title
                                    font.pixelSize: AppTheme.fontSizeBody
                                    color: AppTheme.textPrimary
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                                
                                Text {
                                    text: modelData.songCount + " songs"
                                    font.pixelSize: AppTheme.fontSizeSmall
                                    color: AppTheme.textSecondary
                                }
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
        }
    }

    Dialog {
        id: setAlbumDialog
        title: "Set Album"
        anchors.centerIn: parent
        width: 400  // Increased width
        height: 500  // Add explicit height
        standardButtons: Dialog.Cancel
        Material.theme: Material.Dark
        
        property int currentSongId: -1
        property string currentTitle: ""
        property string currentArtist: ""
        property var albumModel: []
        
        function openWithSong(id, title, artist) {
            currentSongId = id
            currentTitle = title
            currentArtist = artist
            albumModel = musicController.getAlbums()
            open()
        }

        background: Rectangle {
            color: AppTheme.surface
            radius: AppTheme.radiusLarge
            border.color: AppTheme.border
            border.width: 1
        }

        contentItem: ColumnLayout {
            spacing: AppTheme.spacing3
            
            Label { 
                text: "Select Album:" 
                font.pixelSize: AppTheme.fontSizeBody
                font.bold: true
                color: AppTheme.textPrimary
            }
            
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                
                ColumnLayout {
                    width: parent.width - 20  // Account for scrollbar
                    spacing: AppTheme.spacing2
                    
                    Repeater {
                        model: setAlbumDialog.albumModel
                        
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 50
                            radius: AppTheme.radiusMedium
                            color: albumMouseArea.containsMouse ? AppTheme.surfaceHover : AppTheme.surfaceElevated
                            
                            Behavior on color {
                                ColorAnimation { duration: AppTheme.durationFast }
                            }
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: AppTheme.spacing3
                                spacing: AppTheme.spacing2
                                
                                Text {
                                    text: "💿"
                                    font.pixelSize: 20
                                }
                                
                                Text {
                                    text: modelData.title
                                    font.pixelSize: AppTheme.fontSizeBody
                                    color: AppTheme.textPrimary
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                                
                                Text {
                                    text: modelData.songCount + " songs"
                                    font.pixelSize: AppTheme.fontSizeSmall
                                    color: AppTheme.textSecondary
                                }
                            }
                            
                            MouseArea {
                                id: albumMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    musicController.updateSong(
                                        setAlbumDialog.currentSongId,
                                        setAlbumDialog.currentTitle,
                                        setAlbumDialog.currentArtist,
                                        modelData.id
                                    )
                                    setAlbumDialog.close()
                                }
                            }
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
