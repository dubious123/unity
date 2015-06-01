public with sharing class CommunityFeedNavigationController {

	public Integer MessageUnreadCount { get; set; }
	public Boolean showMessages {
		get {
			Boolean result = true;
			try {
				ConnectApi.ChatterConversationPage cp = ConnectApi.ChatterMessages.getConversations(Network.getNetworkId());
				ConnectApi.UnreadConversationCount unreadCount = ConnectApi.ChatterMessages.getUnreadCount(Network.getNetworkId());
				MessageUnreadCount  = unreadCount.UnreadCount;
			}
			catch (exception e) {
				result = false;
			}
			return result;
		}
	}

	public String chatterGroupId { get; set; }
	public Boolean getShowGroupManager() {
		Boolean result = false;
		if (String.isNotBlank(chatterGroupId)) {
			List<Community_Group_Manager__c> cgmList = [SELECT Id FROM Community_Group_Manager__c WHERE Group_Manager_User__c = :UserInfo.getUserId() AND Group_Control__r.Chatter_Group_ID__c = :chatterGroupId];
			result = cgmList.size() > 0;
		}
		return result;
	}

	// Photo Upload Section
	public Blob photoBody { get; set; }
	public String photoName { get; set; }
	public String photoContentType { get; set; }
	public Boolean uploadMode { get { return uploadMode == NULL ? false : uploadMode; } set; }
	public Integer cropX { get; set; }
	public Integer cropY { get; set; }
	public Integer cropSize { get; set; }

	public String getUserPhotoUrl() {
		return [SELECT FullPhotoUrl FROM User WHERE Id = :UserInfo.getUserId()].FullPhotoUrl;
	}

	public void uploadmode() {
		uploadMode = true;
	}

	public PageReference photoaction() {
		if (photoBody != NULL) {
			ConnectApi.PhotoInput pi = new ConnectApi.PhotoInput();
			pi.cropX = cropX;
			pi.cropY = cropY;
			pi.cropSize = cropSize;
			if(!Test.isRunningTest()){
			ConnectApi.ChatterUsers.setPhotoWithAttributes(
				Network.getNetworkId(),
				UserInfo.getUserId(),
				pi,
				new ConnectApi.BinaryInput(photoBody, photoContentType, photoName)
			);
		}
		}
		PageReference pr = new PageReference(ApexPages.currentPage().getUrl());
		pr.setRedirect(true);
		return pr;
	}
}