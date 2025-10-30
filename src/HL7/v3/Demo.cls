/// HL7 v3 PRPM_IN406110UV01 解析器演示类
/// 展示如何使用XML解析器
Class HL7.v3.Demo Extends %RegisteredObject
{

/// 演示如何从文件解析XML
ClassMethod ParseFromFile(pFilePath As %String = "")
{
    Write "==========================================", !
    Write "从文件解析 PRPM_IN406110UV01 XML", !
    Write "==========================================", !
    Write !
    
    If pFilePath = "" {
        Write "错误: 请提供XML文件路径", !
        Quit
    }
    
    // 创建解析器实例
    Set parser = ##class(HL7.v3.PRPMIN406110UV01Parser).%New()
    
    // 解析XML文件
    Set status = parser.ParseXMLFile(pFilePath)
    
    If $$$ISERR(status) {
        Write "解析错误: ", $System.Status.GetErrorText(status), !
        Quit
    }
    
    Write "解析成功！", !
    Write !
    
    // 显示所有解析的信息
    Do parser.DisplayAllInfo()
}

/// 演示如何从字符串解析XML
ClassMethod ParseFromString()
{
    Write "==========================================", !
    Write "从字符串解析 PRPM_IN406110UV01 XML", !
    Write "==========================================", !
    Write !
    
    // XML示例字符串
    Set xmlString = ""
    Set xmlString = xmlString _ "<?xml version=""1.0"" encoding=""UTF-8""?>"
    Set xmlString = xmlString _ "<PRPM_IN406110UV01 xmlns=""urn:hl7-org:v3"">"
    Set xmlString = xmlString _ "<id root=""2.16.156.10011.2.5.1.1"" extension=""test-123""/>"
    Set xmlString = xmlString _ "<creationTime value=""20250130122900""/>"
    Set xmlString = xmlString _ "<interactionId root=""2.16.156.10011.2.5.1.2"" extension=""OrganizationInfoQuery""/>"
    Set xmlString = xmlString _ "<processingCode code=""P""/>"
    Set xmlString = xmlString _ "<acceptAckCode code=""AL""/>"
    Set xmlString = xmlString _ "<receiver typeCode=""RCV"">"
    Set xmlString = xmlString _ "<device classCode=""DEV"" determinerCode=""INSTANCE"">"
    Set xmlString = xmlString _ "<id><item root=""2.16.156.10011.2.5.1.3"" extension=""HIP""/></id>"
    Set xmlString = xmlString _ "</device></receiver>"
    Set xmlString = xmlString _ "<sender typeCode=""SND"">"
    Set xmlString = xmlString _ "<device classCode=""DEV"" determinerCode=""INSTANCE"">"
    Set xmlString = xmlString _ "<id><item root=""2.16.156.10011.2.5.1.3"" extension=""LIS""/></id>"
    Set xmlString = xmlString _ "</device></sender>"
    Set xmlString = xmlString _ "</PRPM_IN406110UV01>"
    
    // 创建解析器实例
    Set parser = ##class(HL7.v3.PRPMIN406110UV01Parser).%New()
    
    // 解析XML字符串
    Set status = parser.ParseXMLString(xmlString)
    
    If $$$ISERR(status) {
        Write "解析错误: ", $System.Status.GetErrorText(status), !
        Quit
    }
    
    Write "解析成功！", !
    Write !
    
    // 显示基本信息
    Write "消息ID: ", parser.MessageId, !
    Write "创建时间: ", parser.CreationTime, !
    Write "服务编码: ", parser.InteractionId, !
    Write "接收者: ", parser.GetReceiverCode(), !
    Write "发送者: ", parser.GetSenderCode(), !
}

/// 演示如何解析并提取特定信息
ClassMethod ParseAndExtract(pFilePath As %String = "")
{
    Write "==========================================", !
    Write "解析并提取组织信息", !
    Write "==========================================", !
    Write !
    
    If pFilePath = "" {
        Write "错误: 请提供XML文件路径", !
        Quit
    }
    
    // 创建解析器实例
    Set parser = ##class(HL7.v3.PRPMIN406110UV01Parser).%New()
    
    // 解析XML文件
    Set status = parser.ParseXMLFile(pFilePath)
    
    If $$$ISERR(status) {
        Write "解析错误: ", $System.Status.GetErrorText(status), !
        Quit
    }
    
    // 提取组织信息
    Set orgInfo = parser.GetOrganizationInfo()
    
    Write "【提取的组织信息】", !
    Write "组织ID: ", orgInfo.id, !
    Write "组织名称: ", orgInfo.name, !
    Write "组织类别: ", orgInfo.displayName, !
    Write "联系电话: ", orgInfo.telecom, !
    Write !
    
    // 提取责任者信息
    Set custodianInfo = parser.GetCustodianInfo()
    
    Write "【提取的责任者信息】", !
    Write "姓名: ", custodianInfo.personName, !
    Write "所属科室: ", custodianInfo.orgName, !
    Write "联系人: ", custodianInfo.contactPersonName, !
}

/// 演示如何将解析结果转换为JSON
ClassMethod ParseToJSON(pFilePath As %String = "")
{
    Write "==========================================", !
    Write "解析XML并转换为JSON格式", !
    Write "==========================================", !
    Write !
    
    If pFilePath = "" {
        Write "错误: 请提供XML文件路径", !
        Quit
    }
    
    // 创建解析器实例
    Set parser = ##class(HL7.v3.PRPMIN406110UV01Parser).%New()
    
    // 解析XML文件
    Set status = parser.ParseXMLFile(pFilePath)
    
    If $$$ISERR(status) {
        Write "解析错误: ", $System.Status.GetErrorText(status), !
        Quit
    }
    
    // 构建JSON对象
    Set json = {}
    
    // 基本信息
    Set basicInfo = {}
    Do basicInfo.%Set("messageId", parser.MessageId)
    Do basicInfo.%Set("creationTime", parser.CreationTime)
    Do basicInfo.%Set("interactionId", parser.InteractionId)
    Do basicInfo.%Set("receiver", parser.GetReceiverCode())
    Do basicInfo.%Set("sender", parser.GetSenderCode())
    Do basicInfo.%Set("acknowledgement", parser.GetAcknowledgementStatus())
    Do basicInfo.%Set("queryResponse", parser.GetQueryResponseCode())
    Do json.%Set("basicInfo", basicInfo)
    
    // 组织信息
    Do json.%Set("organizationInfo", parser.GetOrganizationInfo())
    
    // 责任者信息
    Do json.%Set("custodianInfo", parser.GetCustodianInfo())
    
    // 输出JSON
    Write "JSON输出:", !
    Write json.%ToJSON(), !
}

}
