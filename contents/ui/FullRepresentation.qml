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

import QtQuick 2.7
import QtQuick 2.15 as QtQuick214
import QtQuick.Layouts 1.1
import QtQml.XmlListModel
import QtQuick.Window 2.2
import QtQuick.Controls 2.15
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasma5support as Plasma5Support

Item {
	anchors.fill: parent
	Layout.fillWidth: true
	Layout.fillHeight: true
	Layout.preferredWidth: 5000
	Plasmoid.constraintHints: Plasmoid.CanFillArea

	property int    refreshInterval : 1000 * plasmoid.configuration.feedRefreshInterval
	property int    flickInterval : plasmoid.configuration.scrollSpeed
	property int    flickWidth : plasmoid.configuration.scrollWidth
	property int    flickDirection : -1
	property bool   flickEnabled : true

	property bool   feedTitleVisible : plasmoid.configuration.feedTitleVisible
	property color  feedTitleFontColor : plasmoid.configuration.feedTitleFontColor
	property int    feedTitleFontSize : plasmoid.configuration.feedTitleFontSize
	property string feedTitleFontFamily : plasmoid.configuration.feedTitleFontFamily
	property bool   feedTitleFontBold: plasmoid.configuration.feedTitleFontBold
	property bool   feedTitleFontItalic: plasmoid.configuration.feedTitleFontItalic

	property color  feedLinkFontColor : plasmoid.configuration.feedLinkFontColor
	property int    feedLinkFontSize : plasmoid.configuration.feedLinkFontSize
	property bool   feedLinkVisible : plasmoid.configuration.feedLinkVisible
	property bool   feedLinkFontBold : plasmoid.configuration.feedLinkFontBold
	property bool   feedLinkFontItalic : plasmoid.configuration.feedLinkFontItalic
	property string feedLinkFontFamily : plasmoid.configuration.feedLinkFontFamily

	property color  feedDateFontColor : plasmoid.configuration.feedDateFontColor
	property int    feedDateFontSize : plasmoid.configuration.feedDateFontSize
	property bool   feedDateVisible : plasmoid.configuration.feedDateVisible
	property bool   feedDateFontBold : plasmoid.configuration.feedDateFontBold
	property bool   feedDateFontItalic : plasmoid.configuration.feedDateFontItalic
	property string feedDateFontFamily : plasmoid.configuration.feedDateFontFamily

	property color  feedDescFontColor : plasmoid.configuration.feedDescFontColor
	property int    feedDescFontSize : plasmoid.configuration.feedDescFontSize
	property bool   feedDescVisible : plasmoid.configuration.feedDescVisible
	property bool   feedDescFontBold : plasmoid.configuration.feedDescFontBold
	property bool   feedDescFontItalic : plasmoid.configuration.feedDescFontItalic
	property bool   feedDescClip : plasmoid.configuration.feedDescClip
	property bool   feedDescWordWrap : plasmoid.configuration.feedDescWordWrap
	property string feedDescFontFamily : plasmoid.configuration.feedDescFontFamily

	property color  channelTitleFontColor : plasmoid.configuration.channelTitleFontColor
	property int    channelTitleFontSize : plasmoid.configuration.channelTitleFontSize
	property string channelTitleFontFamily : plasmoid.configuration.channelTitleFontFamily
	property bool   channelTitleFontBold: plasmoid.configuration.channelTitleFontBold
	property bool   channelTitleFontItalic: plasmoid.configuration.channelTitleFontItalic
	property bool   channelTitleVisible: plasmoid.configuration.channelTitleVisible

	property int    feedPadding : plasmoid.configuration.feedPadding

	property int    channelThumbnailSize : 50
	property bool   channelThumbnailsVisible : true
	property bool   channelThumbnailsRound : true

	property int    flickMarginTop :   plasmoid.configuration.flickMarginTop
	property int    flickMarginBottom :   plasmoid.configuration.flickMarginBottom
	property int    flickMarginLeft :   plasmoid.configuration.flickMarginLeft
	property int    flickMarginRight :   plasmoid.configuration.flickMarginRight

	property bool   separatorVisible : plasmoid.configuration.separatorVisible
	property color  separatorColor : plasmoid.configuration.separatorColor
	property int    separatorWidth : plasmoid.configuration.separatorWidth

	property variant urls: plasmoid.configuration.urlList.split('\n').filter(validUrl).map(urlFix)
	property string  browsercmd: plasmoid.configuration.browser

	function stripString (str) {
		str = str.trim();
		var regex = /(<img.*?>)/gi;
		str = str.replace(regex, "");
		regex = /&#228;/gi;
		str = str.replace(regex, "ä");
		regex = /&#246;/gi;
		str = str.replace(regex, "ö");
		regex = /&#252;/gi;
		str = str.replace(regex, "ü");
		regex = /&#196;/gi;
		str = str.replace(regex, "Ä");
		regex = /&#214;/gi;
		str = str.replace(regex, "Ö");
		regex = /&#220;/gi;
		str = str.replace(regex, "Ü");
		regex = /&#223;/gi;
		str = str.replace(regex, "ß");
		
		return str;
	}
	function validUrl(loc) {
		console.log("FIXME: about to validate url : "+loc);
		// FIXME
		return loc != "";
	}

	function urlFix(loc) {
		console.log("FIXME: about to fix url : "+loc);
		// FIXME
		return loc;
	}

	function sendRequest(url, callback)	{
		//found @ https://doc.qt.io/qt-6/qml-qtqml-xmlhttprequest.html
		let request = new XMLHttpRequest();
		request.onreadystatechange = function() {
			if (request.readyState === XMLHttpRequest.DONE) {
				let response = {
					url : url,
					request : request,
					status : request.status,
					headers : request.getAllResponseHeaders(),
					responseType : request.responseType,
					contentType : request.getResponseHeader("content-type"),
					content : request.response
				};
				var date = new Date();
				console.log(date+"--------------------------------------------------------------");
				console.log("downloaded "+url);
				callback(response);
			}
		}
		request.open("GET", url);
		request.send();
	}

	function fillListModelFromFeedUrl(url,listModel) {
		console.log( "download feedModel for "+url);

		busyIndicator.visible=true;
		sendRequest(url, function(response) {
							let contentType = response.contentType.split(";")[0];
							console.log("response.contentType: "+response.contentType);
							//console.log("         contentType: "+contentType);
							switch(contentType){
								case "application/rss+xml":{
									parseRssXml(response,listModel);
									return;
								}
								case "application/atom+xml":{
									parseAtomXml(response,listModel);
									return;
								}
							}
							//no usable contentType from server.
							//checking content
							//FIXME!



							console.log("unable to parse contentType "+contentType);
							listModel.append({
								"channelTitle" : "unable to parse "+url,
								"channelLink" : "unable to parse "+url,
								"channelDesc" : "unable to parse "+url,
								"channelTimestamp" : "unable to parse "+url,
								"channelLang" : "unable to parse "+url,
								"itemTitle": "unable to parse "+url,
								"itemLink": "unable to parse "+url,
								"itemDesc": "unable to parse "+url,
								"itemTimestamp": "unable to parse "+url
							});
		});
		busyIndicator.visible=false;
	}

	function getAttributeValue(element,attributeName){
		for(var i = 0 ; i < element.attributes.length ; i++){
			var attr = element.attributes[i];
			if ( attr.name === attributeName ) return attr.value;
		}
		return null;
	}

	function parseAtomXml(response,listModel){
		console.log("parsing atom+xml");
		var xmlRoot = response.request.responseXML.documentElement;
		console.log(" xmlRoot:"+xmlRoot.nodeName);
		var itemIndex=-1;
		switch(xmlRoot.nodeName){
			case "feed":{
				var feedTitle="?";
				var feedTimestamp="?";
				var feedLink="?";
				var feedID="?";
				for (var feedChildIndex = 0 ; feedChildIndex < xmlRoot.childNodes.length ; feedChildIndex++){
					var feedChild = xmlRoot.childNodes[feedChildIndex];
					switch(feedChild.nodeName){
						case "#text":break;
						case "generator":break;
						case "author":break;
						case "rights":break;
						case "id":
							feedID=feedChild.childNodes[0].nodeValue;
							console.log("  feedID : "+feedID);
							break;
						case "title":
							feedTitle=feedChild.childNodes[0].nodeValue;
							console.log("  feedTitle : "+feedTitle);
							break;
						case "updated":
							feedTimestamp=feedChild.childNodes[0].nodeValue;
							console.log("  feedTimestamp : "+feedTimestamp);
							break;
						case "link":
							feedLink=getAttributeValue(feedChild,"href");
							console.log("  feedLink : "+feedLink);
							break;
						case "entry":{
							itemIndex++;
							var entryTitle = "?";
							var entryID = "?";
							var entryLink = "?";
							var entryUpdated = "?";
							var entrySummary = "?";
							var entryContent = "?";
							var entryPublished = "?";
							for (var entryChildIndex=0 ; entryChildIndex < feedChild.childNodes.length ; entryChildIndex++){
								var entryChild = feedChild.childNodes[entryChildIndex];
								switch(entryChild.nodeName){
									case "#text":break;
									case "id":break;
									case "title":
										entryTitle=entryChild.childNodes[0].nodeValue;
										break;
									case "link":
										entryLink=getAttributeValue(entryChild,"href");
										break;
									case "updated":
										entryUpdated=entryChild.childNodes[0].nodeValue;
										break;
									case "summary":
										entrySummary=entryChild.childNodes[0].nodeValue;
										break;
									case "content":
										entryContent=entryChild.childNodes[0].nodeValue;
										break;
									case "published":
										entryPublished=entryChild.childNodes[0].nodeValue;
										break;
									default :
										console.log("    unknown entry child node <"+entryChild.nodeName+">");
								}
							}
							if(listModel.count<=itemIndex){
								//console.log("append atom item no. "+itemIndex)
								listModel.append({
									"channelTitle" : feedTitle,
									"channelLink" : feedLink,
									"channelDesc" : "?",
									"channelTimestamp" : feedTimestamp,
									"channelLang" : "?",
									"itemTitle": entryTitle,
									"itemLink": entryLink,
									"itemDesc": entrySummary,
									"itemTimestamp": entryUpdated
								});
							}else{
								//console.log("update atom item no. "+itemIndex);
								listModel.setProperty(itemIndex, "channelTitle", feedTitle);
								listModel.setProperty(itemIndex, "channelLink", feedLink);
								listModel.setProperty(itemIndex, "channelDesc", "?");
								listModel.setProperty(itemIndex, "channelTimestamp", feedTimestamp);
								listModel.setProperty(itemIndex, "channelLang", "?");
								listModel.setProperty(itemIndex, "itemTitle", entryTitle);
								listModel.setProperty(itemIndex, "itemLink", entryLink);
								listModel.setProperty(itemIndex, "itemDesc", entrySummary);
								listModel.setProperty(itemIndex, "itemTimestamp", entryUpdated);
							}
							break;
						}
						default:
							console.log("  unknown feed child element <"+feedChild.nodeName+">");
					}
				}
				break;
			}
			default:
				console.log("root element's nodeName != feed : <"+xmlRoot.nodeName+">");
		}
		var r1=itemIndex+1;
		var r2=listModel.count-(itemIndex+1);
		//console.log("listModel.count="+listModel.count+"; itemIndex="+itemIndex+"; r1="+r1+"; r2="+r2);
		if (r2>0) {
			console.log("truncating listModel");
			listModel.rmeove(r1,r2);
		}
		console.log(" parsed "+listModel.count+" atom entries.");

		if(listModel.count<=0){
			console.log("no entries found. appending errors message as feedItem");
			listModel.append({
				"channelTitle" : feedTitle,
				"channelLink" : feedLink,
				"channelDesc" : "?",
				"channelTimestamp" : feedTimestamp,
				"channelLang" : "?",
				"itemTitle": response.url+": no items",
				"itemLink": response.url+": no items",
				"itemDesc": response.url+": no items",
				"itemTimestamp": response.url+": no items"
			});
		}
	}

	function parseRssXml(response,listModel){
		console.log("parsing rss+xml");
		//console.log(response.content);
		var xmlRoot = response.request.responseXML.documentElement;
		console.log(" xmlRoot:"+xmlRoot.nodeName);
		//crawl channels...
		var itemIndex=-1;
		for(var channelIndex = 0 ; channelIndex < xmlRoot.childNodes.length ; channelIndex++){
			var channelElem = xmlRoot.childNodes[channelIndex];
			switch(channelElem.nodeName){
				case "channel":{
					var channelTitle = "?";
					var channelLink = "?";
					var channelDesc = "?";
					var channelTimestamp = "?";
					var channelLang = "?";
					console.log("  parsing channel elem "+channelIndex);
					for (var channelChildIndex = 0 ; channelChildIndex < channelElem.childNodes.length ; channelChildIndex++) {
						var channelChild = channelElem.childNodes[channelChildIndex];
						switch(channelChild.nodeName){
							case "#text":
								//noop
								break;
							case "title":
								channelTitle=channelChild.childNodes[0].nodeValue;
								console.log("   channelTitle : "+channelTitle);
								break;
							case "link":
								channelLink=channelChild.childNodes[0].nodeValue;
								console.log("   channelLink : "+channelLink);
								break;
							case "description":
								channelDesc=channelChild.childNodes[0].nodeValue;
								console.log("   channelDesc : "+channelDesc);
								break;
							case "lastBuildDate":
								channelTimestamp=channelChild.childNodes[0].nodeValue;
								console.log("   channelTimestamp : "+channelTimestamp);
								break;
							case "language":
								channelLang=channelChild.childNodes[0].nodeValue;
								console.log("   channelLang : "+channelLang);
								break;
							case "item":{
								itemIndex++;
								var itemElem=channelChild;
								var itemTitle="?";
								var itemLink="?";
								var itemDesc="?";
								var itemTimestamp="?";
								for(var itemChildIndex=0 ; itemChildIndex < itemElem.childNodes.length ; itemChildIndex++){
									var itemChild=itemElem.childNodes[itemChildIndex];
									switch(itemChild.nodeName){
										case "#text":break;
										case "guid":break;
										case "encoded":break;
										case "title":
											itemTitle=itemChild.childNodes[0].nodeValue;
											break;
										case "link":
											itemLink=itemChild.childNodes[0].nodeValue;
											break;
										case "description":
											itemDesc=itemChild.childNodes[0].nodeValue;
											break;
										case "pubDate":
											itemTimestamp=itemChild.childNodes[0].nodeValue;
											break;
										default:
											console.log("    unknown itemChild <"+itemChild.nodeName+">");
									}
								}
								//console.log("     item : "+itemLink);
								if(listModel.count<=itemIndex){
									//console.log("append item no. "+itemIndex)
									listModel.append({
										"channelTitle" : channelTitle,
										"channelLink" : channelLink,
										"channelDesc" : channelDesc,
										"channelTimestamp" : channelTimestamp,
										"channelLang" : channelLang,
										"itemTitle": itemTitle,
										"itemLink": itemLink,
										"itemDesc": itemDesc,
										"itemTimestamp": itemTimestamp
									});
								}else{
									//console.log("update item no. "+itemIndex);
									listModel.setProperty(itemIndex, "channelTitle", channelTitle);
									listModel.setProperty(itemIndex, "channelLink", channelLink);
									listModel.setProperty(itemIndex, "channelDesc", channelDesc);
									listModel.setProperty(itemIndex, "channelTimestamp", channelTimestamp);
									listModel.setProperty(itemIndex, "channelLang", channelLang);
									listModel.setProperty(itemIndex, "itemTitle", itemTitle);
									listModel.setProperty(itemIndex, "itemLink", itemLink);
									listModel.setProperty(itemIndex, "itemDesc", itemDesc);
									listModel.setProperty(itemIndex, "itemTimestamp", itemTimestamp);
								}
								break;
							}
							default: {
								console.log("unknown channel child <"+channelChild.nodeName+">");
							}
						}
					}
					break;
				}
				case "#text":break;
				default:{
					console.log("expected childElement <channel> but got <"+channelElem.nodeName+">");
				}
			}
		}
		var r1=itemIndex+1;
		var r2=listModel.count-(itemIndex+1);
		//console.log("listModel.count="+listModel.count+"; itemIndex="+itemIndex+"; r1="+r1+"; r2="+r2);
		if (r2>0) {
			console.log("truncating listModel");
			listModel.rmeove(r1,r2);
		}
		console.log(" parsed "+listModel.count+" rss items.");

		if(listModel.count<=0){
			console.log("no entries found. appending errors message as feedItem");
			listModel.append({
				"channelTitle" : channelTitle,
				"channelLink" : channelLink,
				"channelDesc" : channelDesc,
				"channelTimestamp" : channelTimestamp,
				"channelLang" : channelLang,
				"itemTitle": response.url+": no items",
				"itemLink": response.url+": no items",
				"itemDesc": response.url+": no items",
				"itemTimestamp": response.url+": no items"
			});
		}
	}


	function openUrl(url){
		console.log("about to open url '"+url+"'");
		Qt.openUrlExternally(url); //unable to use a custom cmd...
		//this will block. if browsercmd will not return, you cannot open another link :-( //executable.exec("'"+browsercmd+"' '"+url+"'");
	}
	Plasma5Support.DataSource {
		id: executable
		engine: "executable"
		connectedSources: []
		onNewData: function(source, data) {
			disconnectSource(source)
		}

		function exec(cmd) {
			executable.connectSource(cmd)
		}
	}
	Timer {
		id: flickTimer
		interval: flickInterval
		running: flickEnabled
		repeat:true
		onTriggered: {
			rssFlickable.flick(flickWidth*flickDirection,0)
			//console.debug("contentWidth:"+rssFlickable.contentWidth+"; flickable.width:"+rssFlickable.width)
			//console.debug("flick from "+rssFlickable.contentX+" by "+(flickWidth*flickDirection) +" end:"+rssFlickable.atXEnd )
			if( (rssFlickable.atXEnd && flickDirection<=0) || (rssFlickable.atXBeginning && flickDirection>0) ){
				flickDirection = flickDirection * -1
			//	console.log("flipping flick direction")
			}

		}
	}


	Flickable{
		id: rssFlickable
		clip: true
		width: parent.width
		anchors {
			left: parent.left
			right: parent.right
			top: parent.top
			bottom: parent.bottom
			leftMargin: flickMarginLeft
			rightMargin: flickMarginRight
			topMargin: flickMarginTop
			bottomMargin: flickMarginBottom
		}
		interactive: true
		flickableDirection: Flickable.HorizontalFlick
		contentHeight: urlsRow.height
		contentWidth: urlsRow.width

		Row {
			id: urlsRow
			spacing: 30
			Repeater {
				id: rssRepeater
				model: urls
				Row {
					id: feedRow
					spacing: feedPadding
					property string feedUrl: modelData
					// Label {
					// 	text: "feedUrl: " + feedUrl
					// }


					ListModel {
						id: feedModel
						Component.onCompleted: fillListModelFromFeedUrl(feedUrl,feedModel)
					}

					Timer {
						id: refreshTimer
						interval: refreshInterval
						running: true
						repeat: true
						onTriggered: {
							console.log("reload triggered after "+refreshInterval+"ms for url '"+feedUrl+"'")
							//feedModel.clear()
							fillListModelFromFeedUrl(feedUrl,feedModel)
						}
					}

					Repeater {
						id: feedRepeater
						model: feedModel
						delegate: Item{
							id: feedItemCell
							width: feedItemColumn.width+(separatorVisible?spacerColumn.width:0)
							height:feedItemColumn.height
							Row{
								Column { //feedItem
									id:feedItemColumn
									spacing:0
									width: ((!feedDescVisible || feedDescWordWrap || feedDescClip) ? lblItemTitle.width : Math.max(lblItemDesc.width,lblItemTitle.width))
									Row{
										id: firstLineRow
										spacing:10
										Label{
											id: lblChannelTitle
											text: channelTitle
											color: channelTitleFontColor
											visible: channelTitleVisible
											font.bold: channelTitleFontBold
											font.italic: channelTitleFontItalic
											font.pixelSize: channelTitleFontSize
											font.family: channelTitleFontFamily
											anchors.verticalCenter: parent.verticalCenter
										}
										Label{
											id: lblItemTimestamp
											text: itemTimestamp
											color: feedDateFontColor
											visible: feedDateVisible
											font.bold:feedDateFontBold
											font.italic: feedDateFontItalic
											font.family: feedDateFontFamily
											font.pixelSize: feedDateFontSize
											anchors.verticalCenter: parent.verticalCenter
											//font.underline: feedLinkMouseArea.containsMouse || feedTitleMouseArea.containsMouse || feedDescMouseArea.containsMouse || feedDateMouseArea.containsMouse
										}
									}//endof row
									Label{
										id: lblItemTitle
										text: itemTitle
										color: feedTitleFontColor
										visible: feedTitleVisible
										font.bold: feedTitleFontBold
										font.italic: feedTitleFontItalic
										font.family: feedTitleFontFamily
										font.pixelSize : feedTitleFontSize
										font.underline: feedItemCellMouseArea.containsMouse
									}
									Label{
										id: lblItemLink
										text: itemLink
										color: feedLinkFontColor
										visible: feedLinkVisible
										width: lblItemTitle.width
										clip: true
										font.family: feedLinkFontFamily
										font.bold: feedLinkFontBold
										font.italic: feedLinkFontItalic
										font.underline: feedItemCellMouseArea.containsMouse
										font.pixelSize: feedLinkFontSize
									}
									Label{
										id: lblItemDesc
										Layout.fillWidth: true;
										//text: itemDesc
										text : stripString(itemDesc).trim()
										visible: feedDescVisible
										wrapMode : feedDescWordWrap ? Text.WordWrap: Text.NoWrap
										width: feedDescWordWrap || feedDescClip ? lblItemTitle.width : contentWidth
										color: feedDescFontColor
										clip: feedDescClip
										font.bold: feedDescFontBold
										font.italic: feedDescFontItalic
										font.family: feedDescFontFamily
										font.pixelSize : feedDescFontSize
										//font.underline: feedItemCellMouseArea.containsMouse
									} //endof lblItemDesc

								}//endof feedItemColumn

								Column{
									id: spacerColumn
									visible: separatorVisible
									spacing:0
									Row{
										Rectangle{
											id: spacerRect0
											width: feedPadding
											height: feedItemCell.height
											color: "transparent"
										}
										Rectangle{
											id: seperatorRect
											width: separatorWidth
											height: feedItemCell.height
											color: separatorColor
										}
									}
								}
							}
							MouseArea {
								id: feedItemCellMouseArea
								anchors.fill: parent
								hoverEnabled: true
								onEntered:flickEnabled=false
								onExited:flickEnabled=true
								onClicked: openUrl(itemLink)
							}

						} //endof feedItemCell
					}
				}
			}
		}
	} //endof Flickable

	BusyIndicator {
		id: busyIndicator
		visible: false
		anchors.centerIn: parent
	}

	Text {
		id: errorInfo
		text: "hu! some error occured"
		anchors.centerIn: parent
		anchors.fill: parent
		clip: true
		color: "red"
		font.bold: true
		font.pixelSize: 20
		visible: false
	}


	QtQuick214.WheelHandler {
		//property: "rotation"
		onWheel: (event)=> {
			//console.log("rotation", event.angleDelta.y, "scaled", rotation, "@", point.position, "=>", parent.rotation)
			rssFlickable.flick(event.angleDelta.y*10,0)
			if (event.angleDelta.y >=0){
				flickDirection=1
			}else{
				flickDirection=-1
			}
		}
	}
}

