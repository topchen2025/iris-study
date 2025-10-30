# 安装和部署指南

本指南介绍如何在 InterSystems IRIS 中安装和使用 PRPM_IN406110UV01 XML 解析器。

## 前置要求

- InterSystems IRIS 2020.1 或更高版本
- 对 IRIS 实例的访问权限（能够导入和编译类）
- （可选）VSCode + InterSystems ObjectScript 插件用于开发

## 安装方法

### 方法 1: 使用 Management Portal（推荐用于生产环境）

#### 步骤 1: 下载源代码

```bash
git clone https://github.com/topchen2025/iris-study.git
cd iris-study
```

#### 步骤 2: 访问 Management Portal

1. 打开浏览器访问：`http://localhost:52773/csp/sys/UtilHome.csp`
2. 使用管理员账户登录（默认：SuperUser/SYS）

#### 步骤 3: 选择命名空间

1. 在左侧菜单选择 **System Explorer > Classes**
2. 在顶部选择你想使用的命名空间（例如：USER）

#### 步骤 4: 导入类文件

1. 点击 **Import** 按钮
2. 点击 **Browse** 选择文件
3. 导航到 `src/HL7/v3/` 目录
4. 选择所有 `.cls` 文件：
   - `PRPMIN406110UV01Parser.cls`
   - `Demo.cls`
   - `Test.cls`
5. 点击 **Import Selected**
6. 选择 **Compile** 选项
7. 点击 **Go**

#### 步骤 5: 验证安装

在终端中运行：

```objectscript
Do ##class(HL7.v3.Test).RunAll()
```

### 方法 2: 使用终端命令（推荐用于快速部署）

#### 步骤 1: 进入 IRIS 终端

```bash
iris session IRIS
```

或者在 Management Portal 中打开终端：System Explorer > Terminal

#### 步骤 2: 切换到目标命名空间

```objectscript
ZN "USER"
```

#### 步骤 3: 导入并编译

```objectscript
// 设置源代码路径
Set path = "/path/to/iris-study/src/HL7/v3/"

// 导入并编译所有类
Do $System.OBJ.LoadDir(path, "ck")
```

参数说明：
- `c` = compile（编译）
- `k` = keep source（保留源代码）

#### 步骤 4: 验证安装

```objectscript
// 检查类是否存在
Write ##class(%Dictionary.ClassDefinition).%ExistsId("HL7.v3.PRPMIN406110UV01Parser"), !

// 运行测试
Do ##class(HL7.v3.Test).RunAll()
```

### 方法 3: 使用 VSCode + ObjectScript 插件（推荐用于开发）

#### 步骤 1: 安装 VSCode 插件

1. 在 VSCode 中安装 **InterSystems ObjectScript** 插件
2. 安装 **InterSystems Server Manager** 插件

#### 步骤 2: 配置连接

创建或编辑 `.vscode/settings.json`：

```json
{
  "objectscript.conn": {
    "active": true,
    "host": "localhost",
    "port": 52773,
    "username": "SuperUser",
    "password": "SYS",
    "ns": "USER",
    "https": false
  }
}
```

#### 步骤 3: 导入代码

1. 在 VSCode 中打开 `iris-study` 项目
2. 右键点击 `src` 文件夹
3. 选择 **Import and Compile**

#### 步骤 4: 验证安装

在 VSCode 的 ObjectScript 终端中运行：

```objectscript
Do ##class(HL7.v3.Test).RunAll()
```

## 配置

### 设置工作目录

在使用文件解析功能时，你可能需要配置文件路径：

```objectscript
// 设置全局变量存储默认路径
Set ^HL7.Config("XMLPath") = "/path/to/xml/files/"

// 在代码中使用
Set xmlPath = ^HL7.Config("XMLPath") _ "PRPM_IN406110UV01_example.xml"
Do parser.ParseXMLFile(xmlPath)
```

### 复制示例文件

将示例 XML 文件复制到可访问的位置：

```bash
# Linux/Mac
cp examples/PRPM_IN406110UV01_example.xml /opt/iris-data/

# Windows
copy examples\PRPM_IN406110UV01_example.xml C:\iris-data\
```

## 快速测试

### 测试 1: 运行单元测试

```objectscript
ZN "USER"
Do ##class(HL7.v3.Test).RunAll()
```

预期输出：
```
==========================================
运行 PRPM_IN406110UV01Parser 测试套件
==========================================

✓ 测试1: 基本解析功能 - 通过
✓ 测试2: 组织信息提取 - 通过
✓ 测试3: 责任者信息提取 - 通过
✓ 测试4: 字符串解析 - 通过
✓ 测试5: 消息路由信息 - 通过

==========================================
测试总结: 5/5 通过
状态: ✓ 所有测试通过
==========================================
```

### 测试 2: 解析示例文件

