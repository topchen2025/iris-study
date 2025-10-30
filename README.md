# IRIS Study - HL7 v3 PRPM_IN406110UV01 XML解析器

本项目提供了一个用于解析 HL7 v3 PRPM_IN406110UV01 组织信息查询消息的 ObjectScript 实现。

## 项目结构

```
iris-study/
├── src/
│   └── HL7/
│       └── v3/
│           ├── PRPMIN406110UV01Parser.cls  # 主解析器类
│           └── Demo.cls                     # 演示类
├── examples/
│   └── PRPM_IN406110UV01_example.xml       # XML示例文件
└── README.md                                # 本文档
```

## 功能特性

HL7.v3.PRPMIN406110UV01Parser 类提供以下功能：

### 1. XML解析方法

- **ParseXMLString(pXMLString)** - 从XML字符串解析
- **ParseXMLFile(pFilePath)** - 从XML文件解析

### 2. 信息提取方法

- **GetReceiverCode()** - 获取消息接收者编码
- **GetSenderCode()** - 获取消息发送者编码
- **GetOrganizationInfo()** - 获取组织/科室信息（返回JSON对象）
- **GetCustodianInfo()** - 获取责任者信息（返回JSON对象）
- **GetAcknowledgementStatus()** - 获取应答状态
- **GetQueryResponseCode()** - 获取查询响应代码
- **DisplayAllInfo()** - 打印所有解析的信息

### 3. 属性

- **MessageId** - 消息ID
- **CreationTime** - 消息创建时间
- **InteractionId** - 服务编码

## 使用方法

### 方法一：从文件解析

```objectscript
// 创建解析器实例
Set parser = ##class(HL7.v3.PRPMIN406110UV01Parser).%New()

// 解析XML文件
Set status = parser.ParseXMLFile("/path/to/PRPM_IN406110UV01.xml")

If $$$ISERR(status) {
    Write "解析错误: ", $System.Status.GetErrorText(status), !
    Quit
}

// 显示所有信息
Do parser.DisplayAllInfo()

// 或者获取特定信息
Write "消息ID: ", parser.MessageId, !
Write "接收者: ", parser.GetReceiverCode(), !

// 获取组织信息（JSON格式）
Set orgInfo = parser.GetOrganizationInfo()
Write "组织名称: ", orgInfo.name, !
Write "组织电话: ", orgInfo.telecom, !
```

### 方法二：从字符串解析

```objectscript
// 创建解析器实例
Set parser = ##class(HL7.v3.PRPMIN406110UV01Parser).%New()

// XML字符串
Set xmlString = "<?xml version=""1.0""?><PRPM_IN406110UV01>...</PRPM_IN406110UV01>"

// 解析XML字符串
Set status = parser.ParseXMLString(xmlString)

If $$$ISERR(status) {
    Write "解析错误: ", $System.Status.GetErrorText(status), !
    Quit
}

// 获取信息
Write "创建时间: ", parser.CreationTime, !
```

### 使用演示类

项目提供了 `HL7.v3.Demo` 类，包含多个演示方法：

#### 1. 从文件解析并显示所有信息

```objectscript
Do ##class(HL7.v3.Demo).ParseFromFile("/path/to/examples/PRPM_IN406110UV01_example.xml")
```

#### 2. 从字符串解析

```objectscript
Do ##class(HL7.v3.Demo).ParseFromString()
```

#### 3. 解析并提取特定信息

```objectscript
Do ##class(HL7.v3.Demo).ParseAndExtract("/path/to/examples/PRPM_IN406110UV01_example.xml")
```

#### 4. 解析并转换为JSON

```objectscript
Do ##class(HL7.v3.Demo).ParseToJSON("/path/to/examples/PRPM_IN406110UV01_example.xml")
```

## 解析结果示例

### 组织信息对象 (GetOrganizationInfo)

```json
{
  "id": "1234567890",
  "idRoot": "2.16.156.10011.1.26",
  "code": "A03.01",
  "codeSystem": "2.16.156.10011.2.3.2.62",
  "codeSystemName": "医疗卫生机构业务科室分类与代码表",
  "displayName": "呼吸内科专业",
  "name": "11",
  "address": "123",
  "telecom": "13897021787",
  "status": "active",
  "principalOrgName": "呼吸内科1"
}
```

### 责任者信息对象 (GetCustodianInfo)

```json
{
  "personId": "120109197706015518",
  "personIdRoot": "2.16.156.10011.1.4",
  "personName": "李人事",
  "orgId": "xxx12345-X",
  "orgName": "人事科",
  "contactPersonName": "王联系"
}
```

## XML消息结构说明

PRPM_IN406110UV01 消息主要包含以下部分：

1. **基本消息信息**
   - 消息ID (id)
   - 创建时间 (creationTime)
   - 服务编码 (interactionId)
   - 接收者和发送者信息

2. **组织/科室信息** (assignedEntity)
   - 组织标识和代码
   - 组织名称
   - 联系方式
   - 地址
   - 状态

3. **责任者信息** (custodian)
   - 医务人员ID和姓名
   - 所属组织信息
   - 联系人信息

4. **应答信息**
   - 应答状态 (acknowledgement)
   - 查询响应代码 (queryResponseCode)

## 在 InterSystems IRIS 中导入

### 方法1: 使用 Management Portal

1. 打开 IRIS Management Portal
2. 进入 System Explorer > Classes
3. 点击 Import
4. 选择 `src/HL7/v3/` 目录下的 `.cls` 文件
5. 点击 Import Selected 完成导入

### 方法2: 使用终端命令

```objectscript
// 在 IRIS 终端中执行
Do $System.OBJ.LoadDir("/path/to/iris-study/src/HL7/v3/", "ck")
```

### 方法3: 使用 VSCode + ObjectScript 插件

1. 安装 InterSystems ObjectScript 插件
2. 配置连接到 IRIS 实例
3. 右键点击 `src` 文件夹
4. 选择 "Import and Compile"

## 测试示例

```objectscript
// 完整测试流程
Set parser = ##class(HL7.v3.PRPMIN406110UV01Parser).%New()
Set status = parser.ParseXMLFile("/path/to/examples/PRPM_IN406110UV01_example.xml")

If $$$ISOK(status) {
    Write "✓ 解析成功", !
    Write "消息ID: ", parser.MessageId, !
    Write "创建时间: ", parser.CreationTime, !
    Write "服务编码: ", parser.InteractionId, !
    
    Set orgInfo = parser.GetOrganizationInfo()
    Write "组织信息: ", orgInfo.%ToJSON(), !
    
    Set custInfo = parser.GetCustodianInfo()
    Write "责任者信息: ", custInfo.%ToJSON(), !
} Else {
    Write "✗ 解析失败: ", $System.Status.GetErrorText(status), !
}
```

## 注意事项

1. 确保 XML 文件编码为 UTF-8
2. XML 必须符合 HL7 v3 PRPM_IN406110UV01 标准格式
3. 文件路径需要使用绝对路径或相对于 IRIS 实例的路径
4. 解析前需要检查 XML 文件是否存在和可读

## 扩展开发

如需扩展解析器功能，可以：

1. 添加新的提取方法到 `PRPMIN406110UV01Parser.cls`
2. 实现数据验证方法
3. 添加数据持久化功能（保存到数据库）
4. 实现 XML 生成功能（从对象生成 XML）

## 许可证

本项目用于学习和研究目的。

## 贡献

欢迎提交 Issue 和 Pull Request。
