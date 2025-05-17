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
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.plasma.plasmoid
// import org.kde.plasma.plasma5support as Plasma5Support

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
		var pattHttp = /^http(s)?:\/\/.*/;
		if(pattHttp.test(loc,false)){
			console.debug("looks like a http(s) url : '"+loc+"'");
			return true;
		}
		var pattFile = /^file:\/\/.*/;
		if(pattFile.test(loc,false)){
			console.debug("looks like a file url : '"+loc+"'");
			return true;
		}
		console.log("FIXME: unknown url scheme : "+loc);
		return loc != "";
	}

	function urlFix(loc) {
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
				console.debug(date+"--------------------------------------------------------------");
				console.log("downloaded "+url);
				callback(response);
			}
		}
		request.open("GET", url);
		request.send();
	}
	
	function isRss(response){
		var contentType = response.contentType.split(";")[0];
		console.debug("         contentType: "+contentType);
		switch(contentType){
			case "application/rss+xml":{
				return true;
			}
		}

		try{
			var xmlRoot = response.request.responseXML.documentElement;
			switch(xmlRoot.nodeName){
				case "rss":
					return true;
				default:
					console.debug("seems to be a xml, but is not a rss document : "+response.url);
			}
		}catch(ex){
			console.debug("failed to parse content like rss+xml");
			console.debug(ex);
		}

		return false;
	}
	function isAtom(response){
		var contentType = response.contentType.split(";")[0];
		console.debug("         contentType: "+contentType);
		switch(contentType){
			case "application/atom+xml":{
				return true;
			}
		}
		
		try{
			var xmlRoot = response.request.responseXML.documentElement;
			switch(xmlRoot.nodeName){
				case "feed":
					return true;
				default:
					console.debug("seems to be a xml, but is not a atom document : "+response.url);
			}
		}catch(ex){
			console.debug("failed to parse content like atom+xml");
			console.debug(ex);
		}
		
		return false;
	}

	function fillListModelFromFeedUrl(url,listModel) {
		console.debug( "download feedModel for "+url);

		busyIndicator.visible=true;
		try{
			sendRequest(url, function(response) {
				let contentType = response.contentType.split(";")[0];
				console.debug("response.contentType: "+response.contentType);
				//console.debug("         contentType: "+contentType);
				try{
					if ( isRss(response) ) {
						parseRssXml(response,listModel);
						return;
					} else if ( isAtom(response) ) {
						parseAtomXml(response,listModel);
						return;
					}
				}catch(ex){
					console.debug("failed to parse content by any method... sorry");
					console.debug(ex);
				}
				
				
				console.debug("unable to parse contentType "+contentType);
				listModel.append({
					"channelTitle" : "unable to parse "+url,
					"channelLink" : url,
					"channelDesc" : "unable to parse "+url,
					"channelTimestamp" : "?",
					"channelLang" : "?",
					"itemTitle": "unable to parse "+url,
					"itemLink": "unable to parse "+url,
					"itemDesc": "unable to parse "+url,
					"itemTimestamp": "unable to parse "+url
				});
			});
		}finally{
			busyIndicator.visible=false;
		}
	}

	function getAttributeValue(element,attributeName){
		for(var i = 0 ; i < element.attributes.length ; i++){
			var attr = element.attributes[i];
			if ( attr.name === attributeName ) return attr.value;
		}
		return null;
	}

	function parseAtomXml(response,listModel){
		console.debug("parsing atom+xml");
		var xmlRoot = response.request.responseXML.documentElement;
		console.debug(" xmlRoot:"+xmlRoot.nodeName);
		var itemIndex=-1;
		switch(xmlRoot.nodeName){
			case "feed":{
				var feedTitle="?";
				var feedTimestamp="?";
				var feedLink="?";
				var feedID="?";
				for (var feedChildIndex = 0 ; feedChildIndex < xmlRoot.childNodes.length ; feedChildIndex++){
					var feedChild = xmlRoot.childNodes[feedChildIndex];
					if(feedChild!=null){
						switch(feedChild.nodeName){
							case "#text":break;
							case "generator":break;
							case "author":break;
							case "rights":break;
							case "id":
								feedID=feedChild.childNodes[0].nodeValue;
								console.debug("  feedID : "+feedID);
								break;
							case "title":
								feedTitle=feedChild.childNodes[0].nodeValue;
								console.debug("  feedTitle : "+feedTitle);
								break;
							case "updated":
								feedTimestamp=feedChild.childNodes[0].nodeValue;
								console.debug("  feedTimestamp : "+feedTimestamp);
								break;
							case "link":
								feedLink=getAttributeValue(feedChild,"href");
								console.debug("  feedLink : "+feedLink);
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
									if(entryChild!=null){
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
												console.debug("    unknown entry child node <"+entryChild.nodeName+">");
										}
									}
								}
								if(listModel.count<=itemIndex){
									//console.debug("append atom item no. "+itemIndex)
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
									//console.debug("update atom item no. "+itemIndex);
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
											console.debug("  unknown feed child element <"+feedChild.nodeName+">");
						}
					}
				}
				break;
			}
			default:
				console.debug("root element's nodeName != feed : <"+xmlRoot.nodeName+">");
		}
		var r1=itemIndex+1;
		var r2=listModel.count-(itemIndex+1);
		//console.debug("listModel.count="+listModel.count+"; itemIndex="+itemIndex+"; r1="+r1+"; r2="+r2);
		if (r2>0) {
			console.debug("truncating listModel");
			listModel.rmeove(r1,r2);
		}
		console.debug(" parsed "+listModel.count+" atom entries.");

		if(listModel.count<=0){
			console.debug("no entries found. appending errors message as feedItem");
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
		console.debug("parsing rss+xml");
		//console.debug(response.content);
		var xmlRoot = response.request.responseXML.documentElement;
		console.debug(" xmlRoot:"+xmlRoot.nodeName);
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
					console.debug("  parsing channel elem "+channelIndex);
					for (var channelChildIndex = 0 ; channelChildIndex < channelElem.childNodes.length ; channelChildIndex++) {
						var channelChild = channelElem.childNodes[channelChildIndex];
						if(channelChild!=null){
							switch(channelChild.nodeName){
								case "#text":
								case "image":
								case "generator":
								case "copyright":
								case "webMaster":
								case "owner":
								case "author":
								case "email":
								case "block":
									//noop
									break;
								case "title":
									try{
										channelTitle=channelChild.childNodes[0].nodeValue;
										console.debug("   channelTitle : "+channelTitle);
									}catch(ex){
										console.debug(ex);
									}
									break;
								case "link":
									try{
										channelLink=channelChild.childNodes[0].nodeValue;
										console.debug("   channelLink : "+channelLink);
									}catch(ex){
										console.debug(ex);
									}
									break;
								case "description":
									try{
										channelDesc=channelChild.childNodes[0].nodeValue;
										console.debug("   channelDesc : "+channelDesc);
									}catch(ex){
										console.debug(ex);
									}
									break;
								case "lastBuildDate":
									try{
										channelTimestamp=channelChild.childNodes[0].nodeValue;
										console.debug("   channelTimestamp : "+channelTimestamp);
									}catch(ex){
										console.debug(ex);
									}
									break;
								case "language":
									try{
										channelLang=channelChild.childNodes[0].nodeValue;
										console.debug("   channelLang : "+channelLang);
									}catch(ex){
										console.debug(ex);
									}
									break;
								case "item":{
									try{
										itemIndex++;
										var itemElem=channelChild;
										var itemTitle="?";
										var itemLink="?";
										var itemDesc="?";
										var itemTimestamp="?";
										for(var itemChildIndex=0 ; itemChildIndex < itemElem.childNodes.length ; itemChildIndex++){
											var itemChild=itemElem.childNodes[itemChildIndex];
											if(itemChild!=null) {
												switch(itemChild.nodeName){
													case "#text":
													case "guid":;
													case "encoded":
													case "creator":
													case "enclosure":
														//noop
														break;
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
														console.debug("    unknown itemChild <"+itemChild.nodeName+">");
												}
											}
										}
										//console.debug("     item : "+itemLink);
										if(listModel.count<=itemIndex){
											//console.debug("append item no. "+itemIndex)
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
											//console.debug("update item no. "+itemIndex);
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
									}catch(ex){
										console.debug("failed to parse "+channelChild);
										console.debug(ex);
									}
									break;
								}
								default: {
									console.debug("unknown channel child <"+channelChild.nodeName+">");
								}
							}
						}
					}
					break;
				}
				case "#text":break;
				default:{
					console.debug("expected childElement <channel> but got <"+channelElem.nodeName+">");
				}
			}
		}
		var r1=itemIndex+1;
		var r2=listModel.count-(itemIndex+1);
		//console.debug("listModel.count="+listModel.count+"; itemIndex="+itemIndex+"; r1="+r1+"; r2="+r2);
		if (r2>0) {
			console.debug("truncating listModel");
			listModel.rmeove(r1,r2);
		}
		console.debug(" parsed "+listModel.count+" rss items.");

		if(listModel.count<=0){
			console.debug("no entries found. appending errors message as feedItem");
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
		console.debug("about to open url '"+url+"'");
		Qt.openUrlExternally(url); //unable to use a custom cmd...
		//this will block. if browsercmd will not return, you cannot open another link :-( //executable.exec("'"+browsercmd+"' '"+url+"'");
	}
	// Plasma5Support.DataSource {
	// 	id: executable
	// 	engine: "executable"
	// 	connectedSources: []
	// 	onNewData: function(source, data) {
	// 		disconnectSource(source)
	// 	}
	//
	// 	function exec(cmd) {
	// 		executable.connectSource(cmd)
	// 	}
	// }

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
			//	console.debug("flipping flick direction")
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
							console.debug("reload triggered after "+refreshInterval+"ms for url '"+feedUrl+"'")
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
		WheelHandler {
			//property: "rotation"
			onWheel: (event)=> {
				//console.debug("rotation", event.angleDelta.y, "scaled", rotation, "@", point.position, "=>", parent.rotation)
				rssFlickable.flick(event.angleDelta.y*10,0)
				if (event.angleDelta.y >=0){
					flickDirection=1
				}else{
					flickDirection=-1
				}
			}
		}
	} //endof Flickable

	BusyIndicator {
		id: busyIndicator
		visible: false
		anchors.centerIn: parent
	}

	

}

