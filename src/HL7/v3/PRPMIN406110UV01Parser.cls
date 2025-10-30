/// HL7 v3 PRPM_IN406110UV01 XML消息解析器
/// 用于解析医疗卫生机构（科室）组织信息查询消息
Class HL7.v3.PRPMIN406110UV01Parser Extends %RegisteredObject
{

/// XML文档对象
Property XMLDoc As %XML.Document;

/// 消息ID
Property MessageId As %String;

/// 消息创建时间
Property CreationTime As %String;

/// 服务编码
Property InteractionId As %String;

/// 解析XML字符串
/// pXMLString - 输入的XML字符串
/// 返回：成功返回1，失败返回0
Method ParseXMLString(pXMLString As %String) As %Status
{
    Set tSC = $$$OK
    Try {
        // 创建XML文档对象
        Set ..XMLDoc = ##class(%XML.Document).%New()
        
        // 加载XML字符串
        Set tSC = ..XMLDoc.ParseString(pXMLString)
        If $$$ISERR(tSC) Quit
        
        // 解析基本信息
        Set tSC = ..ParseBasicInfo()
        
    } Catch ex {
        Set tSC = ex.AsStatus()
    }
    
    Quit tSC
}

/// 从XML文件解析
/// pFilePath - XML文件路径
/// 返回：成功返回1，失败返回0
Method ParseXMLFile(pFilePath As %String) As %Status
{
    Set tSC = $$$OK
    Try {
        // 创建XML文档对象
        Set ..XMLDoc = ##class(%XML.Document).%New()
        
        // 从文件加载XML
        Set tSC = ..XMLDoc.ParseFile(pFilePath)
        If $$$ISERR(tSC) Quit
        
        // 解析基本信息
        Set tSC = ..ParseBasicInfo()
        
    } Catch ex {
        Set tSC = ex.AsStatus()
    }
    
    Quit tSC
}

/// 解析基本消息信息
Method ParseBasicInfo() As %Status [ Private ]
{
    Set tSC = $$$OK
    Try {
        // 获取根节点
        Do ..XMLDoc.GetDocumentElement(.root)
        If '$IsObject(root) {
            Set tSC = $$$ERROR($$$GeneralError, "无法获取XML根节点")
            Quit
        }
        
        // 解析消息ID
        Set idNode = root.GetElementsByTagName("id").GetAt(1)
        If $IsObject(idNode) {
            Set ..MessageId = idNode.GetAttribute("extension")
        }
        
        // 解析创建时间
        Set creationNode = root.GetElementsByTagName("creationTime").GetAt(1)
        If $IsObject(creationNode) {
            Set ..CreationTime = creationNode.GetAttribute("value")
        }
        
        // 解析服务编码
        Set interactionNode = root.GetElementsByTagName("interactionId").GetAt(1)
        If $IsObject(interactionNode) {
            Set ..InteractionId = interactionNode.GetAttribute("extension")
        }
        
    } Catch ex {
        Set tSC = ex.AsStatus()
    }
    
    Quit tSC
}

/// 获取消息接收者编码
Method GetReceiverCode() As %String
{
    Set result = ""
    Try {
        Do ..XMLDoc.GetDocumentElement(.root)
        If '$IsObject(root) Quit
        
        Set receiverList = root.GetElementsByTagName("receiver")
        If receiverList.Size > 0 {
            Set receiver = receiverList.GetAt(1)
            Set idList = receiver.GetElementsByTagName("item")
            If idList.Size > 0 {
                Set idItem = idList.GetAt(1)
                Set result = idItem.GetAttribute("extension")
            }
        }
    } Catch ex {
        Write "Error: ", ex.DisplayString(), !
    }
    
    Quit result
}

/// 获取消息发送者编码
Method GetSenderCode() As %String
{
    Set result = ""
    Try {
        Do ..XMLDoc.GetDocumentElement(.root)
        If '$IsObject(root) Quit
        
        Set senderList = root.GetElementsByTagName("sender")
        If senderList.Size > 0 {
            Set sender = senderList.GetAt(1)
            Set idList = sender.GetElementsByTagName("item")
            If idList.Size > 0 {
                Set idItem = idList.GetAt(1)
                Set result = idItem.GetAttribute("extension")
            }
        }
    } Catch ex {
        Write "Error: ", ex.DisplayString(), !
    }
    
    Quit result
}

