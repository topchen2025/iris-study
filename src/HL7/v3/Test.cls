/// 测试类 - 用于验证PRPM_IN406110UV01Parser的功能
Class HL7.v3.Test Extends %RegisteredObject
{

/// 运行所有测试
ClassMethod RunAll()
{
    Write "==========================================", !
    Write "运行 PRPM_IN406110UV01Parser 测试套件", !
    Write "==========================================", !
    Write !
    
    Set totalTests = 0
    Set passedTests = 0
    
    // 测试1: 基本解析功能
    Set totalTests = totalTests + 1
    If ..TestBasicParsing() {
        Set passedTests = passedTests + 1
        Write "✓ 测试1: 基本解析功能 - 通过", !
    } Else {
        Write "✗ 测试1: 基本解析功能 - 失败", !
    }
    Write !
    
    // 测试2: 组织信息提取
    Set totalTests = totalTests + 1
    If ..TestOrganizationInfo() {
        Set passedTests = passedTests + 1
        Write "✓ 测试2: 组织信息提取 - 通过", !
    } Else {
        Write "✗ 测试2: 组织信息提取 - 失败", !
    }
    Write !
    
    // 测试3: 责任者信息提取
    Set totalTests = totalTests + 1
    If ..TestCustodianInfo() {
        Set passedTests = passedTests + 1
        Write "✓ 测试3: 责任者信息提取 - 通过", !
    } Else {
        Write "✗ 测试3: 责任者信息提取 - 失败", !
    }
    Write !
    
    // 测试4: 从字符串解析
    Set totalTests = totalTests + 1
    If ..TestStringParsing() {
        Set passedTests = passedTests + 1
        Write "✓ 测试4: 字符串解析 - 通过", !
    } Else {
        Write "✗ 测试4: 字符串解析 - 失败", !
    }
    Write !
    
    // 测试5: 消息路由信息
    Set totalTests = totalTests + 1
    If ..TestMessageRouting() {
        Set passedTests = passedTests + 1
        Write "✓ 测试5: 消息路由信息 - 通过", !
    } Else {
        Write "✗ 测试5: 消息路由信息 - 失败", !
    }
    Write !
    
    Write "==========================================", !
    Write "测试总结: ", passedTests, "/", totalTests, " 通过", !
    If passedTests = totalTests {
        Write "状态: ✓ 所有测试通过", !
    } Else {
        Write "状态: ✗ 部分测试失败", !
    }
    Write "==========================================", !
    
    Quit (passedTests = totalTests)
}

/// 测试基本解析功能
ClassMethod TestBasicParsing() As %Boolean [ Private ]
{
    Try {
        Set xml = ..GetTestXML()
        Set parser = ##class(HL7.v3.PRPMIN406110UV01Parser).%New()
        Set status = parser.ParseXMLString(xml)
        
        If $$$ISERR(status) {
            Write "  解析XML失败", !
            Return 0
        }
        
        // 验证基本属性
        If parser.MessageId '= "3bfb7b91-ab19-49e8-bf70-1843e42d01fe" {
            Write "  MessageId不匹配: ", parser.MessageId, !
            Return 0
        }
        
        If parser.CreationTime '= "20170106151903" {
            Write "  CreationTime不匹配: ", parser.CreationTime, !
            Return 0
        }
        
        If parser.InteractionId '= "OrganizationInfoQuery" {
            Write "  InteractionId不匹配: ", parser.InteractionId, !
            Return 0
        }
        
        Return 1
        
    } Catch ex {
        Write "  异常: ", ex.DisplayString(), !
        Return 0
    }
}

/// 测试组织信息提取
ClassMethod TestOrganizationInfo() As %Boolean [ Private ]
{
    Try {
        Set xml = ..GetTestXML()
        Set parser = ##class(HL7.v3.PRPMIN406110UV01Parser).%New()
        Do parser.ParseXMLString(xml)
        
        Set orgInfo = parser.GetOrganizationInfo()
        
        If '$IsObject(orgInfo) {
            Write "  无法获取组织信息对象", !
            Return 0
        }
        
        // 验证组织ID
        If orgInfo.id '= "1234567890" {
            Write "  组织ID不匹配: ", orgInfo.id, !
            Return 0
        }
        
        // 验证组织代码
        If orgInfo.code '= "A03.01" {
            Write "  组织代码不匹配: ", orgInfo.code, !
            Return 0
        }
        
        // 验证联系电话
        If orgInfo.telecom '= "13897021787" {
            Write "  联系电话不匹配: ", orgInfo.telecom, !
            Return 0
        }
        
        // 验证状态
        If orgInfo.status '= "active" {
            Write "  状态不匹配: ", orgInfo.status, !
            Return 0
        }
        
        Return 1
        
    } Catch ex {
        Write "  异常: ", ex.DisplayString(), !
        Return 0
    }
}

