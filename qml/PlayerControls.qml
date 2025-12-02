import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import MusicManager

Rectangle {
    id: root
    height: Theme.playerControlsHeight
    color: Theme.surface
    
    property var currentSong: musicController.getCurrentSong()
    
    Connections {
        target: musicController
        function onCurrentSongChanged() {
            root.currentSong = musicController.getCurrentSong()
            if (root.currentSong.hasSong) {
                player.source = root.currentSong.path
                player.play()
            }
        }
    }
    
    MediaPlayer {
        id: player
        audioOutput: AudioOutput {}
        onPlaybackStateChanged: {
            if (playbackState === MediaPlayer.StoppedState && position > 0 && position >= duration) {
                musicController.nextSong()
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Progress bar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 4
            color: Theme.surfaceElevated
            
            Rectangle {
                width: parent.width * (player.duration > 0 ? player.position / player.duration : 0)
                height: parent.height
                color: Theme.primary
                
                Behavior on width {
                    NumberAnimation { duration: 100 }
                }
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (player.duration > 0) {
                        player.position = (mouse.x / width) * player.duration
                    }
                }
            }
        }
        
        // Main player controls
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: Theme.spacing3
            spacing: Theme.spacing4
            
            // Left: Current song info with album art
            RowLayout {
                Layout.preferredWidth: 250
                spacing: Theme.spacing3
                
                // Album artwork thumbnail
                Rectangle {
                    width: 56
                    height: 56
                    radius: Theme.radiusSmall
                    color: Theme.surfaceElevated
                    
                    Text {
                        anchors.centerIn: parent
                        text: "♫"
                        font.pixelSize: Theme.fontSizeLarge
                        color: Theme.textSecondary
                    }
                }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing1
                    
                    Text { 
                        text: root.currentSong.title || "No song playing"
                        font.pixelSize: Theme.fontSizeBody
                        font.bold: true 
                        color: Theme.textPrimary
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    Text { 
                        text: root.currentSong.artist || "---"
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.textSecondary
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }
            }
            
            Item { Layout.fillWidth: true }
            
            // Center: Playback controls
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: Theme.spacing2
                
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: Theme.spacing3
                    
                    // Previous button
                    Rectangle {
                        width: Theme.minTouchTarget - 8
                        height: Theme.minTouchTarget - 8
                        radius: width / 2
                        color: prevMouseArea.containsMouse ? Theme.surfaceElevated : "transparent"
                        
                        Behavior on color {
                            ColorAnimation { duration: Theme.durationFast }
                        }
                        
                        Text {
                            anchors.centerIn: parent
                            text: "⏮"
                            font.pixelSize: Theme.fontSizeMedium
                            color: Theme.textPrimary
                        }
                        
                        MouseArea {
                            id: prevMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: musicController.previousSong()
                        }
                    }
                    
                    // Play/Pause button (larger, primary)
                    Rectangle {
                        width: Theme.minTouchTarget + 8
                        height: Theme.minTouchTarget + 8
                        radius: width / 2
                        color: Theme.primary
                        enabled: root.currentSong.hasSong
                        opacity: enabled ? (playMouseArea.pressed ? 0.8 : 1) : 0.5
                        
                        Behavior on opacity {
                            NumberAnimation { duration: Theme.durationFast }
                        }
                        
                        Behavior on scale {
                            NumberAnimation { duration: Theme.durationFast }
                        }
                        
                        scale: playMouseArea.containsMouse ? 1.1 : 1.0
                        
                        Text {
                            anchors.centerIn: parent
                            text: player.playbackState === MediaPlayer.PlayingState ? "⏸" : "▶"
                            font.pixelSize: Theme.fontSizeLarge
                            color: Theme.background
                        }
                        
                        MouseArea {
                            id: playMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (player.playbackState === MediaPlayer.PlayingState)
                                    player.pause()
                                else
                                    player.play()
                            }
                        }
                    }
                    
                    // Next button
                    Rectangle {
                        width: Theme.minTouchTarget - 8
                        height: Theme.minTouchTarget - 8
                        radius: width / 2
                        color: nextMouseArea.containsMouse ? Theme.surfaceElevated : "transparent"
                        
                        Behavior on color {
                            ColorAnimation { duration: Theme.durationFast }
                        }
                        
                        Text {
                            anchors.centerIn: parent
                            text: "⏭"
                            font.pixelSize: Theme.fontSizeMedium
                            color: Theme.textPrimary
                        }
                        
                        MouseArea {
                            id: nextMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: musicController.nextSong()
                        }
                    }
                }
                
                // Time indicators
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: Theme.spacing2
                    
                    Text {
                        text: formatTime(player.position)
                        font.pixelSize: Theme.fontSizeXSmall
                        color: Theme.textSecondary
                    }
                    
                    Text {
                        text: "/"
                        font.pixelSize: Theme.fontSizeXSmall
                        color: Theme.textSecondary
                    }
                    
                    Text {
                        text: formatTime(player.duration)
                        font.pixelSize: Theme.fontSizeXSmall
                        color: Theme.textSecondary
                    }
                }
            }
            
            Item { Layout.fillWidth: true }
            
            // Right: Volume and additional controls
            RowLayout {
                Layout.preferredWidth: 250
                Layout.alignment: Qt.AlignRight
                spacing: Theme.spacing3
                
                // Volume icon
                Text {
                    text: player.audioOutput.volume > 0.5 ? "🔊" : (player.audioOutput.volume > 0 ? "🔉" : "🔇")
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.textSecondary
                }
                
                // Volume slider
                Slider {
                    Layout.preferredWidth: 100
                    from: 0
                    to: 1
                    value: player.audioOutput.volume
                    onValueChanged: player.audioOutput.volume = value
                    
                    background: Rectangle {
                        width: parent.availableWidth
                        height: 4
                        radius: 2
                        color: Theme.surfaceElevated
                        
                        Rectangle {
                            width: parent.width * parent.parent.visualPosition
                            height: parent.height
                            radius: 2
                            color: Theme.primary
                        }
                    }
                    
                    handle: Rectangle {
                        x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                        y: parent.topPadding + parent.availableHeight / 2 - height / 2
                        width: 12
                        height: 12
                        radius: 6
                        color: Theme.primary
                        border.color: Theme.textPrimary
                        border.width: 1
                    }
                }
            }
        }
    }
    
    function formatTime(milliseconds) {
        var seconds = Math.floor(milliseconds / 1000)
        var minutes = Math.floor(seconds / 60)
        seconds = seconds % 60
        return minutes + ":" + (seconds < 10 ? "0" : "") + seconds
    }
}