/// 获取组织/科室信息
/// 返回：一个包含组织信息的%DynamicObject对象
Method GetOrganizationInfo() As %DynamicObject
{
    Set result = {}
    Try {
        Do ..XMLDoc.GetDocumentElement(.root)
        If '$IsObject(root) Quit
        
        // 查找assignedEntity节点
        Set entityList = root.GetElementsByTagName("assignedEntity")
        If entityList.Size > 0 {
            Set entity = entityList.GetAt(1)
            
            // 获取组织ID
            Set idList = entity.GetElementsByTagName("item")
            If idList.Size > 0 {
                Set idItem = idList.GetAt(1)
                Do result.%Set("id", idItem.GetAttribute("extension"))
                Do result.%Set("idRoot", idItem.GetAttribute("root"))
            }
            
            // 获取组织类别代码
            Set codeList = entity.GetElementsByTagName("code")
            If codeList.Size > 0 {
                Set codeNode = codeList.GetAt(1)
                Do result.%Set("code", codeNode.GetAttribute("code"))
                Do result.%Set("codeSystem", codeNode.GetAttribute("codeSystem"))
                Do result.%Set("codeSystemName", codeNode.GetAttribute("codeSystemName"))
                
                // 获取显示名称
                Set displayList = codeNode.GetElementsByTagName("displayName")
                If displayList.Size > 0 {
                    Set displayNode = displayList.GetAt(1)
                    Do result.%Set("displayName", displayNode.GetAttribute("value"))
                }
            }
            
            // 获取组织名称
            Set nameList = entity.GetElementsByTagName("name")
            If nameList.Size > 0 {
                Set nameNode = nameList.GetAt(1)
                Set partList = nameNode.GetElementsByTagName("part")
                If partList.Size > 0 {
                    Set partNode = partList.GetAt(1)
                    Do result.%Set("name", partNode.GetAttribute("value"))
                }
            }
            
            // 获取地址
            Set addrList = entity.GetElementsByTagName("addr")
            If addrList.Size > 0 {
                Set addrNode = addrList.GetAt(1)
                Set partList = addrNode.GetElementsByTagName("part")
                If partList.Size > 0 {
                    Set partNode = partList.GetAt(1)
                    Do result.%Set("address", partNode.GetAttribute("value"))
                }
            }
            
            // 获取联系电话
            Set telecomList = entity.GetElementsByTagName("telecom")
            If telecomList.Size > 0 {
                Set telecomNode = telecomList.GetAt(1)
                Set itemList = telecomNode.GetElementsByTagName("item")
                If itemList.Size > 0 {
                    Set itemNode = itemList.GetAt(1)
                    Do result.%Set("telecom", itemNode.GetAttribute("value"))
                }
            }
            
            // 获取状态代码
            Set statusList = entity.GetElementsByTagName("statusCode")
            If statusList.Size > 0 {
                Set statusNode = statusList.GetAt(1)
                Do result.%Set("status", statusNode.GetAttribute("code"))
            }
            
            // 获取上级组织信息
            Set orgList = entity.GetElementsByTagName("assignedPrincipalOrganization")
            If orgList.Size > 0 {
                Set orgNode = orgList.GetAt(1)
                Set nameList = orgNode.GetElementsByTagName("name")
                If nameList.Size > 0 {
                    Set nameNode = nameList.GetAt(1)
                    Set partList = nameNode.GetElementsByTagName("part")
                    If partList.Size > 0 {
                        Set partNode = partList.GetAt(1)
                        Do result.%Set("principalOrgName", partNode.GetAttribute("value"))
                    }
                }
            }
        }
    } Catch ex {
        Write "Error: ", ex.DisplayString(), !
    }
    
    Quit result
}