/// 测试责任者信息提取
ClassMethod TestCustodianInfo() As %Boolean [ Private ]
{
    Try {
        Set xml = ..GetTestXML()
        Set parser = ##class(HL7.v3.PRPMIN406110UV01Parser).%New()
        Do parser.ParseXMLString(xml)
        
        Set custInfo = parser.GetCustodianInfo()
        
        If '$IsObject(custInfo) {
            Write "  无法获取责任者信息对象", !
            Return 0
        }
        
        // 验证人员ID
        If custInfo.personId '= "120109197706015518" {
            Write "  人员ID不匹配: ", custInfo.personId, !
            Return 0
        }
        
        // 验证人员姓名
        If custInfo.personName '= "李人事" {
            Write "  人员姓名不匹配: ", custInfo.personName, !
            Return 0
        }
        
        // 验证组织名称
        If custInfo.orgName '= "人事科" {
            Write "  组织名称不匹配: ", custInfo.orgName, !
            Return 0
        }
        
        // 验证联系人
        If custInfo.contactPersonName '= "王联系" {
            Write "  联系人不匹配: ", custInfo.contactPersonName, !
            Return 0
        }
        
        Return 1
        
    } Catch ex {
        Write "  异常: ", ex.DisplayString(), !
        Return 0
    }
}

/// 测试字符串解析
ClassMethod TestStringParsing() As %Boolean [ Private ]
{
    Try {
        Set xml = "<?xml version=""1.0"" encoding=""UTF-8""?>"
        Set xml = xml _ "<PRPM_IN406110UV01 xmlns=""urn:hl7-org:v3"">"
        Set xml = xml _ "<id root=""2.16.156.10011.2.5.1.1"" extension=""test-123""/>"
        Set xml = xml _ "<creationTime value=""20250130000000""/>"
        Set xml = xml _ "<interactionId root=""2.16.156.10011.2.5.1.2"" extension=""TestService""/>"
        Set xml = xml _ "</PRPM_IN406110UV01>"
        
        Set parser = ##class(HL7.v3.PRPMIN406110UV01Parser).%New()
        Set status = parser.ParseXMLString(xml)
        
        If $$$ISERR(status) {
            Write "  字符串解析失败", !
            Return 0
        }
        
        If parser.MessageId '= "test-123" {
            Write "  MessageId不匹配: ", parser.MessageId, !
            Return 0
        }
        
        If parser.InteractionId '= "TestService" {
            Write "  InteractionId不匹配: ", parser.InteractionId, !
            Return 0
        }
        
        Return 1
        
    } Catch ex {
        Write "  异常: ", ex.DisplayString(), !
        Return 0
    }
}

/// 测试消息路由信息
ClassMethod TestMessageRouting() As %Boolean [ Private ]
{
    Try {
        Set xml = ..GetTestXML()
        Set parser = ##class(HL7.v3.PRPMIN406110UV01Parser).%New()
        Do parser.ParseXMLString(xml)
        
        // 验证接收者
        Set receiver = parser.GetReceiverCode()
        If receiver '= "HIP" {
            Write "  接收者不匹配: ", receiver, !
            Return 0
        }
        
        // 验证发送者
        Set sender = parser.GetSenderCode()
        If sender '= "LIS" {
            Write "  发送者不匹配: ", sender, !
            Return 0
        }
        
        // 验证应答状态
        Set ackStatus = parser.GetAcknowledgementStatus()
        If ackStatus '= "AA" {
            Write "  应答状态不匹配: ", ackStatus, !
            Return 0
        }
        
        // 验证查询响应
        Set queryCode = parser.GetQueryResponseCode()
        If queryCode '= "OK" {
            Write "  查询响应不匹配: ", queryCode, !
            Return 0
        }
        
        Return 1
        
    } Catch ex {
        Write "  异常: ", ex.DisplayString(), !
        Return 0
    }
}

