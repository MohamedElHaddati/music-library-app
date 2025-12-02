import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

ToolBar {
    property string currentSongTitle
    property string currentSongArtist
    property string source
    
    MediaPlayer {
        id: player
        source: parent.source
        audioOutput: AudioOutput {}
    }

    RowLayout {
        anchors.fill: parent
        
        ColumnLayout {
            Text { text: currentSongTitle; font.bold: true }
            Text { text: currentSongArtist; font.pixelSize: 10 }
        }
        
        Item { Layout.fillWidth: true }
        
        Button {
            text: player.playbackState === MediaPlayer.PlayingState ? "Pause" : "Play"
            enabled: source !== ""
            onClicked: {
                if (player.playbackState === MediaPlayer.PlayingState)
                    player.pause()
                else
                    player.play()
            }
        }
        
        Button {
            text: "Stop"
            enabled: source !== ""
            onClicked: player.stop()
        }
    }
}