/// 获取责任者（医务人员）信息
/// 返回：一个包含责任者信息的%DynamicObject对象
Method GetCustodianInfo() As %DynamicObject
{
    Set result = {}
    Try {
        Do ..XMLDoc.GetDocumentElement(.root)
        If '$IsObject(root) Quit
        
        // 查找custodian节点
        Set custodianList = root.GetElementsByTagName("custodian")
        If custodianList.Size > 0 {
            Set custodian = custodianList.GetAt(1)
            
            // 获取责任者信息
            Set entityList = custodian.GetElementsByTagName("assignedEntity")
            If entityList.Size > 0 {
                Set entity = entityList.GetAt(1)
                
                // 获取医务人员ID
                Set idList = entity.GetElementsByTagName("item")
                If idList.Size > 0 {
                    Set idItem = idList.GetAt(1)
                    Do result.%Set("personId", idItem.GetAttribute("extension"))
                    Do result.%Set("personIdRoot", idItem.GetAttribute("root"))
                }
                
                // 获取人员姓名
                Set personList = entity.GetElementsByTagName("assignedPerson")
                If personList.Size > 0 {
                    Set person = personList.GetAt(1)
                    Set nameList = person.GetElementsByTagName("name")
                    If nameList.Size > 0 {
                        Set nameNode = nameList.GetAt(1)
                        Set partList = nameNode.GetElementsByTagName("part")
                        If partList.Size > 0 {
                            Set partNode = partList.GetAt(1)
                            Do result.%Set("personName", partNode.GetAttribute("value"))
                        }
                    }
                }
                
                // 获取所属组织信息
                Set orgList = entity.GetElementsByTagName("representedOrganization")
                If orgList.Size > 0 {
                    Set org = orgList.GetAt(1)
                    
                    // 组织ID
                    Set orgIdList = org.GetElementsByTagName("item")
                    If orgIdList.Size > 0 {
                        Set orgIdItem = orgIdList.GetAt(1)
                        Do result.%Set("orgId", orgIdItem.GetAttribute("extension"))
                    }
                    
                    // 组织名称
                    Set orgNameList = org.GetElementsByTagName("name")
                    If orgNameList.Size > 0 {
                        Set orgNameNode = orgNameList.GetAt(1)
                        Set partList = orgNameNode.GetElementsByTagName("part")
                        If partList.Size > 0 {
                            Set partNode = partList.GetAt(1)
                            Do result.%Set("orgName", partNode.GetAttribute("value"))
                        }
                    }
                    
                    // 联系人信息
                    Set contactList = org.GetElementsByTagName("contactPerson")
                    If contactList.Size > 0 {
                        Set contact = contactList.GetAt(1)
                        Set contactNameList = contact.GetElementsByTagName("name")
                        If contactNameList.Size > 0 {
                            Set contactNameNode = contactNameList.GetAt(1)
                            Set partList = contactNameNode.GetElementsByTagName("part")
                            If partList.Size > 0 {
                                Set partNode = partList.GetAt(1)
                                Do result.%Set("contactPersonName", partNode.GetAttribute("value"))
                            }
                        }
                    }
                }
            }
        }
    } Catch ex {
        Write "Error: ", ex.DisplayString(), !
    }
    
    Quit result
}

/// 获取应答状态
Method GetAcknowledgementStatus() As %String
{
    Set result = ""
    Try {
        Do ..XMLDoc.GetDocumentElement(.root)
        If '$IsObject(root) Quit
        
        Set ackList = root.GetElementsByTagName("acknowledgement")
        If ackList.Size > 0 {
            Set ack = ackList.GetAt(1)
            Set result = ack.GetAttribute("typeCode")
        }
    } Catch ex {
        Write "Error: ", ex.DisplayString(), !
    }
    
    Quit result
}

/// 获取查询响应代码
Method GetQueryResponseCode() As %String
{
    Set result = ""
    Try {
        Do ..XMLDoc.GetDocumentElement(.root)
        If '$IsObject(root) Quit
        
        Set codeList = root.GetElementsByTagName("queryResponseCode")
        If codeList.Size > 0 {
            Set codeNode = codeList.GetAt(1)
            Set result = codeNode.GetAttribute("code")
        }
    } Catch ex {
        Write "Error: ", ex.DisplayString(), !
    }
    
    Quit result
}

/// 打印所有解析的信息（用于演示）
Method DisplayAllInfo()
{
    Write "==========================================", !
    Write "HL7 v3 PRPM_IN406110UV01 消息解析结果", !
    Write "==========================================", !
    Write !
    
    Write "【基本消息信息】", !
    Write "消息ID: ", ..MessageId, !
    Write "创建时间: ", ..CreationTime, !
    Write "服务编码: ", ..InteractionId, !
    Write "接收者: ", ..GetReceiverCode(), !
    Write "发送者: ", ..GetSenderCode(), !
    Write "应答状态: ", ..GetAcknowledgementStatus(), !
    Write "查询响应: ", ..GetQueryResponseCode(), !
    Write !
    
    Write "【组织/科室信息】", !
    Set orgInfo = ..GetOrganizationInfo()
    Write "组织ID: ", orgInfo.id, !
    Write "组织代码: ", orgInfo.code, !
    Write "代码系统: ", orgInfo.codeSystemName, !
    Write "显示名称: ", orgInfo.displayName, !
    Write "组织名称: ", orgInfo.name, !
    Write "地址: ", orgInfo.address, !
    Write "联系电话: ", orgInfo.telecom, !
    Write "状态: ", orgInfo.status, !
    Write "上级组织: ", orgInfo.principalOrgName, !
    Write !
    
    Write "【责任者信息】", !
    Set custodianInfo = ..GetCustodianInfo()
    Write "人员ID: ", custodianInfo.personId, !
    Write "人员姓名: ", custodianInfo.personName, !
    Write "所属组织ID: ", custodianInfo.orgId, !
    Write "所属组织名称: ", custodianInfo.orgName, !
    Write "联系人: ", custodianInfo.contactPersonName, !
    Write !
    Write "==========================================", !
}

}