/// 获取测试用的XML数据（简化版）
ClassMethod GetTestXML() As %String [ Private ]
{
    Set xml = "<?xml version=""1.0"" encoding=""UTF-8""?>"
    Set xml = xml _ "<PRPM_IN406110UV01 xmlns=""urn:hl7-org:v3"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"">"
    Set xml = xml _ "<id root=""2.16.156.10011.2.5.1.1"" extension=""3bfb7b91-ab19-49e8-bf70-1843e42d01fe""/>"
    Set xml = xml _ "<creationTime value=""20170106151903""/>"
    Set xml = xml _ "<interactionId root=""2.16.156.10011.2.5.1.2"" extension=""OrganizationInfoQuery""/>"
    Set xml = xml _ "<processingCode code=""P""/>"
    Set xml = xml _ "<acceptAckCode code=""AL""/>"
    Set xml = xml _ "<receiver typeCode=""RCV"">"
    Set xml = xml _ "<device classCode=""DEV"" determinerCode=""INSTANCE"">"
    Set xml = xml _ "<id><item root=""2.16.156.10011.2.5.1.3"" extension=""HIP""/></id>"
    Set xml = xml _ "</device></receiver>"
    Set xml = xml _ "<sender typeCode=""SND"">"
    Set xml = xml _ "<device classCode=""DEV"" determinerCode=""INSTANCE"">"
    Set xml = xml _ "<id><item root=""2.16.156.10011.2.5.1.3"" extension=""LIS""/></id>"
    Set xml = xml _ "</device></sender>"
    Set xml = xml _ "<acknowledgement typeCode=""AA"">"
    Set xml = xml _ "<targetMessage><id root=""2.16.156.10011.2.5.1.1"" extension=""8D73520B-D489-4B70-8F4B-7B5C2D7961BQ""/></targetMessage>"
    Set xml = xml _ "<acknowledgementDetail><text value=""处理结果说明""/></acknowledgementDetail>"
    Set xml = xml _ "</acknowledgement>"
    Set xml = xml _ "<controlActProcess classCode=""CACT"" moodCode=""EVN"">"
    Set xml = xml _ "<subject typeCode=""SUBJ"">"
    Set xml = xml _ "<registrationEvent classCode=""REG"" moodCode=""EVN"">"
    Set xml = xml _ "<statusCode code=""active""/>"
    Set xml = xml _ "<subject1 typeCode=""SBJ"">"
    Set xml = xml _ "<assignedEntity classCode=""ASSIGNED"">"
    Set xml = xml _ "<id><item root=""2.16.156.10011.1.26"" extension=""1234567890""/></id>"
    Set xml = xml _ "<code code=""A03.01"" codeSystem=""2.16.156.10011.2.3.2.62"" codeSystemName=""医疗卫生机构业务科室分类与代码表"">"
    Set xml = xml _ "<displayName value=""呼吸内科专业""/></code>"
    Set xml = xml _ "<name xsi:type=""LIST_EN""><item><part value=""11""/></item></name>"
    Set xml = xml _ "<addr xsi:type=""DSET_AD""><item><part value=""123""/></item></addr>"
    Set xml = xml _ "<telecom xsi:type=""DSET_TEL""><item value=""13897021787""/></telecom>"
    Set xml = xml _ "<statusCode code=""active""/>"
    Set xml = xml _ "<assignedPrincipalOrganization classCode=""ORG"" determinerCode=""INSTANCE"">"
    Set xml = xml _ "<name xsi:type=""LIST_EN""><item><part value=""呼吸内科1""/></item></name>"
    Set xml = xml _ "</assignedPrincipalOrganization>"
    Set xml = xml _ "</assignedEntity>"
    Set xml = xml _ "</subject1>"
    Set xml = xml _ "<custodian typeCode=""CST"">"
    Set xml = xml _ "<assignedEntity classCode=""ASSIGNED"">"
    Set xml = xml _ "<id><item root=""2.16.156.10011.1.4"" extension=""120109197706015518""/></id>"
    Set xml = xml _ "<assignedPerson classCode=""PSN"" determinerCode=""INSTANCE"">"
    Set xml = xml _ "<name xsi:type=""LIST_EN""><item><part value=""李人事""/></item></name>"
    Set xml = xml _ "</assignedPerson>"
    Set xml = xml _ "<representedOrganization classCode=""ORG"" determinerCode=""INSTANCE"">"
    Set xml = xml _ "<id><item root=""2.16.156.10011.1.26"" extension=""xxx12345-X""/></id>"
    Set xml = xml _ "<name xsi:type=""LIST_EN""><item><part value=""人事科""/></item></name>"
    Set xml = xml _ "<contactParty classCode=""CON"">"
    Set xml = xml _ "<contactPerson classCode=""PSN"" determinerCode=""INSTANCE"">"
    Set xml = xml _ "<name xsi:type=""LIST_EN""><item><part value=""王联系""/></item></name>"
    Set xml = xml _ "</contactPerson></contactParty>"
    Set xml = xml _ "</representedOrganization>"
    Set xml = xml _ "</assignedEntity>"
    Set xml = xml _ "</custodian>"
    Set xml = xml _ "</registrationEvent>"
    Set xml = xml _ "</subject>"
    Set xml = xml _ "<queryAck><queryResponseCode code=""OK""/></queryAck>"
    Set xml = xml _ "</controlActProcess>"
    Set xml = xml _ "</PRPM_IN406110UV01>"
    
    Quit xml
}

}
