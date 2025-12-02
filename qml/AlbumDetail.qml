import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: root
    property int albumId: -1
    property string albumTitle: ""
    property string albumCover: ""

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            ToolButton {
                text: "←"
                onClicked: stackView.pop()
            }
            Label {
                text: root.albumTitle
                font.bold: true
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }
            ToolButton {
                text: "Play Album"
                onClicked: musicController.playAlbum(root.albumId)
            }
        }
    }

    ListView {
        anchors.fill: parent
        model: musicController.getAlbumSongs(root.albumId)
        clip: true
        
        delegate: ItemDelegate {
            width: parent.width
            text: modelData.title
            
            onClicked: musicController.playSong(modelData.id)
        }
    }
}
