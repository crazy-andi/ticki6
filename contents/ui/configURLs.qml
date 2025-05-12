/*
This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, see <https://www.gnu.org/licenses/>.
*/

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
//import org.kde.kirigami as Kirigami


ColumnLayout {
  id: configItem
    property alias cfg_urlList: urlList.text
    // property alias cfg_browser: browser.text
//     QQC2.Label {
//         text: i18n("Open URLs with")
// //        Layout.alignment: Qt.AlignTop
// //        color: theme.textColor
//     }
//
//     QQC2.TextField {
//         id: browser
//         Layout.fillWidth: true
//     }

    QQC2.Label {
        text: i18n("Feed-URLs (RSS/Atom) (one per line)")
        Layout.alignment: Qt.AlignTop
//        color: theme.textColor
    }

    QQC2.TextArea {
        id: urlList
        Layout.fillWidth: true
        Layout.minimumWidth: parent.width
        Layout.fillHeight: true
    }
}


/*
Kirigami.FormLayout {
    id: pageURLS
    anchors.fill: parent
    
    property alias cfg_urlList: urlList.text
    property alias cfg_browser: browser.text
    
    Text {
        text: i18n("Open URLs with")
        Layout.alignment: Qt.AlignTop
        color: theme.textColor
    }
    
    TextField {
        id: browser
        Layout.fillWidth: true
    }

    Text {
        text: i18n("URLs (one per line)")
        Layout.alignment: Qt.AlignTop
        color: theme.textColor
    }
    
    TextArea {
        id: urlList
        Layout.fillWidth: true
        Layout.minimumWidth: parent.width
        Layout.fillHeight: true
    }
}
*/
