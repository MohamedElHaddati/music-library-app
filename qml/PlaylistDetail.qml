import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: root
    property int playlistId: -1
    property string playlistTitle: ""

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            ToolButton {
                text: "←"
                onClicked: stackView.pop()
            }
            Label {
                text: root.playlistTitle
                font.bold: true
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }
            ToolButton {
                text: "Play Playlist"
                onClicked: musicController.playPlaylist(root.playlistId)
            }
        }
    }

    ListView {
        anchors.fill: parent
        model: musicController.getPlaylistSongs(root.playlistId)
        clip: true
        
        delegate: ItemDelegate {
            width: parent.width
            text: modelData.title + " - " + modelData.artist
            
            onClicked: musicController.playSong(modelData.id)
        }
    }
}
