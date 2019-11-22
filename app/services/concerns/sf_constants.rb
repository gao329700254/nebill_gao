module SfConstants
  SF_PROJECTS                       = :tsl__PcProject__c
  SF_PROJECT_ID                     = :Id
  SF_PROJECT_NAME                   = :Name
  SF_PROJECT_CD                     = :tsl__Code__c
  SF_PROJECT_START_DATE             = :tsl__StartDate__c
  SF_PROJECT_END_DATE               = :tsl__EndDate__c
  SF_PROJECT_PERIOD_UNIT            = :tsl__PeriodUnit__c # 期間単位
  SF_PROJECT_MANDAYS_UNIT           = :tsl__MandaysUnit__c # 工数入力単位
  SF_PROJECT_GROSS_MARGIN_RATE_PLAN = :tsl__GrossMarginRatePlan__c # 目標粗利率

  SF_PROJECTDETAILS           = :tsl__PcProjectDetail__c
  SF_PROJECTDETAIL_PROJECT_ID = :tsl__ProjectId__c
  SF_PROJECTDETAIL_START_DATE = :tsl__StartDate__c

  SF_WORKITEMS           = :tsl__PcWorkItem__c
  SF_WORKITEM_PROJECT_ID = :tsl__ProjectId__c
  SF_WORKITEM_NAME       = :Name

  SF_WORKITEMDETAILS                  = :tsl__PcWorkItemDetail__c
  SF_WORKITEMDETAIL_WORKITEM_ID       = :tsl__WorkItemId__c
  SF_WORKITEMDETAIL_START_DATE        = :tsl__StartDate__c
  SF_WORKITEMDETAIL_END_DATE          = :tsl__EndDate__c
  SF_WORKITEMDETAIL_RESOURCE_ID       = :tsl__ResourceId__c
  SF_WORKITEMDETAIL_RANK_ID           = :tsl__RankId__c
  SF_WORKITEMDETAIL_PROJECT_DETAIL_ID = :tsl__ProjectDetailId__c

  SF_RESOURCES     = :tsl__PcResource__c
  SF_RESOURCE_NAME = :Name
end
