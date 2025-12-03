import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import MusicManager

Rectangle {
    id: root
    height: AppTheme.playerControlsHeight
    color: AppTheme.surface
    
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
            color: AppTheme.surfaceElevated
            
            Rectangle {
                width: parent.width * (player.duration > 0 ? player.position / player.duration : 0)
                height: parent.height
                color: AppTheme.primary
                
                Behavior on width {
                    NumberAnimation { duration: 100 }
                }
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: function(mouse) {
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
            Layout.margins: AppTheme.spacing3
            spacing: AppTheme.spacing4
            
            // Left: Current song info with album art
            RowLayout {
                Layout.preferredWidth: 250
                spacing: AppTheme.spacing3
                
                // Album artwork thumbnail
                Rectangle {
                    width: 56
                    height: 56
                    radius: AppTheme.radiusSmall
                    color: AppTheme.surfaceElevated
                    
                    Text {
                        anchors.centerIn: parent
                        text: "♫"
                        font.pixelSize: AppTheme.fontSizeLarge
                        color: AppTheme.textSecondary
                    }
                }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: AppTheme.spacing1
                    
                    Text { 
                        text: root.currentSong.title || "No song playing"
                        font.pixelSize: AppTheme.fontSizeBody
                        font.bold: true 
                        color: AppTheme.textPrimary
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    Text { 
                        text: root.currentSong.artist || "---"
                        font.pixelSize: AppTheme.fontSizeSmall
                        color: AppTheme.textSecondary
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }
            }
            
            Item { Layout.fillWidth: true }
            
            // Center: Playback controls
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: AppTheme.spacing2
                
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: AppTheme.spacing3
                    
                    // Previous button
                    Rectangle {
                        width: AppTheme.minTouchTarget - 8
                        height: AppTheme.minTouchTarget - 8
                        radius: width / 2
                        color: prevMouseArea.containsMouse ? AppTheme.surfaceElevated : "transparent"
                        
                        Behavior on color {
                            ColorAnimation { duration: AppTheme.durationFast }
                        }
                        
                        Text {
                            anchors.centerIn: parent
                            text: "◀◀"
                            font.pixelSize: AppTheme.fontSizeMedium
                            color: AppTheme.textPrimary
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
                        width: AppTheme.minTouchTarget + 8
                        height: AppTheme.minTouchTarget + 8
                        radius: width / 2
                        color: AppTheme.primary
                        enabled: root.currentSong.hasSong
                        opacity: enabled ? (playMouseArea.pressed ? 0.8 : 1) : 0.5
                        
                        Behavior on opacity {
                            NumberAnimation { duration: AppTheme.durationFast }
                        }
                        
                        Behavior on scale {
                            NumberAnimation { duration: AppTheme.durationFast }
                        }
                        
                        scale: playMouseArea.containsMouse ? 1.1 : 1.0
                        
                        Text {
                            anchors.centerIn: parent
                            text: player.playbackState === MediaPlayer.PlayingState ? "||" : "▶"
                            font.pixelSize: AppTheme.fontSizeMedium
                            font.bold: true
                            color: AppTheme.background
                        }
                        
                        MouseArea {
                            id: playMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (player.playbackState === MediaPlayer.PlayingState) {
                                    player.pause()
                                } else {
                                    player.play()
                                }
                            }
                        }
                    }
                    
                    // Next button
                    Rectangle {
                        width: AppTheme.minTouchTarget - 8
                        height: AppTheme.minTouchTarget - 8
                        radius: width / 2
                        color: nextMouseArea.containsMouse ? AppTheme.surfaceElevated : "transparent"
                        
                        Behavior on color {
                            ColorAnimation { duration: AppTheme.durationFast }
                        }
                        
                        Text {
                            anchors.centerIn: parent
                            text: "▶▶"
                            font.pixelSize: AppTheme.fontSizeMedium
                            color: AppTheme.textPrimary
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
                    spacing: AppTheme.spacing2
                    
                    Text {
                        text: formatTime(player.position)
                        font.pixelSize: AppTheme.fontSizeXSmall
                        color: AppTheme.textSecondary
                    }
                    
                    Text {
                        text: "/"
                        font.pixelSize: AppTheme.fontSizeXSmall
                        color: AppTheme.textSecondary
                    }
                    
                    Text {
                        text: formatTime(player.duration)
                        font.pixelSize: AppTheme.fontSizeXSmall
                        color: AppTheme.textSecondary
                    }
                }
            }
            
            Item { Layout.fillWidth: true }
            
            // Right: Volume and additional controls
            RowLayout {
                Layout.preferredWidth: 250
                Layout.alignment: Qt.AlignRight
                spacing: AppTheme.spacing3
                
                // Volume icon
                Text {
                    text: player.audioOutput.volume > 0.5 ? "🔊" : (player.audioOutput.volume > 0 ? "🔉" : "🔇")
                    font.pixelSize: AppTheme.fontSizeMedium
                    color: AppTheme.textSecondary
                }
                
                // Volume slider
                Slider {
                    Layout.preferredWidth: 100
                    from: 0
                    to: 1
                    value: player.audioOutput.volume
                    onValueChanged: player.audioOutput.volume = value
                    
                    background: Rectangle {
                        x: parent.leftPadding
                        y: parent.topPadding + parent.availableHeight / 2 - height / 2
                        width: parent.availableWidth
                        height: 4
                        radius: 2
                        color: AppTheme.surfaceElevated
                        
                        Rectangle {
                            width: parent.width * parent.parent.visualPosition
                            height: parent.height
                            color: AppTheme.primary
                            radius: 2
                        }
                    }
                    
                    handle: Rectangle {
                        x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                        y: parent.topPadding + parent.availableHeight / 2 - height / 2
                        width: 12
                        height: 12
                        radius: 6
                        color: AppTheme.primary
                        border.color: AppTheme.textPrimary
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