```objectscript
Do ##class(HL7.v3.Demo).ParseFromFile("/path/to/examples/PRPM_IN406110UV01_example.xml")
```

### 测试 3: 简单解析测试

```objectscript
Set parser = ##class(HL7.v3.PRPMIN406110UV01Parser).%New()
Set xml = "<PRPM_IN406110UV01 xmlns=""urn:hl7-org:v3""><id extension=""test""/></PRPM_IN406110UV01>"
Do parser.ParseXMLString(xml)
Write "成功!", !
```

## 验证 XML 文件（使用 Python）

如果你安装了 Python，可以在导入 IRIS 之前验证 XML 文件：

```bash
cd iris-study
python3 examples/validate_xml.py examples/PRPM_IN406110UV01_example.xml
```

## 故障排除

### 问题 1: 类未找到

**错误信息**: `<CLASS DOES NOT EXIST>`

**解决方案**:
```objectscript
// 检查当前命名空间
Write $NAMESPACE, !

// 切换到正确的命名空间
ZN "USER"

// 重新导入
Do $System.OBJ.LoadDir("/path/to/src/HL7/v3/", "ck")
```

### 问题 2: 编译错误

**错误信息**: `ERROR #5540: ...`

**解决方案**:
1. 检查 IRIS 版本是否支持
2. 确保命名空间有编译权限
3. 查看详细错误信息：
```objectscript
Do $System.OBJ.DisplayError(%objlasterror)
```

### 问题 3: 文件路径错误

**错误信息**: `ERROR #5001: Cannot open file`

**解决方案**:
```objectscript
// 使用绝对路径
Set path = "/opt/iris-data/PRPM_IN406110UV01_example.xml"

// 或者检查文件是否存在
If ##class(%Library.File).Exists(path) {
    Write "文件存在", !
} Else {
    Write "文件不存在", !
}
```

### 问题 4: XML 解析错误

**错误信息**: `ERROR #6301: SAX XML Parser Error`

**解决方案**:
1. 使用 Python 脚本验证 XML 格式
2. 检查 XML 编码（应为 UTF-8）
3. 确认 XML 包含正确的命名空间

```bash
python3 examples/validate_xml.py your-file.xml
```

### 问题 5: 权限错误

**错误信息**: `<PROTECT>`

**解决方案**:
```objectscript
// 确认有足够的权限
Write $ROLES, !

// 如果需要，使用管理员账户
```

## 性能优化

### 批量导入

如果需要处理大量文件：

```objectscript
ClassMethod BatchImport(directory As %String)
{
    Set rs = ##class(%Library.File).ListFiles(directory, "*.xml")
    Set parser = ##class(HL7.v3.PRPMIN406110UV01Parser).%New()
    
    While rs.%Next() {
        Set status = parser.ParseXMLFile(rs.Name)
        If $$$ISOK(status) {
            // 处理数据
            Do ..ProcessData(parser)
        }
    }
}
```

### 缓存解析器

重用解析器对象以提高性能：

```objectscript
// 不推荐：每次都创建新对象
For i=1:1:100 {
    Set parser = ##class(HL7.v3.PRPMIN406110UV01Parser).%New()
    Do parser.ParseXMLFile(file)
}

// 推荐：重用对象
Set parser = ##class(HL7.v3.PRPMIN406110UV01Parser).%New()
For i=1:1:100 {
    Do parser.ParseXMLFile(file)
}
```

## 生产部署建议

1. **命名空间隔离**: 在独立的命名空间中部署
2. **错误日志**: 实现错误日志记录机制
3. **性能监控**: 监控解析性能和内存使用
4. **备份**: 定期备份类定义和数据
5. **版本控制**: 使用源代码管理系统跟踪更改

## 卸载

如果需要卸载解析器：

```objectscript
// 删除类
Do ##class(%Dictionary.ClassDefinition).%DeleteId("HL7.v3.PRPMIN406110UV01Parser")
Do ##class(%Dictionary.ClassDefinition).%DeleteId("HL7.v3.Demo")
Do ##class(%Dictionary.ClassDefinition).%DeleteId("HL7.v3.Test")

// 删除包（如果为空）
Do ##class(%Dictionary.PackageDefinition).%DeleteId("HL7.v3")
Do ##class(%Dictionary.PackageDefinition).%DeleteId("HL7")
```

## 获取帮助

- 查看文档：[README.md](README.md)
- 查看示例：[examples/使用示例.md](examples/使用示例.md)
- 查看快速参考：[examples/快速参考.md](examples/快速参考.md)
- 提交问题：GitHub Issues

## 下一步

安装完成后，建议：

1. 阅读 [快速参考](examples/快速参考.md)
2. 查看 [使用示例](examples/使用示例.md)
3. 运行单元测试验证安装
4. 尝试解析示例 XML 文件
5. 根据需求修改和扩展功能
