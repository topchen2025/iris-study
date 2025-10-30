#!/usr/bin/env python3
"""
简单的XML验证脚本
用于验证PRPM_IN406110UV01_example.xml文件是否是格式良好的XML
"""

import xml.etree.ElementTree as ET
import sys
import os

def validate_xml(file_path):
    """验证XML文件是否格式良好"""
    try:
        print(f"正在验证XML文件: {file_path}")
        print("-" * 60)
        
        # 解析XML文件
        tree = ET.parse(file_path)
        root = tree.getroot()
        
        print(f"✓ XML格式良好")
        print(f"✓ 根元素: {root.tag}")
        
        # 提取命名空间
        ns = {'hl7': 'urn:hl7-org:v3'}
        
        # 验证关键元素
        print("\n验证关键元素:")
        
        # 消息ID
        id_elem = root.find('.//hl7:id', ns)
        if id_elem is not None:
            msg_id = id_elem.get('extension')
            print(f"  ✓ 消息ID: {msg_id}")
        else:
            print(f"  ✗ 未找到消息ID")
        
        # 创建时间
        time_elem = root.find('.//hl7:creationTime', ns)
        if time_elem is not None:
            creation_time = time_elem.get('value')
            print(f"  ✓ 创建时间: {creation_time}")
        else:
            print(f"  ✗ 未找到创建时间")
        
        # 服务编码
        interaction_elem = root.find('.//hl7:interactionId', ns)
        if interaction_elem is not None:
            interaction_id = interaction_elem.get('extension')
            print(f"  ✓ 服务编码: {interaction_id}")
        else:
            print(f"  ✗ 未找到服务编码")
        
        # 接收者
        receiver = root.find('.//hl7:receiver//hl7:item', ns)
        if receiver is not None:
            receiver_code = receiver.get('extension')
            print(f"  ✓ 接收者: {receiver_code}")
        else:
            print(f"  ✗ 未找到接收者")
        
        # 发送者
        sender = root.find('.//hl7:sender//hl7:item', ns)
        if sender is not None:
            sender_code = sender.get('extension')
            print(f"  ✓ 发送者: {sender_code}")
        else:
            print(f"  ✗ 未找到发送者")
        
        # 组织信息
        print("\n验证组织信息:")
        assigned_entity = root.find('.//hl7:subject1//hl7:assignedEntity', ns)
        if assigned_entity is not None:
            # 组织ID
            org_id_elem = assigned_entity.find('.//hl7:id/hl7:item', ns)
            if org_id_elem is not None:
                org_id = org_id_elem.get('extension')
                print(f"  ✓ 组织ID: {org_id}")
            
            # 组织代码
            code_elem = assigned_entity.find('.//hl7:code', ns)
            if code_elem is not None:
                org_code = code_elem.get('code')
                display_name_elem = code_elem.find('.//hl7:displayName', ns)
                if display_name_elem is not None:
                    display_name = display_name_elem.get('value')
                    print(f"  ✓ 组织代码: {org_code} ({display_name})")
            
            # 联系电话
            telecom_elem = assigned_entity.find('.//hl7:telecom/hl7:item', ns)
            if telecom_elem is not None:
                telecom = telecom_elem.get('value')
                print(f"  ✓ 联系电话: {telecom}")
        else:
            print(f"  ✗ 未找到组织信息")
        
        # 责任者信息
        print("\n验证责任者信息:")
        custodian = root.find('.//hl7:custodian//hl7:assignedEntity', ns)
        if custodian is not None:
            # 人员ID
            person_id_elem = custodian.find('.//hl7:id/hl7:item', ns)
            if person_id_elem is not None:
                person_id = person_id_elem.get('extension')
                print(f"  ✓ 人员ID: {person_id}")
            
            # 人员姓名
            person_name_elem = custodian.find('.//hl7:assignedPerson//hl7:name//hl7:part', ns)
            if person_name_elem is not None:
                person_name = person_name_elem.get('value')
                print(f"  ✓ 人员姓名: {person_name}")
            
            # 所属组织
            org_name_elem = custodian.find('.//hl7:representedOrganization//hl7:name//hl7:part', ns)
            if org_name_elem is not None:
                org_name = org_name_elem.get('value')
                print(f"  ✓ 所属组织: {org_name}")
        else:
            print(f"  ✗ 未找到责任者信息")
        
        print("\n" + "-" * 60)
        print("✓ XML验证完成")
        return True
        
    except ET.ParseError as e:
        print(f"✗ XML解析错误: {e}")
        return False
    except Exception as e:
        print(f"✗ 错误: {e}")
        return False

def main():
    # 获取XML文件路径
    if len(sys.argv) > 1:
        xml_file = sys.argv[1]
    else:
        # 默认使用examples目录下的文件
        script_dir = os.path.dirname(os.path.abspath(__file__))
        xml_file = os.path.join(script_dir, "PRPM_IN406110UV01_example.xml")
    
    if not os.path.exists(xml_file):
        print(f"错误: 文件不存在: {xml_file}")
        sys.exit(1)
    
    # 验证XML
    success = validate_xml(xml_file)
    
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()
