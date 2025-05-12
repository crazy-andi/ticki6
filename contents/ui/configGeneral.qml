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
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami
import org.kde.kquickcontrols as KQControls

ScrollView {
		id: pageGENERAL
		//	anchors.left: parent.left
		//	anchors.right: parent.right

		property alias cfg_scrollSpeed: scrollSpeed.value
		property alias cfg_scrollWidth: scrollWidth.value

		property alias cfg_feedTitleVisible: feedTitleVisible.checked
		property alias cfg_feedTitleFontColor: feedTitleFontColor.color
		property alias cfg_feedTitleFontSize: feedTitleFontSize.value
		property alias cfg_feedTitleFontFamily: feedTitleFontFamily.text
		property alias cfg_feedTitleFontBold : feedTitleFontBold.checked
		property alias cfg_feedTitleFontItalic : feedTitleFontItalic.checked

		property alias cfg_feedRefreshInterval: feedRefreshInterval.value

		property alias cfg_feedLinkFontColor: feedLinkFontColor.color
		property alias cfg_feedLinkFontSize: feedLinkFontSize.value
		property alias cfg_feedLinkVisible: feedLinkVisible.checked
		property alias cfg_feedLinkFontBold: feedLinkFontBold.checked
		property alias cfg_feedLinkFontItalic: feedLinkFontItalic.checked
		property alias cfg_feedLinkFontFamily: feedLinkFontFamily.text

		property alias cfg_feedDateFontColor: feedDateFontColor.color
		property alias cfg_feedDateFontSize: feedDateFontSize.value
		property alias cfg_feedDateVisible: feedDateVisible.checked
		property alias cfg_feedDateFontBold: feedDateFontBold.checked
		property alias cfg_feedDateFontItalic: feedDateFontItalic.checked
		property alias cfg_feedDateFontFamily: feedDateFontFamily.text

		property alias cfg_feedDescFontColor: feedDescFontColor.color
		property alias cfg_feedDescFontSize: feedDescFontSize.value
		property alias cfg_feedDescVisible: feedDescVisible.checked
		property alias cfg_feedDescFontBold: feedDescFontBold.checked
		property alias cfg_feedDescFontItalic: feedDescFontItalic.checked
		property alias cfg_feedDescFontFamily: feedDescFontFamily.text
		property alias cfg_feedDescWordWrap: feedDescWordWrap.checked
		property alias cfg_feedDescClip: feedDescClip.checked

		property alias cfg_channelTitleFontColor:   channelTitleFontColor.color
		property alias cfg_channelTitleFontSize:    channelTitleFontSize.value
		property alias cfg_channelTitleFontFamily:  channelTitleFontFamily.text
		property alias cfg_channelTitleFontBold :   channelTitleFontBold.checked
		property alias cfg_channelTitleFontItalic : channelTitleFontItalic.checked
		property alias cfg_channelTitleVisible :    channelTitleVisible.checked

		property alias cfg_flickMarginBottom : flickMarginBottom.value
		property alias cfg_flickMarginTop :    flickMarginTop.value
		property alias cfg_flickMarginLeft :   flickMarginLeft.value
		property alias cfg_flickMarginRight :  flickMarginRight.value

		property alias cfg_feedPadding: feedPadding.value

		property alias cfg_separatorVisible: separatorVisible.checked
		property alias cfg_separatorWidth:   separatorWidth.value
		property alias cfg_separatorColor:   separatorColor.color

	Kirigami.FormLayout {

		SpinBox {
			id: scrollSpeed
			Kirigami.FormData.label: i18n("Scroll Tick Interval (ms):")
			from:1
			to:5000
		}
		SpinBox {
			id: scrollWidth
			Kirigami.FormData.label: i18n("Scroll Width:")
			from:1
			to:5000
		}
		SpinBox {
			id: feedRefreshInterval
			Kirigami.FormData.label: i18n("Feed Refresh Interval (sec):")
			from:30
			to:9999
		}
		SpinBox {
			id: feedPadding
			Kirigami.FormData.label: i18n("Space between Feeds (px):")
			from:1
			to:999
		}
		GridLayout {
			Kirigami.FormData.label: i18n("Margins:")
			id: marginsGrid
			columns:3
			RowLayout{
				Layout.column:1
				Layout.row:0
				Label {
					text:"Top:"
					height: flickMarginTop.height
				}
				SpinBox {
					id: flickMarginTop
				}
			}
			RowLayout{
				Layout.column:0
				Layout.row:1
				Label {
					text:i18n("Left:")
					height: flickMarginTop.height
				}
				SpinBox{
					id: flickMarginLeft
				}
			}
			RowLayout {
				Layout.column:2
				Layout.row:1
				Label{
					text:i18n("Right:")
					height: flickMarginTop.height
				}
				SpinBox{
					id: flickMarginRight
				}
			}
			RowLayout {
				Layout.column:1
				Layout.row:2
				Label {
					text:i18n("Bottom:")
					height: flickMarginTop.height
				}
				SpinBox {
					id: flickMarginBottom
				}
			}
		}

		Item { Kirigami.FormData.isSection: true }

		FontDialog {
			id: feedTitleFontDialog
			visible: false
			modality: Qt.WindowModal
			options: FontDialog.ScalableFonts,FontDialog.MonospacedFonts,FontDialog.ProportionalFonts
			title: i18n("Choose a font")
			currentFont: Qt.font({ family: "Arial", pointSize: 24, weight: Font.Normal })
			onCurrentFontChanged: { console.log("CurrentFontChanged: " + currentFont) }
			onAccepted: {
				console.log("Accepted feedTitleFont : " + currentFont)
				feedTitleFontFamily.text=currentFont.family
				feedTitleFontSize.value=currentFont.pointSize
				feedTitleFontBold.checked=currentFont.bold
				feedTitleFontItalic.checked=currentFont.italic
			}
			onRejected: { console.log("Rejected") }
		}
		CheckBox {
			id: feedTitleVisible
			Kirigami.FormData.label: i18n("Title Visible:")
		}
		Row {
			visible: feedTitleVisible.checked
			TextField {
				id:feedTitleFontFamily
				font.family: feedTitleFontFamily.text
				font.bold: feedTitleFontBold.checked
				font.italic: feedTitleFontItalic.checked
				readOnly: true
			}
			SpinBox {
				id: feedTitleFontSize
			}
			Kirigami.FormData.label: i18n("Title Font")
		}
		Row{
			visible: feedTitleVisible.checked
			Button {
				id: feedTitleFontButton
				text: "..."
				onClicked:{
					//feedTitleFontDialog.font = Qt.font({ family: feedTitleFontFamily.text, pointSize: feedTitleFontSize.value, weight: Font.Normal })
					feedTitleFontDialog.currentFont = Qt.font({ family: feedTitleFontFamily.text, pointSize: feedTitleFontSize.value, bold:feedTitleFontBold.checked })
					feedTitleFontDialog.open()
				}
			}
			KQControls.ColorButton {
				id: feedTitleFontColor
				showAlphaChannel: true
			}
			CheckBox {
				id: feedTitleFontBold
				text: "Bold"
				height: feedTitleFontColor.height
			}
			CheckBox {
				id: feedTitleFontItalic
				text: "Italic"
				height: feedTitleFontColor.height
			}
		}

		Item { Kirigami.FormData.isSection: true }

		FontDialog {
			id: feedLinkFontDialog
			visible: false
			modality: Qt.WindowModal
			options: FontDialog.ScalableFonts,FontDialog.MonospacedFonts,FontDialog.ProportionalFonts
			title: i18n("Choose a font")
			currentFont: Qt.font({ family: "Arial", pointSize: 24, weight: Font.Normal })
			onCurrentFontChanged: { console.log("CurrentFontChanged: " + currentFont) }
			onAccepted: {
				console.log("Accepted feedLinkFont : " + currentFont)
				feedLinkFontFamily.text=currentFont.family
				feedLinkFontSize.value=currentFont.pointSize
				feedLinkFontBold.checked=currentFont.bold
				feedLinkFontItalic.checked=currentFont.italic
			}
			onRejected: { console.log("Rejected") }
		}
		CheckBox {
			id: feedLinkVisible
			Kirigami.FormData.label: i18n("Link Visible:")
		}
		Row{
			Kirigami.FormData.label: i18n("Link Font")
			visible: feedLinkVisible.checked
			TextField {
				id: feedLinkFontFamily
				font.family: feedLinkFontFamily.text
				font.bold: feedLinkFontBold.checked
				font.italic: feedLinkFontItalic.checked
				readOnly: true
			}
			SpinBox {
				id: feedLinkFontSize
			}
		}
		Row{
			Button {
				id: feedLinkFontButton
				text: "..."
				onClicked:{
					feedLinkFontDialog.currentFont = Qt.font({ family: feedLinkFontFamily.text, pointSize: feedLinkFontSize.value, bold:feedLinkFontBold.checked })
					feedLinkFontDialog.open()
				}
			}
			visible: feedLinkVisible.checked
			KQControls.ColorButton {
				id: feedLinkFontColor
				showAlphaChannel: true
			}
			CheckBox {
				id: feedLinkFontBold
				text: "Bold"
				height: feedLinkFontColor.height
			}
			CheckBox {
				id: feedLinkFontItalic
				text: "Italic"
				height: feedLinkFontColor.height
			}
		}








		Item { Kirigami.FormData.isSection: true }

		FontDialog {
			id: channelTitleFontDialog
			visible: false
			modality: Qt.WindowModal
			options: FontDialog.ScalableFonts,FontDialog.MonospacedFonts,FontDialog.ProportionalFonts
			title: i18n("Choose a font")
			currentFont: Qt.font({ family: "Arial", pointSize: 24, weight: Font.Normal })
			onCurrentFontChanged: { console.log("CurrentFontChanged: " + currentFont) }
			onAccepted: {
				console.log("Accepted channelTitleFont : " + currentFont)
				.text=currentFont.family
				channelTitleFontSize.value=currentFont.pointSize
				channelTitleFontBold.checked=currentFont.bold
				channelTitleFontItalic.checked=currentFont.italic
			}
			onRejected: { console.log("Rejected") }
		}
		CheckBox {
			id: channelTitleVisible
			Kirigami.FormData.label: i18n("Channel Title Visible:")
		}
		Row{
			Kirigami.FormData.label: i18n("Channel Title Font")
			visible: channelTitleVisible.checked
			TextField {
				id: channelTitleFontFamily
				font.family: channelTitleFontFamily.text
				font.bold: channelTitleFontBold.checked
				font.italic: channelTitleFontItalic.checked
				readOnly: true
			}
			SpinBox {
				id: channelTitleFontSize
			}
		}
		Row{
			visible: channelTitleVisible.checked
			Button {
				id: channelTitleFontButton
				text: "..."
				onClicked:{
					channelTitleFontDialog.currentFont = Qt.font({ family: channelTitleFontFamily.text, pointSize: channelTitleFontSize.value, bold:channelTitleFontBold.checked })
					channelTitleFontDialog.open()
				}
			}
			KQControls.ColorButton {
				id: channelTitleFontColor
				visible: channelTitleVisible.checked
				showAlphaChannel: true
			}
			CheckBox {
				id: channelTitleFontBold
				text: "Bold"
				height: channelTitleFontColor.height
			}
			CheckBox {
				id:channelTitleFontItalic
				text: "Italic"
				height: channelTitleFontColor.height
			}
		}












		Item { Kirigami.FormData.isSection: true }

		FontDialog {
			id: feedDateFontDialog
			visible: false
			modality: Qt.WindowModal
			options: FontDialog.ScalableFonts,FontDialog.MonospacedFonts,FontDialog.ProportionalFonts
			title: i18n("Choose a font")
			currentFont: Qt.font({ family: "Arial", pointSize: 24, weight: Font.Normal })
			onCurrentFontChanged: { console.log("CurrentFontChanged: " + currentFont) }
			onAccepted: {
				console.log("Accepted feedDateFont : " + currentFont)
				feedDateFontFamily.text=currentFont.family
				feedDateFontSize.value=currentFont.pointSize
				feedDateFontBold.checked=currentFont.bold
				feedDateFontItalic.checked=currentFont.italic
			}
			onRejected: { console.log("Rejected") }
		}
		CheckBox {
			id: feedDateVisible
			Kirigami.FormData.label: i18n("Date Visible:")
		}
		Row{
			Kirigami.FormData.label: i18n("Date Font")
			visible: feedDateVisible.checked
			TextField {
				id: feedDateFontFamily
				font.family: feedDateFontFamily.text
				font.bold: feedDateFontBold.checked
				font.italic: feedDateFontItalic.checked
				readOnly: true
			}
			SpinBox {
				id: feedDateFontSize
			}
		}
		Row{
			visible: feedDateVisible.checked
			Button {
				id: feedDateFontButton
				text: "..."
				onClicked:{
					feedDateFontDialog.currentFont = Qt.font({ family: feedDateFontFamily.text, pointSize: feedDateFontSize.value, bold:feedDateFontBold.checked })
					feedDateFontDialog.open()
				}
			}
			KQControls.ColorButton {
				id: feedDateFontColor
				visible: feedDateVisible.checked
				showAlphaChannel: true
			}
			CheckBox {
				id: feedDateFontBold
				text: "Bold"
				height: feedDateFontColor.height
			}
			CheckBox {
				id:feedDateFontItalic
				text: "Italic"
				height: feedDateFontColor.height
			}
		}

		Item { Kirigami.FormData.isSection: true }

		FontDialog {
			id: feedDescFontDialog
			visible: false
			modality: Qt.WindowModal
			options: FontDialog.ScalableFonts,FontDialog.MonospacedFonts,FontDialog.ProportionalFonts
			title: i18n("Choose a font")
			currentFont: Qt.font({ family: "Arial", pointSize: 24, weight: Font.Normal })
			onCurrentFontChanged: { console.log("CurrentFontChanged: " + currentFont) }
			onAccepted: {
				console.log("Accepted feedDescFont : " + currentFont)
				feedDescFontFamily.text=currentFont.family
				feedDescFontSize.value=currentFont.pointSize
				feedDescFontBold.checked=currentFont.bold
				feedDescFontItalic.checked=currentFont.italic
			}
			onRejected: { console.log("Rejected") }
		}
		CheckBox {
			id: feedDescVisible
			Kirigami.FormData.label: i18n("Description Visible:")
		}
		Row{
			visible: feedDescVisible.checked
			Kirigami.FormData.label: i18n("Description Font")
			TextField {
				id:feedDescFontFamily
				font.bold:feedDescFontBold.checked
				font.family:feedDescFontFamily.text
				font.italic: feedDescFontItalic.checked
				readOnly: true
			}
			SpinBox {
				id: feedDescFontSize
			}
		}
		Row{
			visible: feedDescVisible.checked
			Button {
				id: feedDescFontButton
				text: "..."
				onClicked:{
					feedDescFontDialog.currentFont = Qt.font({ family: feedDescFontFamily.text, pointSize: feedDescFontSize.value, bold:feedDescFontBold.checked })
					feedDescFontDialog.open()
				}
			}
			KQControls.ColorButton {
				id: feedDescFontColor
				showAlphaChannel: true
				Kirigami.FormData.label: i18n("Description Font Color:")
			}
			CheckBox{
				id:feedDescFontBold
				text:"Bold"
				height: feedDescFontColor.height
			}
			CheckBox{
				id:feedDescFontItalic
				text:"Italic"
				height: feedDescFontColor.height
			}
		}
		CheckBox{
			id: feedDescWordWrap
			Kirigami.FormData.label: i18n("Description Word Wrap:")
			visible: feedDescVisible.checked
		}
		CheckBox {
			id: feedDescClip
			Kirigami.FormData.label: i18n("Cut Description to Title Width:")
			visible : !feedDescWordWrap.checked && feedDescVisible.checked
		}

		Item { Kirigami.FormData.isSection: true }

		CheckBox {
			id: separatorVisible
			Kirigami.FormData.label: i18n("Separator Visible:")
		}
		SpinBox {
			id: separatorWidth
			Kirigami.FormData.label: i18n("Separator Width:")
			visible: separatorVisible.checked
		}
		KQControls.ColorButton {
			id: separatorColor
			showAlphaChannel: true
			Kirigami.FormData.label: i18n("Separator Color:")
			visible: separatorVisible.checked
		}
	}
}
